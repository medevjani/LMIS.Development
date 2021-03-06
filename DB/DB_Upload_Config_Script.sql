USE [LMIS]
GO
/****** Object:  Table [dbo].[PackageConfig]    Script Date: 9/7/2016 9:23:32 PM ******/
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
/****** Object:  Table [dbo].[SurveyUpload]    Script Date: 9/7/2016 9:23:32 PM ******/
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
SET IDENTITY_INSERT [dbo].[PackageConfig] ON 

INSERT [dbo].[PackageConfig] ([PackageConfigId], [ConfigKey], [ConfigValue], [SurveyType], [CreatedDate]) VALUES (1, N'SourceFilePath', N'C:\LMIS\development\LabourForceSurveyData - Copy.xlsx', N'LabourForce', NULL)
INSERT [dbo].[PackageConfig] ([PackageConfigId], [ConfigKey], [ConfigValue], [SurveyType], [CreatedDate]) VALUES (2, N'ErrorFilePath', N'C:\LMIS\development\LabourForceSurvey_Error.xlsx', N'LabourForce', NULL)
INSERT [dbo].[PackageConfig] ([PackageConfigId], [ConfigKey], [ConfigValue], [SurveyType], [CreatedDate]) VALUES (3, N'ErrorFileTemplatePath', N'C:\LMIS\development\LabourForceSurvey_Error_Template.xlsx', N'LabourForce', NULL)
SET IDENTITY_INSERT [dbo].[PackageConfig] OFF
SET IDENTITY_INSERT [dbo].[SurveyUpload] ON 

INSERT [dbo].[SurveyUpload] ([SurveyUploadId], [SurveyType], [PackageStatus], [CreatedDate], [ModifiedDate]) VALUES (1, N'LabourForce', N'ERROR', CAST(N'2016-08-14 11:10:20.600' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[SurveyUpload] OFF
