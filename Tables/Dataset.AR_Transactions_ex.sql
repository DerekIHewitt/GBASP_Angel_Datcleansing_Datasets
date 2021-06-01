CREATE TABLE [Dataset].[AR_Transactions_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED] [datetime] NOT NULL CONSTRAINT [DF_Table_ex_1_Mig_CREATED] DEFAULT (getdate()),
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AR_Transactions_ex_MIG_COMMENT] DEFAULT (''),
[CUSTOMER_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_NO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_DATE] [datetime] NOT NULL,
[DUEW_DATE] [datetime] NOT NULL,
[PAY_TERM_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENCY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENCY_RATE] [decimal] (18, 4) NOT NULL,
[NET_CURR_AMMOUNT] [decimal] (18, 4) NOT NULL,
[NET_DOM_AMOUNT] [decimal] (18, 4) NOT NULL,
[VAT_CURR_AMOUNT] [decimal] (18, 4) NOT NULL,
[VAT_DOM_AMOUNT] [decimal] (18, 4) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[AR_Transactions_ex] ADD CONSTRAINT [PK_AR_Transactions_ex] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
