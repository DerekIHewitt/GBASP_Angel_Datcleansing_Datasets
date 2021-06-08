CREATE TABLE [DatasetSys].[LOV_Batch_Working]
(
[ID] [int] NOT NULL,
[ID_Batch] [int] NULL,
[Status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_Working_Status] DEFAULT ('Dataset:New'),
[DataType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataField] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LegacyValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsNew] [bit] NOT NULL CONSTRAINT [DF_LOV_Batch_Working_IsNew] DEFAULT ((0)),
[RemValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_Working_RemValue] DEFAULT (''),
[ExValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DsValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_Working_DsValue] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[LOV_Batch_Working] ADD CONSTRAINT [PK_LOV_Batch_Working] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
