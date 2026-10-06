USE [TKS_Thuc_Tap_V11]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET NUMERIC_ROUNDABORT OFF
GO

IF OBJECT_ID(N'dbo.tbl_DM_Xuat_Kho', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.tbl_DM_Xuat_Kho
	(
		Auto_ID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_tbl_DM_Xuat_Kho PRIMARY KEY,
		So_Phieu_Xuat_Kho NVARCHAR(50) NOT NULL,
		Kho_ID BIGINT NOT NULL,
		Ngay_Xuat_Kho DATE NOT NULL,
		Ghi_Chu NVARCHAR(1000) NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_Ghi_Chu DEFAULT (N''),
		deleted INT NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_deleted DEFAULT (0),
		Created DATETIME2(0) NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_Created DEFAULT (SYSDATETIME()),
		Created_By NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_Created_By DEFAULT (N''),
		Created_By_Function NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_Created_By_Function DEFAULT (N''),
		Last_Updated DATETIME2(0) NULL,
		Last_Updated_By NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_Last_Updated_By DEFAULT (N''),
		Last_Updated_By_Function NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_DM_Xuat_Kho_Last_Updated_By_Function DEFAULT (N''),
		CONSTRAINT CK_tbl_DM_Xuat_Kho_So_Phieu_Not_Empty CHECK (LEN(LTRIM(RTRIM(So_Phieu_Xuat_Kho))) > 0),
		CONSTRAINT CK_tbl_DM_Xuat_Kho_Kho_ID_Not_Empty CHECK (Kho_ID > 0),
		CONSTRAINT FK_tbl_DM_Xuat_Kho_Kho FOREIGN KEY (Kho_ID) REFERENCES dbo.tbl_DM_Kho(Auto_ID)
	);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.tbl_DM_Xuat_Kho') AND name = N'UX_tbl_DM_Xuat_Kho_So_Phieu')
	CREATE UNIQUE INDEX UX_tbl_DM_Xuat_Kho_So_Phieu
		ON dbo.tbl_DM_Xuat_Kho(So_Phieu_Xuat_Kho) WHERE deleted = 0;
GO

IF OBJECT_ID(N'dbo.tbl_DM_Xuat_Kho_Raw_Data', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.tbl_DM_Xuat_Kho_Raw_Data
	(
		Auto_ID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_tbl_DM_Xuat_Kho_Raw_Data PRIMARY KEY,
		Xuat_Kho_ID BIGINT NOT NULL,
		San_Pham_ID BIGINT NOT NULL,
		SL_Xuat DECIMAL(18, 3) NOT NULL,
		Don_Gia_Xuat DECIMAL(18, 2) NOT NULL,
		CONSTRAINT CK_tbl_DM_Xuat_Kho_Raw_Data_SL_Xuat_Positive CHECK (SL_Xuat > 0),
		CONSTRAINT CK_tbl_DM_Xuat_Kho_Raw_Data_Don_Gia_Xuat_Nonnegative CHECK (Don_Gia_Xuat >= 0),
		CONSTRAINT FK_tbl_DM_Xuat_Kho_Raw_Data_Header FOREIGN KEY (Xuat_Kho_ID) REFERENCES dbo.tbl_DM_Xuat_Kho(Auto_ID),
		CONSTRAINT FK_tbl_DM_Xuat_Kho_Raw_Data_Product FOREIGN KEY (San_Pham_ID) REFERENCES dbo.tbl_DM_San_Pham(Auto_ID)
	);
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_sel_List
AS
BEGIN
	SET NOCOUNT ON;
	SELECT H.Auto_ID, H.So_Phieu_Xuat_Kho, H.Kho_ID, H.Ngay_Xuat_Kho,
		H.Ghi_Chu, K.Ten_Kho, COUNT(R.Auto_ID) AS So_Dong_Hang,
		ISNULL(SUM(R.SL_Xuat * R.Don_Gia_Xuat), 0) AS Tong_Tien,
		H.deleted, H.Created, H.Created_By, H.Created_By_Function,
		H.Last_Updated, H.Last_Updated_By, H.Last_Updated_By_Function
	FROM dbo.tbl_DM_Xuat_Kho H
	JOIN dbo.tbl_DM_Kho K ON K.Auto_ID = H.Kho_ID
	LEFT JOIN dbo.tbl_DM_Xuat_Kho_Raw_Data R ON R.Xuat_Kho_ID = H.Auto_ID
	WHERE H.deleted = 0
	GROUP BY H.Auto_ID, H.So_Phieu_Xuat_Kho, H.Kho_ID, H.Ngay_Xuat_Kho,
		H.Ghi_Chu, K.Ten_Kho, H.deleted, H.Created, H.Created_By,
		H.Created_By_Function, H.Last_Updated, H.Last_Updated_By, H.Last_Updated_By_Function
	ORDER BY H.Ngay_Xuat_Kho DESC, H.Auto_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_sel_List_Raw_By_Xuat_Kho_ID
	@Xuat_Kho_ID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT R.Auto_ID, R.Xuat_Kho_ID, R.San_Pham_ID, R.SL_Xuat, R.Don_Gia_Xuat,
		P.Ma_San_Pham, P.Ten_San_Pham, D.Ten_Don_Vi_Tinh
	FROM dbo.tbl_DM_Xuat_Kho_Raw_Data R
	JOIN dbo.tbl_DM_San_Pham P ON P.Auto_ID = R.San_Pham_ID
	JOIN dbo.tbl_DM_Don_Vi_Tinh D ON D.Auto_ID = P.Don_Vi_Tinh_ID
	WHERE R.Xuat_Kho_ID = @Xuat_Kho_ID
	ORDER BY R.Auto_ID;
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_ins_Insert
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
	IF EXISTS (SELECT 1 FROM dbo.tbl_DM_Xuat_Kho WHERE So_Phieu_Xuat_Kho = @So_Phieu_Xuat_Kho AND deleted = 0)
		THROW 50075, N'Số phiếu xuất đã tồn tại.', 1;

	INSERT INTO dbo.tbl_DM_Xuat_Kho
		(So_Phieu_Xuat_Kho, Kho_ID, Ngay_Xuat_Kho, Ghi_Chu,
		 Created_By, Created_By_Function, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@So_Phieu_Xuat_Kho, @Kho_ID, @Ngay_Xuat_Kho, ISNULL(@Ghi_Chu, N''),
		 ISNULL(@Last_Updated_By, N''), ISNULL(@Last_Updated_By_Function, N''),
		 ISNULL(@Last_Updated_By, N''), ISNULL(@Last_Updated_By_Function, N''));

	SELECT CONVERT(BIGINT, SCOPE_IDENTITY());
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_ins_Insert_Raw_Data
	@Xuat_Kho_ID BIGINT,
	@San_Pham_ID BIGINT,
	@SL_Xuat DECIMAL(18, 3),
	@Don_Gia_Xuat DECIMAL(18, 2)
AS
BEGIN
	SET NOCOUNT ON;
	IF ISNULL(@Xuat_Kho_ID, 0) <= 0 THROW 50076, N'Phiếu xuất không hợp lệ.', 1;
	IF ISNULL(@San_Pham_ID, 0) <= 0 THROW 50077, N'Sản phẩm không được để trống.', 1;
	IF @SL_Xuat <= 0 THROW 50078, N'Số lượng xuất phải lớn hơn 0.', 1;
	IF @Don_Gia_Xuat < 0 THROW 50079, N'Đơn giá xuất không được nhỏ hơn 0.', 1;
	IF NOT EXISTS (SELECT 1 FROM dbo.tbl_DM_San_Pham WHERE Auto_ID = @San_Pham_ID AND deleted = 0)
		THROW 50080, N'Sản phẩm không tồn tại hoặc đã ngưng sử dụng.', 1;

	INSERT INTO dbo.tbl_DM_Xuat_Kho_Raw_Data (Xuat_Kho_ID, San_Pham_ID, SL_Xuat, Don_Gia_Xuat)
	VALUES (@Xuat_Kho_ID, @San_Pham_ID, @SL_Xuat, @Don_Gia_Xuat);
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_111_XK_sp_del_Delete_By_ID
	@Auto_ID BIGINT,
	@Last_Updated_By NVARCHAR(100),
	@Last_Updated_By_Function NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.tbl_DM_Xuat_Kho
	SET deleted = 1,
		Last_Updated = SYSDATETIME(),
		Last_Updated_By = ISNULL(@Last_Updated_By, N''),
		Last_Updated_By_Function = ISNULL(@Last_Updated_By_Function, N'')
	WHERE Auto_ID = @Auto_ID AND deleted = 0;
END
GO

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


BEGIN TRY
	BEGIN TRANSACTION;
	DECLARE @Function_ID BIGINT;
	DECLARE @Source_Function_ID BIGINT;
	DECLARE @Parent_ID BIGINT;
	DECLARE @Now DATETIME = GETDATE();
	DECLARE @Login_Name NVARCHAR(100) = CONVERT(NVARCHAR(100), SUSER_SNAME());

	SELECT @Source_Function_ID = Auto_ID, @Parent_ID = Chuc_Nang_Parent_ID
	FROM dbo.tbl_Sys_Chuc_Nang WITH (UPDLOCK, HOLDLOCK)
	WHERE Func_URL = N'/Danh_Muc/Kho' AND deleted = 0;
	IF @Source_Function_ID IS NULL
		THROW 50081, N'Không tìm thấy chức năng Kho để đăng ký Phiếu xuất.', 1;

	SELECT @Function_ID = Auto_ID
	FROM dbo.tbl_Sys_Chuc_Nang WITH (UPDLOCK, HOLDLOCK)
	WHERE Func_URL = N'/Danh_Muc/Xuat_Kho' AND deleted = 0;

	IF @Function_ID IS NULL
	BEGIN
		IF EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = N'2011' AND deleted = 0)
			THROW 50082, N'Mã chức năng 2011 đã được sử dụng.', 1;

		SELECT @Function_ID = ISNULL(MAX(Auto_ID), 0) + 1
		FROM dbo.tbl_Sys_Chuc_Nang WITH (TABLOCKX, HOLDLOCK);

		INSERT INTO dbo.tbl_Sys_Chuc_Nang
			(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
			 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
			 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By,
			 Created_By_Function, Last_Updated, Last_Updated_By, Last_Updated_By_Function)
		SELECT @Function_ID, N'2011', N'Phiếu xuất kho',
			(SELECT ISNULL(MAX(Sort_Priority), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Chuc_Nang_Parent_ID = @Parent_ID AND deleted = 0),
			Chuc_Nang_Parent_ID, Nhom_Chuc_Nang_ID, N'/Danh_Muc/Xuat_Kho', Image_URL,
			Is_View, Is_New, 0, Is_Delete, Is_Export, Khach_Hang_ID,
			N'Quản lý phiếu xuất kho', 0, @Now, @Login_Name, N'DB_SETUP', @Now, @Login_Name, N'DB_SETUP'
		FROM dbo.tbl_Sys_Chuc_Nang
		WHERE Auto_ID = @Source_Function_ID;
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang <> N'2011' AND Func_URL = N'/Danh_Muc/Xuat_Kho' AND deleted = 0)
		THROW 50083, N'Route Phiếu xuất đã được đăng ký với mã chức năng khác.', 1;
	ELSE
	BEGIN
		UPDATE dbo.tbl_Sys_Chuc_Nang
		SET Ten_Chuc_Nang = N'Phiếu xuất kho',
			Ghi_Chu = N'Quản lý phiếu xuất kho',
			Last_Updated = @Now,
			Last_Updated_By = @Login_Name,
			Last_Updated_By_Function = N'DB_SETUP'
		WHERE Auto_ID = @Function_ID;
	END

	DECLARE @Permission_Base_ID BIGINT;
	SELECT @Permission_Base_ID = ISNULL(MAX(Auto_ID), 0)
	FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang WITH (TABLOCKX, HOLDLOCK);

	;WITH Permission_Source AS
	(
		SELECT SourcePermission.Nhom_Thanh_Vien_ID, SourcePermission.Is_Have_View_Permission,
			SourcePermission.Is_Have_Add_Permission, SourcePermission.Is_Have_Edit_Permission,
			SourcePermission.Is_Have_Delete_Permission, SourcePermission.Is_Have_Export_Permission,
			ROW_NUMBER() OVER (ORDER BY SourcePermission.Nhom_Thanh_Vien_ID) AS Row_Number
		FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang SourcePermission
		WHERE SourcePermission.Chuc_Nang_ID = @Source_Function_ID AND SourcePermission.deleted = 0
			AND NOT EXISTS
			(
				SELECT 1 FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang Existing
				WHERE Existing.Chuc_Nang_ID = @Function_ID
					AND Existing.Nhom_Thanh_Vien_ID = SourcePermission.Nhom_Thanh_Vien_ID
					AND Existing.deleted = 0
			)
	)
	INSERT INTO dbo.tbl_Sys_Phan_Quyen_Chuc_Nang
		(Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission,
		 Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission,
		 Is_Have_Export_Permission, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	SELECT @Permission_Base_ID + Row_Number, Nhom_Thanh_Vien_ID, @Function_ID,
		Is_Have_View_Permission, Is_Have_Add_Permission, Is_Have_Edit_Permission,
		Is_Have_Delete_Permission, Is_Have_Export_Permission, 0, @Now, @Login_Name,
		N'DB_SETUP', @Now, @Login_Name, N'DB_SETUP'
	FROM Permission_Source;

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	THROW;
END CATCH
GO
