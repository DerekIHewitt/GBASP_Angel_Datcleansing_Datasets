CREATE TABLE [DatasetMasterOnly].[Doc_Schema]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SchemaName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsEndUserAccesable] [bit] NOT NULL CONSTRAINT [DF_Doc_Schema_IsEndUserAccesable] DEFAULT ((1)),
[IsNexusTeamOnly] [bit] NOT NULL CONSTRAINT [DF_Doc_Schema_IsNexusTeamOnly] DEFAULT ((0)),
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Doc_Schema_Comment] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetMasterOnly].[Doc_Schema] ADD CONSTRAINT [PK_Doc_Schema] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
