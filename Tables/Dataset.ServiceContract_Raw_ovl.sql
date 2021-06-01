CREATE TABLE [Dataset].[ServiceContract_Raw_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_ServiceContract_Raw_ovl_MIG_CREATED_DATE] DEFAULT (getdate()),
[MIG_SRC_CREATED_DATE] [datetime] NOT NULL,
[IsSuspect] [bit] NOT NULL,
[CUSTOMER_DELIVERY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_INVOICE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MACHINE_LEGACY_UID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MATRIX_TYPES] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CONTRACT_NAME] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_MACHINE_PART_NUM] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_MACHINE_OWNER] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_PO_NUMBER] [nvarchar] (99) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_PO_VALUE] [decimal] (18, 4) NOT NULL,
[SRC_PO_VALID_FROM] [date] NULL,
[SRC_PO_EXPIRY_DATE] [date] NULL,
[SRC_BILLING_IFS_FROM_DATE] [datetime] NULL,
[SRC_RENT_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_RENT_PER_UNIT] [decimal] (10, 4) NOT NULL,
[SRC_RENT_INVOICE_FREQ] [int] NOT NULL,
[SRC_RENT_IN_ADVANCE] [bit] NOT NULL,
[SRC_RENT_NEXT_INVOICE_DATE] [date] NULL,
[SRC_RENT_NEXT_PERIOD_FROM_DATE] [date] NULL,
[SRC_SERVICE_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SERVICE_PER_UNIT] [decimal] (10, 4) NOT NULL,
[SRC_SERVICE_INVOICE_FREQ] [int] NOT NULL,
[SRC_SERVICE_FREQ] [int] NOT NULL,
[SRC_SERVICE_IN_ADVANCE] [bit] NOT NULL,
[SRC_SERVICE_NEXT_INVOICE_DATE] [date] NULL,
[SRC_SERVICE_NEXT_PERIOD_FROM] [date] NULL,
[SRC_SERVICE_NEXT_PM_BASE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SERVICE_PM_START_VALUE] [date] NULL,
[SRC_ENV_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ENV_PRICE_PER_UNIT] [decimal] (18, 4) NOT NULL,
[SRC_ENV_INV_FREQ] [int] NOT NULL,
[SRC_ENV_NEXT_INVOICE_DATE] [date] NULL,
[SRC_ENV_NEXT_PERIOD_FROM] [date] NULL,
[SRC_OTHER1_TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OTHER1_SUBTYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OTHER1_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OTHER1_PRICE_PER_UNIT] [decimal] (18, 4) NOT NULL,
[SRC_OTHER1_INVOICE_FREQ] [int] NOT NULL,
[SRC_OTHER1_INVOICE_QTY] [int] NOT NULL,
[SRC_OTHER1_NEXT_INVOICE_DATE] [date] NULL,
[SRC_OTHER1_NEXT_PERIOD_FROM] [date] NULL,
[SRC_OTHER2_TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OTHER2_SUBTYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OTHER2_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_OTHER2_PRICE_PER_UNIT] [decimal] (18, 4) NOT NULL,
[SRC_OTHER2_INVOICE_FREQ] [int] NOT NULL,
[SRC_OTHER2_INVOICE_QTY] [int] NOT NULL,
[SRC_OTHER2_NEXT_INVOICE_DATE] [date] NULL,
[SRC_OTHER2_NEXT_PERIOD_FROM] [date] NULL,
[SRC_HASADDITIONALDATA] [bit] NOT NULL,
[SRC_SLA_EXC] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SLA_SWP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SLA_SER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SLA_TER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SLA_CMA] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_SLA_DEL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CURRENT_CONTRACT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CURRENT_CONTRACT_NUMBER] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_CURRENT_START_DATE] [date] NULL,
[SRC_ORIGINAL_CONTRACT_NUMBER] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ORIGINAL_END_DATE] [date] NULL,
[SRC_ORIGINAL_START_DATE] [date] NULL,
[SRC_CONTRACT_TERM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COMMENT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CONTRACT_NAME] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MACHINE_PART_NUM] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MACHINE_OWNER] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_NUMBER] [nvarchar] (99) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_VALUE] [decimal] (18, 4) NULL,
[PO_VALID_FROM] [date] NULL,
[PO_EXPIRY_DATE] [date] NULL,
[BILLING_IFS_FROM_DATE] [datetime] NULL,
[RENT_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RENT_PER_UNIT] [decimal] (10, 4) NULL,
[RENT_INVOICE_FREQ] [int] NULL,
[RENT_IN_ADVANCE] [bit] NULL,
[RENT_NEXT_INVOICE_DATE] [date] NULL,
[RENT_NEXT_PERIOD_FROM_DATE] [date] NULL,
[SERVICE_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERVICE_PER_UNIT] [decimal] (10, 4) NULL,
[SERVICE_INVOICE_FREQ] [int] NULL,
[SERVICE_FREQ] [int] NULL,
[SERVICE_IN_ADVANCE] [bit] NULL,
[SERVICE_NEXT_INVOICE_DATE] [date] NULL,
[SERVICE_NEXT_PERIOD_FROM] [date] NULL,
[SERVICE_NEXT_PM_BASE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERVICE_PM_START_VALUE] [date] NULL,
[ENV_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ENV_PRICE_PER_UNIT] [decimal] (18, 4) NULL,
[ENV_INV_FREQ] [int] NULL,
[ENV_NEXT_INVOICE_DATE] [date] NULL,
[ENV_NEXT_PERIOD_FROM] [date] NULL,
[OTHER1_TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER1_SUBTYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER1_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER1_PRICE_PER_UNIT] [decimal] (18, 4) NULL,
[OTHER1_INVOICE_FREQ] [int] NULL,
[OTHER1_INVOICE_QTY] [int] NULL,
[OTHER1_NEXT_INVOICE_DATE] [date] NULL,
[OTHER1_NEXT_PERIOD_FROM] [date] NULL,
[OTHER2_TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER2_SUBTYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER2_UNIT] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER2_PRICE_PER_UNIT] [decimal] (18, 4) NULL,
[OTHER2_INVOICE_FREQ] [int] NULL,
[OTHER2_INVOICE_QTY] [int] NULL,
[OTHER2_NEXT_INVOICE_DATE] [date] NULL,
[OTHER2_NEXT_PERIOD_FROM] [date] NULL,
[HASADDITIONALDATA] [bit] NULL,
[SLA_EXC] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SLA_SWP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SLA_SER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SLA_TER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SLA_CMA] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SLA_DEL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENT_CONTRACT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENT_CONTRACT_NUMBER] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENT_START_DATE] [date] NULL,
[ORIGINAL_CONTRACT_NUMBER] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIGINAL_END_DATE] [date] NULL,
[ORIGINAL_START_DATE] [date] NULL,
[CONTRACT_TERM] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[ServiceContract_Raw_ovl] ADD CONSTRAINT [PK_ServiceContract_Raw_ovlEqpData] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'When a date is not supplied, the transformation will use system or ''go live'' date.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'BILLING_IFS_FROM_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A field that the legacy system can use to ''tag'' the data t', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'COMMENT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Legacy system reference for the customer account for where the machine is installed.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'CUSTOMER_DELIVERY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Legacy systems reference for the account that recieves the invoice', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'CUSTOMER_INVOICE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number of times per year to raise an environmental invoice (1 = once per year covering 12 months)', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'ENV_INV_FREQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date of the next invoice covering environmental charges.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'ENV_NEXT_INVOICE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first day of the period that the next environmental charge will cover.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'ENV_NEXT_PERIOD_FROM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UID in the legacy system that identifies this machine', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'MACHINE_LEGACY_UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Y = The customer ownes the equipment | N = The company owns the equipment', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'MACHINE_OWNER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Legacy system part number for the piece of equipment.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'MACHINE_PART_NUM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains pipe seperated values (no spaces, just pipes and numbers) for the contract line types to be generated. String must start and end with a pipe.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'MATRIX_TYPES'
GO
EXEC sp_addextendedproperty N'MS_Description', N'How many times a year to raise an invoice.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'OTHER1_INVOICE_FREQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When an invoice is raised, each invoice will charge the value in this field multiplied by the [OTHER1_PRICE_PER] value.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'OTHER1_INVOICE_QTY'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The next date that an invoice should be raised.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'OTHER1_NEXT_INVOICE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first day of the period that is covered by the next invoice.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'OTHER1_NEXT_PERIOD_FROM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ''unit'' price that is to be invoiced (this could be a monthly rate or it could be a single anuall charge)', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'OTHER1_PRICE_PER_UNIT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A MIG specific code representing another item to be included on the service contract.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'OTHER1_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TRUE = Rent is charged in advance | FASLE = Rent is charged in arears.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'RENT_IN_ADVANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Times per year to generate a rental invoice (4 = one every quater covering a 3 month period)', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'RENT_INVOICE_FREQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date that should be on the next generated invoice.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'RENT_NEXT_INVOICE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First day of the period that the next rental invoice is covering.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'RENT_NEXT_PERIOD_FROM_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rental per month for the equiment', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'RENT_PER_UNIT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The numver of services per year (2 = two services per year six months apart)', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_FREQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TRUE = Services are invoiced in advance | FALSE = Services are invoiced in arears.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_IN_ADVANCE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'How many times per year to raise a service invoice (2 = raise two service invoices per year with six months invoiced on each invoice)', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_INVOICE_FREQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date on the next service invoice.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_NEXT_INVOICE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First day of the period that will be next invoiced.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_NEXT_PERIOD_FROM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Charge per service per month.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_PER_UNIT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date of the next scheduled service.', 'SCHEMA', N'Dataset', 'TABLE', N'ServiceContract_Raw_ovl', 'COLUMN', N'SERVICE_PM_START_VALUE'
GO
