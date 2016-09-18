SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 7th August 2016
-- Description:	
-- =============================================
ALTER PROCEDURE ValidateDataType 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON; 
	DECLARE @ErrorCount INT;

	SET @ErrorCount = 
	 (SELECT
		COUNT(*)
		FROM [dbo].[LabourForceSurveyError]);
	IF (@ErrorCount>0)
	BEGIN
		EXEC [dbo].[SendEmail] 'LabourForce','PackageDataError'
		EXEC [dbo].[AddToLog] 
			@PackageId=''
			, @PackageName = 'LabourForceSurvey'
			, @TaskName='Validate error data from sql'
			, @LogDescription='Data error found and email is sent for the same'
		
		EXEC dbo.ThrowError 'Data is not valid. Please refer mail for erronous data.';
	END

END
GO
