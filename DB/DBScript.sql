USE [master]
GO
/****** Object:  Database [LMIS]    Script Date: 8/7/2016 7:58:58 AM ******/
CREATE DATABASE [LMIS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LMIS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\LMIS.mdf' , SIZE = 1271808KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'LMIS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\LMIS_log.ldf' , SIZE = 427392KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [LMIS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LMIS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LMIS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LMIS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LMIS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LMIS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LMIS] SET ARITHABORT OFF 
GO
ALTER DATABASE [LMIS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LMIS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [LMIS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LMIS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LMIS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LMIS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LMIS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LMIS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LMIS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LMIS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LMIS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LMIS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LMIS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LMIS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LMIS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LMIS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LMIS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LMIS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LMIS] SET RECOVERY FULL 
GO
ALTER DATABASE [LMIS] SET  MULTI_USER 
GO
ALTER DATABASE [LMIS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LMIS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LMIS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LMIS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [LMIS]
GO
/****** Object:  User [AD2012\SPAdmin]    Script Date: 8/7/2016 7:58:58 AM ******/
CREATE USER [AD2012\SPAdmin] FOR LOGIN [AD2012\SPAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [AD2012\Administrator]    Script Date: 8/7/2016 7:58:58 AM ******/
CREATE USER [AD2012\Administrator] FOR LOGIN [AD2012\Administrator] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [AD2012\SPAdmin]
GO
ALTER ROLE [db_owner] ADD MEMBER [AD2012\Administrator]
GO
/****** Object:  StoredProcedure [dbo].[ThrowError]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 8th August 2016
-- Description:	Throw custom error
-- =============================================
CREATE PROCEDURE [dbo].[ThrowError] 
	-- Add the parameters for the stored procedure here
	@ErrorNumber int, 
	@ErrorMsg VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	THROW @ErrorNumber, @ErrorMsg, 1
END

GO
/****** Object:  StoredProcedure [dbo].[TruncateTables]    Script Date: 8/7/2016 7:58:59 AM ******/
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
/****** Object:  StoredProcedure [dbo].[ValidateDataType]    Script Date: 8/7/2016 7:58:59 AM ******/
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
		EXEC dbo.ThrowError 50001,'Data is not valid. Please refer error table for erronous data.';
	END

END

GO
/****** Object:  StoredProcedure [dbo].[ValidateYear]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 7th August 2016
-- Description:	Validate Year of Survey data to avoid duplicate
-- =============================================
CREATE PROCEDURE [dbo].[ValidateYear] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS(SELECT * FROM [dbo].[LabourForceSurveyTemp]
				WHERE HH_Y IN(SELECT HH_Y 
				FROM [dbo].[LabourForceSurvey]))
	BEGIN
		EXEC dbo.ThrowError 50002,'Data Already exists for specific year. Please upload fresh data!!';
	END
END

GO
/****** Object:  Table [dbo].[AgeGroup]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AgeGroup](
	[AgeGroupId] [bigint] NOT NULL,
	[AgeGroupCode] [varchar](10) NULL,
	[AgeGroupTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_AgeGroup] PRIMARY KEY CLUSTERED 
(
	[AgeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LabourForceSurvey]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourForceSurvey](
	[LabourForceSurveyId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
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
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_LabourForceSurvey] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LabourForceSurveyDump]    Script Date: 8/7/2016 7:58:59 AM ******/
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
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_LabourForceSurveyTemp_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_LabelForceSurvey] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LabourForceSurveyError]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 CONSTRAINT [PK_LabourForceSurveError] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LabourForceSurveyTemp]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourForceSurveyTemp](
	[LabourForceSurveyId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
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
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_LabourForceSurveyValid] PRIMARY KEY CLUSTERED 
(
	[LabourForceSurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Occupation]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Occupation](
	[OccupationId] [bigint] IDENTITY(1,1) NOT NULL,
	[OccupationCode] [varchar](10) NULL,
	[OccupationTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Occupation] PRIMARY KEY CLUSTERED 
(
	[OccupationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PackageLog]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PackageLog](
	[PackageLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[PackageId] [varchar](100) NULL,
	[PackageName] [varchar](100) NULL,
	[TaskName] [varchar](100) NULL,
	[Message] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PackageLog] PRIMARY KEY CLUSTERED 
(
	[PackageLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ParticipationRate]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ParticipationRate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Region] [varchar](50) NULL,
	[District] [varchar](50) NULL,
	[IncomeGroup] [varchar](10) NULL,
	[Year] [int] NULL,
	[Sex] [varchar](20) NULL,
	[AgeGroup] [varchar](10) NULL,
	[ParticipationRate] [float] NULL,
 CONSTRAINT [PK_ParticipationRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Population]    Script Date: 8/7/2016 7:58:59 AM ******/
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
/****** Object:  Table [dbo].[Region]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Region](
	[RegionId] [int] IDENTITY(1,1) NOT NULL,
	[RegionCode] [varchar](10) NULL,
	[RegionTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Residence]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Residence](
	[ResidenceId] [bigint] NOT NULL,
	[ResidenceCode] [varchar](50) NULL,
	[ResidenceTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_District] PRIMARY KEY CLUSTERED 
(
	[ResidenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sector]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sector](
	[SectorId] [bigint] IDENTITY(1,1) NOT NULL,
	[SectorCode] [varchar](10) NULL,
	[SectorTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Sector] PRIMARY KEY CLUSTERED 
(
	[SectorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sex]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sex](
	[SexId] [bigint] IDENTITY(1,1) NOT NULL,
	[SexCode] [varchar](10) NULL,
	[SexTitle] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Sex] PRIMARY KEY CLUSTERED 
(
	[SexId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TestDestination]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestDestination](
	[Data] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TestDestinationError]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TestDestinationError](
	[Data] [varchar](50) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TestSource]    Script Date: 8/7/2016 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TestSource](
	[Data] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AgeGroup] ADD  CONSTRAINT [DF_AgeGroup_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LabourForceSurvey] ADD  CONSTRAINT [DF_LabourForceSurvey_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Occupation] ADD  CONSTRAINT [DF_Occupation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PackageLog] ADD  CONSTRAINT [DF_PackageLog_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Region] ADD  CONSTRAINT [DF_Region_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Residence] ADD  CONSTRAINT [DF_Residence_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Sector] ADD  CONSTRAINT [DF_Sector_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Sex] ADD  CONSTRAINT [DF_Sex_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
USE [master]
GO
ALTER DATABASE [LMIS] SET  READ_WRITE 
GO
