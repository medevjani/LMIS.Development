SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 14th August
-- Description:	Get all config details based on survey type
-- GetPackageConfigurations 'LabourForce'
-- =============================================
CREATE PROCEDURE dbo.GetPackageConfigurations 
	-- Add the parameters for the stored procedure here
	@SurveyType VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SourceFilePath AS VARCHAR(255)
	DECLARE @ErrorFilePath AS VARCHAR(255)
	DECLARE @ErrorFileTemplatePath AS VARCHAR(255)

    -- Insert statements for procedure here
	SET @SourceFilePath = 
		(SELECT ConfigValue  
			FROM [dbo].[PackageConfig]
			WHERE SurveyType = @SurveyType
			AND ConfigKey = 'SourceFilePath'

		)

	SET @ErrorFilePath = 
		(SELECT ConfigValue  
			FROM [dbo].[PackageConfig]
			WHERE SurveyType = @SurveyType
			AND ConfigKey = 'ErrorFilePath'

		)
	SET @ErrorFileTemplatePath = 
		(SELECT ConfigValue  
			FROM [dbo].[PackageConfig]
			WHERE SurveyType = @SurveyType
			AND ConfigKey = 'ErrorFileTemplatePath'

		)
	SELECT 
		@SourceFilePath AS 'SourceFilePath'
		,@ErrorFilePath AS 'ErrorFilePath'
		,@ErrorFileTemplatePath AS 'ErrorFileTemplatePath'



END
GO
