CREATE TABLE [DatasetSys].[DataDefect_Total_Audit]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DataDefect_Total_Audit_MIG_SITE_NAME] DEFAULT (''),
[Rule_Table_Rule_Code] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rule_Table_Detail] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rule_Table_Table_Name] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rule_Table_Field_Name] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID_Rule] [int] NULL,
[This_Run_ID_Iteration] [int] NULL,
[This_Run_Total] [int] NULL,
[Previous_ID_Iteration] [int] NULL,
[Previous_Run_Total] [int] NULL,
[Rule_Trend_Change] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rule_Difference] [int] NULL,
[ETL_NOTES] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CONTROL_ITERATION_ID] [int] NULL,
[ETL_SOURCE_ID] [int] NULL,
[ETL_LOAD_STEP_ID] [int] NULL,
[ETL_DATE_TIME_CREATED] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[DataDefect_Total_Audit] ADD CONSTRAINT [PK_Data_Defect_Total_Audit] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
