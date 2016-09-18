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
		,TotalPopulation
,TotalLabourForce
,TotalInactivePopulation
,TotalEmployment
,TotalUnemployment
,TotalYouthEmployment
, TotalYouthUnemployment
,TotalYouthLabourForce
,TotalAdultEmployment
,TotalAdultUnemployment
,TotalAdultLabourForce
,TotalTimeRelUnderEmployment
,TotalLessThanPrimaryQualification
,TotalPrimaryQualification
,TotalSecondaryQualification
,TotalUniversityQualification
,TotalOtherTertiaryQualification
,TotalVocationalQualification
,TotalUnknownQualification
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

		--LFS.age15
		--,LFS.Reg
		--, LFS.gender
		--,LFS.G04
		--,LFS.occupation
		--,LFS.Residence
		--,LFS.sector
		--,SUM(CASE WHEN BG1>=15 THEN 1 ELSE 0 END) TotalPopulation
		,SUM(ELT) TotalPopulation
		,SUM(CASE WHEN employed=1 
					OR unemployed_broad=1 
					OR unemployed_strict=1 THEN 1 
				ELSE 0 
			END) TotalLabourForce
		,(SUM(ELT)
		 - SUM(CASE WHEN employed=1 
					OR unemployed_broad=1 
					OR unemployed_strict=1 THEN 1 
				ELSE 0 
			END)) AS TotalInactivePopulation --Total Population – Labour Force
		,SUM(CASE WHEN employed=1 THEN 1 ELSE 0 END) TotalEmployment
		,SUM(CASE WHEN unemployed_broad=1 
					OR unemployed_strict=1 THEN 1 
				ELSE 0 
			END) TotalUnemployment
		,SUM(CASE WHEN employed=1 
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthEmployment
		,SUM(CASE WHEN (unemployed_broad=1 OR unemployed_strict=1)
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthUnemployment
		,SUM(CASE WHEN (employed=1 OR unemployed_broad=1 OR unemployed_strict=1)
					AND (AG.AgeGroupTitle='15 - 19'
						OR AG.AgeGroupTitle='20 - 24'
						OR AG.AgeGroupTitle='25 - 29'
						OR AG.AgeGroupTitle='30 - 34'
						) THEN 1 
				ELSE 0 
			END) TotalYouthLabourForce
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
		,SUM(CASE WHEN (unemployed_broad=1 OR unemployed_strict=1)
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultUnemployment
		,SUM(CASE WHEN (employed=1 OR unemployed_broad=1 OR unemployed_strict=1)
					AND (AG.AgeGroupTitle='35 - 39'
						OR AG.AgeGroupTitle='40 - 44'
						OR AG.AgeGroupTitle='45 - 49'
						OR AG.AgeGroupTitle='50 - 54'
						OR AG.AgeGroupTitle='55 - 59'
						OR AG.AgeGroupTitle='60 - 64'
						) THEN 1 
				ELSE 0 
			END) TotalAdultLabourForce
		
		
		,SUM(CASE WHEN E02C_Total<48 THEN 1 ELSE 0 END) TotalTimeRelUnderEmployment-- Employed less than 48 hours= E02C_Total< 48
		--,SUM(CASE WHEN BG1>=15 THEN 1 ELSE 0 END) TotalPopulation
		,SUM(CASE WHEN Q.QualificationTitle='None' THEN 1 ELSE 0 END) TotalLessThanPrimaryQualification
		,SUM(CASE WHEN Q.QualificationTitle='Primary' THEN 1 ELSE 0 END) TotalPrimaryQualification
		,SUM(CASE WHEN Q.QualificationTitle='Secondary' THEN 1 ELSE 0 END) TotalSecondaryQualification
		,SUM(CASE WHEN Q.QualificationTitle='University' THEN 1 ELSE 0 END) TotalUniversityQualification
		,SUM(CASE WHEN Q.QualificationTitle='Other tertiary' THEN 1 ELSE 0 END) TotalOtherTertiaryQualification
		,SUM(CASE WHEN Q.QualificationTitle='Vocational' THEN 1 ELSE 0 END) TotalVocationalQualification
		,SUM(CASE WHEN Q.QualificationTitle IS NULL THEN 1 ELSE 0 END) TotalUnknownQualificationQualification
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
	LEFT JOIN [dbo].[Qualification] Q
	ON LFS.BG9 = Q.QualificationCode
	
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
	
	-- Update percentage columns
	UPDATE dbo.LF_Indicator_PopulationEmployment
		SET PerLabourforce = CAST(((TotalLabourForce/TotalPopulation) *100) as decimal(5,2))
			,PerEmployment = CAST(((TotalEmployment/TotalPopulation) *100) as decimal(5,2))
			,PerInactivePopulation = CAST(((TotalInactivePopulation/TotalPopulation) *100) as decimal(5,2))

			
END
GO
