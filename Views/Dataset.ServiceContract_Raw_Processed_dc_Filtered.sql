SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [Dataset].[ServiceContract_Raw_Processed_dc_Filtered]
AS
SELECT Dataset.ServiceContract_Raw_Processed_dc.ID, Dataset.ServiceContract_Raw_Processed_dc.MIG_SITE_NAME, Dataset.ServiceContract_Raw_Processed_dc.MIG_CREATED_DATE, Dataset.ServiceContract_Raw_Processed_dc.MIG_SRC_CREATED_DATE, 
             Dataset.ServiceContract_Raw_Processed_dc.CUSTOMER_DELIVERY, Dataset.ServiceContract_Raw_Processed_dc.CUSTOMER_INVOICE, Dataset.ServiceContract_Raw_Processed_dc.LEGACY_MACHINE_ID, Dataset.ServiceContract_Raw_Processed_dc.MATRIX_TYPE, 
             Dataset.ServiceContract_Raw_Processed_dc.CONTRACT_NAME, Dataset.ServiceContract_Raw_Processed_dc.SITE, Dataset.ServiceContract_Raw_Processed_dc.INTERVAL_UNIT, Dataset.ServiceContract_Raw_Processed_dc.INVOICE_START_DATE, 
             Dataset.ServiceContract_Raw_Processed_dc.NEXT_PM_DATE, Dataset.ServiceContract_Raw_Processed_dc.PO_VALID_FROM, Dataset.ServiceContract_Raw_Processed_dc.PO_EXPIRY_DATE, Dataset.ServiceContract_Raw_Processed_dc.PO_NUMBER, 
             Dataset.ServiceContract_Raw_Processed_dc.PO_VALUE, Dataset.ServiceContract_Raw_Processed_dc.PART_NO, Dataset.ServiceContract_Raw_Processed_dc.PRICE, Dataset.ServiceContract_Raw_Processed_dc.PERIOD_PRICE_INV_PER_YEAR, 
             Dataset.ServiceContract_Raw_Processed_dc.PM_SERVICE_INTERVAL, Dataset.ServiceContract_Raw_Processed_dc.CURRENT_CONTRACT_NUMBER, Dataset.ServiceContract_Raw_Processed_dc.CURRENT_CONTRACT_START_DATE, 
             Dataset.ServiceContract_Raw_Processed_dc.ORIGINAL_CONTRACT_NUMBER, Dataset.ServiceContract_Raw_Processed_dc.ORIGINAL_CONTRACT_END_DATE, Dataset.ServiceContract_Raw_Processed_dc.ORIGINAL_CONTRACT_START_DATE, 
             Dataset.ServiceContract_Raw_Processed_dc.CONTRACT_TERM, Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_TYPE, Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_UNIT, Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_UNIT_PRICE, 
             Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_UNIT_QTY, Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_INTERVAL, Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_NEXT_INVOICE_DATE, 
             Dataset.ServiceContract_Raw_Processed_dc.NX_OTHER1_NEXT_PERIOD_FROM_DATE, Dataset.ServiceContract_Raw_Processed_dc.NX_COMMENT, Dataset.ServiceContract_Raw_Processed_dc.NX_INVOICE_RULE, 
             Dataset.ServiceContract_Raw_Processed_dc.NX_SERVICE_NEXT_PM_BASE, Dataset.ServiceContract_Raw_Processed_dc.NX_FIRST_REVALUATION_DATE, Dataset.ServiceContract_Raw_Processed_dc.NX_REVALUATION_TYPE, 
             Dataset.ServiceContract_Raw_Processed_dc.NX_UNIT_QTY, Dataset.ServiceContract_Raw_Processed_dc.NX_CURRENT_CONTRACT
FROM   Dataset.ServiceContract_Raw_Processed_dc LEFT OUTER JOIN
             Dataset.SerialObject_Filter_Override LEFT OUTER JOIN
             Dataset.SerialObject_dc ON Dataset.SerialObject_Filter_Override.MIG_SITE_NAME = Dataset.SerialObject_dc.MIG_SITE_NAME AND Dataset.SerialObject_Filter_Override.MCH_CODE = Dataset.SerialObject_dc.MCH_CODE ON 
             Dataset.ServiceContract_Raw_Processed_dc.MIG_SITE_NAME = Dataset.SerialObject_dc.MIG_SITE_NAME AND Dataset.ServiceContract_Raw_Processed_dc.LEGACY_MACHINE_ID = Dataset.SerialObject_dc.MCH_CODE LEFT OUTER JOIN
             Dataset.Customer_Filter_Override LEFT OUTER JOIN
             Dataset.Customer_Header_dc ON Dataset.Customer_Filter_Override.MIG_SITE_NAME = Dataset.Customer_Header_dc.MIG_SITE_NAME AND Dataset.Customer_Filter_Override.CUSTOMER_ID = Dataset.Customer_Header_dc.CUSTOMER_ID ON 
             Dataset.ServiceContract_Raw_Processed_dc.MIG_SITE_NAME = Dataset.Customer_Header_dc.MIG_SITE_NAME AND Dataset.ServiceContract_Raw_Processed_dc.CUSTOMER_DELIVERY = Dataset.Customer_Header_dc.CUSTOMER_ID
WHERE (Dataset.Filter_SerialObject(Dataset.ServiceContract_Raw_Processed_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), Dataset.SerialObject_dc.NX_OPERATIONAL_STATUS, Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE, Dataset.Filter_Customer(Dataset.ServiceContract_Raw_Processed_dc.MIG_SITE_NAME, 'dc', 
             ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.ServiceContract_Raw_Processed_dc.CUSTOMER_DELIVERY, 
             Dataset.Customer_Header_dc.NAME, Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE)) > 0) AND (Dataset.Filter_Customer(Dataset.ServiceContract_Raw_Processed_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.ServiceContract_Raw_Processed_dc.CUSTOMER_DELIVERY, Dataset.Customer_Header_dc.NAME, 
             Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE) > 0)
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
         Configuration = "(H (1[29] 4[20] 2) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ServiceContract_Raw_Processed_dc (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 22
               Bottom = 447
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_dc (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 931
               Bottom = 459
               Right = 1221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Header_dc (Dataset)"
            Begin Extent = 
               Top = 364
               Left = 461
               Bottom = 776
               Right = 835
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 474
               Left = 910
               Bottom = 788
               Right = 1178
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 441
               Left = 1259
               Bottom = 778
               Right = 1501
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
 ', 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_Processed_dc_Filtered', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'        SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_Processed_dc_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_Processed_dc_Filtered', NULL, NULL
GO
