CREATE TABLE [Dataset].[Purchase_Order_Details_dc]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Purchase_Order_Details_dc_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Purchase_Order_Details_dc_MIG_CREATED_DATE] DEFAULT (getdate()),
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PO_SCHEMA] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_PO] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Purchase_Order_Details_dc_CUSTOMER_PO] DEFAULT (''),
[CUSTOMER_PO_VALUE] [decimal] (18, 0) NULL,
[CUSTOMER_PO_START] [date] NULL,
[CUSTOMER_PO_EXPIRY] [date] NULL,
[PO_RENT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Purchase_Order_Details_dc_PO_RENT] DEFAULT (''),
[PO_RENT_VALUE] [decimal] (18, 0) NULL,
[PO_RENT_START] [date] NULL,
[PO_RENT_EXPIRY] [date] NULL,
[PO_SANI] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Purchase_Order_Details_dc_PO_SANI] DEFAULT (''),
[PO_SANI_VALUE] [decimal] (18, 0) NULL,
[PO_SANI_START] [date] NULL,
[PO_SANI_EXPIRY] [date] NULL,
[PO_EL] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Purchase_Order_Details_dc_PO_EL] DEFAULT (''),
[PO_EL_VALUE] [decimal] (18, 0) NULL,
[PO_EL_START] [date] NULL,
[PO_EL_EXPIRY] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Purchase_Order_Details_dc] ADD CONSTRAINT [PK_Purchase_Order_Details_dc] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
