CREATE TABLE [DatasetSys].[sysVersion]
(
[ID] [int] NOT NULL,
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysVersion_MIG_SITE_NAME] DEFAULT (''),
[VersionLevel] [int] NOT NULL CONSTRAINT [DF_sysVersion_VersionLevel] DEFAULT ((0)),
[Version] [int] NOT NULL CONSTRAINT [DF_sysVersion_Version] DEFAULT ((0)),
[Comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysVersion_Comment] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysVersion] ADD CONSTRAINT [PK_sysVersion] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
