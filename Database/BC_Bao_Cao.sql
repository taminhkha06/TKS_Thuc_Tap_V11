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

-- Báo cáo chi tiết hàng nhập
CREATE OR ALTER PROCEDURE dbo.FQ_2015_BC_sp_sel_Bao_Cao_Nhap_Kho
	@Ngay_Dau_Ky DATE = NULL,
	@Ngay_Cuoi_Ky DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @Ngay_Dau_Ky = ISNULL(@Ngay_Dau_Ky, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));
	SET @Ngay_Cuoi_Ky = ISNULL(@Ngay_Cuoi_Ky, GETDATE());

	SELECT 
		H.Ngay_Nhap_Kho,
		H.So_Phieu_Nhap_Kho,
		N.Ten_NCC,
		P.Ma_San_Pham,
		P.Ten_San_Pham,
		R.SL_Nhap,
		R.Don_Gia_Nhap,
		R.SL_Nhap * R.Don_Gia_Nhap AS Tri_Gia
	FROM dbo.tbl_DM_Nhap_Kho_Raw_Data R
	JOIN dbo.tbl_DM_Nhap_Kho H ON H.Auto_ID = R.Nhap_Kho_ID
	JOIN dbo.tbl_DM_San_Pham P ON P.Auto_ID = R.San_Pham_ID
	JOIN dbo.tbl_DM_NCC N ON N.Auto_ID = H.NCC_ID
	WHERE H.deleted = 0 AND P.deleted = 0 AND N.deleted = 0
		AND H.Ngay_Nhap_Kho >= @Ngay_Dau_Ky AND H.Ngay_Nhap_Kho <= @Ngay_Cuoi_Ky
	ORDER BY H.Ngay_Nhap_Kho DESC, H.So_Phieu_Nhap_Kho, R.Auto_ID;
END
GO

-- Báo cáo chi tiết hàng xuất
CREATE OR ALTER PROCEDURE dbo.FQ_2016_BC_sp_sel_Bao_Cao_Xuat_Kho
	@Ngay_Dau_Ky DATE = NULL,
	@Ngay_Cuoi_Ky DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @Ngay_Dau_Ky = ISNULL(@Ngay_Dau_Ky, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));
	SET @Ngay_Cuoi_Ky = ISNULL(@Ngay_Cuoi_Ky, GETDATE());

	SELECT 
		H.Ngay_Xuat_Kho,
		H.So_Phieu_Xuat_Kho,
		P.Ma_San_Pham,
		P.Ten_San_Pham,
		R.SL_Xuat,
		R.Don_Gia_Xuat,
		R.SL_Xuat * R.Don_Gia_Xuat AS Tri_Gia
	FROM dbo.tbl_DM_Xuat_Kho_Raw_Data R
	JOIN dbo.tbl_DM_Xuat_Kho H ON H.Auto_ID = R.Xuat_Kho_ID
	JOIN dbo.tbl_DM_San_Pham P ON P.Auto_ID = R.San_Pham_ID
	WHERE H.deleted = 0 AND P.deleted = 0
		AND H.Ngay_Xuat_Kho >= @Ngay_Dau_Ky AND H.Ngay_Xuat_Kho <= @Ngay_Cuoi_Ky
	ORDER BY H.Ngay_Xuat_Kho DESC, H.So_Phieu_Xuat_Kho, R.Auto_ID;
END
GO

-- Báo cáo xuất nhập tồn
CREATE OR ALTER PROCEDURE dbo.FQ_2017_BC_sp_sel_Bao_Cao_Xuat_Nhap_Ton
	@Ngay_Dau_Ky DATE = NULL,
	@Ngay_Cuoi_Ky DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @Ngay_Dau_Ky = ISNULL(@Ngay_Dau_Ky, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));
	SET @Ngay_Cuoi_Ky = ISNULL(@Ngay_Cuoi_Ky, GETDATE());

	DECLARE @Ngay_Dau_Truoc_Ky DATE = DATEADD(DAY, -1, @Ngay_Dau_Ky);

	-- Tính SL đầu kỳ, nhập trong kỳ, xuất trong kỳ cho từng sản phẩm
	DECLARE @TmpTon TABLE (
		San_Pham_ID BIGINT,
		Ma_San_Pham NVARCHAR(50),
		Ten_San_Pham NVARCHAR(200),
		SL_Dau_Ky DECIMAL(18, 3) DEFAULT 0,
		SL_Nhap DECIMAL(18, 3) DEFAULT 0,
		SL_Xuat DECIMAL(18, 3) DEFAULT 0
	);

	INSERT INTO @TmpTon (San_Pham_ID, Ma_San_Pham, Ten_San_Pham)
	SELECT P.Auto_ID, P.Ma_San_Pham, P.Ten_San_Pham
	FROM dbo.tbl_DM_San_Pham P
	WHERE P.deleted = 0;

	-- SL đầu kỳ = tổng nhập trước kỳ - tổng xuất trước kỳ
	UPDATE T
	SET SL_Dau_Ky = ISNULL((SELECT SUM(ISNULL(R.SL_Nhap, 0))
		FROM dbo.tbl_DM_Nhap_Kho_Raw_Data R
		JOIN dbo.tbl_DM_Nhap_Kho H ON H.Auto_ID = R.Nhap_Kho_ID
		WHERE R.San_Pham_ID = T.San_Pham_ID AND H.deleted = 0
		AND H.Ngay_Nhap_Kho < @Ngay_Dau_Ky), 0)
		- ISNULL((SELECT SUM(ISNULL(R.SL_Xuat, 0))
		FROM dbo.tbl_DM_Xuat_Kho_Raw_Data R
		JOIN dbo.tbl_DM_Xuat_Kho H ON H.Auto_ID = R.Xuat_Kho_ID
		WHERE R.San_Pham_ID = T.San_Pham_ID AND H.deleted = 0
		AND H.Ngay_Xuat_Kho < @Ngay_Dau_Ky), 0)
	FROM @TmpTon T;

	-- SL nhập trong kỳ
	UPDATE T
	SET SL_Nhap = ISNULL((SELECT SUM(ISNULL(R.SL_Nhap, 0))
		FROM dbo.tbl_DM_Nhap_Kho_Raw_Data R
		JOIN dbo.tbl_DM_Nhap_Kho H ON H.Auto_ID = R.Nhap_Kho_ID
		WHERE R.San_Pham_ID = T.San_Pham_ID AND H.deleted = 0
		AND H.Ngay_Nhap_Kho >= @Ngay_Dau_Ky AND H.Ngay_Nhap_Kho <= @Ngay_Cuoi_Ky), 0)
	FROM @TmpTon T;

	-- SL xuất trong kỳ
	UPDATE T
	SET SL_Xuat = ISNULL((SELECT SUM(ISNULL(R.SL_Xuat, 0))
		FROM dbo.tbl_DM_Xuat_Kho_Raw_Data R
		JOIN dbo.tbl_DM_Xuat_Kho H ON H.Auto_ID = R.Xuat_Kho_ID
		WHERE R.San_Pham_ID = T.San_Pham_ID AND H.deleted = 0
		AND H.Ngay_Xuat_Kho >= @Ngay_Dau_Ky AND H.Ngay_Xuat_Kho <= @Ngay_Cuoi_Ky), 0)
	FROM @TmpTon T;

	SELECT 
		Ma_San_Pham,
		Ten_San_Pham,
		SL_Dau_Ky,
		SL_Nhap,
		SL_Xuat,
		SL_Dau_Ky + SL_Nhap - SL_Xuat AS SL_Cuoi_Ky
	FROM @TmpTon
	ORDER BY Ma_San_Pham;
END
GO

PRINT 'Đã tạo stored procedures cho 3 báo cáo thành công!';
