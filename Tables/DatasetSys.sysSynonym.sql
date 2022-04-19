CREATE TABLE [DatasetSys].[sysSynonym]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DB_Num_ID] [int] NOT NULL CONSTRAINT [DF_sysSynonyms_DB_Num] DEFAULT ((1)),
[SynonymSchema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_SynonymSchema] DEFAULT ('dbo'),
[SynonymName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonyms_TableNameOverride] DEFAULT (''),
[TargetObjectSchema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_SchemaNmae] DEFAULT ('dbo'),
[TargetObjectName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AcquisitionTargetObjectSchema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_AcquisitionTargetObjectSchema] DEFAULT (''),
[AcquisitionTargetObjectName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_AcquisitionTargetObjectName] DEFAULT (''),
[FlagActive] [bit] NOT NULL CONSTRAINT [DF_sysSynonyms_FlagActive] DEFAULT ((1)),
[Comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonyms_Comment] DEFAULT (''),
[Upgrage2020Done] [bit] NOT NULL CONSTRAINT [DF_sysSynonym_Upgrage2020Done] DEFAULT ((0)),
[Remember_Stagging_Schema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_Remember_Stagging_Schema] DEFAULT (''),
[Remember_Stagging_Object] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_Remember_Stagging_Object] DEFAULT (''),
[Remember_DbLink_Schema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_Remember_DbLink_Schema] DEFAULT (''),
[Remember_DbLink_Object] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_Remember_DbLink_Object] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysSynonym] ADD CONSTRAINT [PK_sysSynonyms] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target object for Acquisition functions (Leave blank if the same as migration)', 'SCHEMA', N'DatasetSys', 'TABLE', N'sysSynonym', 'COLUMN', N'AcquisitionTargetObjectName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target object to link to for Acquisition functions (leave blank if the same as Migration)', 'SCHEMA', N'DatasetSys', 'TABLE', N'sysSynonym', 'COLUMN', N'AcquisitionTargetObjectSchema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target object to link to for MIGRATION Etl functions.', 'SCHEMA', N'DatasetSys', 'TABLE', N'sysSynonym', 'COLUMN', N'TargetObjectName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target object to link to for MIGRATION Etl functions', 'SCHEMA', N'DatasetSys', 'TABLE', N'sysSynonym', 'COLUMN', N'TargetObjectSchema'
GO
