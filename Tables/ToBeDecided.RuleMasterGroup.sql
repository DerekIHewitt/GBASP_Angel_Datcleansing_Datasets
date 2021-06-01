CREATE TABLE [ToBeDecided].[RuleMasterGroup]
(
[ID] [int] NOT NULL,
[RuleMasterCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TestType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FaultCausedBy] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequiredAction] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_CREATED_DATE_TIME] [datetime] NULL,
[ETL_RuleMasterGroup_LAST_LOAD_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [ToBeDecided].[RuleMasterGroup] ADD CONSTRAINT [ETL_RuleMasterGroup_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
