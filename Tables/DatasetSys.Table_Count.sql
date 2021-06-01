CREATE TABLE [DatasetSys].[Table_Count]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IterationNumber] [int] NOT NULL,
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[Table_Count] ADD CONSTRAINT [PK_Table_Count] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Table_Count] ON [DatasetSys].[Table_Count] ([MIG_SITE_NAME], [IterationNumber], [TableName]) ON [PRIMARY]
GO
