CREATE TABLE [Dataset].[Customer_Hierarchy_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Hierarchy_ex_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Hierarchy_ex_MIG_CREATED_DATE] DEFAULT (getdate()),
[HIERARCHY_ID] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HIERARCHY_DESC] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LEVEL_ID] [int] NOT NULL,
[LEVEL_NAME] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PARENT_CUST_ID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CHILD_CUST_ID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Hierarchy_ex] ADD CONSTRAINT [PK_Customer_Hierarchy_ex] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
