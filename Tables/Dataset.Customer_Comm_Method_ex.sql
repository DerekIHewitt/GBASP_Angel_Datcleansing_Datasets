CREATE TABLE [Dataset].[Customer_Comm_Method_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Comm_Method_ex_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Comm_Method_ex_MIG_CREATED_DATE] DEFAULT (getdate()),
[IDENTITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMM_ID] [int] NOT NULL,
[PARTY_TYPE_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMM_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMM_DESCRIPTION] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[METHOD_ID_DB] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMM_METHOD_VALUE] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEFAULT_PER_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EXT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[POD_EMAIL_DB] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_COMPANY] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Comm_Method_ex_NX_COMPANY] DEFAULT (''),
[NX_ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Comm_Method_ex_NX_ADDRESS_ID] DEFAULT (''),
[NX_ADDRESS_DEFAULT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Customer_Comm_Method_ex_NX_ADDRESS_DEFAULT] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Comm_Method_ex] ADD CONSTRAINT [PK_Customer_Comms_Method_ext] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
