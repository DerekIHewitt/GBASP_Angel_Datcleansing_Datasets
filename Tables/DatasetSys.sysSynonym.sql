CREATE TABLE [DatasetSys].[sysSynonym]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DB_Num_ID] [int] NOT NULL CONSTRAINT [DF_sysSynonyms_DB_Num] DEFAULT ((1)),
[SynonymSchema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_SynonymSchema] DEFAULT ('dbo'),
[SynonymName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonyms_TableNameOverride] DEFAULT (''),
[TargetObjectSchema] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_SchemaNmae] DEFAULT ('dbo'),
[TargetObjectName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
