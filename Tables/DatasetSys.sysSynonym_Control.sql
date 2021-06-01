CREATE TABLE [DatasetSys].[sysSynonym_Control]
(
[DB_Num_ID] [int] NOT NULL,
[DbName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentlyLinkedTo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysSynonym_DbIndex_RemTimeStmp] DEFAULT ('unlinked'),
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[sysSynonym_Control] ADD CONSTRAINT [PK_sysSynonym_DbIndex] PRIMARY KEY CLUSTERED  ([DB_Num_ID]) ON [PRIMARY]
GO
