CREATE TABLE [Dataset].[ServiceContract_Raw_Processed_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_ServiceContract_Raw_Processed_ex_MIG_CREATED_DATE] DEFAULT (getdate()),
[MIG_SRC_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_ServiceContract_Raw_Processed_ex_MIG_SRC_CREATED_DATE] DEFAULT (getdate()),
[CUSTOMER_DELIVERY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_INVOICE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LEGACY_MACHINE_ID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MATRIX_TYPE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CONTRACT_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SITE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INTERVAL_UNIT] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_START_DATE] [date] NOT NULL,
[NEXT_PM_DATE] [date] NULL,
[PO_VALID_FROM] [date] NULL,
[PO_EXPIRY_DATE] [date] NULL,
[PO_NUMBER] [varchar] (99) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PO_VALUE] [decimal] (18, 4) NULL,
[PART_NO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PRICE] [decimal] (18, 4) NOT NULL,
[PERIOD_PRICE_INV_PER_YEAR] [int] NOT NULL,
[PM_SERVICE_INTERVAL] [int] NOT NULL,
[CURRENT_CONTRACT_NUMBER] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENT_CONTRACT_START_DATE] [date] NULL,
[ORIGINAL_CONTRACT_NUMBER] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ORIGINAL_CONTRACT_END_DATE] [date] NULL,
[ORIGINAL_CONTRACT_START_DATE] [date] NULL,
[CONTRACT_TERM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_OTHER1_TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_OTHER1_UNIT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_OTHER1_UNIT_PRICE] [decimal] (18, 4) NULL,
[NX_OTHER1_UNIT_QTY] [decimal] (18, 4) NULL,
[NX_OTHER1_INTERVAL] [int] NULL,
[NX_OTHER1_NEXT_INVOICE_DATE] [date] NULL,
[NX_OTHER1_NEXT_PERIOD_FROM_DATE] [date] NULL,
[NX_COMMENT] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_INVOICE_RULE] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_SERVICE_NEXT_PM_BASE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_FIRST_REVALUATION_DATE] [date] NULL,
[NX_REVALUATION_TYPE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_UNIT_QTY] [decimal] (18, 4) NULL,
[NX_CURRENT_CONTRACT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[ServiceContract_Raw_Processed_ex] ADD CONSTRAINT [PK_ServiceContract_Raw_Processed_ex] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceContract_Raw_Processed_ex] ON [Dataset].[ServiceContract_Raw_Processed_ex] ([MIG_SITE_NAME], [CUSTOMER_DELIVERY], [CUSTOMER_INVOICE], [LEGACY_MACHINE_ID], [MATRIX_TYPE], [ID]) ON [PRIMARY]
GO
