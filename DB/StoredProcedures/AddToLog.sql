SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August
-- Description:	Add log entry
-- =============================================
ALTER PROCEDURE dbo.AddToLog 
	-- Add the parameters for the stored procedure here
	@PackageId VARCHAR(50) , 
	@PackageName VARCHAR(50),
	@TaskName VARCHAR(255),
	@LogDescription VARCHAR(500),
	@ErrorCode	INT=NULL,
	@ErrorDescription VARCHAR(500)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[PackageLog]
	(
		[PackageId]
		,[PackageName]
		,[TaskName]
		,[LogDescription]
		,[ErrorCode]
		,[ErrorDescription]
	)
	VALUES
	(
		@PackageId
		,@PackageName
		,@TaskName
		,@LogDescription
		,@ErrorCode
		,@ErrorDescription
	)
END
GO
