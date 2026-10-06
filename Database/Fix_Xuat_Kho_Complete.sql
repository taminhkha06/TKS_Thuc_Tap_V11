USE [TKS_Thuc_Tap_V11]
GO

-- 1. Tạo/Update stored procedure Update Header
CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_upd_Update_Header
	@Auto_ID BIGINT,
	@So_Phieu_Xuat_Kho NVARCHAR(50),
	@Kho_ID BIGINT,
	@Ngay_Xuat_Kho DATE,
	@Ghi_Chu NVARCHAR(1000),
	@Last_Updated_By NVARCHAR(100),
	@Last_Updated_By_Function NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	SET @So_Phieu_Xuat_Kho = LTRIM(RTRIM(ISNULL(@So_Phieu_Xuat_Kho, N'')));

	IF @So_Phieu_Xuat_Kho = N'' THROW 50071, N'Số phiếu xuất không được để trống.', 1;
	IF ISNULL(@Kho_ID, 0) <= 0 THROW 50072, N'Kho không được để trống.', 1;
	IF @Ngay_Xuat_Kho IS NULL THROW 50073, N'Ngày xuất kho không được để trống.', 1;
	IF NOT EXISTS (SELECT 1 FROM dbo.tbl_DM_Kho WHERE Auto_ID = @Kho_ID AND deleted = 0)
		THROW 50074, N'Kho không tồn tại hoặc đã ngưng sử dụng.', 1;
	IF EXISTS (SELECT 1 FROM dbo.tbl_DM_Xuat_Kho WHERE So_Phieu_Xuat_Kho = @So_Phieu_Xuat_Kho AND deleted = 0 AND Auto_ID <> @Auto_ID)
		THROW 50075, N'Số phiếu xuất đã tồn tại.', 1;

	UPDATE dbo.tbl_DM_Xuat_Kho
	SET So_Phieu_Xuat_Kho = @So_Phieu_Xuat_Kho,
		Kho_ID = @Kho_ID,
		Ngay_Xuat_Kho = @Ngay_Xuat_Kho,
		Ghi_Chu = ISNULL(@Ghi_Chu, N''),
		Last_Updated = SYSDATETIME(),
		Last_Updated_By = ISNULL(@Last_Updated_By, N''),
		Last_Updated_By_Function = ISNULL(@Last_Updated_By_Function, N'')
	WHERE Auto_ID = @Auto_ID AND deleted = 0;
END
GO

-- 2. Tạo/Update stored procedure Update Raw Data
CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_upd_Update_Raw_Data
	@Auto_ID BIGINT,
	@SL_Xuat DECIMAL(18, 3),
	@Don_Gia_Xuat DECIMAL(18, 2)
AS
BEGIN
	SET NOCOUNT ON;
	IF @SL_Xuat <= 0 THROW 50078, N'Số lượng xuất phải lớn hơn 0.', 1;
	IF @Don_Gia_Xuat < 0 THROW 50079, N'Đơn giá xuất không được nhỏ hơn 0.', 1;
	IF NOT EXISTS
	(
		SELECT 1
		FROM dbo.tbl_DM_Xuat_Kho_Raw_Data R
		JOIN dbo.tbl_DM_Xuat_Kho H ON H.Auto_ID = R.Xuat_Kho_ID
		WHERE R.Auto_ID = @Auto_ID AND H.deleted = 0
	)
		THROW 50085, N'Không tìm thấy dòng hàng thuộc phiếu xuất đang hoạt động.', 1;

	UPDATE dbo.tbl_DM_Xuat_Kho_Raw_Data
	SET SL_Xuat = @SL_Xuat, Don_Gia_Xuat = @Don_Gia_Xuat
	WHERE Auto_ID = @Auto_ID;
END
GO

-- 3. Tạo/Update stored procedure Delete Raw Data
CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_del_Delete_Raw_Data
	@Auto_ID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS
	(
		SELECT 1
		FROM dbo.tbl_DM_Xuat_Kho_Raw_Data R
		JOIN dbo.tbl_DM_Xuat_Kho H ON H.Auto_ID = R.Xuat_Kho_ID
		WHERE R.Auto_ID = @Auto_ID AND H.deleted = 0
	)
		THROW 50085, N'Không tìm thấy dòng hàng thuộc phiếu xuất đang hoạt động.', 1;

	DELETE FROM dbo.tbl_DM_Xuat_Kho_Raw_Data WHERE Auto_ID = @Auto_ID;
END
GO

-- 4. Update quyền Edit cho chức năng 2011
BEGIN TRY
	BEGIN TRANSACTION;
	DECLARE @Function_ID BIGINT;
	DECLARE @Login_Name NVARCHAR(100) = CONVERT(NVARCHAR(100), SUSER_SNAME());
	DECLARE @Now DATETIME = GETDATE();

	SELECT @Function_ID = Auto_ID
	FROM dbo.tbl_Sys_Chuc_Nang WITH (UPDLOCK, HOLDLOCK)
	WHERE Func_URL = N'/Danh_Muc/Xuat_Kho' AND deleted = 0;

	IF @Function_ID IS NOT NULL
	BEGIN
		UPDATE dbo.tbl_Sys_Chuc_Nang
		SET Is_Edit = 1,
			Last_Updated = @Now,
			Last_Updated_By = @Login_Name,
			Last_Updated_By_Function = N'FIX_PERMISSION'
		WHERE Auto_ID = @Function_ID;

		-- Copy quyền Edit từ chức năng cha
		DECLARE @Parent_ID BIGINT;
		SELECT @Parent_ID = Chuc_Nang_Parent_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Auto_ID = @Function_ID;

		UPDATE Existing
		SET Is_Have_Edit_Permission = SourcePermission.Is_Have_Edit_Permission,
			Last_Updated = @Now,
			Last_Updated_By = @Login_Name,
			Last_Updated_By_Function = N'FIX_PERMISSION'
		FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang Existing
		JOIN dbo.tbl_Sys_Phan_Quyen_Chuc_Nang SourcePermission
			ON SourcePermission.Chuc_Nang_ID = @Parent_ID
		WHERE Existing.Chuc_Nang_ID = @Function_ID AND Existing.deleted = 0;
	END

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	THROW;
END CATCH
GO

PRINT 'Fix hoàn thành! Vui lòng build lại dự án và restart ứng dụng.';
