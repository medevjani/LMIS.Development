SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 7th August 2016
-- Description:	Validate date of Survey data to avoid duplicate
-- =============================================
ALTER PROCEDURE ValidateYear 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS(SELECT * FROM [dbo].[LabourForceSurveyTemp] LT
		INNER JOIN [dbo].[LabourForceSurvey] L
				ON (CONVERT(DATETIME,(CONVERT(VARCHAR,LT.HH_Y) +'-'+
				CONVERT(VARCHAR,LT.HH_M) + '-'+
				CONVERT(VARCHAR,LT.HH_D))))<=(SELECT 
				CONVERT(DATETIME,(CONVERT(VARCHAR,L.HH_Y) +'-'+
				CONVERT(VARCHAR,L.HH_M) + '-'+
				CONVERT(VARCHAR,L.HH_D)))))
	BEGIN
		EXEC [dbo].[SendEmail] 'LabourForce','PackageDataDuplicate'
		EXEC [dbo].[AddToLog] 
			@PackageId=''
			, @PackageName = 'LabourForceSurvey'
			, @TaskName='Validate survey date from sql'
			, @LogDescription='Duplicate Data found and email is sent for the same'
		EXEC dbo.ThrowError 'Data Already exists for specific time. Please upload fresh data!!';
	END
	ELSE
	BEGIN
		-- Calculate the survey effective year and update the temp table
		DECLARE @MaxYear INT
		SET @MaxYear = (SELECT MAX(HH_Y)
						FROM [dbo].[LabourForceSurveyTemp])
		IF(@MaxYear IS NOT NULL)
		BEGIN
			IF NOT EXISTS(SELECT * FROM [dbo].[SurveyEffectiveYear] WHERE EffectiveYear = @MaxYear)
			BEGIN
				-- Insert into year table
				INSERT INTO [dbo].[SurveyEffectiveYear]
				(
					EffectiveYear
				)
				VALUES
				(
					@MaxYear
				)
			END
		END

		DECLARE @SurveyEffectiveYearId INT
		SET @SurveyEffectiveYearId = (SELECT SurveyEffectiveYearId 
										FROM [dbo].[SurveyEffectiveYear]
										WHERE EffectiveYear=@MaxYear)

		-- Update effective year in temp table
		UPDATE [dbo].[LabourForceSurveyTemp]
		SET SurveyEffectiveYearId = @SurveyEffectiveYearId

		-- Update year table
		INSERT INTO [dbo].[SurveyYear]
		(
			SurveyYear
		)
		SELECT 
			DISTINCT HH_Y
		FROM [dbo].[LabourForceSurveyTemp]
		WHERE HH_Y NOT IN (SELECT SurveyYear FROM [dbo].[SurveyYear])

	END
END
GO
