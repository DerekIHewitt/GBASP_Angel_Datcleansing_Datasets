CREATE TABLE [Dataset].[Customer_Billing_Address_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Billing_Address_ex_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Billing_Address_ex_MIG_CREATED_DATE] DEFAULT (getdate()),
[CUSTOMER_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDRESS1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDRESS2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Billing_Address_ex_ADDRESS2] DEFAULT (''),
[CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COUNTY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Billing_Address_ex_COUNTY] DEFAULT (''),
[COUNTRY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Billing_Address_ex] ADD CONSTRAINT [PK_Customer__Billing_Address_ex] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
