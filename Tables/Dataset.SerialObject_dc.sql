CREATE TABLE [Dataset].[SerialObject_dc]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SerialObject_dc_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_SerialObject_dc_MIG_CREATED_DATE] DEFAULT (getdate()),
[MCH_CODE] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MCH_NAME] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PART_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SERIAL_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INSTALLATION_DATE] [date] NOT NULL CONSTRAINT [DF_SerialObject_dc_INSTALLATION_DATE] DEFAULT ('1899-12-30'),
[OWNERSHIP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOCATION1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LOCATION2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OWNER] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SerialObject_dc_OWNER] DEFAULT (''),
[NX_LATITUDE] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_LONGITUDE] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_OPERATIONAL_STATUS] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_HAS_PEDAL] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[SerialObject_dc] ADD CONSTRAINT [PK_SerialObject_dc] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SerialObject_dc] ON [Dataset].[SerialObject_dc] ([MIG_SITE_NAME], [CUSTOMER_ID], [ID]) ON [PRIMARY]
GO
