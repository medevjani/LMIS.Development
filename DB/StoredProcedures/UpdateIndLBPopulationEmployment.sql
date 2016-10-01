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
-- Create date: 27th August
-- Description:	Update the indicator table consisting population and employment details
-- =============================================
ALTER PROCEDURE dbo.UpdateIndLFPopulationEmployment 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Truncate existing data
	TRUNCATE TABLE [dbo].[LF_Indicator_PopulationEmployment]

	INSERT INTO [dbo].[LF_Indicator_PopulationEmployment]
	(
		AgeGroupId
		,RegionId
		,GenderId
		,IncomeGroupId
		,OcupationId
		,ResidenceId
		,SectorId
		,SurveyYearId
		,SurveyEffectiveYearId
		,EducationId
		,TotalPopulation
,TotalLabourForceBroad
,TotalLabourForceStrict
,TotalInactivePopulationBroad
,TotalInactivePopulationStrict
,TotalEmployment
,TotalUnemploymentBroad
,TotalUnemploymentStrict
,TotalYouthEmployment
, TotalYouthUnemploymentBroad
, TotalYouthUnemploymentStrict
,TotalYouthLabourForceBroad
,TotalYouthLabourForceStrict
,TotalAdultEmployment
,TotalAdultUnemploymentBroad
,TotalAdultUnemploymentStrict
,TotalAdultLabourForceBroad
,TotalAdultLabourForceStrict
,TotalTimeRelUnderEmployment
	)
	SELECT 
		AG.AgeGroupId
		,R.RegionId
		,G.GenderId
		,IG.IncomeGroupId
		,O.OccupationId
		,Res.ResidenceId
		,S.SectorId
		,SY.SurveyYearId
		,LFS.SurveyEffectiveYearId
		,E.EducationId
		--LFS.age15
		--,LFS.Reg
		--, LFS.gender
		--,LFS.G04
		--,LFS.occupation
		--,LFS.Residence
		--,LFS.sector
		,SUM(CASE WHEN BG1>=15 THEN 1 ELSE 0 END) TotalPopulation
		--,SUM(ELT) TotalPopulation
		,SUM(CASE WHEN labour_force_broad=1 OR labour_force_broad=2 THEN 1 ELSE 0 END) TotalLabourForceBroad
		,SUM(CASE WHEN labour_force_strict=1 OR labour_force_strict=2 THEN 1 ELSE 0 END) TotalLabourForceStrict
		,SUM(CASE WHEN inactive_broad=1 THEN 1 ELSE 0 END) TotalInactivePopulationBroad
		,SUM(CASE WHEN inactive_strict=1 THEN 1 ELSE 0 END) TotalInactivePopulationStrict
		,SUM(CASE WHEN employed=1 THEN 1 ELSE 0 END) TotalEmployment
		,SUM(CASE WHEN unemployed_broad=1 THEN 1 ELSE 0 END) TotalUnemploymentBroad
		,SUM(CASE WHEN unemployed_strict=1 THEN 1 ELSE 0 END) TotalUnemploymentStrict
		,SUM(CASE WHEN employed=1 
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthEmployment
		,SUM(CASE WHEN (unemployed_broad=1)
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthUnemploymentBroad
			,SUM(CASE WHEN (unemployed_strict=1)
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthUnemploymentStrict
		,SUM(CASE WHEN (labour_force_broad=1 OR labour_force_broad=2)
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthLabourForceBroad
		,SUM(CASE WHEN (labour_force_strict=1 OR labour_force_strict=2)
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthLabourForceStrict
		,SUM(CASE WHEN employed=1 
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultEmployment
		,SUM(CASE WHEN (unemployed_broad=1)
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultUnemploymentBroad
			,SUM(CASE WHEN (unemployed_strict=1)
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultUnemploymentStrict
		,SUM(CASE WHEN (labour_force_broad=1 OR labour_force_broad=2)
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultLabourForceBroad
			,SUM(CASE WHEN (labour_force_strict=1 OR labour_force_strict=2)
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultLabourForceStrict
		
		
		,SUM(CASE WHEN E02C_Total<48 THEN 1 ELSE 0 END) TotalTimeRelUnderEmployment-- Employed less than 48 hours= E02C_Total< 48
		
	FROM
	[dbo].[LabourForceSurvey] LFS
	LEFT JOIN [dbo].[Region] R
	ON LFS.Reg = R.RegionCode
	LEFT JOIN [dbo].[AgeGroup] AG
	ON LFS.age15 = AG.AgeGroupCode
	LEFT JOIN [dbo].[Gender] G
	ON LFS.gender = G.GenderCode
	LEFT JOIN [dbo].[IncomeGroup] IG
	ON LFS.G04 = IG.IncomeGroupCode
	LEFT JOIN [dbo].[Residence] Res
	ON LFS.Residence = Res.ResidenceCode
	LEFT JOIN [dbo].[Sector] S
	ON LFS.sector = S.SectorCode
	LEFT JOIN [dbo].[Occupation] O
	ON LFS.occupation = O.OccupationCode
	LEFT JOIN [dbo].[SurveyYear] SY
	ON LFS.HH_Y = SY.SurveyYear
	LEFT JOIN [dbo].[Education] E
	ON LFS.education = E.EducationCode
	WHERE BG1>=15
	GROUP BY 
	--Reg
	--,Residence
	--,occupation
	--,sector
	--,age15 -- Age group
	--,gender
	--,G04 -- Income group

	AG.AgeGroupId
	, G.GenderId
	, IG.IncomeGroupId
	,O.OccupationId
	,R.RegionId
	,Res.ResidenceId
	,S.SectorId
	,SY.SurveyYearId
	,LFS.SurveyEffectiveYearId
	,E.EducationId
	
	-- Update percentage columns
	UPDATE dbo.LF_Indicator_PopulationEmployment
		SET 
			PerLabourForceBroad = CAST(((TotalLabourForceBroad/TotalPopulation) *100) as decimal(5,2))
			,PerLabourForceStrict = CAST(((TotalLabourForceStrict/TotalPopulation) *100) as decimal(5,2))
			,PerEmployment = CAST(((TotalEmployment/TotalPopulation) *100) as decimal(5,2))
			,PerInactivePopulationBroad = CAST(((TotalInactivePopulationBroad/TotalPopulation) *100) as decimal(5,2))
			,PerInactivePopulationStrict = CAST(((TotalInactivePopulationStrict/TotalPopulation) *100) as decimal(5,2))
			,PerUnemploymentBroad = CAST(((TotalUnemploymentBroad/TotalPopulation) *100) as decimal(5,2))
			,PerUnemploymentStrict = CAST(((TotalUnemploymentStrict/TotalPopulation) *100) as decimal(5,2))
			,PerYouthEmployment = CAST(((TotalYouthEmployment/TotalPopulation) *100) as decimal(5,2))
			,PerYouthUnemploymentBroad = CAST(((TotalYouthUnemploymentBroad/TotalPopulation) *100) as decimal(5,2))
			,PerYouthUnemploymentStrict = CAST(((TotalYouthUnemploymentStrict/TotalPopulation) *100) as decimal(5,2))
			,PerAdultEmployment = CAST(((TotalAdultEmployment/TotalPopulation) *100) as decimal(5,2))
			,PerAdultUnemploymentBroad = CAST(((TotalAdultUnemploymentBroad/TotalPopulation) *100) as decimal(5,2))
			,PerAdultUnemploymentStrict = CAST(((TotalAdultUnemploymentStrict/TotalPopulation) *100) as decimal(5,2))
	--where totalpopulation>0

	select
	CAST(((TotalLabourForceBroad/TotalPopulation) *100) as decimal(5,2))
	from LF_Indicator_PopulationEmployment
			where totalpopulation>0
			and CAST(((TotalLabourForceBroad/TotalPopulation) *100) as decimal(6,2))>100
END
GO


