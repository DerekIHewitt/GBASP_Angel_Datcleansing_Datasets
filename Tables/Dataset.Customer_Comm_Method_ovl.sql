CREATE TABLE [Dataset].[Customer_Comm_Method_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IDENTITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMM_ID] [int] NOT NULL,
[IsSuspect] [bit] NOT NULL CONSTRAINT [DF_Customer_Comm_Method_ovl_IsSuspect] DEFAULT ((0)),
[SRC_PARTY_TYPE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COMM_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COMM_DESCRIPTION] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_METHOD_ID_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COMM_METHOD_VALUE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEFAULT_PER_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_EXT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_POD_EMAIL_DB] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_COMPANY] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_ADDRESS_DEFAULT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PARTY_TYPE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM_DESCRIPTION] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[METHOD_ID_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM_METHOD_VALUE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFAULT_PER_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POD_EMAIL_DB] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMPANY] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS_DEFAULT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Comm_Method_ovl] ADD CONSTRAINT [PK_Customer_Comms_Method_ovl] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_Comm_Method_ovl] ON [Dataset].[Customer_Comm_Method_ovl] ([MIG_SITE_NAME], [IDENTITY], [COMM_ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the CUSTOMER_ID, butr as the IFS table the data will be going to is also used for persons and suppliers, it uses the IDENTITY ', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_Comm_Method_ovl', 'COLUMN', N'IDENTITY'
GO
