CREATE TABLE [dbo].[AP Customers Cut 1 Load 1]
(
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEFAULT_LANGUAGE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COUNTRY_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_FEE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMPANY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GROUP_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAY_TERM_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TAX_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUST_GRP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CURRENCY_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CREDIT_LIMIT] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MARKET_CODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_CUSTOMER] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORDER_TYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IDENTITY_TYPE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PRINT_TAX_CODE_TEXT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CYCLE_PERIOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INVOICE_SORT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ORDER_CONF_FLAG_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PACK_LIST_FLAG_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CATEGORY_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SUMMARIZED_SOURCE_LINES_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REPLICATE_DOC_TEXT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PRINT_AMOUNTS_INCL_TAX_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CHECK_SALES_GRP_DELIV_CONF_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RELEASE_INTERNAL_ORDER_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CREDIT_CONTROL_GROUP_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BACKORDER_OPTION_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SUMMARIZED_FREIGHT_CHARGES_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PRINT_DELIVERED_LINES_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EMAIL_ORDER_CONF_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EMAIL_INVOICE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CREDIT_BLOCK] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NETTING_ALLOWED] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAYMENT_ADVICE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAYMENT_RECEIPT_TYPE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PAY_OUTPUT_MEDIA_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEFAULT_PAYMENT_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IS_ONE_INV_PER_PAY_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REMINDER_TEMPLATE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CRM_ACCOUNT_TYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACTIVE_TRIAL_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CCA_FLAG_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BLANKET_PURCHASE_ORDER] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_EXPIRY_DATE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_EXPIRY_VALUE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_VALUE_USED] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAYMENT_METHOD] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_DESCRIPTION] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_ACCOUNT] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_SORT_CODE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_ACC_NAME] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_BUILD_SOC_REF] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_TRANS_CODE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAY_ADDR_OUR_REF] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREDIT_ANALYST] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MESSAGE_GROUP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ALLOWED_OVERDUE_AMOUNT] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ALLOWED_OVERDUE_DAYS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREDIT_RELATIONSHIP_EXIST] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CREDIT_RELATIONSHIP_TYPE_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PARENT_COMPANY] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PARENT_CUSTOMER_ID] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAIN_REP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUST_ORDER_INVOICING_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST_ORDER_INV_TYPE_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONSOLIDATION_DAY_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SAGE_CODE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OLD_CUST_REF1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OLD_CUST_REF2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACQUIRED_FROM_COMP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BOOK_IN_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NO_LIMIT_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ON_SITE_RA_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PURCHASE_ORDER_REQ_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SHORT_TERM_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COST_CODE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST_PRICE_GROUP_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ASSOCIATION_NO] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BR_PAYMENT_TERM] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BR_ORDER_TYPE] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BR_BLOCKED_DD] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BR_CONSOLIDATION] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LEGAL_ENTITY_DB] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IMPORT_ACCOUNT] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNT_GROUP] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
