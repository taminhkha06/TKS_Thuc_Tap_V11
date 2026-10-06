USE [TKS_Thuc_Tap_V11]
GO

-- 1. Tạo 4 nhóm menu cha
BEGIN TRANSACTION;

-- Kiểm tra và tạo nhóm Danh mục
IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_DANH_MUC' AND deleted = 0)
BEGIN
	DECLARE @DanhMuc_ID BIGINT;
	SELECT @DanhMuc_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;
	
	INSERT INTO dbo.tbl_Sys_Chuc_Nang
		(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
		 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
		 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@DanhMuc_ID, 'MENU_DANH_MUC', N'Danh mục', 1, 0,
		 1, NULL, 'ri-list-check', 1, 0, 0, 0, 0, NULL,
			N'Nhóm danh mục', 0, GETDATE(), 'admin', 'MENU_SETUP',
		 GETDATE(), 'admin', 'MENU_SETUP');
END

-- Kiểm tra và tạo nhóm Kho
IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_KHO' AND deleted = 0)
BEGIN
	DECLARE @Kho_ID BIGINT;
	SELECT @Kho_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;
	
	INSERT INTO dbo.tbl_Sys_Chuc_Nang
		(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
		 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
		 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@Kho_ID, 'MENU_KHO', N'Kho', 2, 0,
			1, NULL, 'ri-store-2-line', 1, 0, 0, 0, 0, NULL,
			N'Nhóm kho', 0, GETDATE(), 'admin', 'MENU_SETUP',
			GETDATE(), 'admin', 'MENU_SETUP');
END

-- Kiểm tra và tạo nhóm Báo cáo
IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_BAO_CAO' AND deleted = 0)
BEGIN
	DECLARE @BaoCao_ID BIGINT;
	SELECT @BaoCao_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;
	
	INSERT INTO dbo.tbl_Sys_Chuc_Nang
		(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
		 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
		 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@BaoCao_ID, 'MENU_BAO_CAO', N'Báo cáo', 3, 0,
			1, NULL, 'ri-file-chart-line', 1, 0, 0, 0, 0, NULL,
			N'Nhóm báo cáo', 0, GETDATE(), 'admin', 'MENU_SETUP',
			GETDATE(), 'admin', 'MENU_SETUP');
END

-- 2. Di chuyển các chức năng vào đúng nhóm
DECLARE @Parent_DanhMuc BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_DANH_MUC' AND deleted = 0);
DECLARE @Parent_Kho BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_KHO' AND deleted = 0);
DECLARE @Parent_BaoCao BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_BAO_CAO' AND deleted = 0);

-- Di chuyển Chủ hàng, Đơn vị tính vào Danh mục
UPDATE dbo.tbl_Sys_Chuc_Nang
SET Chuc_Nang_Parent_ID = @Parent_DanhMuc,
	Sort_Priority = CASE Ma_Chuc_Nang
		WHEN '2003' THEN 1  -- Chủ hàng
		WHEN '2004' THEN 2  -- Đơn vị tính
		ELSE Sort_Priority
	END
WHERE Ma_Chuc_Nang IN ('2003', '2004') AND deleted = 0;

-- Di chuyển Loại sản phẩm, Sản phẩm, Nhà cung cấp, Kho, Kho User, Phiếu nhập, Phiếu xuất vào Kho
UPDATE dbo.tbl_Sys_Chuc_Nang
SET Chuc_Nang_Parent_ID = @Parent_Kho,
	Sort_Priority = CASE Ma_Chuc_Nang
		WHEN '2005' THEN 1  -- Loại sản phẩm
		WHEN '2006' THEN 2  -- Sản phẩm
		WHEN '2007' THEN 3  -- Nhà cung cấp
		WHEN '2008' THEN 4  -- Kho
		WHEN '2009' THEN 5  -- Kho User
		WHEN '2010' THEN 6  -- Phiếu nhập
		WHEN '2011' THEN 7  -- Phiếu xuất
		ELSE Sort_Priority
	END
WHERE Ma_Chuc_Nang IN ('2005', '2006', '2007', '2008', '2009', '2010', '2011') AND deleted = 0;

COMMIT TRANSACTION;
GO

-- 3. Tạo 3 chức năng báo cáo
DECLARE @Parent_BaoCao BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = 'MENU_BAO_CAO' AND deleted = 0);
DECLARE @Login_Name NVARCHAR(100) = CONVERT(NVARCHAR(100), SUSER_SNAME());
DECLARE @Now DATETIME = GETDATE();
DECLARE @Max_Perm_ID BIGINT = ISNULL((SELECT MAX(Auto_ID) FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang), 0);

-- Báo cáo chi tiết hàng nhập
IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = '2015' AND deleted = 0)
BEGIN
	DECLARE @BC_Nhap_ID BIGINT;
	SELECT @BC_Nhap_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;
	
	INSERT INTO dbo.tbl_Sys_Chuc_Nang
		(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
		 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
		 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@BC_Nhap_ID, '2015', 'Báo cáo chi tiết hàng nhập', 1, @Parent_BaoCao,
		 NULL, '/Bao_Cao/Bao_Cao_Nhap_Kho', 'ri-file-list-3-line', 1, 0, 0, 0, 1, NULL,
			N'Báo cáo chi tiết hàng nhập', 0, @Now, @Login_Name, 'MENU_SETUP',
			@Now, @Login_Name, 'MENU_SETUP');
END

-- Báo cáo chi tiết hàng xuất
IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = '2016' AND deleted = 0)
BEGIN
	DECLARE @BC_Xuat_ID BIGINT;
	SELECT @BC_Xuat_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;
	
	INSERT INTO dbo.tbl_Sys_Chuc_Nang
		(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
		 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
		 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@BC_Xuat_ID, '2016', 'Báo cáo chi tiết hàng xuất', 2, @Parent_BaoCao,
		 NULL, '/Bao_Cao/Bao_Cao_Xuat_Kho', 'ri-file-list-3-line', 1, 0, 0, 0, 1, NULL,
			N'Báo cáo chi tiết hàng xuất', 0, @Now, @Login_Name, 'MENU_SETUP',
			@Now, @Login_Name, 'MENU_SETUP');
END

-- Báo cáo xuất nhập tồn
IF NOT EXISTS (SELECT 1 FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = '2017' AND deleted = 0)
BEGIN
	DECLARE @BC_Ton_ID BIGINT;
	SELECT @BC_Ton_ID = ISNULL(MAX(Auto_ID), 0) + 1 FROM dbo.tbl_Sys_Chuc_Nang;
	
	INSERT INTO dbo.tbl_Sys_Chuc_Nang
		(Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID,
		 Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete,
		 Is_Export, Khach_Hang_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function,
		 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@BC_Ton_ID, '2017', 'Báo cáo xuất nhập tồn', 3, @Parent_BaoCao,
		 NULL, '/Bao_Cao/Bao_Cao_Xuat_Nhap_Ton', 'ri-file-chart-2-line', 1, 0, 0, 0, 1, NULL,
			N'Báo cáo xuất nhập tồn', 0, @Now, @Login_Name, 'MENU_SETUP',
			@Now, @Login_Name, 'MENU_SETUP');
END

-- 4. Copy quyền cho các chức năng báo cáo
DECLARE @Source_Permission_ID BIGINT = (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Ma_Chuc_Nang = '2010' AND deleted = 0);

INSERT INTO dbo.tbl_Sys_Phan_Quyen_Chuc_Nang
	(Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission,
	 Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission,
	 Is_Have_Export_Permission, deleted, Created, Created_By, Created_By_Function,
	 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
SELECT 
	@Max_Perm_ID + ROW_NUMBER() OVER (ORDER BY SourcePermission.Nhom_Thanh_Vien_ID),
	SourcePermission.Nhom_Thanh_Vien_ID, TargetFunction.Auto_ID,
	SourcePermission.Is_Have_View_Permission,
	0, 0, 0,
	SourcePermission.Is_Have_Export_Permission, 0, @Now, @Login_Name, 'MENU_SETUP',
	@Now, @Login_Name, 'MENU_SETUP'
FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang SourcePermission
CROSS JOIN dbo.tbl_Sys_Chuc_Nang TargetFunction
WHERE SourcePermission.Chuc_Nang_ID = @Source_Permission_ID 
	AND SourcePermission.deleted = 0
	AND TargetFunction.Ma_Chuc_Nang IN ('2015', '2016', '2017')
	AND TargetFunction.deleted = 0
	AND NOT EXISTS (
		SELECT 1 FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang Existing
		WHERE Existing.Chuc_Nang_ID = TargetFunction.Auto_ID
			AND Existing.Nhom_Thanh_Vien_ID = SourcePermission.Nhom_Thanh_Vien_ID
			AND Existing.deleted = 0
	);

-- 5. Chuẩn hóa tên tiếng Việt (phòng trường hợp file chạy sai mã hóa) và cấu trúc menu
UPDATE dbo.tbl_Sys_Chuc_Nang SET Ten_Chuc_Nang = N'Danh mục', Ghi_Chu = N'Nhóm danh mục' WHERE Ma_Chuc_Nang = 'MENU_DANH_MUC' AND deleted = 0;
UPDATE dbo.tbl_Sys_Chuc_Nang SET Ten_Chuc_Nang = N'Kho', Ghi_Chu = N'Nhóm kho' WHERE Ma_Chuc_Nang = 'MENU_KHO' AND deleted = 0;
UPDATE dbo.tbl_Sys_Chuc_Nang SET Ten_Chuc_Nang = N'Báo cáo', Ghi_Chu = N'Nhóm báo cáo' WHERE Ma_Chuc_Nang = 'MENU_BAO_CAO' AND deleted = 0;
UPDATE dbo.tbl_Sys_Chuc_Nang SET Ten_Chuc_Nang = N'Báo cáo chi tiết hàng nhập', Ghi_Chu = N'Báo cáo chi tiết hàng nhập' WHERE Ma_Chuc_Nang = '2015' AND deleted = 0;
UPDATE dbo.tbl_Sys_Chuc_Nang SET Ten_Chuc_Nang = N'Báo cáo chi tiết hàng xuất', Ghi_Chu = N'Báo cáo chi tiết hàng xuất' WHERE Ma_Chuc_Nang = '2016' AND deleted = 0;
UPDATE dbo.tbl_Sys_Chuc_Nang SET Ten_Chuc_Nang = N'Báo cáo xuất nhập tồn', Ghi_Chu = N'Báo cáo xuất nhập tồn' WHERE Ma_Chuc_Nang = '2017' AND deleted = 0;

-- Đưa 3 nhóm về cấp top-level (Parent = 0) và nhóm Quan_Tri (Nhom = 1) để hiển thị trên sidebar
UPDATE dbo.tbl_Sys_Chuc_Nang
SET Chuc_Nang_Parent_ID = 0, Nhom_Chuc_Nang_ID = 1
WHERE Ma_Chuc_Nang IN ('MENU_DANH_MUC', 'MENU_KHO', 'MENU_BAO_CAO') AND deleted = 0;

-- 3 chức năng báo cáo cũng phải thuộc nhóm Quan_Tri thì mới vào được cache menu (sidebar)
UPDATE dbo.tbl_Sys_Chuc_Nang
SET Nhom_Chuc_Nang_ID = 1
WHERE Ma_Chuc_Nang IN ('2015', '2016', '2017') AND deleted = 0;

-- 6. Copy quyền View/Export cho 3 nhóm menu theo quyền của các chức năng con
-- MENU_DANH_MUC ← quyền 2003/2004; MENU_KHO ← quyền 2005..2011; MENU_BAO_CAO ← quyền 2010/2015..2017
DECLARE @Max_Perm_ID_2 BIGINT = ISNULL((SELECT MAX(Auto_ID) FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang), 0);

;WITH Src AS (
	SELECT M_New.Ma_Chuc_Nang AS Ma_Nhom_Moi, P.Nhom_Thanh_Vien_ID,
		MAX(CAST(P.Is_Have_View_Permission AS INT)) AS Is_View,
		MAX(CAST(P.Is_Have_Export_Permission AS INT)) AS Is_Export
	FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang P
	JOIN dbo.tbl_Sys_Chuc_Nang C_SRC ON C_SRC.Auto_ID = P.Chuc_Nang_ID AND C_SRC.deleted = 0
	JOIN dbo.tbl_Sys_Chuc_Nang M_New ON M_New.deleted = 0 AND (
		(M_New.Ma_Chuc_Nang = 'MENU_DANH_MUC' AND C_SRC.Ma_Chuc_Nang IN ('2003', '2004'))
		OR (M_New.Ma_Chuc_Nang = 'MENU_KHO' AND C_SRC.Ma_Chuc_Nang IN ('2005', '2006', '2007', '2008', '2009', '2010', '2011'))
		OR (M_New.Ma_Chuc_Nang = 'MENU_BAO_CAO' AND C_SRC.Ma_Chuc_Nang IN ('2010', '2015', '2016', '2017')))
	WHERE P.deleted = 0
	GROUP BY M_New.Ma_Chuc_Nang, P.Nhom_Thanh_Vien_ID
)
INSERT INTO dbo.tbl_Sys_Phan_Quyen_Chuc_Nang
	(Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission,
	 Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission,
	 Is_Have_Export_Permission, deleted, Created, Created_By, Created_By_Function,
	 Last_Updated, Last_Updated_By, Last_Updated_By_Function)
SELECT 
	@Max_Perm_ID_2 + ROW_NUMBER() OVER (ORDER BY Src.Ma_Nhom_Moi, Src.Nhom_Thanh_Vien_ID),
	Src.Nhom_Thanh_Vien_ID, M_New.Auto_ID,
	Src.Is_View, 0, 0, 0,
	Src.Is_Export, 0, @Now, @Login_Name, 'MENU_SETUP',
	@Now, @Login_Name, 'MENU_SETUP'
FROM Src
JOIN dbo.tbl_Sys_Chuc_Nang M_New ON M_New.Ma_Chuc_Nang = Src.Ma_Nhom_Moi AND M_New.deleted = 0
WHERE NOT EXISTS (
	SELECT 1 FROM dbo.tbl_Sys_Phan_Quyen_Chuc_Nang Existing
	WHERE Existing.Chuc_Nang_ID = M_New.Auto_ID
		AND Existing.Nhom_Thanh_Vien_ID = Src.Nhom_Thanh_Vien_ID
		AND Existing.deleted = 0
);
GO

PRINT 'Đã tạo 3 chức năng báo cáo và copy quyền thành công!';
