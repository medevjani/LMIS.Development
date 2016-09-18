SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August 2016
-- Description:	Determine whether the package can  be executed or not
-- GetUploadDetails 'LabourForce'
-- =============================================
ALTER PROCEDURE dbo.GetUploadDetails
	-- Add the parameters for the stored procedure here
	@SurveyType VARCHAR(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrMsg VARCHAR(500)

    -- Insert statements for procedure here
	IF EXISTS(SELECT *
				FROM [dbo].[SurveyUpload]
			  WHERE PackageStatus = 'IN-PROGRESS')
	BEGIN
		SET @ErrMsg = @SurveyType + ' import already in progress. Please try after sometime.'
		EXEC dbo.ThrowError @ErrMsg
	END
	ELSE
	BEGIN
		-- Get the upload detail to process further
		IF EXISTS(SELECT *
				FROM [dbo].[SurveyUpload]
			  WHERE PackageStatus = 'NEW')
		BEGIN
			SELECT
				SurveyUploadId
			FROM [dbo].[SurveyUpload]
			WHERE [PackageStatus]='NEW'
			AND SurveyType = @SurveyType
		END
		ELSE
		BEGIN
			EXEC [dbo].[SendEmail] 'LabourForce','NoSurveyData'
			DECLARE @SurveyName VARCHAR(255);
			SET @SurveyName = @SurveyType + 'Survey';
			EXEC [dbo].[AddToLog] 
			@PackageId=''
			, @PackageName = @SurveyName
			, @TaskName='Get Survey details'
			, @LogDescription='There is no survey details found. Package execution is failed.'

			SET @ErrMsg = 'There is no ' + @SurveyType + ' survey queued for processing. Please upload the survey data again.'
			EXEC dbo.ThrowError @ErrMsg
		END
	END

END
GO
