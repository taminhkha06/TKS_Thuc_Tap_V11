USE [TKS_Thuc_Tap_V11]
GO

-- Bật quyền Edit cho chức năng Phiếu xuất kho (2011)
UPDATE dbo.tbl_Sys_Chuc_Nang
SET Is_Edit = 1
WHERE Func_URL = N'/Danh_Muc/Xuat_Kho' AND deleted = 0;
GO

-- Bật quyền Edit cho tất cả user group của chức năng Phiếu xuất kho
UPDATE dbo.tbl_Sys_Phan_Quyen_Chuc_Nang
SET Is_Have_Edit_Permission = 1
WHERE Chuc_Nang_ID IN (SELECT Auto_ID FROM dbo.tbl_Sys_Chuc_Nang WHERE Func_URL = N'/Danh_Muc/Xuat_Kho' AND deleted = 0)
	AND deleted = 0;
GO

PRINT 'Đã bật quyền Edit thành công!';
