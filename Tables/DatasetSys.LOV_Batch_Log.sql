CREATE TABLE [DatasetSys].[LOV_Batch_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ID_Batch] [int] NULL,
[LogEntry] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_LOV_Batch_Log_LogEntry] DEFAULT ('Pointless log entry....')
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[LOV_Batch_Log] ADD CONSTRAINT [PK_LOV_Batch_Log] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
