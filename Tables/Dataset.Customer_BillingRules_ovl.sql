CREATE TABLE [Dataset].[Customer_BillingRules_ovl]
(
[ID] [int] NOT NULL,
[MIG_SITE_NAME] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUST_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSuspect] [bit] NOT NULL CONSTRAINT [DF_Customer_BillingRules_IsSuispect] DEFAULT ((0)),
[SRC_ORDER_TYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CUSTOMER_INVOICE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_PAYMENT_TERM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CONS_RULE_DESC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ORDER_TYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_INVOICE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAYMENT_TERM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONS_RULE_DESC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_BillingRules_ovl] ADD CONSTRAINT [PK_Customer_BillingRules_ovl] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_BillingRules_ovl] ON [Dataset].[Customer_BillingRules_ovl] ([MIG_SITE_NAME], [CUST_ID]) ON [PRIMARY]
GO
