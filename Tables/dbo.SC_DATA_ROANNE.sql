CREATE TABLE [dbo].[SC_DATA_ROANNE]
(
[MIG_Object] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIG_Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIG_Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIG_Line_Date] [datetime] NULL,
[MIG_NISP_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIG_Price] [decimal] (18, 2) NULL,
[MIG_IP_Freq] [decimal] (18, 2) NULL,
[MIG_SER_Freq] [decimal] (18, 2) NULL,
[MIG_SER_Date] [datetime] NULL
) ON [PRIMARY]
GO
