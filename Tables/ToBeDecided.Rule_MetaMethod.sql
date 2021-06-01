CREATE TABLE [ToBeDecided].[Rule_MetaMethod]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MetaMethod] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_MetaMethod_MetaMethod] DEFAULT ('{Missing}'),
[RuleProfileTemplate] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_MetaMethod_ParamA] DEFAULT (''),
[TestProfile] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MethodStart] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_MetaMethod_MethodStart] DEFAULT (''),
[MethodEnd] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_MetaMethod_MethodEnd] DEFAULT (''),
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_MetaMethod_Comment] DEFAULT (''),
[Stamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ToBeDecided].[Rule_MetaMethod] ADD CONSTRAINT [PK_Rule_MetaMethod] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Rule_MetaMethod_Method] ON [ToBeDecided].[Rule_MetaMethod] ([MetaMethod]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the second part of the test AFTER the %FIELD has been appended to [MethodStart]', 'SCHEMA', N'ToBeDecided', 'TABLE', N'Rule_MetaMethod', 'COLUMN', N'MethodEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the first part of the test before appending the %FIELD% to it', 'SCHEMA', N'ToBeDecided', 'TABLE', N'Rule_MetaMethod', 'COLUMN', N'MethodStart'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This section is added to the top of the scriot ro declare and set variables.', 'SCHEMA', N'ToBeDecided', 'TABLE', N'Rule_MetaMethod', 'COLUMN', N'TestProfile'
GO
