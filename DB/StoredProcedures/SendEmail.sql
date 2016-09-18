SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Devjani
-- Create date: 13th August 2016
-- Description:	Send email based on survey type and event
-- EXEC dbo.SendEmail @SurveyType='LabourForce', @EventType = 'PackageStart'
-- =============================================
CREATE PROCEDURE dbo.SendEmail 
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
