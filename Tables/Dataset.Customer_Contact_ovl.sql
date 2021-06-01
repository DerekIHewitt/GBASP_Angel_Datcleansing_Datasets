CREATE TABLE [Dataset].[Customer_Contact_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSuspect] [bit] NOT NULL CONSTRAINT [DF_Customer_Contact_ovl_IsSuspect] DEFAULT ((0)),
[SRC_FIRST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_MIDDLE_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_LAST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_PERSON_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_TITLE] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ROLE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CUSTOMER_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CUSTOMER_SECONDARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CUSTOMER_ADDRESS_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CUSTOMER_ADDRESS_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDDLE_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PERSON_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TITLE] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ROLE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_SECONDARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_ADDRESS_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_ADDRESS_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Contact_ovl] ADD CONSTRAINT [PK_Customer_Contact_ovl] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_Contact_ovl] ON [Dataset].[Customer_Contact_ovl] ([MIG_SITE_NAME], [CUSTOMER_ID], [ID]) ON [PRIMARY]
GO
