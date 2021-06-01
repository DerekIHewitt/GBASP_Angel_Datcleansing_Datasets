SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Dataset].[ServiceContract_Raw_Processed_ex_Filtered]
AS
SELECT Dataset.ServiceContract_Raw_Processed_DcEx.ID, Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SITE_NAME, Dataset.ServiceContract_Raw_Processed_DcEx.MIG_CREATED_DATE, Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SRC_CREATED_DATE, 
             Dataset.ServiceContract_Raw_Processed_DcEx.CONTRACT_NAME, Dataset.ServiceContract_Raw_Processed_DcEx.SITE, Dataset.ServiceContract_Raw_Processed_DcEx.CUSTOMER_INVOICE, Dataset.ServiceContract_Raw_Processed_DcEx.CUSTOMER_DELIVERY, 
             Dataset.ServiceContract_Raw_Processed_DcEx.MATRIX_TYPE, Dataset.ServiceContract_Raw_Processed_DcEx.INTERVAL_UNIT, Dataset.ServiceContract_Raw_Processed_DcEx.INVOICE_START_DATE, Dataset.ServiceContract_Raw_Processed_DcEx.NEXT_PM_DATE, 
             Dataset.ServiceContract_Raw_Processed_DcEx.PO_VALID_FROM, Dataset.ServiceContract_Raw_Processed_DcEx.PO_EXPIRY_DATE, Dataset.ServiceContract_Raw_Processed_DcEx.PO_NUMBER, Dataset.ServiceContract_Raw_Processed_DcEx.PO_VALUE, 
             Dataset.ServiceContract_Raw_Processed_DcEx.PART_NO, Dataset.ServiceContract_Raw_Processed_DcEx.PRICE, Dataset.ServiceContract_Raw_Processed_DcEx.LEGACY_MACHINE_ID, Dataset.ServiceContract_Raw_Processed_DcEx.PERIOD_PRICE_INV_PER_YEAR, 
             Dataset.ServiceContract_Raw_Processed_DcEx.PM_SERVICE_INTERVAL, Dataset.ServiceContract_Raw_Processed_DcEx.CURRENT_CONTRACT_NUMBER, Dataset.ServiceContract_Raw_Processed_DcEx.CURRENT_CONTRACT_START_DATE, 
             Dataset.ServiceContract_Raw_Processed_DcEx.ORIGINAL_CONTRACT_NUMBER, Dataset.ServiceContract_Raw_Processed_DcEx.ORIGINAL_CONTRACT_END_DATE, Dataset.ServiceContract_Raw_Processed_DcEx.ORIGINAL_CONTRACT_START_DATE, 
             Dataset.ServiceContract_Raw_Processed_DcEx.CONTRACT_TERM, Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_TYPE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_UNIT, 
             Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_UNIT_PRICE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_UNIT_QTY, Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_INTERVAL, 
             Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_NEXT_INVOICE_DATE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_OTHER1_NEXT_PERIOD_FROM_DATE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_COMMENT, 
             Dataset.ServiceContract_Raw_Processed_DcEx.NX_INVOICE_RULE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_SERVICE_NEXT_PM_BASE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_FIRST_REVALUATION_DATE, 
             Dataset.ServiceContract_Raw_Processed_DcEx.NX_REVALUATION_TYPE, Dataset.ServiceContract_Raw_Processed_DcEx.NX_UNIT_QTY, Dataset.ServiceContract_Raw_Processed_DcEx.NX_CURRENT_CONTRACT
FROM   Dataset.ServiceContract_Raw_Processed_DcEx LEFT OUTER JOIN
             Dataset.Customer_Header_DcEx ON Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SITE_NAME = Dataset.Customer_Header_DcEx.MIG_SITE_NAME AND 
             Dataset.ServiceContract_Raw_Processed_DcEx.CUSTOMER_DELIVERY = Dataset.Customer_Header_DcEx.CUSTOMER_ID LEFT OUTER JOIN
             Dataset.Customer_Filter_Override ON Dataset.Customer_Header_DcEx.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND Dataset.Customer_Header_DcEx.CUSTOMER_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID LEFT OUTER JOIN
             Dataset.SerialObject_DcEx ON Dataset.SerialObject_DcEx.MIG_SITE_NAME = Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SITE_NAME AND 
             Dataset.SerialObject_DcEx.MCH_CODE = Dataset.ServiceContract_Raw_Processed_DcEx.LEGACY_MACHINE_ID LEFT OUTER JOIN
             Dataset.SerialObject_Filter_Override ON Dataset.SerialObject_Filter_Override.MIG_SITE_NAME = Dataset.SerialObject_DcEx.MIG_SITE_NAME AND Dataset.SerialObject_Filter_Override.MCH_CODE = Dataset.SerialObject_DcEx.MCH_CODE
WHERE (Dataset.Filter_Customer(Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SITE_NAME, 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.ServiceContract_Raw_Processed_DcEx.CUSTOMER_DELIVERY, Dataset.Customer_Header_DcEx.NAME, Dataset.Customer_Header_DcEx.CRM_ACCOUNT_TYPE) > 0) AND 
             (Dataset.Filter_SerialObject(Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SITE_NAME, 'ex', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), Dataset.SerialObject_DcEx.NX_OPERATIONAL_STATUS, Dataset.Customer_Header_DcEx.CRM_ACCOUNT_TYPE, Dataset.Filter_Customer(Dataset.ServiceContract_Raw_Processed_DcEx.MIG_SITE_NAME, 'ex', 
             ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.ServiceContract_Raw_Processed_DcEx.CUSTOMER_DELIVERY, 
             Dataset.Customer_Header_DcEx.NAME, Dataset.Customer_Header_DcEx.CRM_ACCOUNT_TYPE)) > 0)
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
         Configuration = "(H (1[39] 4[36] 3) )"
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
         Configuration = "(H (1[67] 4[12] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[75] 4) )"
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
         Begin Table = "Customer_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 8
               Left = 1311
               Bottom = 339
               Right = 1579
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 381
               Left = 992
               Bottom = 695
               Right = 1234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceContract_Raw_Processed_DcEx (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 735
               Right = 483
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Header_DcEx (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 605
               Bottom = 339
               Right = 1010
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_DcEx (Dataset)"
            Begin Extent = 
               Top = 381
               Left = 598
               Bottom = 780
               Right = 919
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
         NewValue = 1170', 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_Processed_ex_Filtered', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
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
', 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_Processed_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_Processed_ex_Filtered', NULL, NULL
GO
