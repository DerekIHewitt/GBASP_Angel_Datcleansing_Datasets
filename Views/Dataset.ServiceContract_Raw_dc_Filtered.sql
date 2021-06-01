SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Dataset].[ServiceContract_Raw_dc_Filtered]
AS
SELECT        Dataset.ServiceContract_Raw_dc.ID, Dataset.ServiceContract_Raw_dc.MIG_SITE_NAME, Dataset.ServiceContract_Raw_dc.MIG_CREATED_DATE, Dataset.ServiceContract_Raw_dc.CUSTOMER_INVOICE, 
                         Dataset.ServiceContract_Raw_dc.CUSTOMER_DELIVERY, Dataset.ServiceContract_Raw_dc.CONTRACT_NAME, Dataset.ServiceContract_Raw_dc.MATRIX_TYPES, Dataset.ServiceContract_Raw_dc.MACHINE_LEGACY_UID, 
                         Dataset.ServiceContract_Raw_dc.MACHINE_PART_NUM, Dataset.ServiceContract_Raw_dc.MACHINE_OWNER, Dataset.ServiceContract_Raw_dc.PO_NUMBER, Dataset.ServiceContract_Raw_dc.PO_VALUE, 
                         Dataset.ServiceContract_Raw_dc.PO_VALID_FROM, Dataset.ServiceContract_Raw_dc.PO_EXPIRY_DATE, Dataset.ServiceContract_Raw_dc.BILLING_IFS_FROM_DATE, Dataset.ServiceContract_Raw_dc.RENT_UNIT, 
                         Dataset.ServiceContract_Raw_dc.RENT_PER_UNIT, Dataset.ServiceContract_Raw_dc.RENT_INVOICE_FREQ, Dataset.ServiceContract_Raw_dc.RENT_IN_ADVANCE, 
                         Dataset.ServiceContract_Raw_dc.RENT_NEXT_INVOICE_DATE, Dataset.ServiceContract_Raw_dc.RENT_NEXT_PERIOD_FROM_DATE, Dataset.ServiceContract_Raw_dc.SERVICE_UNIT, 
                         Dataset.ServiceContract_Raw_dc.SERVICE_PER_UNIT, Dataset.ServiceContract_Raw_dc.SERVICE_INVOICE_FREQ, Dataset.ServiceContract_Raw_dc.SERVICE_FREQ, Dataset.ServiceContract_Raw_dc.SERVICE_IN_ADVANCE, 
                         Dataset.ServiceContract_Raw_dc.SERVICE_NEXT_INVOICE_DATE, Dataset.ServiceContract_Raw_dc.SERVICE_NEXT_PERIOD_FROM, Dataset.ServiceContract_Raw_dc.SERVICE_NEXT_PM_BASE, 
                         Dataset.ServiceContract_Raw_dc.SERVICE_PM_START_VALUE, Dataset.ServiceContract_Raw_dc.ENV_UNIT, Dataset.ServiceContract_Raw_dc.ENV_PRICE_PER_UNIT, Dataset.ServiceContract_Raw_dc.ENV_INV_FREQ, 
                         Dataset.ServiceContract_Raw_dc.ENV_NEXT_INVOICE_DATE, Dataset.ServiceContract_Raw_dc.ENV_NEXT_PERIOD_FROM, Dataset.ServiceContract_Raw_dc.OTHER1_TYPE, 
                         Dataset.ServiceContract_Raw_dc.OTHER1_SUBTYPE, Dataset.ServiceContract_Raw_dc.OTHER1_UNIT, Dataset.ServiceContract_Raw_dc.OTHER1_PRICE_PER_UNIT, Dataset.ServiceContract_Raw_dc.OTHER1_INVOICE_FREQ, 
                         Dataset.ServiceContract_Raw_dc.OTHER1_INVOICE_QTY, Dataset.ServiceContract_Raw_dc.OTHER1_NEXT_INVOICE_DATE, Dataset.ServiceContract_Raw_dc.OTHER1_NEXT_PERIOD_FROM, 
                         Dataset.ServiceContract_Raw_dc.OTHER2_TYPE, Dataset.ServiceContract_Raw_dc.OTHER2_SUBTYPE, Dataset.ServiceContract_Raw_dc.OTHER2_UNIT, Dataset.ServiceContract_Raw_dc.OTHER2_PRICE_PER_UNIT, 
                         Dataset.ServiceContract_Raw_dc.OTHER2_INVOICE_FREQ, Dataset.ServiceContract_Raw_dc.OTHER2_INVOICE_QTY, Dataset.ServiceContract_Raw_dc.OTHER2_NEXT_INVOICE_DATE, 
                         Dataset.ServiceContract_Raw_dc.OTHER2_NEXT_PERIOD_FROM, Dataset.ServiceContract_Raw_dc.HASADDITIONALDATA, Dataset.ServiceContract_Raw_dc.SLA_EXC, Dataset.ServiceContract_Raw_dc.SLA_SWP, 
                         Dataset.ServiceContract_Raw_dc.SLA_SER, Dataset.ServiceContract_Raw_dc.SLA_TER, Dataset.ServiceContract_Raw_dc.SLA_CMA, Dataset.ServiceContract_Raw_dc.SLA_DEL, 
                         Dataset.ServiceContract_Raw_dc.CURRENT_CONTRACT, Dataset.ServiceContract_Raw_dc.CURRENT_CONTRACT_NUMBER, Dataset.ServiceContract_Raw_dc.CURRENT_START_DATE, 
                         Dataset.ServiceContract_Raw_dc.ORIGINAL_CONTRACT_NUMBER, Dataset.ServiceContract_Raw_dc.ORIGINAL_END_DATE, Dataset.ServiceContract_Raw_dc.ORIGINAL_START_DATE, 
                         Dataset.ServiceContract_Raw_dc.CONTRACT_TERM, Dataset.ServiceContract_Raw_dc.COMMENT
FROM            Dataset.ServiceContract_Raw_dc LEFT OUTER JOIN
                         Dataset.SerialObject_Filter_Override LEFT OUTER JOIN
                         Dataset.SerialObject_dc ON Dataset.SerialObject_Filter_Override.MIG_SITE_NAME = Dataset.SerialObject_dc.MIG_SITE_NAME AND Dataset.SerialObject_Filter_Override.MCH_CODE = Dataset.SerialObject_dc.MCH_CODE ON 
                         Dataset.ServiceContract_Raw_dc.MIG_SITE_NAME = Dataset.SerialObject_dc.MIG_SITE_NAME AND Dataset.ServiceContract_Raw_dc.MACHINE_LEGACY_UID = Dataset.SerialObject_dc.MCH_CODE LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override LEFT OUTER JOIN
                         Dataset.Customer_Header_dc ON Dataset.Customer_Filter_Override.MIG_SITE_NAME = Dataset.Customer_Header_dc.MIG_SITE_NAME AND 
                         Dataset.Customer_Filter_Override.CUSTOMER_ID = Dataset.Customer_Header_dc.CUSTOMER_ID ON Dataset.ServiceContract_Raw_dc.MIG_SITE_NAME = Dataset.Customer_Header_dc.MIG_SITE_NAME AND 
                         Dataset.ServiceContract_Raw_dc.CUSTOMER_DELIVERY = Dataset.Customer_Header_dc.CUSTOMER_ID
WHERE        (Dataset.Filter_SerialObject(Dataset.ServiceContract_Raw_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), Dataset.SerialObject_dc.NX_OPERATIONAL_STATUS, Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE, 
                         Dataset.Filter_Customer(Dataset.ServiceContract_Raw_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.ServiceContract_Raw_dc.CUSTOMER_DELIVERY, Dataset.Customer_Header_dc.NAME, Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE)) > 0) AND 
                         (Dataset.Filter_Customer(Dataset.ServiceContract_Raw_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.ServiceContract_Raw_dc.CUSTOMER_DELIVERY, Dataset.Customer_Header_dc.NAME, Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE) > 0)
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
         Begin Table = "ServiceContract_Raw_dc (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 266
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 342
               Bottom = 136
               Right = 524
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_dc (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 562
               Bottom = 136
               Right = 795
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 833
               Bottom = 136
               Right = 1031
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Header_dc (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 1069
               Bottom = 136
               Right = 1358
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
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
         SortType = 1350
         Sort', 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_dc_Filtered', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'Order = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_dc_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'ServiceContract_Raw_dc_Filtered', NULL, NULL
GO
