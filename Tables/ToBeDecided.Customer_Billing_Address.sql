CREATE TABLE [ToBeDecided].[Customer_Billing_Address]
(
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [varchar] (15) COLLATE Latin1_General_CI_AS NULL,
[BILL_ADDRESS] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
