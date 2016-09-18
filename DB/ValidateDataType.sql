SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 8th August 2016
-- Description:	Validate the datatype of the columns of Labour Force Survey data
-- ValidateDataType 'dbo.LabourForceSurveyTemp'
-- =============================================
ALTER PROCEDURE ValidateDataType 
	@TableName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @name VARCHAR(50) -- column name
	DECLARE @query VARCHAR(MAX) -- dynamic query for all columm
	BEGIN TRY
		DECLARE db_cursor CURSOR FOR  
		SELECT name 
		FROM sys.columns 
		WHERE object_id = OBJECT_ID(@TableName) 
		AND name not in('Id','CreatedDate')
	
		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @name   

		WHILE @@FETCH_STATUS = 0   
		BEGIN   
			   SELECT COUNT(@name) from dbo.LabourForceSurveyTemp

			   FETCH NEXT FROM db_cursor INTO @name   
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
	END
GO
