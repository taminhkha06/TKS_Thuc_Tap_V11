USE [TKS_Thuc_Tap_V11]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE dbo.FCommon_Sys_sp_sel_List_Log_Record_Action_History
	@Ref_ID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Auto_ID, Ref_ID, Ten_Hanh_Dong, Ten_Moi_Truong, Ma_Chuc_Nang, Ten_Chuc_Nang, Noi_Dung_Action,
		deleted, Created, Created_By
	FROM dbo.view_Log_Record_Action_History WITH (NOLOCK)
	WHERE Ref_ID = @Ref_ID
	ORDER BY Auto_ID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.FCommon_Insert_Log_API
	@Key_No NVARCHAR(50),
	@API_Source_Name NVARCHAR(50),
	@API_Function_Name NVARCHAR(50),
	@Description NVARCHAR(500),
	@Link_URL NVARCHAR(500),
	@Trang_Thai_ID INT,
	@Last_Updated_By NVARCHAR(50),
	@Last_Updated_By_Function NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Auto_ID BIGINT;

	SELECT TOP 1 @Auto_ID = Auto_ID
	FROM dbo.tbl_Log_API WITH (NOLOCK)
	WHERE Key_No = @Key_No AND API_Source_Name = @API_Source_Name AND API_Function_Name = @API_Function_Name AND deleted = 0;

	IF (@Auto_ID IS NOT NULL AND @Auto_ID > 0)
	BEGIN
		UPDATE dbo.tbl_Log_API
		SET Description = @Description,
			Link_URL = @Link_URL,
			Trang_Thai_ID = @Trang_Thai_ID,
			Last_Updated = GETDATE(),
			Last_Updated_By = @Last_Updated_By,
			Last_Updated_By_Function = @Last_Updated_By_Function
		WHERE Auto_ID = @Auto_ID;

		SELECT 0;
	END
	ELSE
	BEGIN
		SET @Auto_ID = (NEXT VALUE FOR dbo.Seq_ID);

		INSERT INTO dbo.tbl_Log_API
		(
			Auto_ID, Key_No, API_Source_Name, API_Function_Name, Description,
			Trang_Thai_ID, Link_URL, deleted, Created, Created_By, Created_By_Function,
			Last_Updated, Last_Updated_By, Last_Updated_By_Function
		)
		VALUES
		(
			@Auto_ID, @Key_No, @API_Source_Name, @API_Function_Name, @Description,
			@Trang_Thai_ID, @Link_URL, 0, GETDATE(), @Last_Updated_By, @Last_Updated_By_Function,
			GETDATE(), @Last_Updated_By, @Last_Updated_By_Function
		);

		SELECT @Auto_ID;
	END
END
GO
