SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Dataset].[Customer_Address_ex_Filtered]
AS
SELECT Dataset.Customer_Address_DcEx.ID, Dataset.Customer_Address_DcEx.MIG_SITE_NAME, Dataset.Customer_Address_DcEx.MIG_COMMENT, Dataset.Customer_Address_DcEx.MIG_CREATED_DATE, Dataset.Customer_Address_DcEx.CUSTOMER_ID, 
             Dataset.Customer_Address_DcEx.NAME, Dataset.Customer_Address_DcEx.ADDRESS1, Dataset.Customer_Address_DcEx.ADDRESS2, Dataset.Customer_Address_DcEx.ZIP_CODE, Dataset.Customer_Address_DcEx.CITY, Dataset.Customer_Address_DcEx.COUNTY, 
             Dataset.Customer_Address_DcEx.STATE, Dataset.Customer_Address_DcEx.VAT_NO, Dataset.Customer_Address_DcEx.SPECIAL_INS, Dataset.Customer_Address_DcEx.WORK_ORDER_NOTES, Dataset.Customer_Address_DcEx.NX_SUPPLY_COUNTRY_DB, 
             Dataset.Customer_Address_DcEx.NX_DELIVERY_COUNTRY_DB, Dataset.Customer_Address_DcEx.NX_LONGITUDE, Dataset.Customer_Address_DcEx.NX_LATITUDE, Dataset.Customer_Address_DcEx.NX_ADDRESS_ID, Dataset.Customer_Address_DcEx.NX_DELIVERY_TERMS, 
             Dataset.Customer_Address_DcEx.NX_SHIP_VIA_CODE, Dataset.Customer_Address_DcEx.NX_IN_CITY, Dataset.Customer_Address_DcEx.NX_TAX_WITHHOLDING_DB, Dataset.Customer_Address_DcEx.NX_TAX_ROUNDING_METHOD_DB, 
             Dataset.Customer_Address_DcEx.NX_TAX_ROUNDING_LEVEL_DB, Dataset.Customer_Address_DcEx.NX_TAX_EXEMPT_DB, Dataset.Customer_Address_DcEx.NX_INTRASTAT_EXEMPT_DB, Dataset.Customer_Address_DcEx.NX_OPENING_AM, 
             Dataset.Customer_Address_DcEx.NX_CLOSING_AM, Dataset.Customer_Address_DcEx.NX_OPENING_PM, Dataset.Customer_Address_DcEx.NX_CLOSING_PM, Dataset.Customer_Address_DcEx.NX_MON_AM, Dataset.Customer_Address_DcEx.NX_MON_PM, 
             Dataset.Customer_Address_DcEx.NX_TUE_AM, Dataset.Customer_Address_DcEx.NX_TUE_PM, Dataset.Customer_Address_DcEx.NX_WED_AM, Dataset.Customer_Address_DcEx.NX_WED_PM, Dataset.Customer_Address_DcEx.NX_THU_AM, 
             Dataset.Customer_Address_DcEx.NX_THU_PM, Dataset.Customer_Address_DcEx.NX_FRI_AM, Dataset.Customer_Address_DcEx.NX_FRI_PM, Dataset.Customer_Address_DcEx.NX_SAT_AM, Dataset.Customer_Address_DcEx.NX_SAT_PM, 
             Dataset.Customer_Address_DcEx.NX_SUN_AM, Dataset.Customer_Address_DcEx.NX_SUN_PM, Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_DELIVERY, Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_INVOICE, 
             Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_PAY, Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_HOME, Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_PRIMARY, Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_SECONDARY, 
             Dataset.Customer_Address_DcEx.NX_DEF_ADDRESS_VISIT, Dataset.Customer_Address_DcEx.NX_TAX_REGIME_DB, Dataset.Customer_Address_DcEx.NX_COUNTRY_DB, Dataset.Customer_Address_DcEx.NX_COMPANY
FROM   Dataset.Customer_Address_DcEx LEFT OUTER JOIN
             Dataset.Customer_Filter_Override ON Dataset.Customer_Address_DcEx.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND Dataset.Customer_Address_DcEx.CUSTOMER_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID LEFT OUTER JOIN
             Dataset.Customer_Header_DcEx ON Dataset.Customer_Address_DcEx.MIG_SITE_NAME = Dataset.Customer_Header_DcEx.MIG_SITE_NAME AND Dataset.Customer_Address_DcEx.CUSTOMER_ID = Dataset.Customer_Header_DcEx.CUSTOMER_ID
WHERE (Dataset.Filter_Customer(Dataset.Customer_Address_DcEx.MIG_SITE_NAME, 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
             Dataset.Customer_Address_DcEx.CUSTOMER_ID, Dataset.Customer_Address_DcEx.NAME, Dataset.Customer_Header_DcEx.CRM_ACCOUNT_TYPE) > 0)
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
         Configuration = "(H (1[43] 4[15] 2) )"
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
         Begin Table = "Customer_Address_DcEx (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 435
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 254
               Left = 483
               Bottom = 451
               Right = 751
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Header_DcEx (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 492
               Bottom = 206
               Right = 897
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
         Column = 11720
         Alias = 900
         Table = 2890
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
', 'SCHEMA', N'Dataset', 'VIEW', N'Customer_Address_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'Customer_Address_ex_Filtered', NULL, NULL
GO
