CREATE TABLE [Dataset].[Customer_Address_dc]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Address_dc_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Address_dc_MIG_CREATED_DATE] DEFAULT (getdate()),
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDRESS1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDRESS2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CITY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COUNTY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VAT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SPECIAL_INS] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WORK_ORDER_NOTES] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_DELIVERY_COUNTRY_DB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_SUPPLY_COUNTRY_DB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_LONGITUDE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_LATITUDE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DELIVERY_TERMS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_SHIP_VIA_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_IN_CITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_TAX_WITHHOLDING_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_TAX_ROUNDING_METHOD_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_TAX_ROUNDING_LEVEL_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_TAX_EXEMPT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_INTRASTAT_EXEMPT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_OPENING_AM] [smalldatetime] NULL,
[NX_CLOSING_AM] [smalldatetime] NULL,
[NX_OPENING_PM] [smalldatetime] NULL,
[NX_CLOSING_PM] [smalldatetime] NULL,
[NX_MON_AM] [bit] NULL,
[NX_MON_PM] [bit] NULL,
[NX_TUE_AM] [bit] NULL,
[NX_TUE_PM] [bit] NULL,
[NX_WED_AM] [bit] NULL,
[NX_WED_PM] [bit] NULL,
[NX_THU_AM] [bit] NULL,
[NX_THU_PM] [bit] NULL,
[NX_FRI_AM] [bit] NULL,
[NX_FRI_PM] [bit] NULL,
[NX_SAT_AM] [bit] NULL,
[NX_SAT_PM] [bit] NULL,
[NX_SUN_AM] [bit] NULL,
[NX_SUN_PM] [bit] NULL,
[NX_DEF_ADDRESS_DELIVERY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DEF_ADDRESS_INVOICE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DEF_ADDRESS_PAY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DEF_ADDRESS_HOME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DEF_ADDRESS_PRIMARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DEF_ADDRESS_SECONDARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_DEF_ADDRESS_VISIT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_TAX_REGIME_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_COUNTRY_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_COMPANY] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Address_dc] ADD CONSTRAINT [PK_Customer_Address_dc] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_Address_dc] ON [Dataset].[Customer_Address_dc] ([MIG_SITE_NAME], [CUSTOMER_ID], [ID]) ON [PRIMARY]
GO
