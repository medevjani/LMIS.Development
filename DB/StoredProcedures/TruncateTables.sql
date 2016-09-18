SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 8th August 2016
-- Description:	Truncate dump, temp and error tables
-- =============================================
CREATE PROCEDURE TruncateTables 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		-- Truncate dump table
		TRUNCATE TABLE [dbo].[LabourForceSurveyDump]

		-- Truncate temp table
		TRUNCATE TABLE [dbo].[LabourForceSurveyTemp]

		-- Truncate error table
		TRUNCATE TABLE [dbo].[LabourForceSurveyError]
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO
