SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August
-- Description:	Update the upload status
-- =============================================
ALTER PROCEDURE dbo.UpdateUploadStatus 
	-- Add the parameters for the stored procedure here
	@SurveyUploadId BIGINT , 
	@PackageStatus VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE [dbo].[SurveyUpload]
		SET [PackageStatus] = @PackageStatus 
		,ModifiedDate = GETDATE()
	WHERE SurveyUploadId = @SurveyUploadId

END
GO
