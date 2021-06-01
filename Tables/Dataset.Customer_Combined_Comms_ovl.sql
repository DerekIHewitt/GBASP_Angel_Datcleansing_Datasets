CREATE TABLE [Dataset].[Customer_Combined_Comms_ovl]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsSespect] [bit] NOT NULL,
[SRC_FIRST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_MIDDLE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_LAST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_PHONE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_EXT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_MOBILE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_EMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_FAX] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_AR_CONTACT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_DEFAULT_PER_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SRC_POD_EMAIL_DB] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDDLE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXT_NO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MOBILE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAX] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AR_CONTACT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEFAULT_PER_METHOD] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POD_EMAIL_DB] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_Combined_Comms_ovl] ADD CONSTRAINT [PK_Customer_Combined_Comms_ovl] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
