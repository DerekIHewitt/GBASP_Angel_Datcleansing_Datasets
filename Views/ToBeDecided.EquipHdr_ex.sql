SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ToBeDecided].[EquipHdr_ex]
AS
SELECT        dbo.Syn_EquipHdr_ex.EQH_IDNo, dbo.Syn_EquipHdr_ex.EQH_Stock_Code, dbo.Syn_EquipHdr_ex.EQH_Account, dbo.Syn_EquipHdr_ex.EQH_ContractID, dbo.Syn_EquipHdr_ex.EQH_Asset, 
                         dbo.Syn_EquipHdr_ex.EQH_Location, dbo.Syn_EquipHdr_ex.EQH_Colour_Code, dbo.Syn_EquipHdr_ex.EQH_ColourID, dbo.Syn_EquipHdr_ex.EQH_RepID, dbo.Syn_EquipHdr_ex.EQH_FinanceID, 
                         dbo.Syn_EquipHdr_ex.EQH_ExSani, dbo.Syn_EquipHdr_ex.EQH_Frequency, dbo.Syn_EquipHdr_ex.EQH_S_Span, dbo.Syn_EquipHdr_ex.EQH_Due_Date, dbo.Syn_EquipHdr_ex.EQH_Last_Sevice, 
                         dbo.Syn_EquipHdr_ex.EQH_FixSaniDate, dbo.Syn_EquipHdr_ex.EQH_SaniCycle, dbo.Syn_EquipHdr_ex.EQH_Filter_Freq, dbo.Syn_EquipHdr_ex.EQH_F_Span, dbo.Syn_EquipHdr_ex.EQH_Last_FiltChg, 
                         dbo.Syn_EquipHdr_ex.EQH_F_Due_Date, dbo.Syn_EquipHdr_ex.EQH_F_Stock_Code, dbo.Syn_EquipHdr_ex.EQH_F_Qty, dbo.Syn_EquipHdr_ex.EQH_M_Freq, dbo.Syn_EquipHdr_ex.EQH_M_Span, 
                         dbo.Syn_EquipHdr_ex.EQH_M_Last_Done, dbo.Syn_EquipHdr_ex.EQH_M_Next_Due, dbo.Syn_EquipHdr_ex.EQH_M_Stock_Code, dbo.Syn_EquipHdr_ex.EQH_SupplierCode, dbo.Syn_EquipHdr_ex.EQH_Date_Purch, 
                         dbo.Syn_EquipHdr_ex.EQH_DSDate, dbo.Syn_EquipHdr_ex.EQH_Life, dbo.Syn_EquipHdr_ex.EQH_Agreement, dbo.Syn_EquipHdr_ex.EQH_Start_Date, dbo.Syn_EquipHdr_ex.EQH_Expiry_Date, 
                         dbo.Syn_EquipHdr_ex.EQH_Install_Date, dbo.Syn_EquipHdr_ex.EQH_Last_Inv, dbo.Syn_EquipHdr_ex.EQH_Due_Inv, dbo.Syn_EquipHdr_ex.EQH_I_Span, dbo.Syn_EquipHdr_ex.EQH_I_Freq, 
                         dbo.Syn_EquipHdr_ex.EQH_Odd_Days, dbo.Syn_EquipHdr_ex.EQH_Rental_Amnt, dbo.Syn_EquipHdr_ex.EQH_RentSpan, dbo.Syn_EquipHdr_ex.EQH_Contract_Pd1, dbo.Syn_EquipHdr_ex.EQH_Span, 
                         dbo.Syn_EquipHdr_ex.EQH_C_Rented, dbo.Syn_EquipHdr_ex.EQH_C_Value, dbo.Syn_EquipHdr_ex.EQH_AddStockCode, dbo.Syn_EquipHdr_ex.EQH_Sani_Amnt, dbo.Syn_EquipHdr_ex.EQH_Arrears, 
                         dbo.Syn_EquipHdr_ex.EQH_ELFreq, dbo.Syn_EquipHdr_ex.EQH_ELSpan, dbo.Syn_EquipHdr_ex.EQH_ELLast, dbo.Syn_EquipHdr_ex.EQH_ELDue, dbo.Syn_EquipHdr_ex.EQH_Status_Flag, 
                         dbo.Syn_EquipHdr_ex.EQH_PATLastDate, dbo.Syn_EquipHdr_ex.EQH_PATDueDate, dbo.Syn_EquipHdr_ex.EQH_MakerID, dbo.Syn_EquipHdr_ex.EQH_SaniOS, dbo.Syn_EquipHdr_ex.EQH_SaniORD, 
                         dbo.Syn_EquipHdr_ex.EQH_SaniORLID, dbo.Syn_EquipHdr_ex.EQH_PurchPrice, dbo.Syn_EquipHdr_ex.EQH_Notes, dbo.Syn_EquipHdr_ex.EQH_Isolation, dbo.Syn_EquipHdr_ex.EQH_ExSaniCons, 
                         dbo.Syn_EquipHdr_ex.EQH_MaintPrice, dbo.Syn_EquipHdr_ex.EQH_UseMaintPrice, dbo.Syn_EquipHdr_ex.EQH_EarlyInvDays, dbo.Syn_EquipHdr_ex.EQH_InstallID, dbo.Syn_EquipHdr_ex.EQH_PRSchemeID, 
                         dbo.Syn_EquipHdr_ex.EQH_PRDueDate, dbo.Syn_EquipHdr_ex.EQH_ImportContract, dbo.Syn_EquipHdr_ex.EQH_InvNote, dbo.Syn_EquipHdr_ex.EQH_RepIDContract, dbo.Syn_EquipHdr_ex.EQH_CDtSerial, 
                         dbo.Syn_EquipHdr_ex.EQH_CBySerial, dbo.Syn_EquipHdr_ex.EQH_CDtLocation, dbo.Syn_EquipHdr_ex.EQH_CByLocation, dbo.Syn_EquipHdr_ex.EQH_CDtRentDue, dbo.Syn_EquipHdr_ex.EQH_CByRentDue, 
                         dbo.Syn_EquipHdr_ex.EQH_CDtSaniDue, dbo.Syn_EquipHdr_ex.EQH_CBySaniDue, dbo.Syn_EquipHdr_ex.EQH_CDtFilterDue, dbo.Syn_EquipHdr_ex.EQH_CByFilterDue, dbo.Syn_EquipHdr_ex.EQH_CDtMaintDue, 
                         dbo.Syn_EquipHdr_ex.EQH_CByMaintDue, dbo.Syn_EquipHdr_ex.EQH_CDtELDue, dbo.Syn_EquipHdr_ex.EQH_CByELDue, dbo.Syn_EquipHdr_ex.EQH_SaniPrice, dbo.Syn_EquipHdr_ex.EQH_UseSaniPrice, 
                         dbo.Syn_EquipHdr_ex.EQH_FilterPrice, dbo.Syn_EquipHdr_ex.EQH_UseFilterPrice, dbo.Syn_EquipHdr_ex.EQH_ELPrice, dbo.Syn_EquipHdr_ex.EQH_UseELPrice, dbo.Syn_EquipHdr_ex.EQH_ID, dbo.Filter_SerialObject('ex', 
                         dbo.Syn_EquipHdr_ex.EQH_Status_Flag, dbo.Customer_ex.CUS_Type, dbo.Customer_ex.CUS_Filter_Status) AS EQH_Filter_Status
FROM            dbo.Syn_EquipHdr_ex LEFT OUTER JOIN
                         dbo.Customer_ex ON dbo.Syn_EquipHdr_ex.EQH_Account = dbo.Customer_ex.CUS_Account
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Syn_EquipHdr_ex"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 328
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_ex"
            Begin Extent = 
               Top = 6
               Left = 276
               Bottom = 136
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 270
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 8715
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'ToBeDecided', 'VIEW', N'EquipHdr_ex', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'ToBeDecided', 'VIEW', N'EquipHdr_ex', NULL, NULL
GO
