CREATE TABLE [DatasetSys].[FilterMode]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Scope] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentMode] [int] NOT NULL,
[CurrentModeDescription] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_FilterMode_CurrentModeDescription] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[FilterMode] ADD CONSTRAINT [PK_FilterMode] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FilterMode] ON [DatasetSys].[FilterMode] ([MIG_SITE_NAME], [DataType]) ON [PRIMARY]
GO
