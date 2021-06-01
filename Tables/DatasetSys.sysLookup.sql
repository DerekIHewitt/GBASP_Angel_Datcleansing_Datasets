CREATE TABLE [DatasetSys].[sysLookup]
(
[ID] [int] NOT NULL,
[ID_Group] [int] NOT NULL,
[ID_Group_Offset] [int] NOT NULL,
[IsCommentEntry] [bit] NOT NULL CONSTRAINT [DF_sysLookup_IsCommentEntry] DEFAULT ((0)),
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysLookup_Code] DEFAULT ('to do'),
[FlagA] [bit] NOT NULL CONSTRAINT [DF_sysLookup_FlagA] DEFAULT ((0)),
[FlagB] [bit] NOT NULL CONSTRAINT [DF_sysLookup_FlagB] DEFAULT ((0)),
[FlagC] [bit] NOT NULL CONSTRAINT [DF_sysLookup_FlagC] DEFAULT ((1)),
[IntA] [int] NOT NULL CONSTRAINT [DF_sysLookup_IntA] DEFAULT ((0)),
[IntB] [int] NOT NULL CONSTRAINT [DF_sysLookup_IntB] DEFAULT ((0)),
[IntC] [int] NOT NULL CONSTRAINT [DF_sysLookup_IntC] DEFAULT ((0)),
[TxtA] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysLookup_TxtA] DEFAULT (''),
[TxtB] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysLookup_TxtB] DEFAULT (''),
[TxtC] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysLookup_TxtC] DEFAULT (''),
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysLookup_Description] DEFAULT (''),
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysLookup_Comment] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysLookup] ADD CONSTRAINT [PK_sysLookup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_sysLookup_Group] ON [DatasetSys].[sysLookup] ([ID_Group_Offset]) ON [PRIMARY]
GO
