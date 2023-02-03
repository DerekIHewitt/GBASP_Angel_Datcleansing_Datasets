CREATE TABLE [Dataset].[CariadServiceContractStaticTable]
(
[ID] [int] NOT NULL,
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_INVOICE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_DELIVERY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CONTRACT_NAME] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MATRIX_TYPE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INTERVAL_UNIT] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_INVOICE_RULE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_START_DATE] [datetime] NOT NULL,
[NEXT_PM_DATE] [datetime] NULL,
[NX_SERVICE_NEXT_PM_BASE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PO_VALID_FROM] [date] NULL,
[PO_EXPIRY_DATE] [date] NULL,
[PO_NUMBER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PO_VALUE] [int] NOT NULL,
[NX_FIRST_REVALUATION_DATE] [date] NULL,
[NX_REVALUATION_TYPE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PART_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PRICE] [decimal] (18, 2) NOT NULL,
[NX_UNIT_QTY] [int] NOT NULL,
[LEGACY_MACHINE_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PERIOD_PRICE_INV_PER_YEAR] [int] NULL,
[PM_SERVICE_INTERVAL] [int] NULL,
[CURRENT_CONTRACT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENT_CONTRACT_NUMBER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENT_CONTRACT_START_DATE] [date] NULL,
[ORIGINAL_CONTRACT_NUMBER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ORIGINAL_CONTRACT_END_DATE] [date] NULL,
[ORIGINAL_CONTRACT_START_DATE] [date] NULL,
[CONTRACT_TERM] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_OTHER1_TYPE] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_OTHER1_UNIT] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_OTHER1_UNIT_PRICE] [decimal] (18, 2) NOT NULL,
[NX_OTHER1_UNIT_QTY] [int] NOT NULL,
[NX_OTHER1_INTERVAL] [int] NULL,
[NX_OTHER1_NEXT_INVOICE_DATE] [datetime] NOT NULL,
[NX_OTHER1_NEXT_PERIOD_FROM_DATE] [date] NULL,
[OTHER2_TYPE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OTHER2_UNIT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OTHER2_UNIT_PRICE] [int] NOT NULL,
[OTHER2_UNIT_QTY] [int] NOT NULL,
[OTHER2_INTERVAL] [int] NOT NULL,
[OTHER2_NEXT_INVOICE_DATE] [date] NULL,
[OTHER2_NEXT_PERIOD_FROM_DATE] [date] NULL,
[NX_COMMENT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL,
[MIG_SRC_CREATED_DATE] [datetime] NOT NULL,
[MIG_Object] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Customer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Line_Date] [datetime] NOT NULL,
[MIG_NISP_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Price] [decimal] (18, 2) NOT NULL,
[MIG_IP_Freq] [decimal] (18, 2) NOT NULL,
[MIG_SER_Freq] [decimal] (18, 2) NULL,
[EL_PRICE] [decimal] (18, 2) NULL,
[EL_FREQ] [decimal] (18, 2) NULL,
[EL_DATE] [datetime] NULL,
[NX_CURRENT_CONTRACT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO