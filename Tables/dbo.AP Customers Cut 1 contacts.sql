CREATE TABLE [dbo].[AP Customers Cut 1 contacts]
(
[MIG_SITE_NAME] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PERSON_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIDDLE_NAME] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TITLE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ROLE_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_PRIMARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_SECONDARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ADDRESS_PRIMARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
