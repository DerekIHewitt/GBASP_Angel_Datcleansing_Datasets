SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Dataset].[Supplier_dc_Filtered]
AS
SELECT        Dataset.Supplier_dc.ID, Dataset.Supplier_dc.MIG_SITE_NAME, Dataset.Supplier_dc.MIG_COMMENT, Dataset.Supplier_dc.MIG_CREATED_DATE, Dataset.Supplier_dc.NX_IDENTITY, Dataset.Supplier_dc.NX_NAME, 
                         Dataset.Supplier_dc.NX_COUNTRY_DB, Dataset.Supplier_dc.NX_ADDRESS1, Dataset.Supplier_dc.NX_ADDRESS2, Dataset.Supplier_dc.NX_ZIPCODE, Dataset.Supplier_dc.NX_CITY, Dataset.Supplier_dc.NX_COUNTY, 
                         Dataset.Supplier_dc.NX_STATE, Dataset.Supplier_dc.NX_CONTACT, Dataset.Supplier_dc.NX_GROUP_ID, Dataset.Supplier_dc.NX_SUPP_STAT_GRP, Dataset.Supplier_dc.NX_CURRENCY_CODE, 
                         Dataset.Supplier_dc.NX_PAY_WAY_ID, Dataset.Supplier_dc.NX_PAY_TERM_ID, Dataset.Supplier_dc.NX_PAY_ACCOUNT, Dataset.Supplier_dc.NX_SORT_CODE, Dataset.Supplier_dc.NX_BANK_NAME, 
                         Dataset.Supplier_dc.NX_LEGACY_SUPPLIER, Dataset.Supplier_dc.NX_PHONE, Dataset.Supplier_dc.NX_FAX, Dataset.Supplier_dc.NX_WWW, Dataset.Supplier_dc.NX_E_MAIL, Dataset.Supplier_dc.NX_ASSOCIATION_NO, 
                         Dataset.Supplier_dc.NX_DEFAULT_CURRENCY, Dataset.Supplier_dc.NX_OLD_SUPPLIER_REF, Dataset.Supplier_dc.NX_VAT_NO, Dataset.Supplier_dc.NX_PURCHASE_CODE, 
                         Dataset.Supplier_dc.NX_INVOICE_TAX_DELIVERY_TYPE, Dataset.Supplier_dc.NX_INVOICING_SUPPLIER, Dataset.Supplier_dc.NX_VAT_CODE, Dataset.Filter_Supplier(Dataset.Supplier_dc.MIG_SITE_NAME, 'dc', 
                         ISNULL(Dataset.Supplier_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Supplier_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Supplier_Filter_Override.IsOnSubSetList, 0), Dataset.Supplier_dc.NX_IDENTITY, 
                         Dataset.Supplier_dc.NX_NAME) AS NX_FILTER_STATUS
FROM            Dataset.Supplier_dc LEFT OUTER JOIN
                         Dataset.Supplier_Filter_Override ON Dataset.Supplier_dc.MIG_SITE_NAME = Dataset.Supplier_Filter_Override.MIG_SITE_NAME AND Dataset.Supplier_dc.NX_IDENTITY = Dataset.Supplier_Filter_Override.Supplier_ID
WHERE        (Dataset.Filter_Supplier(Dataset.Supplier_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Supplier_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Supplier_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Supplier_Filter_Override.IsOnSubSetList, 0), Dataset.Supplier_dc.NX_IDENTITY, Dataset.Supplier_dc.NX_NAME) > 0)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[29] 3) )"
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
         Begin Table = "Supplier_dc (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 293
               Right = 344
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "Supplier_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 382
               Bottom = 136
               Right = 580
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
         Column = 6600
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
', 'SCHEMA', N'Dataset', 'VIEW', N'Supplier_dc_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'Supplier_dc_Filtered', NULL, NULL
GO
