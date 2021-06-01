CREATE TABLE [ToBeDecided].[NxTrans_DataDefect]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_NxTrans_DataDefect_MIG_SITE_NAME] DEFAULT (''),
[ID_Iteration] [int] NOT NULL,
[ID_Rule] [int] NOT NULL,
[SourceReferences] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BadValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalInfo] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ToBeDecided].[NxTrans_DataDefect] ADD CONSTRAINT [ETL_NxTrans_DataDefect_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_NxTrans_DataDefect] ON [ToBeDecided].[NxTrans_DataDefect] ([MIG_SITE_NAME], [ID_Iteration], [ID]) ON [PRIMARY]
GO
