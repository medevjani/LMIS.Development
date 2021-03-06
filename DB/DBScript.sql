USE [LMIS]
GO
/****** Object:  StoredProcedure [dbo].[AddSurveyUploadInfo]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August
-- Description:	Add information regarding survey upload
-- =============================================
CREATE PROCEDURE [dbo].[AddSurveyUploadInfo] 
	-- Add the parameters for the stored procedure here
	@SurveyType VARCHAR(50) , 
	@SourceFilePath VARCHAR(255),
	@ErrorFilePath VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
INSERT INTO [dbo].[SurveyUpload]
           ([SurveyType]
           ,[SourceFilePath]
           ,[ErrorFilePath]
           ,[PackageStatus])
     VALUES
           (@SurveyType
           ,@SourceFilePath
           ,@ErrorFilePath
           ,'NEW')
END

GO
/****** Object:  StoredProcedure [dbo].[AddToLog]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August
-- Description:	Add log entry
-- =============================================
CREATE PROCEDURE [dbo].[AddToLog] 
	-- Add the parameters for the stored procedure here
	@PackageId VARCHAR(50) , 
	@PackageName VARCHAR(50),
	@TaskName VARCHAR(255),
	@LogDescription VARCHAR(500),
	@ErrorCode	INT=NULL,
	@ErrorDescription VARCHAR(500)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[PackageLog]
	(
		[PackageId]
		,[PackageName]
		,[TaskName]
		,[LogDescription]
		,[ErrorCode]
		,[ErrorDescription]
	)
	VALUES
	(
		@PackageId
		,@PackageName
		,@TaskName
		,@LogDescription
		,@ErrorCode
		,@ErrorDescription
	)
END

GO
/****** Object:  StoredProcedure [dbo].[GetIndicatorColumnOptions]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 30th Sept
-- Description:	Get the column option for specific indicator
-- GetIndicatorColumnOptions 'LabourForceParticipationRatio'
-- =============================================
CREATE PROCEDURE [dbo].[GetIndicatorColumnOptions] 
	-- Add the parameters for the stored procedure here
	@IndicatorName VARCHAR(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		ICO.IndicatorColumnInternalName
		,ICO.IndicatorColumnDisplayName
	FROM dbo.IndicatorColumnOption ICO
	INNER JOIN dbo.IndicatorMaster IM
	ON ICO.IndicatorId = IM.IndicatorMasterId
	WHERE IM.IndicatorName = @IndicatorName
		
END

GO
/****** Object:  StoredProcedure [dbo].[GetIndicatorDataOptions]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 30th Sept
-- Description:	Get the column option for specific indicator
-- GetIndicatorDataOptions 'LabourForceParticipationRatio'
-- =============================================
CREATE PROCEDURE [dbo].[GetIndicatorDataOptions] 
	-- Add the parameters for the stored procedure here
	@IndicatorName VARCHAR(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		IDO.IndicatorDataColInternalName
		,IDO.IndicatorDataColDisplayName
	FROM dbo.IndicatorDataOption IDO
	INNER JOIN dbo.IndicatorMaster IM
	ON IDO.IndicatorId = IM.IndicatorMasterId
	WHERE IM.IndicatorName = @IndicatorName
		
END

GO
/****** Object:  StoredProcedure [dbo].[GetPackageConfigurations]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 14th August
-- Description:	Get all config details based on survey type
-- =============================================
CREATE PROCEDURE [dbo].[GetPackageConfigurations] 
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
/****** Object:  StoredProcedure [dbo].[GetPopulationIndicatorDetails]    Script Date: 10/1/2016 6:33:28 AM ******/
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
CREATE PROCEDURE [dbo].[GetPopulationIndicatorDetails] 
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
/****** Object:  StoredProcedure [dbo].[GetSurveyFilePath]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August 2016
-- Description:	Get file path based on survey type
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyFilePath] 
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
/****** Object:  StoredProcedure [dbo].[GetUploadDetails]    Script Date: 10/1/2016 6:33:28 AM ******/
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
CREATE PROCEDURE [dbo].[GetUploadDetails]
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
/****** Object:  StoredProcedure [dbo].[SendEmail]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August 2016
-- Description:	Send email based on event
-- =============================================
CREATE PROCEDURE [dbo].[SendEmail] 
	-- Add the parameters for the stored procedure here
	@SurveyType VARCHAR(50), 
	@EventType VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Recipients VARCHAR(500)
	DECLARE @MailSubject VARCHAR(500)
	DECLARE @Body VARCHAR(MAX)
	DECLARE @AttachmentPath VARCHAR(255)

	SELECT 
		@Recipients = ToEmail
		,@MailSubject = MailSubject
		,@Body = Body
		,@AttachmentPath = AttachmentPath
		FROM [dbo].[MailConfig]
	WHERE SurveyType = @SurveyType
	AND EventType = @EventType 

	-- Send mail
    EXEC msdb.dbo.sp_send_dbmail 
		  @profile_name='My DB Email',
		  @recipients=@Recipients,
		  @subject=@MailSubject,
		  @body=@Body,
		  @file_attachments=@AttachmentPath
END

GO
/****** Object:  StoredProcedure [dbo].[ThrowError]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 8th August 2016
-- Description:	Throw custom error
-- ThrowError 'test error'
-- =============================================
CREATE PROCEDURE [dbo].[ThrowError] 
	-- Add the parameters for the stored procedure here
	@ErrorMsg VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	THROW 50001, @ErrorMsg, 1
END

GO
/****** Object:  StoredProcedure [dbo].[TruncateTables]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 8th August 2016
-- Description:	Truncate dump, temp and error tables
-- =============================================
CREATE PROCEDURE [dbo].[TruncateTables] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Truncate dump table
	TRUNCATE TABLE [dbo].[LabourForceSurveyDump]

	-- Truncate temp table
	TRUNCATE TABLE [dbo].[LabourForceSurveyTemp]

	-- Truncate error table
	TRUNCATE TABLE [dbo].[LabourForceSurveyError]
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateIndLFPopulationEmployment]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 27th August
-- Description:	Update the indicator table consisting population and employment details
-- =============================================
CREATE PROCEDURE [dbo].[UpdateIndLFPopulationEmployment] 

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
/****** Object:  StoredProcedure [dbo].[UpdateUploadStatus]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August
-- Description:	Update the upload status
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUploadStatus] 
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
/****** Object:  StoredProcedure [dbo].[ValidateDataType]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 7th August 2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ValidateDataType] 

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
/****** Object:  StoredProcedure [dbo].[ValidateYear]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 7th August 2016
-- Description:	Validate date of Survey data to avoid duplicate
-- =============================================
CREATE PROCEDURE [dbo].[ValidateYear] 
	
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
/****** Object:  UserDefinedFunction [dbo].[FnSplit]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Function [dbo].[FnSplit]
(
    @CSVList Varchar(max)
)
RETURNS @Table TABLE (ColumnData VARCHAR(100))
AS
BEGIN
    IF RIGHT(@CSVList, 1) <> ','
    SELECT @CSVList = @CSVList + ','

    DECLARE @Pos    BIGINT,
            @OldPos BIGINT
    SELECT  @Pos    = 1,
            @OldPos = 1

    WHILE   @Pos < LEN(@CSVList)
        BEGIN
            SELECT  @Pos = CHARINDEX(',', @CSVList, @OldPos)
            INSERT INTO @Table
            SELECT  LTRIM(RTRIM(SUBSTRING(@CSVList, @OldPos, @Pos - @OldPos))) Col001

            SELECT  @OldPos = @Pos + 1
        END

    RETURN
END

GO
/****** Object:  Table [dbo].[AgeGroup]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AgeGroup](
	[AgeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[AgeGroupCode] [decimal](18, 0) NULL,
	[AgeGroupTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_AgeGroup_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_AgeGroup] PRIMARY KEY CLUSTERED 
(
	[AgeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Education]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Education](
	[EducationId] [int] IDENTITY(1,1) NOT NULL,
	[EducationCode] [decimal](18, 0) NULL,
	[EducationTitle] [varchar](250) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Qualification_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Education] PRIMARY KEY CLUSTERED 
(
	[EducationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Gender](
	[GenderId] [int] IDENTITY(1,1) NOT NULL,
	[GenderCode] [decimal](18, 0) NULL,
	[GenderTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Sex_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Sex] PRIMARY KEY CLUSTERED 
(
	[GenderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IncomeGroup]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IncomeGroup](
	[IncomeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[IncomeGroupCode] [decimal](18, 0) NULL,
	[IncomeGroupTitle] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_IncomeGroup_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_IncomeGroup] PRIMARY KEY CLUSTERED 
(
	[IncomeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IndicatorColumnOption]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IndicatorColumnOption](
	[IndicatorColumnOptionId] [int] IDENTITY(1,1) NOT NULL,
	[IndicatorColumnInternalName] [varchar](50) NULL,
	[IndicatorColumnDisplayName] [varchar](50) NULL,
	[IndicatorId] [int] NULL,
 CONSTRAINT [PK_IndicatorColumnOption] PRIMARY KEY CLUSTERED 
(
	[IndicatorColumnOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IndicatorDataOption]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IndicatorDataOption](
	[IndicatorDataOptionId] [int] IDENTITY(1,1) NOT NULL,
	[IndicatorDataColInternalName] [varchar](50) NULL,
	[IndicatorDataColDisplayName] [varchar](50) NULL,
	[IndicatorId] [int] NULL,
 CONSTRAINT [PK_IndicatorDataOpttion] PRIMARY KEY CLUSTERED 
(
	[IndicatorDataOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IndicatorMaster]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IndicatorMaster](
	[IndicatorMasterId] [int] IDENTITY(1,1) NOT NULL,
	[IndicatorName] [varchar](200) NULL,
	[IndicatorDescription] [varchar](500) NULL,
 CONSTRAINT [PK_IndicatorMaster] PRIMARY KEY CLUSTERED 
(
	[IndicatorMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LabourForceSurvey]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourForceSurvey](
	[LabourForceSurveyId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Reg] [decimal](18, 2) NULL,
	[Residence] [decimal](18, 0) NULL,
	[cluster] [decimal](18, 0) NULL,
	[HH] [decimal](18, 0) NULL,
	[HHM] [decimal](18, 0) NULL,
	[HHF] [decimal](18, 0) NULL,
	[HHT] [decimal](18, 0) NULL,
	[ELM] [decimal](18, 0) NULL,
	[ELF] [decimal](18, 0) NULL,
	[ELT] [decimal](18, 0) NULL,
	[CL_M] [decimal](18, 0) NULL,
	[CL_F] [decimal](18, 0) NULL,
	[CL_T] [decimal](18, 0) NULL,
	[IQ_M] [decimal](18, 0) NULL,
	[IQ_F] [decimal](18, 0) NULL,
	[IQ_T] [decimal](18, 0) NULL,
	[HH_D] [decimal](18, 0) NULL,
	[HH_M] [decimal](18, 0) NULL,
	[HH_Y] [decimal](18, 0) NULL,
	[HHR] [decimal](18, 0) NULL,
	[IA6] [decimal](18, 0) NULL,
	[BG1] [decimal](18, 0) NULL,
	[BG2] [decimal](18, 0) NULL,
	[BG3] [decimal](18, 0) NULL,
	[BG4] [decimal](18, 0) NULL,
	[BG5_M] [decimal](18, 0) NULL,
	[BG5_Y] [decimal](18, 0) NULL,
	[BG5_N] [decimal](18, 0) NULL,
	[BG6_TA] [decimal](18, 0) NULL,
	[BG6D] [decimal](18, 0) NULL,
	[BG6C] [decimal](18, 0) NULL,
	[BG8] [decimal](18, 0) NULL,
	[BG9] [decimal](18, 0) NULL,
	[BG10] [decimal](18, 0) NULL,
	[A1] [decimal](18, 0) NULL,
	[A2A] [decimal](18, 0) NULL,
	[A2B] [decimal](18, 0) NULL,
	[A2C] [decimal](18, 0) NULL,
	[A2D] [decimal](18, 0) NULL,
	[A2E] [decimal](18, 0) NULL,
	[A2F] [decimal](18, 0) NULL,
	[A2G] [decimal](18, 0) NULL,
	[A3] [decimal](18, 0) NULL,
	[A4] [decimal](18, 0) NULL,
	[A5] [decimal](18, 0) NULL,
	[A6] [decimal](18, 0) NULL,
	[A7] [decimal](18, 0) NULL,
	[A8] [decimal](18, 0) NULL,
	[A9] [decimal](18, 0) NULL,
	[A10] [decimal](18, 0) NULL,
	[B2] [decimal](18, 0) NULL,
	[B4] [decimal](18, 0) NULL,
	[B5] [decimal](18, 0) NULL,
	[B6] [decimal](18, 0) NULL,
	[B6A] [decimal](18, 0) NULL,
	[B7] [decimal](18, 0) NULL,
	[B8] [decimal](18, 0) NULL,
	[B9] [decimal](18, 0) NULL,
	[B10] [decimal](18, 0) NULL,
	[B11] [decimal](18, 0) NULL,
	[B11A] [decimal](18, 0) NULL,
	[B12] [decimal](18, 0) NULL,
	[B13] [decimal](18, 0) NULL,
	[B14] [decimal](18, 0) NULL,
	[B15] [decimal](18, 0) NULL,
	[B15A] [decimal](18, 0) NULL,
	[B15B] [decimal](18, 0) NULL,
	[B17] [decimal](18, 0) NULL,
	[B18] [decimal](18, 0) NULL,
	[B19] [decimal](18, 0) NULL,
	[B20] [decimal](18, 0) NULL,
	[B21] [decimal](18, 0) NULL,
	[B22] [decimal](18, 0) NULL,
	[B23] [decimal](18, 0) NULL,
	[B24] [decimal](18, 0) NULL,
	[B25] [decimal](18, 0) NULL,
	[B26] [decimal](18, 0) NULL,
	[C1] [decimal](18, 0) NULL,
	[C1A] [decimal](18, 0) NULL,
	[C1B] [decimal](18, 0) NULL,
	[C1C] [decimal](18, 0) NULL,
	[C1D] [decimal](18, 0) NULL,
	[C1E] [decimal](18, 0) NULL,
	[C1F] [decimal](18, 0) NULL,
	[C1G] [decimal](18, 0) NULL,
	[C2] [decimal](18, 0) NULL,
	[C5] [decimal](18, 0) NULL,
	[C7] [decimal](18, 0) NULL,
	[C8] [decimal](18, 0) NULL,
	[C9] [decimal](18, 0) NULL,
	[C10] [decimal](18, 0) NULL,
	[C11] [decimal](18, 0) NULL,
	[C12] [decimal](18, 0) NULL,
	[C13] [decimal](18, 0) NULL,
	[C14] [decimal](18, 0) NULL,
	[C14A] [decimal](18, 0) NULL,
	[C15] [decimal](18, 0) NULL,
	[C16] [decimal](18, 0) NULL,
	[C17] [decimal](18, 0) NULL,
	[C18] [decimal](18, 0) NULL,
	[C19] [decimal](18, 0) NULL,
	[C20] [decimal](18, 0) NULL,
	[C21] [decimal](18, 0) NULL,
	[C22] [decimal](18, 0) NULL,
	[C23] [decimal](18, 0) NULL,
	[C24] [decimal](18, 0) NULL,
	[C25] [decimal](18, 0) NULL,
	[C26] [decimal](18, 0) NULL,
	[C27] [decimal](18, 0) NULL,
	[D01] [decimal](18, 0) NULL,
	[D02] [decimal](18, 0) NULL,
	[D03] [decimal](18, 0) NULL,
	[D04] [decimal](18, 0) NULL,
	[D05] [decimal](18, 0) NULL,
	[E01A] [decimal](18, 0) NULL,
	[E01B] [decimal](18, 0) NULL,
	[E01C] [decimal](18, 0) NULL,
	[E02A_MON] [decimal](18, 0) NULL,
	[E02A_TUES] [decimal](18, 0) NULL,
	[E02A_WEDS] [decimal](18, 0) NULL,
	[E02A_THURS] [decimal](18, 0) NULL,
	[E02A_FRID] [decimal](18, 0) NULL,
	[E02A_SAT] [decimal](18, 0) NULL,
	[E02A_SUN] [decimal](18, 0) NULL,
	[E02A_TOTAL] [decimal](18, 0) NULL,
	[E02B_MON] [decimal](18, 0) NULL,
	[E02B_TUES] [decimal](18, 0) NULL,
	[E02B_WEDS] [decimal](18, 0) NULL,
	[E02B_THURS] [decimal](18, 0) NULL,
	[E02B_FRID] [decimal](18, 0) NULL,
	[E02B_SATUR] [decimal](18, 0) NULL,
	[E02B_SUNDAY] [decimal](18, 0) NULL,
	[E02B_TOTAL] [decimal](18, 0) NULL,
	[E02C_TOTAL] [decimal](18, 0) NULL,
	[F01] [decimal](18, 0) NULL,
	[F02] [decimal](18, 0) NULL,
	[F03] [decimal](18, 0) NULL,
	[F04] [decimal](18, 0) NULL,
	[F05] [decimal](18, 0) NULL,
	[F06] [decimal](18, 0) NULL,
	[F07] [decimal](18, 0) NULL,
	[G01] [decimal](18, 0) NULL,
	[G01_AMOUNT] [decimal](18, 0) NULL,
	[G02] [decimal](18, 0) NULL,
	[G03] [decimal](18, 0) NULL,
	[G03_AMOUNT] [decimal](18, 0) NULL,
	[G04] [decimal](18, 0) NULL,
	[G05] [decimal](18, 0) NULL,
	[G06] [decimal](18, 0) NULL,
	[G07] [decimal](18, 0) NULL,
	[G08] [decimal](18, 0) NULL,
	[G09] [decimal](18, 0) NULL,
	[G10] [decimal](18, 0) NULL,
	[G11] [decimal](18, 0) NULL,
	[G12] [decimal](18, 0) NULL,
	[G13] [decimal](18, 0) NULL,
	[G14] [decimal](18, 0) NULL,
	[H01A] [decimal](18, 0) NULL,
	[H01B] [decimal](18, 0) NULL,
	[H02] [decimal](18, 0) NULL,
	[H03A] [decimal](18, 0) NULL,
	[H03B] [decimal](18, 0) NULL,
	[H04] [decimal](18, 0) NULL,
	[H05] [decimal](18, 0) NULL,
	[H06] [decimal](18, 0) NULL,
	[H07] [decimal](18, 0) NULL,
	[H08A] [decimal](18, 0) NULL,
	[H08B] [decimal](18, 0) NULL,
	[H09] [decimal](18, 0) NULL,
	[H10] [decimal](18, 0) NULL,
	[I01] [decimal](18, 0) NULL,
	[I02] [decimal](18, 0) NULL,
	[I03] [decimal](18, 0) NULL,
	[I04] [decimal](18, 0) NULL,
	[I05] [decimal](18, 0) NULL,
	[I06] [decimal](18, 0) NULL,
	[I07] [decimal](18, 0) NULL,
	[I08] [decimal](18, 0) NULL,
	[I09] [decimal](18, 0) NULL,
	[J01_JANUARY] [decimal](18, 0) NULL,
	[J01_FEBRUARY] [decimal](18, 0) NULL,
	[J01_MARCH] [decimal](18, 0) NULL,
	[J01_APRIL] [decimal](18, 0) NULL,
	[J01_MAY] [decimal](18, 0) NULL,
	[J01_JUNE] [decimal](18, 0) NULL,
	[J01_JULY] [decimal](18, 0) NULL,
	[J01_AUGUST] [decimal](18, 0) NULL,
	[J01_SEPTEMBER] [decimal](18, 0) NULL,
	[J01_OCTOBER] [decimal](18, 0) NULL,
	[J01_NOVEMBER] [decimal](18, 0) NULL,
	[J01_DECEMBER] [decimal](18, 0) NULL,
	[J02] [decimal](18, 0) NULL,
	[J03] [decimal](18, 0) NULL,
	[new_calwgt2] [decimal](18, 0) NULL,
	[gender] [decimal](18, 0) NULL,
	[education] [decimal](18, 0) NULL,
	[age15] [decimal](18, 0) NULL,
	[employed] [decimal](18, 0) NULL,
	[unemployed_broad] [decimal](18, 0) NULL,
	[unemployed_strict] [decimal](18, 0) NULL,
	[inactive_broad] [decimal](18, 0) NULL,
	[inactive_strict] [decimal](18, 0) NULL,
	[labour_force_broad] [decimal](18, 0) NULL,
	[labour_force_strict] [decimal](18, 0) NULL,
	[occupation] [decimal](18, 0) NULL,
	[sector] [decimal](18, 0) NULL,
	[status_inemployment] [decimal](18, 0) NULL,
	[SurveyEffectiveYearId] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_LabourForceSurvey] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LabourForceSurveyDump]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourForceSurveyDump](
	[LabourForceSurveyId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Reg] [nvarchar](255) NULL,
	[Residence] [nvarchar](255) NULL,
	[cluster] [nvarchar](255) NULL,
	[HH] [nvarchar](255) NULL,
	[HHM] [nvarchar](255) NULL,
	[HHF] [nvarchar](255) NULL,
	[HHT] [nvarchar](255) NULL,
	[ELM] [nvarchar](255) NULL,
	[ELF] [nvarchar](255) NULL,
	[ELT] [nvarchar](255) NULL,
	[CL_M] [nvarchar](255) NULL,
	[CL_F] [nvarchar](255) NULL,
	[CL_T] [nvarchar](255) NULL,
	[IQ_M] [nvarchar](255) NULL,
	[IQ_F] [nvarchar](255) NULL,
	[IQ_T] [nvarchar](255) NULL,
	[HH_D] [nvarchar](255) NULL,
	[HH_M] [nvarchar](255) NULL,
	[HH_Y] [nvarchar](255) NULL,
	[HHR] [nvarchar](255) NULL,
	[IA6] [nvarchar](255) NULL,
	[BG1] [nvarchar](255) NULL,
	[BG2] [nvarchar](255) NULL,
	[BG3] [nvarchar](255) NULL,
	[BG4] [nvarchar](255) NULL,
	[BG5_M] [nvarchar](255) NULL,
	[BG5_Y] [nvarchar](255) NULL,
	[BG5_N] [nvarchar](255) NULL,
	[BG6_TA] [nvarchar](255) NULL,
	[BG6D] [nvarchar](255) NULL,
	[BG6C] [nvarchar](255) NULL,
	[BG8] [nvarchar](255) NULL,
	[BG9] [nvarchar](255) NULL,
	[BG10] [nvarchar](255) NULL,
	[A1] [nvarchar](255) NULL,
	[A2A] [nvarchar](255) NULL,
	[A2B] [nvarchar](255) NULL,
	[A2C] [nvarchar](255) NULL,
	[A2D] [nvarchar](255) NULL,
	[A2E] [nvarchar](255) NULL,
	[A2F] [nvarchar](255) NULL,
	[A2G] [nvarchar](255) NULL,
	[A3] [nvarchar](255) NULL,
	[A4] [nvarchar](255) NULL,
	[A5] [nvarchar](255) NULL,
	[A6] [nvarchar](255) NULL,
	[A7] [nvarchar](255) NULL,
	[A8] [nvarchar](255) NULL,
	[A9] [nvarchar](255) NULL,
	[A10] [nvarchar](255) NULL,
	[B2] [nvarchar](255) NULL,
	[B4] [nvarchar](255) NULL,
	[B5] [nvarchar](255) NULL,
	[B6] [nvarchar](255) NULL,
	[B6A] [nvarchar](255) NULL,
	[B7] [nvarchar](255) NULL,
	[B8] [nvarchar](255) NULL,
	[B9] [nvarchar](255) NULL,
	[B10] [nvarchar](255) NULL,
	[B11] [nvarchar](255) NULL,
	[B11A] [nvarchar](255) NULL,
	[B12] [nvarchar](255) NULL,
	[B13] [nvarchar](255) NULL,
	[B14] [nvarchar](255) NULL,
	[B15] [nvarchar](255) NULL,
	[B15A] [nvarchar](255) NULL,
	[B15B] [nvarchar](255) NULL,
	[B17] [nvarchar](255) NULL,
	[B18] [nvarchar](255) NULL,
	[B19] [nvarchar](255) NULL,
	[B20] [nvarchar](255) NULL,
	[B21] [nvarchar](255) NULL,
	[B22] [nvarchar](255) NULL,
	[B23] [nvarchar](255) NULL,
	[B24] [nvarchar](255) NULL,
	[B25] [nvarchar](255) NULL,
	[B26] [nvarchar](255) NULL,
	[C1] [nvarchar](255) NULL,
	[C1A] [nvarchar](255) NULL,
	[C1B] [nvarchar](255) NULL,
	[C1C] [nvarchar](255) NULL,
	[C1D] [nvarchar](255) NULL,
	[C1E] [nvarchar](255) NULL,
	[C1F] [nvarchar](255) NULL,
	[C1G] [nvarchar](255) NULL,
	[C2] [nvarchar](255) NULL,
	[C5] [nvarchar](255) NULL,
	[C7] [nvarchar](255) NULL,
	[C8] [nvarchar](255) NULL,
	[C9] [nvarchar](255) NULL,
	[C10] [nvarchar](255) NULL,
	[C11] [nvarchar](255) NULL,
	[C12] [nvarchar](255) NULL,
	[C13] [nvarchar](255) NULL,
	[C14] [nvarchar](255) NULL,
	[C14A] [nvarchar](255) NULL,
	[C15] [nvarchar](255) NULL,
	[C16] [nvarchar](255) NULL,
	[C17] [nvarchar](255) NULL,
	[C18] [nvarchar](255) NULL,
	[C19] [nvarchar](255) NULL,
	[C20] [nvarchar](255) NULL,
	[C21] [nvarchar](255) NULL,
	[C22] [nvarchar](255) NULL,
	[C23] [nvarchar](255) NULL,
	[C24] [nvarchar](255) NULL,
	[C25] [nvarchar](255) NULL,
	[C26] [nvarchar](255) NULL,
	[C27] [nvarchar](255) NULL,
	[D01] [nvarchar](255) NULL,
	[D02] [nvarchar](255) NULL,
	[D03] [nvarchar](255) NULL,
	[D04] [nvarchar](255) NULL,
	[D05] [nvarchar](255) NULL,
	[E01A] [nvarchar](255) NULL,
	[E01B] [nvarchar](255) NULL,
	[E01C] [nvarchar](255) NULL,
	[E02A_MON] [nvarchar](255) NULL,
	[E02A_TUES] [nvarchar](255) NULL,
	[E02A_WEDS] [nvarchar](255) NULL,
	[E02A_THURS] [nvarchar](255) NULL,
	[E02A_FRID] [nvarchar](255) NULL,
	[E02A_SAT] [nvarchar](255) NULL,
	[E02A_SUN] [nvarchar](255) NULL,
	[E02A_TOTAL] [nvarchar](255) NULL,
	[E02B_MON] [nvarchar](255) NULL,
	[E02B_TUES] [nvarchar](255) NULL,
	[E02B_WEDS] [nvarchar](255) NULL,
	[E02B_THURS] [nvarchar](255) NULL,
	[E02B_FRID] [nvarchar](255) NULL,
	[E02B_SATUR] [nvarchar](255) NULL,
	[E02B_SUNDAY] [nvarchar](255) NULL,
	[E02B_TOTAL] [nvarchar](255) NULL,
	[E02C_TOTAL] [nvarchar](255) NULL,
	[F01] [nvarchar](255) NULL,
	[F02] [nvarchar](255) NULL,
	[F03] [nvarchar](255) NULL,
	[F04] [nvarchar](255) NULL,
	[F05] [nvarchar](255) NULL,
	[F06] [nvarchar](255) NULL,
	[F07] [nvarchar](255) NULL,
	[G01] [nvarchar](255) NULL,
	[G01_AMOUNT] [nvarchar](255) NULL,
	[G02] [nvarchar](255) NULL,
	[G03] [nvarchar](255) NULL,
	[G03_AMOUNT] [nvarchar](255) NULL,
	[G04] [nvarchar](255) NULL,
	[G05] [nvarchar](255) NULL,
	[G06] [nvarchar](255) NULL,
	[G07] [nvarchar](255) NULL,
	[G08] [nvarchar](255) NULL,
	[G09] [nvarchar](255) NULL,
	[G10] [nvarchar](255) NULL,
	[G11] [nvarchar](255) NULL,
	[G12] [nvarchar](255) NULL,
	[G13] [nvarchar](255) NULL,
	[G14] [nvarchar](255) NULL,
	[H01A] [nvarchar](255) NULL,
	[H01B] [nvarchar](255) NULL,
	[H02] [nvarchar](255) NULL,
	[H03A] [nvarchar](255) NULL,
	[H03B] [nvarchar](255) NULL,
	[H04] [nvarchar](255) NULL,
	[H05] [nvarchar](255) NULL,
	[H06] [nvarchar](255) NULL,
	[H07] [nvarchar](255) NULL,
	[H08A] [nvarchar](255) NULL,
	[H08B] [nvarchar](255) NULL,
	[H09] [nvarchar](255) NULL,
	[H10] [nvarchar](255) NULL,
	[I01] [nvarchar](255) NULL,
	[I02] [nvarchar](255) NULL,
	[I03] [nvarchar](255) NULL,
	[I04] [nvarchar](255) NULL,
	[I05] [nvarchar](255) NULL,
	[I06] [nvarchar](255) NULL,
	[I07] [nvarchar](255) NULL,
	[I08] [nvarchar](255) NULL,
	[I09] [nvarchar](255) NULL,
	[J01_JANUARY] [nvarchar](255) NULL,
	[J01_FEBRUARY] [nvarchar](255) NULL,
	[J01_MARCH] [nvarchar](255) NULL,
	[J01_APRIL] [nvarchar](255) NULL,
	[J01_MAY] [nvarchar](255) NULL,
	[J01_JUNE] [nvarchar](255) NULL,
	[J01_JULY] [nvarchar](255) NULL,
	[J01_AUGUST] [nvarchar](255) NULL,
	[J01_SEPTEMBER] [nvarchar](255) NULL,
	[J01_OCTOBER] [nvarchar](255) NULL,
	[J01_NOVEMBER] [nvarchar](255) NULL,
	[J01_DECEMBER] [nvarchar](255) NULL,
	[J02] [nvarchar](255) NULL,
	[J03] [nvarchar](255) NULL,
	[new_calwgt2] [nvarchar](255) NULL,
	[gender] [nvarchar](255) NULL,
	[education] [nvarchar](255) NULL,
	[age15] [nvarchar](255) NULL,
	[employed] [nvarchar](255) NULL,
	[unemployed_broad] [nvarchar](255) NULL,
	[unemployed_strict] [nvarchar](255) NULL,
	[inactive_broad] [nvarchar](255) NULL,
	[inactive_strict] [nvarchar](255) NULL,
	[labour_force_broad] [nvarchar](255) NULL,
	[labour_force_strict] [nvarchar](255) NULL,
	[occupation] [nvarchar](255) NULL,
	[sector] [nvarchar](255) NULL,
	[status_inemployment] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_LabelForceSurvey] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LabourForceSurveyError]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LabourForceSurveyError](
	[LabourForceSurveyErrorId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[LabourForceSurveyId] [decimal](18, 0) NULL,
	[Reg] [nvarchar](255) NULL,
	[Residence] [nvarchar](255) NULL,
	[cluster] [nvarchar](255) NULL,
	[HH] [nvarchar](255) NULL,
	[HHM] [nvarchar](255) NULL,
	[HHF] [nvarchar](255) NULL,
	[HHT] [nvarchar](255) NULL,
	[ELM] [nvarchar](255) NULL,
	[ELF] [nvarchar](255) NULL,
	[ELT] [nvarchar](255) NULL,
	[CL_M] [nvarchar](255) NULL,
	[CL_F] [nvarchar](255) NULL,
	[CL_T] [nvarchar](255) NULL,
	[IQ_M] [nvarchar](255) NULL,
	[IQ_F] [nvarchar](255) NULL,
	[IQ_T] [nvarchar](255) NULL,
	[HH_D] [nvarchar](255) NULL,
	[HH_M] [nvarchar](255) NULL,
	[HH_Y] [nvarchar](255) NULL,
	[HHR] [nvarchar](255) NULL,
	[IA6] [nvarchar](255) NULL,
	[BG1] [nvarchar](255) NULL,
	[BG2] [nvarchar](255) NULL,
	[BG3] [nvarchar](255) NULL,
	[BG4] [nvarchar](255) NULL,
	[BG5_M] [nvarchar](255) NULL,
	[BG5_Y] [nvarchar](255) NULL,
	[BG5_N] [nvarchar](255) NULL,
	[BG6_TA] [nvarchar](255) NULL,
	[BG6D] [nvarchar](255) NULL,
	[BG6C] [nvarchar](255) NULL,
	[BG8] [nvarchar](255) NULL,
	[BG9] [nvarchar](255) NULL,
	[BG10] [nvarchar](255) NULL,
	[A1] [nvarchar](255) NULL,
	[A2A] [nvarchar](255) NULL,
	[A2B] [nvarchar](255) NULL,
	[A2C] [nvarchar](255) NULL,
	[A2D] [nvarchar](255) NULL,
	[A2E] [nvarchar](255) NULL,
	[A2F] [nvarchar](255) NULL,
	[A2G] [nvarchar](255) NULL,
	[A3] [nvarchar](255) NULL,
	[A4] [nvarchar](255) NULL,
	[A5] [nvarchar](255) NULL,
	[A6] [nvarchar](255) NULL,
	[A7] [nvarchar](255) NULL,
	[A8] [nvarchar](255) NULL,
	[A9] [nvarchar](255) NULL,
	[A10] [nvarchar](255) NULL,
	[B2] [nvarchar](255) NULL,
	[B4] [nvarchar](255) NULL,
	[B5] [nvarchar](255) NULL,
	[B6] [nvarchar](255) NULL,
	[B6A] [nvarchar](255) NULL,
	[B7] [nvarchar](255) NULL,
	[B8] [nvarchar](255) NULL,
	[B9] [nvarchar](255) NULL,
	[B10] [nvarchar](255) NULL,
	[B11] [nvarchar](255) NULL,
	[B11A] [nvarchar](255) NULL,
	[B12] [nvarchar](255) NULL,
	[B13] [nvarchar](255) NULL,
	[B14] [nvarchar](255) NULL,
	[B15] [nvarchar](255) NULL,
	[B15A] [nvarchar](255) NULL,
	[B15B] [nvarchar](255) NULL,
	[B17] [nvarchar](255) NULL,
	[B18] [nvarchar](255) NULL,
	[B19] [nvarchar](255) NULL,
	[B20] [nvarchar](255) NULL,
	[B21] [nvarchar](255) NULL,
	[B22] [nvarchar](255) NULL,
	[B23] [nvarchar](255) NULL,
	[B24] [nvarchar](255) NULL,
	[B25] [nvarchar](255) NULL,
	[B26] [nvarchar](255) NULL,
	[C1] [nvarchar](255) NULL,
	[C1A] [nvarchar](255) NULL,
	[C1B] [nvarchar](255) NULL,
	[C1C] [nvarchar](255) NULL,
	[C1D] [nvarchar](255) NULL,
	[C1E] [nvarchar](255) NULL,
	[C1F] [nvarchar](255) NULL,
	[C1G] [nvarchar](255) NULL,
	[C2] [nvarchar](255) NULL,
	[C5] [nvarchar](255) NULL,
	[C7] [nvarchar](255) NULL,
	[C8] [nvarchar](255) NULL,
	[C9] [nvarchar](255) NULL,
	[C10] [nvarchar](255) NULL,
	[C11] [nvarchar](255) NULL,
	[C12] [nvarchar](255) NULL,
	[C13] [nvarchar](255) NULL,
	[C14] [nvarchar](255) NULL,
	[C14A] [nvarchar](255) NULL,
	[C15] [nvarchar](255) NULL,
	[C16] [nvarchar](255) NULL,
	[C17] [nvarchar](255) NULL,
	[C18] [nvarchar](255) NULL,
	[C19] [nvarchar](255) NULL,
	[C20] [nvarchar](255) NULL,
	[C21] [nvarchar](255) NULL,
	[C22] [nvarchar](255) NULL,
	[C23] [nvarchar](255) NULL,
	[C24] [nvarchar](255) NULL,
	[C25] [nvarchar](255) NULL,
	[C26] [nvarchar](255) NULL,
	[C27] [nvarchar](255) NULL,
	[D01] [nvarchar](255) NULL,
	[D02] [nvarchar](255) NULL,
	[D03] [nvarchar](255) NULL,
	[D04] [nvarchar](255) NULL,
	[D05] [nvarchar](255) NULL,
	[E01A] [nvarchar](255) NULL,
	[E01B] [nvarchar](255) NULL,
	[E01C] [nvarchar](255) NULL,
	[E02A_MON] [nvarchar](255) NULL,
	[E02A_TUES] [nvarchar](255) NULL,
	[E02A_WEDS] [nvarchar](255) NULL,
	[E02A_THURS] [nvarchar](255) NULL,
	[E02A_FRID] [nvarchar](255) NULL,
	[E02A_SAT] [nvarchar](255) NULL,
	[E02A_SUN] [nvarchar](255) NULL,
	[E02A_TOTAL] [nvarchar](255) NULL,
	[E02B_MON] [nvarchar](255) NULL,
	[E02B_TUES] [nvarchar](255) NULL,
	[E02B_WEDS] [nvarchar](255) NULL,
	[E02B_THURS] [nvarchar](255) NULL,
	[E02B_FRID] [nvarchar](255) NULL,
	[E02B_SATUR] [nvarchar](255) NULL,
	[E02B_SUNDAY] [nvarchar](255) NULL,
	[E02B_TOTAL] [nvarchar](255) NULL,
	[E02C_TOTAL] [nvarchar](255) NULL,
	[F01] [nvarchar](255) NULL,
	[F02] [nvarchar](255) NULL,
	[F03] [nvarchar](255) NULL,
	[F04] [nvarchar](255) NULL,
	[F05] [nvarchar](255) NULL,
	[F06] [nvarchar](255) NULL,
	[F07] [nvarchar](255) NULL,
	[G01] [nvarchar](255) NULL,
	[G01_AMOUNT] [nvarchar](255) NULL,
	[G02] [nvarchar](255) NULL,
	[G03] [nvarchar](255) NULL,
	[G03_AMOUNT] [nvarchar](255) NULL,
	[G04] [nvarchar](255) NULL,
	[G05] [nvarchar](255) NULL,
	[G06] [nvarchar](255) NULL,
	[G07] [nvarchar](255) NULL,
	[G08] [nvarchar](255) NULL,
	[G09] [nvarchar](255) NULL,
	[G10] [nvarchar](255) NULL,
	[G11] [nvarchar](255) NULL,
	[G12] [nvarchar](255) NULL,
	[G13] [nvarchar](255) NULL,
	[G14] [nvarchar](255) NULL,
	[H01A] [nvarchar](255) NULL,
	[H01B] [nvarchar](255) NULL,
	[H02] [nvarchar](255) NULL,
	[H03A] [nvarchar](255) NULL,
	[H03B] [nvarchar](255) NULL,
	[H04] [nvarchar](255) NULL,
	[H05] [nvarchar](255) NULL,
	[H06] [nvarchar](255) NULL,
	[H07] [nvarchar](255) NULL,
	[H08A] [nvarchar](255) NULL,
	[H08B] [nvarchar](255) NULL,
	[H09] [nvarchar](255) NULL,
	[H10] [nvarchar](255) NULL,
	[I01] [nvarchar](255) NULL,
	[I02] [nvarchar](255) NULL,
	[I03] [nvarchar](255) NULL,
	[I04] [nvarchar](255) NULL,
	[I05] [nvarchar](255) NULL,
	[I06] [nvarchar](255) NULL,
	[I07] [nvarchar](255) NULL,
	[I08] [nvarchar](255) NULL,
	[I09] [nvarchar](255) NULL,
	[J01_JANUARY] [nvarchar](255) NULL,
	[J01_FEBRUARY] [nvarchar](255) NULL,
	[J01_MARCH] [nvarchar](255) NULL,
	[J01_APRIL] [nvarchar](255) NULL,
	[J01_MAY] [nvarchar](255) NULL,
	[J01_JUNE] [nvarchar](255) NULL,
	[J01_JULY] [nvarchar](255) NULL,
	[J01_AUGUST] [nvarchar](255) NULL,
	[J01_SEPTEMBER] [nvarchar](255) NULL,
	[J01_OCTOBER] [nvarchar](255) NULL,
	[J01_NOVEMBER] [nvarchar](255) NULL,
	[J01_DECEMBER] [nvarchar](255) NULL,
	[J02] [nvarchar](255) NULL,
	[J03] [nvarchar](255) NULL,
	[new_calwgt2] [nvarchar](255) NULL,
	[gender] [nvarchar](255) NULL,
	[education] [nvarchar](255) NULL,
	[age15] [nvarchar](255) NULL,
	[employed] [nvarchar](255) NULL,
	[unemployed_broad] [nvarchar](255) NULL,
	[unemployed_strict] [nvarchar](255) NULL,
	[inactive_broad] [nvarchar](255) NULL,
	[inactive_strict] [nvarchar](255) NULL,
	[labour_force_broad] [nvarchar](255) NULL,
	[labour_force_strict] [nvarchar](255) NULL,
	[occupation] [nvarchar](255) NULL,
	[sector] [nvarchar](255) NULL,
	[status_inemployment] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[CustomErrorCode] [int] NULL,
	[CustomErrorColumn] [int] NULL,
	[ErrorDescription] [varchar](255) NULL,
	[ErrorColumnName] [varchar](255) NULL,
	[SurveyUploadId] [bigint] NULL,
 CONSTRAINT [PK_LabourForceSurveError] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LabourForceSurveyTemp]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourForceSurveyTemp](
	[LabourForceSurveyTempId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Reg] [decimal](18, 0) NULL,
	[Residence] [decimal](18, 0) NULL,
	[cluster] [decimal](18, 0) NULL,
	[HH] [decimal](18, 0) NULL,
	[HHM] [decimal](18, 0) NULL,
	[HHF] [decimal](18, 0) NULL,
	[HHT] [decimal](18, 0) NULL,
	[ELM] [decimal](18, 0) NULL,
	[ELF] [decimal](18, 0) NULL,
	[ELT] [decimal](18, 0) NULL,
	[CL_M] [decimal](18, 0) NULL,
	[CL_F] [decimal](18, 0) NULL,
	[CL_T] [decimal](18, 0) NULL,
	[IQ_M] [decimal](18, 0) NULL,
	[IQ_F] [decimal](18, 0) NULL,
	[IQ_T] [decimal](18, 0) NULL,
	[HH_D] [decimal](18, 0) NULL,
	[HH_M] [decimal](18, 0) NULL,
	[HH_Y] [decimal](18, 0) NULL,
	[HHR] [decimal](18, 0) NULL,
	[IA6] [decimal](18, 0) NULL,
	[BG1] [decimal](18, 0) NULL,
	[BG2] [decimal](18, 0) NULL,
	[BG3] [decimal](18, 0) NULL,
	[BG4] [decimal](18, 0) NULL,
	[BG5_M] [decimal](18, 0) NULL,
	[BG5_Y] [decimal](18, 0) NULL,
	[BG5_N] [decimal](18, 0) NULL,
	[BG6_TA] [decimal](18, 0) NULL,
	[BG6D] [decimal](18, 0) NULL,
	[BG6C] [decimal](18, 0) NULL,
	[BG8] [decimal](18, 0) NULL,
	[BG9] [decimal](18, 0) NULL,
	[BG10] [decimal](18, 0) NULL,
	[A1] [decimal](18, 0) NULL,
	[A2A] [decimal](18, 0) NULL,
	[A2B] [decimal](18, 0) NULL,
	[A2C] [decimal](18, 0) NULL,
	[A2D] [decimal](18, 0) NULL,
	[A2E] [decimal](18, 0) NULL,
	[A2F] [decimal](18, 0) NULL,
	[A2G] [decimal](18, 0) NULL,
	[A3] [decimal](18, 0) NULL,
	[A4] [decimal](18, 0) NULL,
	[A5] [decimal](18, 0) NULL,
	[A6] [decimal](18, 0) NULL,
	[A7] [decimal](18, 0) NULL,
	[A8] [decimal](18, 0) NULL,
	[A9] [decimal](18, 0) NULL,
	[A10] [decimal](18, 0) NULL,
	[B2] [decimal](18, 0) NULL,
	[B4] [decimal](18, 0) NULL,
	[B5] [decimal](18, 0) NULL,
	[B6] [decimal](18, 0) NULL,
	[B6A] [decimal](18, 0) NULL,
	[B7] [decimal](18, 0) NULL,
	[B8] [decimal](18, 0) NULL,
	[B9] [decimal](18, 0) NULL,
	[B10] [decimal](18, 0) NULL,
	[B11] [decimal](18, 0) NULL,
	[B11A] [decimal](18, 0) NULL,
	[B12] [decimal](18, 0) NULL,
	[B13] [decimal](18, 0) NULL,
	[B14] [decimal](18, 0) NULL,
	[B15] [decimal](18, 0) NULL,
	[B15A] [decimal](18, 0) NULL,
	[B15B] [decimal](18, 0) NULL,
	[B17] [decimal](18, 0) NULL,
	[B18] [decimal](18, 0) NULL,
	[B19] [decimal](18, 0) NULL,
	[B20] [decimal](18, 0) NULL,
	[B21] [decimal](18, 0) NULL,
	[B22] [decimal](18, 0) NULL,
	[B23] [decimal](18, 0) NULL,
	[B24] [decimal](18, 0) NULL,
	[B25] [decimal](18, 0) NULL,
	[B26] [decimal](18, 0) NULL,
	[C1] [decimal](18, 0) NULL,
	[C1A] [decimal](18, 0) NULL,
	[C1B] [decimal](18, 0) NULL,
	[C1C] [decimal](18, 0) NULL,
	[C1D] [decimal](18, 0) NULL,
	[C1E] [decimal](18, 0) NULL,
	[C1F] [decimal](18, 0) NULL,
	[C1G] [decimal](18, 0) NULL,
	[C2] [decimal](18, 0) NULL,
	[C5] [decimal](18, 0) NULL,
	[C7] [decimal](18, 0) NULL,
	[C8] [decimal](18, 0) NULL,
	[C9] [decimal](18, 0) NULL,
	[C10] [decimal](18, 0) NULL,
	[C11] [decimal](18, 0) NULL,
	[C12] [decimal](18, 0) NULL,
	[C13] [decimal](18, 0) NULL,
	[C14] [decimal](18, 0) NULL,
	[C14A] [decimal](18, 0) NULL,
	[C15] [decimal](18, 0) NULL,
	[C16] [decimal](18, 0) NULL,
	[C17] [decimal](18, 0) NULL,
	[C18] [decimal](18, 0) NULL,
	[C19] [decimal](18, 0) NULL,
	[C20] [decimal](18, 0) NULL,
	[C21] [decimal](18, 0) NULL,
	[C22] [decimal](18, 0) NULL,
	[C23] [decimal](18, 0) NULL,
	[C24] [decimal](18, 0) NULL,
	[C25] [decimal](18, 0) NULL,
	[C26] [decimal](18, 0) NULL,
	[C27] [decimal](18, 0) NULL,
	[D01] [decimal](18, 0) NULL,
	[D02] [decimal](18, 0) NULL,
	[D03] [decimal](18, 0) NULL,
	[D04] [decimal](18, 0) NULL,
	[D05] [decimal](18, 0) NULL,
	[E01A] [decimal](18, 0) NULL,
	[E01B] [decimal](18, 0) NULL,
	[E01C] [decimal](18, 0) NULL,
	[E02A_MON] [decimal](18, 0) NULL,
	[E02A_TUES] [decimal](18, 0) NULL,
	[E02A_WEDS] [decimal](18, 0) NULL,
	[E02A_THURS] [decimal](18, 0) NULL,
	[E02A_FRID] [decimal](18, 0) NULL,
	[E02A_SAT] [decimal](18, 0) NULL,
	[E02A_SUN] [decimal](18, 0) NULL,
	[E02A_TOTAL] [decimal](18, 0) NULL,
	[E02B_MON] [decimal](18, 0) NULL,
	[E02B_TUES] [decimal](18, 0) NULL,
	[E02B_WEDS] [decimal](18, 0) NULL,
	[E02B_THURS] [decimal](18, 0) NULL,
	[E02B_FRID] [decimal](18, 0) NULL,
	[E02B_SATUR] [decimal](18, 0) NULL,
	[E02B_SUNDAY] [decimal](18, 0) NULL,
	[E02B_TOTAL] [decimal](18, 0) NULL,
	[E02C_TOTAL] [decimal](18, 0) NULL,
	[F01] [decimal](18, 0) NULL,
	[F02] [decimal](18, 0) NULL,
	[F03] [decimal](18, 0) NULL,
	[F04] [decimal](18, 0) NULL,
	[F05] [decimal](18, 0) NULL,
	[F06] [decimal](18, 0) NULL,
	[F07] [decimal](18, 0) NULL,
	[G01] [decimal](18, 0) NULL,
	[G01_AMOUNT] [decimal](18, 0) NULL,
	[G02] [decimal](18, 0) NULL,
	[G03] [decimal](18, 0) NULL,
	[G03_AMOUNT] [decimal](18, 0) NULL,
	[G04] [decimal](18, 0) NULL,
	[G05] [decimal](18, 0) NULL,
	[G06] [decimal](18, 0) NULL,
	[G07] [decimal](18, 0) NULL,
	[G08] [decimal](18, 0) NULL,
	[G09] [decimal](18, 0) NULL,
	[G10] [decimal](18, 0) NULL,
	[G11] [decimal](18, 0) NULL,
	[G12] [decimal](18, 0) NULL,
	[G13] [decimal](18, 0) NULL,
	[G14] [decimal](18, 0) NULL,
	[H01A] [decimal](18, 0) NULL,
	[H01B] [decimal](18, 0) NULL,
	[H02] [decimal](18, 0) NULL,
	[H03A] [decimal](18, 0) NULL,
	[H03B] [decimal](18, 0) NULL,
	[H04] [decimal](18, 0) NULL,
	[H05] [decimal](18, 0) NULL,
	[H06] [decimal](18, 0) NULL,
	[H07] [decimal](18, 0) NULL,
	[H08A] [decimal](18, 0) NULL,
	[H08B] [decimal](18, 0) NULL,
	[H09] [decimal](18, 0) NULL,
	[H10] [decimal](18, 0) NULL,
	[I01] [decimal](18, 0) NULL,
	[I02] [decimal](18, 0) NULL,
	[I03] [decimal](18, 0) NULL,
	[I04] [decimal](18, 0) NULL,
	[I05] [decimal](18, 0) NULL,
	[I06] [decimal](18, 0) NULL,
	[I07] [decimal](18, 0) NULL,
	[I08] [decimal](18, 0) NULL,
	[I09] [decimal](18, 0) NULL,
	[J01_JANUARY] [decimal](18, 0) NULL,
	[J01_FEBRUARY] [decimal](18, 0) NULL,
	[J01_MARCH] [decimal](18, 0) NULL,
	[J01_APRIL] [decimal](18, 0) NULL,
	[J01_MAY] [decimal](18, 0) NULL,
	[J01_JUNE] [decimal](18, 0) NULL,
	[J01_JULY] [decimal](18, 0) NULL,
	[J01_AUGUST] [decimal](18, 0) NULL,
	[J01_SEPTEMBER] [decimal](18, 0) NULL,
	[J01_OCTOBER] [decimal](18, 0) NULL,
	[J01_NOVEMBER] [decimal](18, 0) NULL,
	[J01_DECEMBER] [decimal](18, 0) NULL,
	[J02] [decimal](18, 0) NULL,
	[J03] [decimal](18, 0) NULL,
	[new_calwgt2] [decimal](18, 0) NULL,
	[gender] [decimal](18, 0) NULL,
	[education] [decimal](18, 0) NULL,
	[age15] [decimal](18, 0) NULL,
	[employed] [decimal](18, 0) NULL,
	[unemployed_broad] [decimal](18, 0) NULL,
	[unemployed_strict] [decimal](18, 0) NULL,
	[inactive_broad] [decimal](18, 0) NULL,
	[inactive_strict] [decimal](18, 0) NULL,
	[labour_force_broad] [decimal](18, 0) NULL,
	[labour_force_strict] [decimal](18, 0) NULL,
	[occupation] [decimal](18, 0) NULL,
	[sector] [decimal](18, 0) NULL,
	[status_inemployment] [decimal](18, 0) NULL,
	[SurveyEffectiveYearId] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_LabourForceSurveyValid] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyTempId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LF_Indicator_PopulationEmployment]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LF_Indicator_PopulationEmployment](
	[LabourForcePopulationEmployment1d] [bigint] IDENTITY(1,1) NOT NULL,
	[RegionId] [int] NULL,
	[SurveyYearId] [int] NULL,
	[SurveyEffectiveYearId] [int] NULL,
	[AgeGroupId] [int] NULL,
	[GenderId] [int] NULL,
	[ResidenceId] [int] NULL,
	[IncomeGroupId] [int] NULL,
	[SectorId] [int] NULL,
	[OcupationId] [int] NULL,
	[EducationId] [int] NULL,
	[TotalPopulation] [decimal](18, 0) NULL,
	[TotalLabourForceBroad] [decimal](18, 0) NULL,
	[TotalLabourForceStrict] [decimal](18, 0) NULL,
	[PerLabourForceBroad] [decimal](5, 2) NULL,
	[PerLabourForceStrict] [decimal](5, 2) NULL,
	[TotalInactivePopulationBroad] [decimal](18, 0) NULL,
	[TotalInactivePopulationStrict] [decimal](18, 0) NULL,
	[PerInactivePopulationStrict] [decimal](5, 2) NULL,
	[PerInactivePopulationBroad] [decimal](5, 2) NULL,
	[TotalEmployment] [decimal](18, 0) NULL,
	[PerEmployment] [decimal](5, 2) NULL,
	[TotalPartTimeWorker] [decimal](18, 0) NULL,
	[PerPartTimeWorker] [decimal](5, 2) NULL,
	[TotalInformalEmployment] [decimal](18, 0) NULL,
	[PerInformalEmployment] [decimal](5, 2) NULL,
	[TotalUnemploymentBroad] [decimal](18, 0) NULL,
	[TotalUnemploymentStrict] [decimal](18, 0) NULL,
	[PerUnemploymentBroad] [decimal](5, 2) NULL,
	[PerUnemploymentStrict] [decimal](5, 2) NULL,
	[TotalYouthLabourForceBroad] [decimal](18, 0) NULL,
	[TotalYouthLabourForceStrict] [decimal](18, 0) NULL,
	[TotalYouthUnemploymentBroad] [decimal](18, 0) NULL,
	[TotalYouthUnemploymentStrict] [decimal](18, 0) NULL,
	[TotalYouthEmployment] [decimal](18, 0) NULL,
	[PerYouthEmployment] [decimal](5, 2) NULL,
	[PerYouthUnemploymentBroad] [decimal](5, 2) NULL,
	[PerYouthUnemploymentStrict] [decimal](5, 2) NULL,
	[TotalAdultLabourForceBroad] [decimal](18, 0) NULL,
	[TotalAdultLabourForceStrict] [decimal](18, 0) NULL,
	[TotalAdultEmployment] [decimal](18, 0) NULL,
	[TotalAdultUnemploymentBroad] [decimal](18, 0) NULL,
	[TotalAdultUnemploymentStrict] [decimal](18, 0) NULL,
	[PerAdultEmployment] [decimal](5, 2) NULL,
	[PerAdultUnemploymentBroad] [decimal](5, 2) NULL,
	[PerAdultUnemploymentStrict] [decimal](5, 2) NULL,
	[TotalLongTermUnemployment] [decimal](18, 0) NULL,
	[PerLongTermUnemployment] [decimal](5, 2) NULL,
	[TotalEmployedLabourForceBroad] [decimal](18, 0) NULL,
	[TotalEmployedLabourForceStrict] [decimal](18, 0) NULL,
	[TotalTimeRelUnderEmployment] [decimal](18, 0) NULL,
	[PerTimeRelUnderEmployment] [decimal](5, 2) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_LabourForcePopulationEmployment] PRIMARY KEY CLUSTERED 
(
	[LabourForcePopulationEmployment1d] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MailConfig]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MailConfig](
	[MailConfigId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType] [varchar](50) NULL,
	[EventType] [varchar](255) NULL,
	[MailSubject] [varchar](500) NULL,
	[Body] [varchar](max) NULL,
	[ToEmail] [varchar](500) NULL,
	[AttachmentPath] [varchar](255) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MailConfig_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MailConfig] PRIMARY KEY CLUSTERED 
(
	[MailConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Occupation]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Occupation](
	[OccupationId] [int] IDENTITY(1,1) NOT NULL,
	[OccupationCode] [decimal](18, 0) NULL,
	[OccupationTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Occupation_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Occupation] PRIMARY KEY CLUSTERED 
(
	[OccupationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PackageConfig]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PackageConfig](
	[PackageConfigId] [int] IDENTITY(1,1) NOT NULL,
	[ConfigKey] [varchar](50) NULL,
	[ConfigValue] [varchar](255) NULL,
	[SurveyType] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PackageConfig] PRIMARY KEY CLUSTERED 
(
	[PackageConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PackageLog]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PackageLog](
	[PackageLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[PackageId] [varchar](50) NULL,
	[PackageName] [varchar](50) NULL,
	[TaskName] [varchar](255) NULL,
	[LogDescription] [varchar](500) NULL,
	[ErrorCode] [int] NULL,
	[ErrorDescription] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_AuditLog_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED 
(
	[PackageLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Population]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Population](
	[Id] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Region] [varchar](50) NULL,
	[SubRegion] [varchar](50) NULL,
	[AgeGroup] [varchar](50) NULL,
	[Population] [decimal](18, 0) NULL,
 CONSTRAINT [PK_Population] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Region]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Region](
	[RegionId] [int] IDENTITY(1,1) NOT NULL,
	[RegionCode] [decimal](18, 0) NULL,
	[RegionTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Region_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Residence]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Residence](
	[ResidenceId] [int] IDENTITY(1,1) NOT NULL,
	[ResidenceCode] [decimal](18, 0) NULL,
	[ResidenceTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Residence_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_District] PRIMARY KEY CLUSTERED 
(
	[ResidenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sector]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sector](
	[SectorId] [int] IDENTITY(1,1) NOT NULL,
	[SectorCode] [decimal](18, 0) NULL,
	[SectorTitle] [varchar](255) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Sector_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Sector] PRIMARY KEY CLUSTERED 
(
	[SectorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SurveyEffectiveYear]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyEffectiveYear](
	[SurveyEffectiveYearId] [int] IDENTITY(1,1) NOT NULL,
	[EffectiveYear] [int] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_SurveyEffectiveYear_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_SurveyEffectiveYear] PRIMARY KEY CLUSTERED 
(
	[SurveyEffectiveYearId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SurveyUpload]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SurveyUpload](
	[SurveyUploadId] [bigint] IDENTITY(1,1) NOT NULL,
	[SurveyType] [varchar](50) NULL,
	[PackageStatus] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_SurveyUpload_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_SurveyUpload_ModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_SurveyUpload] PRIMARY KEY CLUSTERED 
(
	[SurveyUploadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SurveyYear]    Script Date: 10/1/2016 6:33:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyYear](
	[SurveyYearId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyYear] [int] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Year_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Year] PRIMARY KEY CLUSTERED 
(
	[SurveyYearId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[AgeGroup] ON 

INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'15 - 19', CAST(N'2016-08-21 11:38:12.107' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'20 - 24', CAST(N'2016-08-21 11:39:25.600' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (3, CAST(3 AS Decimal(18, 0)), N'25 - 29', CAST(N'2016-08-21 11:39:45.500' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (4, CAST(4 AS Decimal(18, 0)), N'30 - 34', CAST(N'2016-08-21 11:40:07.290' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (5, CAST(5 AS Decimal(18, 0)), N'35 - 39', CAST(N'2016-08-21 11:40:33.677' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (6, CAST(6 AS Decimal(18, 0)), N'40 - 44', CAST(N'2016-08-21 11:40:59.953' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (7, CAST(7 AS Decimal(18, 0)), N'45 - 49', CAST(N'2016-08-21 11:41:29.017' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (8, CAST(8 AS Decimal(18, 0)), N'50 - 54', CAST(N'2016-08-21 11:41:47.340' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (9, CAST(9 AS Decimal(18, 0)), N'55 - 59', CAST(N'2016-08-21 11:42:59.893' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (10, CAST(10 AS Decimal(18, 0)), N'60 - 64', CAST(N'2016-08-21 11:43:23.960' AS DateTime))
INSERT [dbo].[AgeGroup] ([AgeGroupId], [AgeGroupCode], [AgeGroupTitle], [CreatedDate]) VALUES (11, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 17:59:30.880' AS DateTime))
SET IDENTITY_INSERT [dbo].[AgeGroup] OFF
SET IDENTITY_INSERT [dbo].[Education] ON 

INSERT [dbo].[Education] ([EducationId], [EducationCode], [EducationTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-10 18:49:34.600' AS DateTime))
INSERT [dbo].[Education] ([EducationId], [EducationCode], [EducationTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'Primary', CAST(N'2016-09-10 18:49:56.630' AS DateTime))
INSERT [dbo].[Education] ([EducationId], [EducationCode], [EducationTitle], [CreatedDate]) VALUES (3, CAST(3 AS Decimal(18, 0)), N'Secondary', CAST(N'2016-09-10 18:50:18.610' AS DateTime))
INSERT [dbo].[Education] ([EducationId], [EducationCode], [EducationTitle], [CreatedDate]) VALUES (4, CAST(4 AS Decimal(18, 0)), N'Tertiary', CAST(N'2016-09-10 18:50:54.983' AS DateTime))
SET IDENTITY_INSERT [dbo].[Education] OFF
SET IDENTITY_INSERT [dbo].[Gender] ON 

INSERT [dbo].[Gender] ([GenderId], [GenderCode], [GenderTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'Male', CAST(N'2016-08-21 11:45:22.187' AS DateTime))
INSERT [dbo].[Gender] ([GenderId], [GenderCode], [GenderTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'Female', CAST(N'2016-08-21 11:45:43.583' AS DateTime))
INSERT [dbo].[Gender] ([GenderId], [GenderCode], [GenderTitle], [CreatedDate]) VALUES (3, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 17:59:49.083' AS DateTime))
SET IDENTITY_INSERT [dbo].[Gender] OFF
SET IDENTITY_INSERT [dbo].[IncomeGroup] ON 

INSERT [dbo].[IncomeGroup] ([IncomeGroupId], [IncomeGroupCode], [IncomeGroupTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'Less than [MK8,242]', CAST(N'2016-09-10 13:50:24.550' AS DateTime))
INSERT [dbo].[IncomeGroup] ([IncomeGroupId], [IncomeGroupCode], [IncomeGroupTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'[MK8,243] to less than [25,000]', CAST(N'2016-09-10 13:50:24.550' AS DateTime))
INSERT [dbo].[IncomeGroup] ([IncomeGroupId], [IncomeGroupCode], [IncomeGroupTitle], [CreatedDate]) VALUES (3, CAST(3 AS Decimal(18, 0)), N'[MK25,000] to less than [MK45,000]', CAST(N'2016-09-10 13:50:45.160' AS DateTime))
INSERT [dbo].[IncomeGroup] ([IncomeGroupId], [IncomeGroupCode], [IncomeGroupTitle], [CreatedDate]) VALUES (4, CAST(4 AS Decimal(18, 0)), N'[MK45,000] or More', CAST(N'2016-09-10 13:51:00.783' AS DateTime))
INSERT [dbo].[IncomeGroup] ([IncomeGroupId], [IncomeGroupCode], [IncomeGroupTitle], [CreatedDate]) VALUES (5, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 18:00:02.797' AS DateTime))
SET IDENTITY_INSERT [dbo].[IncomeGroup] OFF
SET IDENTITY_INSERT [dbo].[IndicatorColumnOption] ON 

INSERT [dbo].[IndicatorColumnOption] ([IndicatorColumnOptionId], [IndicatorColumnInternalName], [IndicatorColumnDisplayName], [IndicatorId]) VALUES (1, N'EffectiveYear', N'Year', 1)
INSERT [dbo].[IndicatorColumnOption] ([IndicatorColumnOptionId], [IndicatorColumnInternalName], [IndicatorColumnDisplayName], [IndicatorId]) VALUES (2, N'GenderTitle', N'Gender', 1)
INSERT [dbo].[IndicatorColumnOption] ([IndicatorColumnOptionId], [IndicatorColumnInternalName], [IndicatorColumnDisplayName], [IndicatorId]) VALUES (3, N'AgeGroupTitle', N'AgeGroup', 1)
SET IDENTITY_INSERT [dbo].[IndicatorColumnOption] OFF
SET IDENTITY_INSERT [dbo].[IndicatorDataOption] ON 

INSERT [dbo].[IndicatorDataOption] ([IndicatorDataOptionId], [IndicatorDataColInternalName], [IndicatorDataColDisplayName], [IndicatorId]) VALUES (1, N'TotalPopulation', N'TotalPopulation', 1)
INSERT [dbo].[IndicatorDataOption] ([IndicatorDataOptionId], [IndicatorDataColInternalName], [IndicatorDataColDisplayName], [IndicatorId]) VALUES (2, N'TotalLabourForceBroad', N'TotalLabourForce (Broad)', 1)
INSERT [dbo].[IndicatorDataOption] ([IndicatorDataOptionId], [IndicatorDataColInternalName], [IndicatorDataColDisplayName], [IndicatorId]) VALUES (3, N'TotalLabourForceStrict', N'TotalLabourForceStrict', 1)
INSERT [dbo].[IndicatorDataOption] ([IndicatorDataOptionId], [IndicatorDataColInternalName], [IndicatorDataColDisplayName], [IndicatorId]) VALUES (4, N'PerLabourforceBroad', N'LabourForceBroad(%)', 1)
INSERT [dbo].[IndicatorDataOption] ([IndicatorDataOptionId], [IndicatorDataColInternalName], [IndicatorDataColDisplayName], [IndicatorId]) VALUES (5, N'PerLabourforceStrict', N'LabourForceStrict(%)', 1)
SET IDENTITY_INSERT [dbo].[IndicatorDataOption] OFF
SET IDENTITY_INSERT [dbo].[IndicatorMaster] ON 

INSERT [dbo].[IndicatorMaster] ([IndicatorMasterId], [IndicatorName], [IndicatorDescription]) VALUES (1, N'LabourForceParticipationRatio', NULL)
SET IDENTITY_INSERT [dbo].[IndicatorMaster] OFF
SET IDENTITY_INSERT [dbo].[MailConfig] ON 

INSERT [dbo].[MailConfig] ([MailConfigId], [SurveyType], [EventType], [MailSubject], [Body], [ToEmail], [AttachmentPath], [CreatedDate]) VALUES (1, N'LabourForce', N'PackageStart', N'Labour Force - Data Import Started', N'This is to inform you that job has started to import Labour Force survey data', N'medevjani@gmail.com', NULL, CAST(N'2016-08-14 14:08:11.600' AS DateTime))
INSERT [dbo].[MailConfig] ([MailConfigId], [SurveyType], [EventType], [MailSubject], [Body], [ToEmail], [AttachmentPath], [CreatedDate]) VALUES (2, N'LabourForce', N'PackageComplete', N'Labour Force - Data Import Completed', N'This is to inform you that Labour force data import job has been completed successfully.', N'medevjani@gmail.com', NULL, CAST(N'2016-08-14 14:08:11.600' AS DateTime))
INSERT [dbo].[MailConfig] ([MailConfigId], [SurveyType], [EventType], [MailSubject], [Body], [ToEmail], [AttachmentPath], [CreatedDate]) VALUES (3, N'LabourForce', N'PackageUnexpectedError', N'Labour Force - Data Import failed due to unexpected error!!', N'This is to inform you that Labour force data import job has been failed due to some unexpected error. Please validate the template and upload the survey data again.', N'medevjani@gmail.com', NULL, CAST(N'2016-08-14 14:08:11.600' AS DateTime))
INSERT [dbo].[MailConfig] ([MailConfigId], [SurveyType], [EventType], [MailSubject], [Body], [ToEmail], [AttachmentPath], [CreatedDate]) VALUES (4, N'LabourForce', N'PackageDataError', N'Labour Force - Data Import failed due to data error!!', N'This is to inform you that Labour force data import job has been failed due to some unexpected error. Please refer attachment for errornous rows. Please validate the template and upload the survey data again.', N'medevjani@gmail.com', N'C:\Devjani\Projects\LMIS\Development\LabourForceSurvey_Error.xlsx', CAST(N'2016-08-14 14:08:11.600' AS DateTime))
INSERT [dbo].[MailConfig] ([MailConfigId], [SurveyType], [EventType], [MailSubject], [Body], [ToEmail], [AttachmentPath], [CreatedDate]) VALUES (5, N'LabourForce', N'PackageDataDuplicate', N'Labour Force - Data Import failed due to presence of duplicate data!', N'This is to inform you that Labour force data import job has been failed. Data Already exists for specific time. Please upload fresh data!!', N'medevjani@gmail.com', NULL, CAST(N'2016-08-14 14:08:11.600' AS DateTime))
INSERT [dbo].[MailConfig] ([MailConfigId], [SurveyType], [EventType], [MailSubject], [Body], [ToEmail], [AttachmentPath], [CreatedDate]) VALUES (6, N'LabourForce', N'NoSurveyData', N'Labour Force - No survey data found. Data import failed!!', N'This is to inform you that Labour force data import job has been failed. There is no survey queued for processing. Please upload the survey data again.', N'medevjani@gmail.com', NULL, CAST(N'2016-08-14 14:08:11.600' AS DateTime))
SET IDENTITY_INSERT [dbo].[MailConfig] OFF
SET IDENTITY_INSERT [dbo].[Occupation] ON 

INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'Manager', CAST(N'2016-08-21 11:31:35.847' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'Professionals', CAST(N'2016-08-21 11:31:54.590' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (3, CAST(3 AS Decimal(18, 0)), N'Technicians ans associated professional', CAST(N'2016-08-21 11:32:28.193' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (4, CAST(4 AS Decimal(18, 0)), N'Clerical support workers', CAST(N'2016-08-21 11:32:52.117' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (5, CAST(5 AS Decimal(18, 0)), N'Service and sales workers', CAST(N'2016-08-21 11:33:11.020' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (6, CAST(6 AS Decimal(18, 0)), N'Skilled agricultural, forestry and fishery workers', CAST(N'2016-08-21 11:33:32.783' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (7, CAST(7 AS Decimal(18, 0)), N'Craft and related trades workers', CAST(N'2016-08-21 11:34:05.640' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (8, CAST(8 AS Decimal(18, 0)), N'Plant and machine operators, and assemblers', CAST(N'2016-08-21 11:34:37.910' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (9, CAST(9 AS Decimal(18, 0)), N'Elementary occupations', CAST(N'2016-08-21 11:35:07.410' AS DateTime))
INSERT [dbo].[Occupation] ([OccupationId], [OccupationCode], [OccupationTitle], [CreatedDate]) VALUES (10, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 18:00:21.480' AS DateTime))
SET IDENTITY_INSERT [dbo].[Occupation] OFF
SET IDENTITY_INSERT [dbo].[PackageConfig] ON 

INSERT [dbo].[PackageConfig] ([PackageConfigId], [ConfigKey], [ConfigValue], [SurveyType], [CreatedDate]) VALUES (1, N'SourceFilePath', N'C:\Devjani\Projects\LMIS\Development\LabourForceSurveyData.xlsx', N'LabourForce', NULL)
INSERT [dbo].[PackageConfig] ([PackageConfigId], [ConfigKey], [ConfigValue], [SurveyType], [CreatedDate]) VALUES (2, N'ErrorFilePath', N'C:\Devjani\Projects\LMIS\Development\LabourForceSurvey_Error.xlsx', N'LabourForce', NULL)
INSERT [dbo].[PackageConfig] ([PackageConfigId], [ConfigKey], [ConfigValue], [SurveyType], [CreatedDate]) VALUES (3, N'ErrorFileTemplatePath', N'C:\Devjani\Projects\LMIS\Development\LabourForceSurvey_Error_Template.xlsx', N'LabourForce', NULL)
SET IDENTITY_INSERT [dbo].[PackageConfig] OFF
SET IDENTITY_INSERT [dbo].[PackageLog] ON 

INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (1, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Package Started', N'Package Started', NULL, NULL, CAST(N'2016-09-19 16:02:22.023' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (2, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Configuation retrieved', N'Configuration is retrieved successfully', NULL, NULL, CAST(N'2016-09-19 16:02:22.300' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (3, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Error file Preparation', N'Erro file is generated successfully fom template', NULL, NULL, CAST(N'2016-09-19 16:02:22.340' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (4, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Dump, temp tables are truncated', N'Data truncation succeeded from dump, temp tables', NULL, NULL, CAST(N'2016-09-19 16:02:22.413' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (5, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Data moved to dump table', N'Data is moved to Dump table', NULL, NULL, CAST(N'2016-09-19 16:03:11.080' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (6, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Dump table data Processed', N'Dump table data is processed successfully', NULL, NULL, CAST(N'2016-09-19 16:06:07.520' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (7, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Data validation Completed', N'Data Validation is completed Successfully', NULL, NULL, CAST(N'2016-09-19 16:06:08.010' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (8, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Survey Date Validation Completed', N'Survey Date Validation is completed successfully', NULL, NULL, CAST(N'2016-09-19 16:06:08.403' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (9, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Data moved to actual tables', N'Data is successfully moved to Report tables', NULL, NULL, CAST(N'2016-09-19 16:06:41.357' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (10, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Indicator tables are updated', N'Indicator tables are updated', NULL, NULL, CAST(N'2016-09-19 16:06:42.420' AS DateTime))
INSERT [dbo].[PackageLog] ([PackageLogId], [PackageId], [PackageName], [TaskName], [LogDescription], [ErrorCode], [ErrorDescription], [CreatedDate]) VALUES (11, N'{AA4CE2B1-B586-4F08-A4BC-FA5E4D1AC38E}', N'LabourForceSurvey', N'Log Entry - Package is completed', N'Package is successfully completed.', NULL, NULL, CAST(N'2016-09-19 16:06:42.500' AS DateTime))
SET IDENTITY_INSERT [dbo].[PackageLog] OFF
SET IDENTITY_INSERT [dbo].[Population] ON 

INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(1 AS Decimal(18, 0)), N'Northern', N'Chitipa', N'15-20', CAST(60 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(2 AS Decimal(18, 0)), N'Northern', N'Chitipa', N'20-45', CAST(78 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(3 AS Decimal(18, 0)), N'Northern', N'Chitipa', N'45-65', CAST(26 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(4 AS Decimal(18, 0)), N'Northern', N'Chitipa', N'65-80', CAST(35 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(5 AS Decimal(18, 0)), N'Northern', N'Karonga', N'15-20', CAST(34 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(6 AS Decimal(18, 0)), N'Northern', N'Karonga', N'20-45', CAST(56 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(7 AS Decimal(18, 0)), N'Northern', N'Karonga', N'45-65', CAST(89 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(8 AS Decimal(18, 0)), N'Northern', N'Karonga', N'65-80', CAST(102 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(9 AS Decimal(18, 0)), N'Northern', N'Likoma', N'15-20', CAST(45 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(10 AS Decimal(18, 0)), N'Northern', N'Likoma', N'20-45', CAST(200 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(11 AS Decimal(18, 0)), N'Northern', N'Likoma', N'45-65', CAST(45 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(12 AS Decimal(18, 0)), N'Northern', N'Likoma', N'65-80', CAST(19 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(13 AS Decimal(18, 0)), N'Southern', N'Balaka', N'15-20', CAST(45 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(14 AS Decimal(18, 0)), N'Southern', N'Balaka', N'20-45', CAST(23 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(15 AS Decimal(18, 0)), N'Southern', N'Balaka', N'45-65', CAST(18 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(16 AS Decimal(18, 0)), N'Southern', N'Balaka', N'65-80', CAST(56 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(17 AS Decimal(18, 0)), N'Southern', N'Blantyre', N'15-20', CAST(34 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(18 AS Decimal(18, 0)), N'Southern', N'Blantyre', N'20-45', CAST(100 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(19 AS Decimal(18, 0)), N'Southern', N'Blantyre', N'45-65', CAST(290 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(20 AS Decimal(18, 0)), N'Southern', N'Blantyre', N'65-80', CAST(34 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(21 AS Decimal(18, 0)), N'Southern', N'Chikwawa', N'15-20', CAST(26 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(22 AS Decimal(18, 0)), N'Southern', N'Chikwawa', N'20-45', CAST(23 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(23 AS Decimal(18, 0)), N'Southern', N'Chikwawa', N'45-65', CAST(78 AS Decimal(18, 0)))
INSERT [dbo].[Population] ([Id], [Region], [SubRegion], [AgeGroup], [Population]) VALUES (CAST(24 AS Decimal(18, 0)), N'Southern', N'Chikwawa', N'65-80', CAST(200 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[Population] OFF
SET IDENTITY_INSERT [dbo].[Region] ON 

INSERT [dbo].[Region] ([RegionId], [RegionCode], [RegionTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'Northern', CAST(N'2016-08-21 11:47:36.853' AS DateTime))
INSERT [dbo].[Region] ([RegionId], [RegionCode], [RegionTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'Central', CAST(N'2016-08-21 11:47:54.973' AS DateTime))
INSERT [dbo].[Region] ([RegionId], [RegionCode], [RegionTitle], [CreatedDate]) VALUES (3, CAST(3 AS Decimal(18, 0)), N'Southern', CAST(N'2016-08-21 11:48:39.020' AS DateTime))
INSERT [dbo].[Region] ([RegionId], [RegionCode], [RegionTitle], [CreatedDate]) VALUES (4, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 18:00:57.200' AS DateTime))
SET IDENTITY_INSERT [dbo].[Region] OFF
SET IDENTITY_INSERT [dbo].[Residence] ON 

INSERT [dbo].[Residence] ([ResidenceId], [ResidenceCode], [ResidenceTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'Urban', CAST(N'2016-08-21 11:50:48.677' AS DateTime))
INSERT [dbo].[Residence] ([ResidenceId], [ResidenceCode], [ResidenceTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'Rural', CAST(N'2016-08-21 11:53:26.250' AS DateTime))
INSERT [dbo].[Residence] ([ResidenceId], [ResidenceCode], [ResidenceTitle], [CreatedDate]) VALUES (3, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 18:01:21.197' AS DateTime))
SET IDENTITY_INSERT [dbo].[Residence] OFF
SET IDENTITY_INSERT [dbo].[Sector] ON 

INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (1, CAST(1 AS Decimal(18, 0)), N'Agriculture, forestry and fishing', CAST(N'2016-08-21 11:18:14.210' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (2, CAST(2 AS Decimal(18, 0)), N'Mining and quarrying', CAST(N'2016-08-21 11:18:57.207' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (3, CAST(3 AS Decimal(18, 0)), N'Manufacturing', CAST(N'2016-08-21 11:19:54.850' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (4, CAST(4 AS Decimal(18, 0)), N'Electricity, gas, steam and air conditioning supply', CAST(N'2016-08-21 11:21:24.697' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (5, CAST(5 AS Decimal(18, 0)), N'Water supply, seherage, waste management and remediation activities', CAST(N'2016-08-21 11:23:25.713' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (6, CAST(6 AS Decimal(18, 0)), N'Construction', CAST(N'2016-08-21 11:24:00.470' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (7, CAST(7 AS Decimal(18, 0)), N'Wholesale and retail trade and repair of motor vehicles', CAST(N'2016-08-21 11:24:37.367' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (8, CAST(8 AS Decimal(18, 0)), N'Transport, storage and storage', CAST(N'2016-08-21 11:25:29.353' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (9, CAST(9 AS Decimal(18, 0)), N'Accommodation and food services activities', CAST(N'2016-08-21 11:25:57.983' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (10, CAST(10 AS Decimal(18, 0)), N'Professional, scientific and technical', CAST(N'2016-08-21 11:26:24.033' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (11, CAST(11 AS Decimal(18, 0)), N'Administrative and support services', CAST(N'2016-08-21 11:27:32.300' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (12, CAST(12 AS Decimal(18, 0)), N'Public administation and defence', CAST(N'2016-08-21 11:27:58.883' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (13, CAST(13 AS Decimal(18, 0)), N'Education', CAST(N'2016-08-21 11:28:23.420' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (14, CAST(14 AS Decimal(18, 0)), N'Human health and social work', CAST(N'2016-08-21 11:29:14.010' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (15, CAST(15 AS Decimal(18, 0)), N'Other service', CAST(N'2016-08-21 11:29:36.563' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (16, CAST(16 AS Decimal(18, 0)), N'Activities of households as employers', CAST(N'2016-08-21 11:30:01.963' AS DateTime))
INSERT [dbo].[Sector] ([SectorId], [SectorCode], [SectorTitle], [CreatedDate]) VALUES (17, CAST(-1 AS Decimal(18, 0)), N'None', CAST(N'2016-09-19 18:01:49.520' AS DateTime))
SET IDENTITY_INSERT [dbo].[Sector] OFF
SET IDENTITY_INSERT [dbo].[SurveyEffectiveYear] ON 

INSERT [dbo].[SurveyEffectiveYear] ([SurveyEffectiveYearId], [EffectiveYear], [CreatedDate]) VALUES (22, 2013, CAST(N'2016-08-21 05:00:01.543' AS DateTime))
SET IDENTITY_INSERT [dbo].[SurveyEffectiveYear] OFF
SET IDENTITY_INSERT [dbo].[SurveyUpload] ON 

INSERT [dbo].[SurveyUpload] ([SurveyUploadId], [SurveyType], [PackageStatus], [CreatedDate], [ModifiedDate]) VALUES (1, N'LabourForce', N'ERROR', CAST(N'2016-08-14 11:10:20.600' AS DateTime), CAST(N'2016-09-11 13:25:27.790' AS DateTime))
INSERT [dbo].[SurveyUpload] ([SurveyUploadId], [SurveyType], [PackageStatus], [CreatedDate], [ModifiedDate]) VALUES (2, N'LabourForce', N'COMPLETED', CAST(N'2016-08-14 11:10:20.600' AS DateTime), CAST(N'2016-09-19 16:06:42.443' AS DateTime))
SET IDENTITY_INSERT [dbo].[SurveyUpload] OFF
SET IDENTITY_INSERT [dbo].[SurveyYear] ON 

INSERT [dbo].[SurveyYear] ([SurveyYearId], [SurveyYear], [CreatedDate]) VALUES (1, 2012, CAST(N'2016-08-21 05:21:26.327' AS DateTime))
INSERT [dbo].[SurveyYear] ([SurveyYearId], [SurveyYear], [CreatedDate]) VALUES (2, 2013, CAST(N'2016-08-21 05:21:26.327' AS DateTime))
SET IDENTITY_INSERT [dbo].[SurveyYear] OFF
ALTER TABLE [dbo].[LabourForceSurvey] ADD  CONSTRAINT [DF_LabourForceSurvey_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LabourForceSurveyDump] ADD  CONSTRAINT [DF_LabourForceSurveyTemp_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LabourForceSurveyError] ADD  CONSTRAINT [DF_LabourForceSurveyError_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LabourForceSurveyTemp] ADD  CONSTRAINT [DF_LabourForceSurveyTemp_CreatedDate_1]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] ADD  CONSTRAINT [DF_LF_Indicator_PopulationEmployment_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[IndicatorColumnOption]  WITH CHECK ADD  CONSTRAINT [FK_IndicatorColumnOption_IndicatorMaster] FOREIGN KEY([IndicatorId])
REFERENCES [dbo].[IndicatorMaster] ([IndicatorMasterId])
GO
ALTER TABLE [dbo].[IndicatorColumnOption] CHECK CONSTRAINT [FK_IndicatorColumnOption_IndicatorMaster]
GO
ALTER TABLE [dbo].[IndicatorDataOption]  WITH CHECK ADD  CONSTRAINT [FK_IndicatorDataOption_IndicatorMaster] FOREIGN KEY([IndicatorId])
REFERENCES [dbo].[IndicatorMaster] ([IndicatorMasterId])
GO
ALTER TABLE [dbo].[IndicatorDataOption] CHECK CONSTRAINT [FK_IndicatorDataOption_IndicatorMaster]
GO
ALTER TABLE [dbo].[LabourForceSurveyError]  WITH NOCHECK ADD  CONSTRAINT [FK_LabourForceSurveyError_SurveyUpload] FOREIGN KEY([SurveyUploadId])
REFERENCES [dbo].[SurveyUpload] ([SurveyUploadId])
GO
ALTER TABLE [dbo].[LabourForceSurveyError] CHECK CONSTRAINT [FK_LabourForceSurveyError_SurveyUpload]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_AgeGroup] FOREIGN KEY([AgeGroupId])
REFERENCES [dbo].[AgeGroup] ([AgeGroupId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_AgeGroup]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Education] FOREIGN KEY([EducationId])
REFERENCES [dbo].[Education] ([EducationId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Education]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Gender] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Gender]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_IncomeGroup] FOREIGN KEY([IncomeGroupId])
REFERENCES [dbo].[IncomeGroup] ([IncomeGroupId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_IncomeGroup]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Occupation] FOREIGN KEY([OcupationId])
REFERENCES [dbo].[Occupation] ([OccupationId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Occupation]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Region1] FOREIGN KEY([RegionId])
REFERENCES [dbo].[Region] ([RegionId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Region1]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Residence] FOREIGN KEY([ResidenceId])
REFERENCES [dbo].[Residence] ([ResidenceId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Residence]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Sector1] FOREIGN KEY([SectorId])
REFERENCES [dbo].[Sector] ([SectorId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_Sector1]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_SurveyEffectiveYear] FOREIGN KEY([SurveyEffectiveYearId])
REFERENCES [dbo].[SurveyEffectiveYear] ([SurveyEffectiveYearId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_SurveyEffectiveYear]
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment]  WITH CHECK ADD  CONSTRAINT [FK_LF_Indicator_PopulationEmployment_SurveyYear] FOREIGN KEY([SurveyYearId])
REFERENCES [dbo].[SurveyYear] ([SurveyYearId])
GO
ALTER TABLE [dbo].[LF_Indicator_PopulationEmployment] CHECK CONSTRAINT [FK_LF_Indicator_PopulationEmployment_SurveyYear]
GO
