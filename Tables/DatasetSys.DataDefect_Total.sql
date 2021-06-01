CREATE TABLE [DatasetSys].[DataDefect_Total]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DataDefect_Total_MIG_SITE_NAME] DEFAULT (''),
[ID_Iteration] [int] NOT NULL,
[ID_Rule] [int] NOT NULL,
[ID_MasterGroup] [int] NOT NULL,
[Current_Total] [int] NOT NULL,
[Current_Filtered] [int] NOT NULL,
[ID_Iteration_ResultsUsed] [int] NOT NULL,
[ETL_LAST_LOAD_DATE] [datetime] NULL,
[ETL_DATADEFECT_TOTAL_TARGET_LAST_LOAD_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[DataDefect_Total] ADD CONSTRAINT [ETL_DATADEFECT_TOTAL_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
