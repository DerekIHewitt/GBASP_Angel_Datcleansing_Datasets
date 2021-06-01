CREATE TABLE [DatasetSys].[sysIteration]
(
[ID] [int] NOT NULL,
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysIteration_MIG_SITE_NAME] DEFAULT (''),
[Version_DB] [int] NOT NULL,
[Version_Report] [int] NOT NULL,
[Version_Defect] [int] NOT NULL,
[IterationDate] [date] NOT NULL,
[Comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsHasRun] [bit] NULL,
[ETL_CREATED_DATE_TIME] [datetime] NULL,
[ETL_sysIteration_LAST_LOAD_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysIteration] ADD CONSTRAINT [ETL_sysIteration_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
