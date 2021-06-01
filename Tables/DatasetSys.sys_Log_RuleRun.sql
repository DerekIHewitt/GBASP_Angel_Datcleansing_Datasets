CREATE TABLE [DatasetSys].[sys_Log_RuleRun]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailAddress] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateStartedRuleRun] [datetime] NULL,
[DateFinishedRuleRun] [datetime] NULL,
[DateDefectsPushedToDashboard] [datetime] NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sys.Log_RuleRun_Comment] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sys_Log_RuleRun] ADD CONSTRAINT [PK_sys.Log_RuleRun] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
