CREATE TABLE [DatasetSys].[sysMigCodes]
(
[PK] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BaseCountry_MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysMigCodes_BaseCountry_MIG_SITE_NAME] DEFAULT (''),
[LoadSecurityCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SynchSecurityCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DashboardSecurityCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_sysMigCodes_CreatedDate] DEFAULT (getdate()),
[DataDetails] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Table_1_Data details] DEFAULT (''),
[isActive] [bit] NOT NULL CONSTRAINT [DF_sysMigCodes_isActive] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysMigCodes] ADD CONSTRAINT [PK_sysMigCodes] PRIMARY KEY CLUSTERED  ([PK]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is a value that any external routine will nead to know to load alter data', 'SCHEMA', N'DatasetSys', 'TABLE', N'sysMigCodes', NULL, NULL
GO
