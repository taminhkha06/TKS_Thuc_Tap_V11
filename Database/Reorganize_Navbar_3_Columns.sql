USE [TKS_Thuc_Tap_V11]
GO

-- ============================================================================
-- Gộp navbar (thanh menu ngang) về đúng 3 cột:
--   1. Dashboard   -> chứa 1 chức năng Dashboard (trang /)
--   2. Master Data -> chứa nhóm Danh mục, Kho, Báo cáo (giữ nguyên cấp con)
--   3. Quản trị    -> giữ nguyên
-- Chạy lại được nhiều lần (idempotent).
-- Sau khi chạy cần restart ứng dụng để load lại cache Chức năng.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRY
	BEGIN TRANSACTION;

	DECLARE @Now DATETIME = GETDATE();
	DECLARE @Login_Name NVARCHAR(100) = CONVERT(NVARCHAR(100), SUSER_SNAME());

	-- ----------------------------------------------------------------------------
	-- 1. Tạo (nếu chưa có) node cha cấp top-level cho Dashboard
	-- ----------------------------------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_DASHBOARD' AND deleted = 0)
	BEGIN
		DECLARE @New_ID BIGINT;
		SELECT @New_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;

		INSERT INTO dbo.tbl_Sys_Chuc_Nang
			(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
			 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
			 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
			 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
		VALUES
			(@New_ID, 'MENU_DASHBOARD', N'Dashboard', 1, 0,
			 1, NULL, 'ri-dashboard-2-line', 1, 0, 0, 0, 0, NULL,
			 N'Nhóm dashboard', 0, @Now, @Login_Name, 'MENU_SETUP',
			 @Now, @Login_Name, 'MENU_SETUP');
	END

	DECLARE @Dashboard_ID BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_DASHBOARD' AND deleted = 0);
	DECLARE @Master_Data_ID BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = '2000' AND deleted = 0);
	DECLARE @Quan_Tri_ID BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = '1000' AND deleted = 0);

	-- ----------------------------------------------------------------------------
	-- 2. Ẩn các bản ghi trùng vô nghĩa (Dashboard không có URL, Chủ hàng không có URL)
	-- ----------------------------------------------------------------------------
	UPDATE dbo.tbl_Sys_Chuc_Nang
	SET deleted = 1, Last_Updated = @Now, Last_Updated_By = @Login_Name, Last_Updated_By_Function = 'MENU_SETUP'
	WHERE deleted = 0
		AND Ma_Chuc_Nang IN ('8000', '6805')
		AND ISNULL(Func_URL, '') = '';

	-- ----------------------------------------------------------------------------
	-- 3. Cột 1: Dashboard -> chứa đúng 1 chức năng Dashboard (Func_URL = '/')
	-- ----------------------------------------------------------------------------
	UPDATE dbo.tbl_Sys_Chuc_Nang
	SET Chuc_Nang_Parent_ID = @Dashboard_ID,
		Sort_Priority = 1,
		Ten_Chuc_Nang = N'Dashboard',
		Is_View = 1,
		Last_Updated = @Now,
		Last_Updated_By = @Login_Name,
		Last_Updated_By_Function = 'MENU_SETUP'
	WHERE Ma_Chuc_Nang = '8001' AND deleted = 0;

	-- ----------------------------------------------------------------------------
	-- 4. Cột 2: Master Data -> nhận 3 nhóm Danh mục / Kho / Báo cáo làm cấp con
	-- ----------------------------------------------------------------------------
	UPDATE dbo.tbl_Sys_Chuc_Nang
	SET Chuc_Nang_Parent_ID = @Master_Data_ID,
		Sort_Priority = CASE Ma_Chuc_Nang
							WHEN 'MENU_DANH_MUC' THEN 1
							WHEN 'MENU_KHO' THEN 2
							WHEN 'MENU_BAO_CAO' THEN 3
							ELSE Sort_Priority
						END,
		Last_Updated = @Now,
		Last_Updated_By = @Login_Name,
		Last_Updated_By_Function = 'MENU_SETUP'
	WHERE Ma_Chuc_Nang IN ('MENU_DANH_MUC', 'MENU_KHO', 'MENU_BAO_CAO') AND deleted = 0;

	-- ----------------------------------------------------------------------------
	-- 5. Thứ tự 3 cột trên navbar: Dashboard (1) -> Master Data (2) -> Quản trị (3)
	-- ----------------------------------------------------------------------------
	UPDATE dbo.tbl_Sys_Chuc_Nang
	SET Sort_Priority = 1, Last_Updated = @Now, Last_Updated_By = @Login_Name, Last_Updated_By_Function = 'MENU_SETUP'
	WHERE Auto_ID = @Dashboard_ID;

	UPDATE dbo.tbl_Sys_Chuc_Nang
	SET Sort_Priority = 2, Chuc_Nang_Parent_ID = 0, Nhom_Chuc_Nang_ID = 1,
		Last_Updated = @Now, Last_Updated_By = @Login_Name, Last_Updated_By_Function = 'MENU_SETUP'
	WHERE Auto_ID = @Master_Data_ID;

	UPDATE dbo.tbl_Sys_Chuc_Nang
	SET Sort_Priority = 3, Chuc_Nang_Parent_ID = 0, Nhom_Chuc_Nang_ID = 1,
		Last_Updated = @Now, Last_Updated_By = @Login_Name, Last_Updated_By_Function = 'MENU_SETUP'
	WHERE Auto_ID = @Quan_Tri_ID;

	-- ----------------------------------------------------------------------------
	-- 6. Copy quyền View/Export cho 2 node cha (nếu chưa có quyền thì menu không hiện)
	--    MENU_DASHBOARD <- quyền của 8001 (Dashboard)
	--    Master Data    <- quyền tổng hợp của MENU_DANH_MUC / MENU_KHO / MENU_BAO_CAO
	-- ----------------------------------------------------------------------------
	DECLARE @Max_Perm_ID BIGINT = ISNULL((SELECT MAX(Auto_ID) FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang), 0);

	-- 6a. Quyền cho MENU_DASHBOARD
	IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang WHERE Chuc_Nang_ID = @Dashboard_ID AND deleted = 0)
	BEGIN
		;WITH Src AS (
			SELECT P.Nhom_Thanh_Vien_ID,
				   MAX(CAST(P.Is_Have_View_Permission AS INT)) AS Is_View,
				   MAX(CAST(P.Is_Have_Export_Permission AS INT)) AS Is_Export
			FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang P
			JOIN dbo.tbl_Sys_Chuc_Nang C ON C.Auto_ID = P.Chuc_Nang_ID AND C.deleted = 0
			WHERE C.Ma_Chuc_Nang = '8001' AND P.deleted = 0
			GROUP BY P.Nhom_Thanh_Vien_ID
		)
		INSERT INTO dbo.tbl_Sys_Phan_Quyen_Chuc_Nang
			(Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission,
			 Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission,
			 Is_Have_Export_Permission, deleted, Created, Created_By, Created_By_Function,
			 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
		SELECT @Max_Perm_ID + ROW_NUMBER() OVER (ORDER BY Src.Nhom_Thanh_Vien_ID),
			   Src.Nhom_Thanh_Vien_ID, @Dashboard_ID,
			   Src.Is_View, 0, 0, 0, Src.Is_Export, 0, @Now, @Login_Name, 'MENU_SETUP',
			   @Now, @Login_Name, 'MENU_SETUP'
		FROM Src;
	END

	-- 6b. Quyền cho Master Data
	IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang WHERE Chuc_Nang_ID = @Master_Data_ID AND deleted = 0)
	BEGIN
		SET @Max_Perm_ID = ISNULL((SELECT MAX(Auto_ID) FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang), 0);

		;WITH Src AS (
			SELECT P.Nhom_Thanh_Vien_ID,
				   MAX(CAST(P.Is_Have_View_Permission AS INT)) AS Is_View,
				   MAX(CAST(P.Is_Have_Export_Permission AS INT)) AS Is_Export
			FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang P
			JOIN dbo.tbl_Sys_Chuc_Nang C ON C.Auto_ID = P.Chuc_Nang_ID AND C.deleted = 0
			WHERE C.Ma_Chuc_Nang IN ('MENU_DANH_MUC', 'MENU_KHO', 'MENU_BAO_CAO') AND P.deleted = 0
			GROUP BY P.Nhom_Thanh_Vien_ID
		)
		INSERT INTO dbo.tbl_Sys_Phan_Quyen_Chuc_Nang
			(Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission,
			 Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission,
			 Is_Have_Export_Permission, deleted, Created, Created_By, Created_By_Function,
			 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
		SELECT @Max_Perm_ID + ROW_NUMBER() OVER (ORDER BY Src.Nhom_Thanh_Vien_ID),
			   Src.Nhom_Thanh_Vien_ID, @Master_Data_ID,
			   Src.Is_View, 0, 0, 0, Src.Is_Export, 0, @Now, @Login_Name, 'MENU_SETUP',
			   @Now, @Login_Name, 'MENU_SETUP'
		FROM Src;
	END

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	THROW;
END CATCH
GO

-- ----------------------------------------------------------------------------
-- 7. Kiểm tra kết quả: đúng 3 cột top-level
-- ----------------------------------------------------------------------------
SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Func_URL
FROM dbo.tbl_Sys_Chuc_Nang
WHERE deleted = 0 AND Nhom_Chuc_Nang_ID = 1 AND Chuc_Nang_Parent_ID = 0
ORDER BY Sort_Priority;
GO
