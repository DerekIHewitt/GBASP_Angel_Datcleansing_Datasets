CREATE TABLE [Dataset].[cariadContactStaticTable]
(
[MIG_SITE_NAME] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NX_PERSON_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIDDLE_NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LAST_NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_TITLE] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_CUSTOMER_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_CUSTOMER_SECONDARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_CUSTOMER_ADDRESS_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_CUSTOMER_ADDRESS_PRIMARY] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NX_ROLE_DB] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ID] [float] NULL,
[MIG_COMMENT] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED_DATE] [datetime2] NULL
) ON [PRIMARY]
GO