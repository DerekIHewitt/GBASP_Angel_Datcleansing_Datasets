CREATE TABLE [DatasetSys].[Rule_PartB]
(
[ID] [int] NOT NULL,
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Rule_Part2_MIG_SITE_NAME] DEFAULT ('GBASP'),
[HowToFixDetails] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_PartB_HowToFixDetails] DEFAULT (''),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_Rule_PartB_IsActive] DEFAULT ((1)),
[IsSecure] [bit] NOT NULL CONSTRAINT [DF_Rule_PartB_IsSecure] DEFAULT ((0)),
[CountBaseLine] [int] NOT NULL,
[CountLastRun] [int] NOT NULL,
[CountFilterBaseLine] [int] NOT NULL,
[CountFilterLastRun] [int] NOT NULL,
[ID_Iteration_Defect_Current] [int] NOT NULL,
[LastRun_Start] [datetime] NULL,
[LastRun_Finish] [datetime] NULL,
[Stamp] [timestamp] NOT NULL,
[ETL_CREATED_DATE_TIME] [datetime] NULL,
[ETL_Rule_LAST_LOAD_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[Rule_PartB] ADD CONSTRAINT [ETL_RULE_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The default GBASP is temp untill MIG striping is added to all rules.', 'SCHEMA', N'DatasetSys', 'TABLE', N'Rule_PartB', 'COLUMN', N'MIG_SITE_NAME'
GO
