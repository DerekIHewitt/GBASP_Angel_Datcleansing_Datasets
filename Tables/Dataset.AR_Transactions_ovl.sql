CREATE TABLE [Dataset].[AR_Transactions_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_NO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSuspect] [bit] NULL,
[SRC_INVOICE_DATE] [datetime] NOT NULL,
[SRC_DUE_DATE] [datetime] NOT NULL,
[SRC_PAY_TERM_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CURRENCY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CURRENCY_RATE] [decimal] (18, 4) NOT NULL,
[SRC_NET_CURR_AMMOUNT] [decimal] (18, 4) NOT NULL,
[SRC_NET_DOM_AMOUNT] [decimal] (18, 4) NOT NULL,
[SRC_VAT_CURR_AMOUNT] [decimal] (18, 4) NOT NULL,
[SRC_VAT_DOM_AMOUNT] [decimal] (18, 4) NOT NULL,
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
ALTER TABLE [Dataset].[AR_Transactions_ovl] ADD CONSTRAINT [PK_AR_Transactions_ovl] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
