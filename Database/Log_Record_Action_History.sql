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

IF OBJECT_ID(N'dbo.tbl_Log_Record_Action_History', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.tbl_Log_Record_Action_History
	(
		Auto_ID BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_tbl_Log_Record_Action_History PRIMARY KEY,
		Ref_ID BIGINT NOT NULL,
		Ten_Hanh_Dong NVARCHAR(100) NOT NULL,
		Ten_Moi_Truong NVARCHAR(100) NOT NULL,
		Ma_Chuc_Nang NVARCHAR(50) NOT NULL,
		Ten_Chuc_Nang NVARCHAR(200) NOT NULL,
		Noi_Dung_Action NVARCHAR(MAX) NOT NULL,
		deleted INT NOT NULL CONSTRAINT DF_tbl_Log_Record_Action_History_deleted DEFAULT (0),
		Created DATETIME2(0) NOT NULL CONSTRAINT DF_tbl_Log_Record_Action_History_Created DEFAULT (SYSDATETIME()),
		Created_By NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_Log_Record_Action_History_Created_By DEFAULT (N''),
		Created_By_Function NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_Log_Record_Action_History_Created_By_Function DEFAULT (N''),
		Last_Updated DATETIME2(0) NULL,
		Last_Updated_By NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_Log_Record_Action_History_Last_Updated_By DEFAULT (N''),
		Last_Updated_By_Function NVARCHAR(100) NOT NULL CONSTRAINT DF_tbl_Log_Record_Action_History_Last_Updated_By_Function DEFAULT (N'')
	);
END
ELSE
BEGIN
	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'Created_By_Function')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD Created_By_Function NVARCHAR(100) NULL;

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'Last_Updated')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD Last_Updated DATETIME2(0) NULL;

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'Last_Updated_By')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD Last_Updated_By NVARCHAR(100) NULL;

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'Last_Updated_By_Function')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD Last_Updated_By_Function NVARCHAR(100) NULL;

	UPDATE dbo.tbl_Log_Record_Action_History
	SET Created_By_Function = ISNULL(Created_By_Function, N''),
		Last_Updated_By = ISNULL(Last_Updated_By, N''),
		Last_Updated_By_Function = ISNULL(Last_Updated_By_Function, N'');

	ALTER TABLE dbo.tbl_Log_Record_Action_History ALTER COLUMN Created_By_Function NVARCHAR(100) NOT NULL;
	ALTER TABLE dbo.tbl_Log_Record_Action_History ALTER COLUMN Last_Updated_By NVARCHAR(100) NOT NULL;
	ALTER TABLE dbo.tbl_Log_Record_Action_History ALTER COLUMN Last_Updated_By_Function NVARCHAR(100) NOT NULL;

	IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'DF_tbl_Log_Record_Action_History_Created_By_Function')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD CONSTRAINT DF_tbl_Log_Record_Action_History_Created_By_Function DEFAULT (N'') FOR Created_By_Function;

	IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'DF_tbl_Log_Record_Action_History_Last_Updated_By')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD CONSTRAINT DF_tbl_Log_Record_Action_History_Last_Updated_By DEFAULT (N'') FOR Last_Updated_By;

	IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.tbl_Log_Record_Action_History') AND name = 'DF_tbl_Log_Record_Action_History_Last_Updated_By_Function')
		ALTER TABLE dbo.tbl_Log_Record_Action_History ADD CONSTRAINT DF_tbl_Log_Record_Action_History_Last_Updated_By_Function DEFAULT (N'') FOR Last_Updated_By_Function;
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_425_RAH_sp_ins_Insert
	@Ref_ID BIGINT,
	@Ten_Hanh_Dong NVARCHAR(100),
	@Ten_Moi_Truong NVARCHAR(100),
	@Ma_Chuc_Nang NVARCHAR(50),
	@Ten_Chuc_Nang NVARCHAR(200),
	@Noi_Dung_Action NVARCHAR(MAX),
	@Created_By NVARCHAR(100),
	@Last_Updated_By_Function NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	SET @Ten_Hanh_Dong = LTRIM(RTRIM(ISNULL(@Ten_Hanh_Dong, N'')));
	SET @Ten_Moi_Truong = LTRIM(RTRIM(ISNULL(@Ten_Moi_Truong, N'')));
	SET @Ma_Chuc_Nang = LTRIM(RTRIM(ISNULL(@Ma_Chuc_Nang, N'')));
	SET @Ten_Chuc_Nang = LTRIM(RTRIM(ISNULL(@Ten_Chuc_Nang, N'')));
	SET @Noi_Dung_Action = ISNULL(@Noi_Dung_Action, N'');

	IF @Ref_ID <= 0 THROW 52501, N'Ref_ID không hợp lệ.', 1;
	IF @Ten_Hanh_Dong = N'' THROW 52502, N'Tên hành động không được để trống.', 1;
	IF @Ten_Moi_Truong = N'' THROW 52503, N'Tên trường không được để trống.', 1;
	IF @Ma_Chuc_Nang = N'' THROW 52504, N'Mã chức năng không được để trống.', 1;
	IF @Ten_Chuc_Nang = N'' THROW 52505, N'Tên chức năng không được để trống.', 1;

	INSERT INTO dbo.tbl_Log_Record_Action_History
		(Ref_ID, Ten_Hanh_Dong, Ten_Moi_Truong, Ma_Chuc_Nang, Ten_Chuc_Nang, Noi_Dung_Action,
		 Created_By, Created_By_Function, Last_Updated_By, Last_Updated_By_Function)
	VALUES
		(@Ref_ID, @Ten_Hanh_Dong, @Ten_Moi_Truong, @Ma_Chuc_Nang, @Ten_Chuc_Nang, @Noi_Dung_Action,
		 ISNULL(@Created_By, N''), ISNULL(@Last_Updated_By_Function, N''),
		 ISNULL(@Created_By, N''), ISNULL(@Last_Updated_By_Function, N''));

	SELECT CONVERT(BIGINT, SCOPE_IDENTITY());
END
GO

CREATE OR ALTER PROCEDURE dbo.FQ_425_RAH_sp_sel_List_By_Created
	@Created_From DATETIME2(0) = NULL,
	@Created_To DATETIME2(0) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Auto_ID, Ref_ID, Ten_Hanh_Dong, Ten_Moi_Truong, Ma_Chuc_Nang, Ten_Chuc_Nang, Noi_Dung_Action,
		deleted, Created, Created_By, Created_By_Function,
		Last_Updated, Last_Updated_By, Last_Updated_By_Function
	FROM dbo.tbl_Log_Record_Action_History
	WHERE deleted = 0
		AND (@Created_From IS NULL OR Created >= @Created_From)
		AND (@Created_To IS NULL OR Created <= @Created_To)
	ORDER BY Created DESC, Auto_ID DESC;
END
GO
