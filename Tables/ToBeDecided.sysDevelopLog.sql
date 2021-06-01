CREATE TABLE [ToBeDecided].[sysDevelopLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysDevelopLog_CreatedBy] DEFAULT ('DIH'),
[CreatedDate] [date] NOT NULL CONSTRAINT [DF_Table_1_CreatedDAte] DEFAULT (getdate()),
[PercentageDone] [int] NOT NULL CONSTRAINT [DF_sysDevelopLog_PercentageDone] DEFAULT ((100)),
[DetailShort] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysDevelopLog_DetailShort] DEFAULT (''),
[DetailLong] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysDevelopLog_DetailLong] DEFAULT (''),
[DeveloperNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_sysDevelopLog_DeveloperNotes] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [ToBeDecided].[sysDevelopLog] ADD CONSTRAINT [PK_sysDevelopLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Initils of person creating', 'SCHEMA', N'ToBeDecided', 'TABLE', N'sysDevelopLog', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date record created.', 'SCHEMA', N'ToBeDecided', 'TABLE', N'sysDevelopLog', 'COLUMN', N'CreatedDate'
GO
