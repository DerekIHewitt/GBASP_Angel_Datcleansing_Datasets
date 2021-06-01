CREATE TABLE [Dataset].[Customer_Address_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSuspect] [bit] NOT NULL CONSTRAINT [DF_Customer_Address_ovl_IsSuspect] DEFAULT ((0)),
[SRC_NAME] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ADDRESS1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ADDRESS2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CITY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COUNTY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_STATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SUPPLY_COUNTRY_DB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DELIVERY_COUNTRY_DB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_VAT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SPECIAL_INS] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_WORK_ORDER_NOTES] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_LONGITUDE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_LATITUDE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DELIVERY_TERMS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SHIP_VIA_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_IN_CITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_TAX_WITHHOLDING_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_TAX_ROUNDING_METHOD_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_TAX_ROUNDING_LEVEL_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_TAX_EXEMPT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_INTRASTAT_EXEMPT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OPENING_AM] [smalldatetime] NOT NULL,
[SRC_CLOSING_AM] [smalldatetime] NOT NULL,
[SRC_OPENING_PM] [smalldatetime] NOT NULL,
[SRC_CLOSING_PM] [smalldatetime] NOT NULL,
[SRC_MON_AM] [bit] NOT NULL,
[SRC_MON_PM] [bit] NOT NULL,
[SRC_TUE_AM] [bit] NOT NULL,
[SRC_TUE_PM] [bit] NOT NULL,
[SRC_WED_AM] [bit] NOT NULL,
[SRC_WED_PM] [bit] NOT NULL,
[SRC_THU_AM] [bit] NOT NULL,
[SRC_THU_PM] [bit] NOT NULL,
[SRC_FRI_AM] [bit] NOT NULL,
[SRC_FRI_PM] [bit] NOT NULL,
[SRC_SAT_AM] [bit] NOT NULL,
[SRC_SAT_PM] [bit] NOT NULL,
[SRC_SUN_AM] [bit] NOT NULL,
[SRC_SUN_PM] [bit] NOT NULL,
[SRC_DEF_ADDRESS_DELIVERY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEF_ADDRESS_INVOICE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEF_ADDRESS_PAY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEF_ADDRESS_HOME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEF_ADDRESS_PRIMARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEF_ADDRESS_SECONDARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEF_ADDRESS_VISIT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_TAX_REGIME_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COUNTRY_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COMPANY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_CODE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTY] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUPPLY_COUNTRY_DB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DELIVERY_COUNTRY_DB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VAT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPECIAL_INS] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WORK_ORDER_NOTES] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LONGITUDE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LATITUDE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DELIVERY_TERMS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHIP_VIA_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IN_CITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAX_WITHHOLDING_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAX_ROUNDING_METHOD_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAX_ROUNDING_LEVEL_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAX_EXEMPT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INTRASTAT_EXEMPT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OPENING_AM] [smalldatetime] NULL,
[CLOSING_AM] [smalldatetime] NULL,
[OPENING_PM] [smalldatetime] NULL,
[CLOSING_PM] [smalldatetime] NULL,
[MON_AM] [bit] NULL,
[MON_PM] [bit] NULL,
[TUE_AM] [bit] NULL,
[TUE_PM] [bit] NULL,
[WED_AM] [bit] NULL,
[WED_PM] [bit] NULL,
[THU_AM] [bit] NULL,
[THU_PM] [bit] NULL,
[FRI_AM] [bit] NULL,
[FRI_PM] [bit] NULL,
[SAT_AM] [bit] NULL,
[SAT_PM] [bit] NULL,
[SUN_AM] [bit] NULL,
[SUN_PM] [bit] NULL,
[DEF_ADDRESS_DELIVERY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF_ADDRESS_INVOICE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF_ADDRESS_PAY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF_ADDRESS_HOME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF_ADDRESS_PRIMARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF_ADDRESS_SECONDARY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEF_ADDRESS_VISIT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAX_REGIME_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTRY_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMPANY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Address_ovl] ADD CONSTRAINT [PK_Customer_Address_ovl] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_Address_ovl] ON [Dataset].[Customer_Address_ovl] ([MIG_SITE_NAME], [CUSTOMER_ID], [ID]) ON [PRIMARY]
GO
