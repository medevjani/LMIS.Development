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
-- GetPopulationIndicatorDetails 0,0,0,0
-- =============================================
ALTER PROCEDURE GetPopulationIndicatorDetails 
(
	@RegionId INT = NULL
	,@AgeGroupId INT = NULL
	,@GenderId INT = NULL
	,@IncomeGroupId INT = NULL
)

AS
BEGIN
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
	,[TotalLabourForce]
	,[TotalPopulation]
	,[PerLabourforce]
	--,[TotalInactivePopulation]
	--,[PerInactivePopulation]
	--,[TotalEmployment]
	--,[PerEmployment]
	--,[TotalPartTimeWorker]
	--,[PerPartTimeWorker]
	--,[TotalInformalEmployment]
	--,[PerInformalEmployment]
	--,[TotalUnemployment]
	--,[PerUnemployment]
	--,[TotalYouthLabourForce]
	--,[TotalYouthUnemployment]
	--,[TotalYouthEmployment]
	--,[PerYouthUnemployment]
	--,[PerYouthUnemployment]
	--,[TotalAdultLabourForce]
	--,[TotalAdultEmployment]
	--,[TotalAdultUnemployment]
	--,[PerAdultUnemployment]
	--,[TotalLongTermUnemployment]
	--,[TotalEmployedLabourForce]
	--,[TotalTimeRelUnderEmployment]
	--,[TotalLessThanPrimaryQualification]
	--,[TotalPrimaryQualification]
	--,[TotalSecondaryQualification]
	--,[TotalUniversityQualification]
	--,[TotalOtherTertiaryQualification]
	--,[TotalVocationalQualification]
	--,[TotalUnknownQualification]
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

END
GO
