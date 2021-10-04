CREATE TABLE [Dataset].[PM_Actions_Non_SC_Material_ex]
(
[PK] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PM_NO] [int] NOT NULL,
[SITE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACTION] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WO_SITE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[INTERVAL] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OPERATIONAL_STATUS_ID] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PART_NO] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QTY] [int] NOT NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_PM_Actions_Non_SC_Material_ex_MIG_CREATED_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[PM_Actions_Non_SC_Material_ex] ADD CONSTRAINT [PK_PM_Actions_Non_SC_Material_ex] PRIMARY KEY CLUSTERED  ([PK]) ON [PRIMARY]
GO
