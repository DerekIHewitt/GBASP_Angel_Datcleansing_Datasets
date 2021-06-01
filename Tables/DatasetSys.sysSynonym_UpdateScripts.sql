CREATE TABLE [DatasetSys].[sysSynonym_UpdateScripts]
(
[ID] [int] NOT NULL,
[DB_NUM] [int] NOT NULL,
[RelativeOrder] [int] NOT NULL,
[IsPreScript] [bit] NOT NULL CONSTRAINT [DF_sysSynonymn_UpdateScripts_IsPreScript] DEFAULT ((0)),
[IsPostscript] [bit] NOT NULL CONSTRAINT [DF_sysSynonymn_UpdateScripts_IsPostscript] DEFAULT ((0)),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_sysSynonymn_UpdateScripts_IsAvtive] DEFAULT ((1)),
[Detail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonymn_UpdateScripts_Detail] DEFAULT (''),
[ScriptText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonymn_UpdateScripts_ScriptText] DEFAULT ('{TODO}'),
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonymn_UpdateScripts_Comment] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysSynonym_UpdateScripts] ADD CONSTRAINT [PK_sysSynonymn_UpdateScripts] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
