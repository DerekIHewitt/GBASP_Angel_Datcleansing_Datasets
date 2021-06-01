CREATE TABLE [DatasetSys].[DataDefect]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DataDefect_MIG_SITE_NAME] DEFAULT (''),
[ID_Iteration] [int] NOT NULL,
[ID_Rule] [int] NOT NULL,
[CreatedDate] [date] NOT NULL CONSTRAINT [DF_DataDefect_CreatedDate] DEFAULT (getdate()),
[SourceReferences] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BadValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalInfo] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DataDefect_AdditionalInfo] DEFAULT (''),
[IsSubSet] [bit] NULL,
[ETL_DATADEFECT_LAST_LOAD_DATE] [datetime] NULL,
[ETL_DATADEFECT_TARGET_LAST_LOAD_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[DataDefect] ADD CONSTRAINT [ETL_DataDefect_PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
