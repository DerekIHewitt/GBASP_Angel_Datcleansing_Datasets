CREATE TABLE [DatasetSys].[LOV_Batch]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_Status] DEFAULT ('New batch'),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_LOV_Batch_CreatedDate] DEFAULT (getdate()),
[FinishExcelIn] [datetime] NULL,
[StartProcessing] [datetime] NULL,
[FinishProcessing] [datetime] NULL,
[ExcelRequestResults] [datetime] NULL,
[Comment] [varchar] (511) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_Comment] DEFAULT (''),
[EmailFromExcel] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_EmailFromExcel] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[LOV_Batch] ADD CONSTRAINT [PK_LOV_Batch] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
