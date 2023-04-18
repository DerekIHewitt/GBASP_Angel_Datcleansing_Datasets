CREATE TABLE [dbo].[SC_DATA_ROANNE_GBCDW]
(
[MIG_Object] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Part] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Customer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Line_Date] [datetime] NOT NULL,
[MIG_NISP_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_Price] [decimal] (18, 2) NOT NULL,
[MIG_IP_Freq] [decimal] (18, 2) NOT NULL,
[MIG_SER_Freq] [decimal] (18, 2) NULL,
[MIG_SER_Date] [datetime] NULL,
[PO_NUMBER] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PO_EXPIRY_DATE] [datetime] NULL
) ON [PRIMARY]
GO
