CREATE TABLE [Dataset].[Open_Work_Orders_ex]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COMPANY] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WO_SITE] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DIRECTIVE] [nvarchar] (600) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAULT_DESC] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAN_START] [date] NULL,
[PLAN_FINISH] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WORK_TYPE] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTION] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OBJECT_ID] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OBJECT_SITE] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COORDINATOR] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PM_NO] [int] NULL,
[PM_REVISION] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_NO] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENCY_CODE] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONTRACT_ID] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONTRACT_LINE_NO] [int] NULL,
[SLA_ID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXCLUDE_FROM_SCHEDULING] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DELIVERY_ADDRESS_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STANDARD_JOB_ID] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRICE] [decimal] (18, 2) NULL,
[BOOK_IN_REQUIRED] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIG_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Open_Work_Orders_ex_MIG_COMMENT] DEFAULT (''),
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Open_Work_Orders_ex_MIG_CREATED_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Open_Work_Orders_ex] ADD CONSTRAINT [PK_WorkOrder_src] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
