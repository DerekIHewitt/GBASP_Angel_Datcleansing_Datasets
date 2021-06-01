CREATE TABLE [Dataset].[Customer_Filter_Override]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Filter_Override_MIG_CREATED_DATE] DEFAULT (getdate()),
[MIG_COMMENT] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Filter_Override_MIG_COMMENT] DEFAULT (''),
[CUSTOMER_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[isAlwaysIncluded] [bit] NOT NULL,
[IsAlwaysExcluded] [bit] NOT NULL CONSTRAINT [DF_Customer_Filter_Override_IsAlwaysExcluded] DEFAULT ((0)),
[IsOnSubSetList] [bit] NOT NULL CONSTRAINT [DF_Customer_Filter_Override_IsOnSubSetList] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Filter_Override] ADD CONSTRAINT [PK_Customer_Filter_Override] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Filter_Override] ON [Dataset].[Customer_Filter_Override] ([MIG_SITE_NAME], [CUSTOMER_ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_Filter_Override', 'COLUMN', N'isAlwaysIncluded'
GO
