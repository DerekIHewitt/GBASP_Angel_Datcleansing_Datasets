CREATE TABLE [dbo].[SC_DATA_ROANNE_GBCDW]
(
[MIG_Object] [bigint] NULL,
[MIG_Part] [int] NULL,
[MIG_Customer] [int] NULL,
[MIG_Line_Date] [datetime] NULL,
[MIG_NISP_Type] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIG_Price] [decimal] (28, 0) NULL,
[MIG_IP_Freq] [decimal] (28, 0) NULL,
[MIG_SER_Freq] [decimal] (28, 0) NULL,
[MIG_SER_Date] [datetime] NULL,
[PO_NUMBER] [varchar] (31) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_EXPIRY_DATE] [datetime] NULL
) ON [PRIMARY]
GO
