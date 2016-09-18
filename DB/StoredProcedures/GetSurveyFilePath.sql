SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August 2016
-- Description:	Get file path based on survey type
-- =============================================
CREATE PROCEDURE dbo.GetSurveyFilePath 
	-- Add the parameters for the stored procedure here
	@SurveyType VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		[SourceFilePath]
		,[ErrorFilePath]
		FROM [dbo].[SurveyUpload]
		WHERE SurveyType = @SurveyType
		AND [PackageStatus] = 'NEW'
		
END
GO
