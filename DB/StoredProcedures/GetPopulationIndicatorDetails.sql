-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 18th Sept 2016
-- Description:	Get populaion related indicator data
-- GetPopulationIndicatorDetails '1,1','1','1','1'
-- =============================================
ALTER PROCEDURE dbo.GetPopulationIndicatorDetails 
(
	@RegionCode VARCHAR(MAX) = NULL
	,@AgeGroupCode VARCHAR(MAX) = NULL
	,@GenderCode VARCHAR(MAX) = NULL
	,@IncomeGroupCode VARCHAR(MAX) = NULL
)

AS
BEGIN

DECLARE @ValRegionCode VARCHAR(MAX)
DECLARE @ValAgeGroupCode VARCHAR(MAX)
DECLARE @ValGenderCode VARCHAR(MAX)
DECLARE @ValIncomeGroupCode VARCHAR(MAX)
SET @ValAgeGroupCode = @AgeGroupCode
SET @ValGenderCode = @GenderCode
SET @ValIncomeGroupCode = @IncomeGroupCode
SET @ValRegionCode = @RegionCode

DECLARE @TableRegion TABLE (Data VARCHAR(100))
DECLARE @TableAgeGroup TABLE (Data VARCHAR(100))
DECLARE @TableGender TABLE (Data VARCHAR(100))
DECLARE @TableIncomeGroup TABLE (Data VARCHAR(100))

INSERT INTO @TableRegion
SELECT * FROM FnSplit(@ValRegionCode)

INSERT INTO @TableAgeGroup
SELECT * FROM FnSplit(@ValAgeGroupCode)

INSERT INTO @TableGender
SELECT * FROM FnSplit(@ValGenderCode)

INSERT INTO @TableIncomeGroup
SELECT * FROM FnSplit(@ValIncomeGroupCode)
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
	R.RegionTitle
	,SY.SurveyYear
	,SEY.EffectiveYear
	,AG.AgeGroupTitle
	,G.GenderTitle
	,Res.ResidenceTitle
	,IG.IncomeGroupTitle
	,S.SectorTitle
	,O.OccupationTitle
	,E.EducationTitle
	,[TotalLabourForceBroad]
	,[TotalLabourForceStrict]
	,[TotalPopulation]
	,[PerLabourForceBroad]
	,[PerLabourForceStrict]
	,[TotalInactivePopulationBroad]
	,[TotalInactivePopulationStrict]
	,[PerInactivePopulationBroad]
	,[PerInactivePopulationStrict]
	,[TotalEmployment]
	,[PerEmployment]
	,[TotalPartTimeWorker]
	,[PerPartTimeWorker]
	,[TotalInformalEmployment]
	,[PerInformalEmployment]
	,[TotalUnemploymentBroad]
	,[TotalUnemploymentStrict]
	,[PerUnemploymentBroad]
	,[PerUnemploymentStrict]
	,[TotalYouthLabourForceBroad]
	,[TotalYouthLabourForceStrict]
	,[TotalYouthUnemploymentBroad]
	,[TotalYouthUnemploymentStrict]
	,[TotalYouthEmployment]
	,[PerYouthUnemploymentBroad]
	,[PerYouthUnemploymentStrict]
	,[TotalAdultLabourForceBroad]
	,[TotalAdultLabourForceStrict]
	,[TotalAdultEmployment]
	,[TotalAdultUnemploymentBroad]
	,[TotalAdultUnemploymentStrict]
	,[PerAdultUnemploymentBroad]
	,[PerAdultUnemploymentStrict]
	,[TotalLongTermUnemployment]
	,[TotalEmployedLabourForceBroad]
	,[TotalEmployedLabourForceStrict]
	,[TotalTimeRelUnderEmployment]
	FROM [dbo].[LF_Indicator_PopulationEmployment] LFIPE
	LEFT JOIN dbo.Region R
	ON LFIPE.RegionId = R.RegionId
	LEFT JOIN dbo.SurveyYear SY
	on LFIPE.SurveyYearId = SY.SurveyYearId
	LEFT JOIN dbo.SurveyEffectiveYear SEY
	ON LFIPE.SurveyEffectiveYearId = SEY.SurveyEffectiveYearId
	LEFT JOIN dbo.AgeGroup AG
	ON LFIPE.AgeGroupId = AG.AgeGroupId
	LEFT JOIN dbo.Gender G
	ON LFIPE.GenderId = G.GenderId
	LEFT JOIN dbo.Residence Res
	ON LFIPE.ResidenceId = Res.ResidenceId
	LEFT JOIN IncomeGroup IG
	ON LFIPE.IncomeGroupId = IG.IncomeGroupId
	LEFT JOIN dbo.Sector S
	ON LFIPE.SectorId = S.SectorId
	LEFT JOIN dbo.Occupation O
	ON LFIPE.OcupationId = O.OccupationId
	LEFT JOIN dbo.Education E
	ON LFIPE.EducationId = E.EducationId
	WHERE ((R.RegionCode IS NULL AND @ValRegionCode LIKE '%-1%') OR (R.RegionCode IN (SELECT * FROM @TableRegion)))
	AND ((AG.AgeGroupCode IS NULL AND @ValAgeGroupCode LIKE '%-1%') OR (AG.AgeGroupCode IN (SELECT * FROM @TableAgeGroup)))
	AND( (G.GenderCode IS NULL AND @ValGenderCode LIKE '%-1%') OR (G.GenderCode IN (SELECT * FROM @TableGender)))
	AND ((IG.IncomeGroupCode IS NULL AND @ValIncomeGroupCode LIKE '%-1%') OR (IG.IncomeGroupCode IN (SELECT * FROM @TableIncomeGroup)))
	----AND G.GenderId IN(SELECT * FROM FnSplit(@GenderId))
	--AND IG.IncomeGroupId IN(SELECT * FROM FnSplit(@IncomeGroupId))
END
GO
