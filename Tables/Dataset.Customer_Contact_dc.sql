CREATE TABLE [Dataset].[Customer_Contact_dc]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Contact_dc_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Contact_dc_MIG_CREATED_DATE] DEFAULT (getdate()),
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIDDLE_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LAST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_PERSON_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_PERSON_ID] DEFAULT (''),
[NX_TITLE] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_TITLE] DEFAULT (''),
[NX_ROLE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_ROLE_DB] DEFAULT (''),
[NX_CUSTOMER_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_CUSTOMER_PRIMARY] DEFAULT (''),
[NX_CUSTOMER_SECONDARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_CUSTOMER_SECONDARY] DEFAULT (''),
[NX_CUSTOMER_ADDRESS_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_CUSTOMER_ADDRESS_ID] DEFAULT (''),
[NX_CUSTOMER_ADDRESS_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Contact_dc_NX_CUSTOMER_ADDRESS_PRIMARY] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Contact_dc] ADD CONSTRAINT [PK_Customer_Contact_dc] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_Contact_dc] ON [Dataset].[Customer_Contact_dc] ([MIG_SITE_NAME], [CUSTOMER_ID], [ID]) ON [PRIMARY]
GO
