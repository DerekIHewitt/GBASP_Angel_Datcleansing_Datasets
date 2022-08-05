CREATE TABLE [Dataset].[Works_Order_Materials_EX_Filtered]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WO_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_NO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PART_NO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QUANTITY_REQUIRED] [float] NOT NULL,
[PRICE] [decimal] (18, 4) NOT NULL,
[DUE_DATE] [datetime] NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Works_Order_Materials_EX_Filtered_MIG_CREATED_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Works_Order_Materials_EX_Filtered] ADD CONSTRAINT [PK_Works_Order_Materials_EX_Filtered] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
