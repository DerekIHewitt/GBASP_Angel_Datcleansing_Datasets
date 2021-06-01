CREATE TABLE [DatasetSys].[Rule_Custom]
(
[ID] [int] NOT NULL IDENTITY(-1000, -1),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_Rule_Custom_IsActive] DEFAULT ((1)),
[SprocName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ID_Guid] [uniqueidentifier] NULL CONSTRAINT [DF_Rule_Custom_ID_Guid] DEFAULT (newid()),
[CustomRuleCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ID_MasterGroup] [int] NOT NULL,
[Detail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HowToFixDetails] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_Custom_HowToFixDetails] DEFAULT (''),
[ID_Owner] [int] NOT NULL,
[IsLatLongCheckInvalidator] [bit] NOT NULL CONSTRAINT [DF_Rule_Custom_IsLatLongCheckInvalidator] DEFAULT ((0)),
[Comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_Custom_Comment] DEFAULT (''),
[ID_Iteration_Deffect_Current] [int] NOT NULL CONSTRAINT [DF_Rule_Custom_ID_Iteration_Deffect_Current] DEFAULT ((0)),
[LastRun_Start] [datetime] NULL,
[LastRun_Finish] [datetime] NULL,
[Stamp] [timestamp] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DatasetSys].[Rule_Custom] ADD CONSTRAINT [PK_Rule_Custom] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom rule IDs are nagative numbers. This allows detected defects to sit in the same tables that ''global'' rules are stored in without clashes.', 'SCHEMA', N'DatasetSys', 'TABLE', N'Rule_Custom', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the ID used to transmit the rule and its defects to the defects dashboard', 'SCHEMA', N'DatasetSys', 'TABLE', N'Rule_Custom', 'COLUMN', N'ID_Guid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the sproc tu run. it will always be in schema [DatasetCustom] so leave that off. If will always take two paramter @MIG_SITE_NAME varchar(5) and @Iteration int.', 'SCHEMA', N'DatasetSys', 'TABLE', N'Rule_Custom', 'COLUMN', N'SprocName'
GO
