CREATE TABLE [dbo].[GBVIR_CUSTOMER_ADDRESS]
(
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDRESS1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VAT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPECIAL_INS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WORK_ORDER_NOTES] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
