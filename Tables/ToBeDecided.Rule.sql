CREATE TABLE [ToBeDecided].[Rule]
(
[ID] [int] NOT NULL,
[ID_MasterGroup] [int] NOT NULL,
[RuleCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MetaMethod] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RuleProfile] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Detail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDedicatedRuleStatic] [bit] NOT NULL,
[IsDedicatedRuleDynamic] [bit] NOT NULL,
[IsMetaRuleStatic] [bit] NOT NULL,
[IsMetaRuleDynamic] [bit] NOT NULL,
[IsDesignUnknown] [bit] NOT NULL,
[IsBusinessRule] [bit] NOT NULL,
[IsIfsSystemRule] [bit] NOT NULL,
[Comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ID_Owner] [int] NOT NULL,
[ImpactOnProject] [int] NOT NULL,
[CountBaseLine] [int] NOT NULL,
[CountLastRun] [int] NOT NULL,
[CountFilterBaseLine] [int] NOT NULL,
[CountFilterLastRun] [int] NOT NULL,
[ID_Iteration_Defect_Current] [int] NOT NULL,
[IsDraftRule] [bit] NOT NULL,
[IsToCurrentVersion] [bit] NOT NULL,
[DesignersRuleRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DesignersRuleVersion] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastRun_Start] [datetime] NULL,
[LastRun_Finish] [datetime] NULL,
[Stamp] [timestamp] NOT NULL,
[ETL_CREATED_DATE_TIME] [datetime] NULL,
[ETL_Rule_LAST_LOAD_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [ToBeDecided].[Rule] ADD CONSTRAINT [ETL_RULE_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
