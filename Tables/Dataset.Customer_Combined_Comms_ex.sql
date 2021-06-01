CREATE TABLE [Dataset].[Customer_Combined_Comms_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_Combined_Comms_ex_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Customer_Combined_Comms_ex_MIG_CREATED_DATE] DEFAULT (getdate()),
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIDDLE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LAST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PHONE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EXT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MOBILE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FAX] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AR_CONTACT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEFAULT_PER_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[POD_EMAIL_DB] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Combined_Comms_ex] ADD CONSTRAINT [PK_Customer_Combined_Comms_ex] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_Combined_Comms_ex', 'COLUMN', N'CUSTOMER_ID'
GO
