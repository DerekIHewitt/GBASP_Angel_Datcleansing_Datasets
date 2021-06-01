CREATE TABLE [Dataset].[SerialObject_Filter_Override]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED] [datetime] NOT NULL CONSTRAINT [DF_SerialObject_Filter_Override_MIG_CREATED] DEFAULT (getdate()),
[MIG_COMMENT] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SerialObject_Filter_Override_MIG_COMMENT] DEFAULT (''),
[MCH_CODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsAlwaysIncluded] [bit] NOT NULL CONSTRAINT [DF_SerialObject_Filter_Override_IsAlwaysIncluded] DEFAULT ((0)),
[IsAlwaysExcluded] [bit] NOT NULL CONSTRAINT [DF_SerialObject_Filter_Override_IsAlwaysExcluded] DEFAULT ((0)),
[IsOnSubsetList] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[SerialObject_Filter_Override] ADD CONSTRAINT [PK_SerialObject_Filter_Override] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SerialObject_Filter_Override] ON [Dataset].[SerialObject_Filter_Override] ([MIG_SITE_NAME], [MCH_CODE]) ON [PRIMARY]
GO
