CREATE TABLE [Dataset].[Customer_Billing_Address_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSuspect] [bit] NOT NULL CONSTRAINT [DF_Customer_Billing_Address_ovl_IsSuspect] DEFAULT ((0)),
[SRC_ADDRESS1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ADDRESS2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COUNTY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COUNTRY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDRESS1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTRY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Billing_Address_ovl] ADD CONSTRAINT [PK_Customer__Billing_Address_ovl] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
