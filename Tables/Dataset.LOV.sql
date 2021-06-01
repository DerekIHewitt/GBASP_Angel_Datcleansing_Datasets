CREATE TABLE [Dataset].[LOV]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_LOV_Text_MIG_SITE_NAME] DEFAULT (''),
[LOV_DataType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_LOV_Text_LOV_DataType] DEFAULT (''),
[LOV_DataField] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOV_LegacyValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOV_IfsValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rule_LOV_Text_LOV_IfsValue] DEFAULT (''),
[Comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[isRecycleArchive] [bit] NOT NULL CONSTRAINT [DF_LOV_isRecycleArchive] DEFAULT ((0)),
[IsAcquisitionField] [bit] NOT NULL CONSTRAINT [DF_LOV_IsAcquisitionField] DEFAULT ((0)),
[IsMigrationField] [bit] NOT NULL CONSTRAINT [DF_LOV_IsMigrationField] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[LOV] ADD CONSTRAINT [PK_Rule_LOV_Text] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Rule_LOV_Text_Code] ON [Dataset].[LOV] ([MIG_SITE_NAME], [LOV_DataType], [LOV_DataField], [LOV_LegacyValue]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not too sure what this field was initialy for. However, I am now defining it to be part of the Toolkit update procedure, whereby all existing fields have this field set to true (archived), if the new load has the same values it gets reset back to false, any new entrys or entrys with different values get new records. This way a record is kept of previouse values.', 'SCHEMA', N'Dataset', 'TABLE', N'LOV', 'COLUMN', N'isRecycleArchive'
GO
