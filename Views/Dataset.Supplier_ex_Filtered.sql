SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Dataset].[Supplier_ex_Filtered]
AS
SELECT Dataset.Supplier_DcEx.ID, Dataset.Supplier_DcEx.MIG_SITE_NAME, Dataset.Supplier_DcEx.MIG_COMMENT, Dataset.Supplier_DcEx.MIG_CREATED_DATE, Dataset.Supplier_DcEx.NX_IDENTITY, Dataset.Supplier_DcEx.NX_NAME, Dataset.Supplier_DcEx.NX_COUNTRY_DB, 
             Dataset.Supplier_DcEx.NX_ADDRESS1, Dataset.Supplier_DcEx.NX_ADDRESS2, Dataset.Supplier_DcEx.NX_ZIPCODE, Dataset.Supplier_DcEx.NX_CITY, Dataset.Supplier_DcEx.NX_COUNTY, Dataset.Supplier_DcEx.NX_STATE, Dataset.Supplier_DcEx.NX_CONTACT, 
             Dataset.Supplier_DcEx.NX_GROUP_ID, Dataset.Supplier_DcEx.NX_SUPP_STAT_GRP, Dataset.Supplier_DcEx.NX_CURRENCY_CODE, Dataset.Supplier_DcEx.NX_PAY_WAY_ID, Dataset.Supplier_DcEx.NX_PAY_TERM_ID, Dataset.Supplier_DcEx.NX_PAY_ACCOUNT, 
             Dataset.Supplier_DcEx.NX_SORT_CODE, Dataset.Supplier_DcEx.NX_BANK_NAME, Dataset.Supplier_DcEx.NX_LEGACY_SUPPLIER, Dataset.Supplier_DcEx.NX_PHONE, Dataset.Supplier_DcEx.NX_FAX, Dataset.Supplier_DcEx.NX_WWW, Dataset.Supplier_DcEx.NX_E_MAIL, 
             Dataset.Supplier_DcEx.NX_ASSOCIATION_NO, Dataset.Supplier_DcEx.NX_DEFAULT_CURRENCY, Dataset.Supplier_DcEx.NX_OLD_SUPPLIER_REF, Dataset.Supplier_DcEx.NX_VAT_NO, Dataset.Supplier_DcEx.NX_PURCHASE_CODE, 
             Dataset.Supplier_DcEx.NX_INVOICE_TAX_DELIVERY_TYPE, Dataset.Supplier_DcEx.NX_INVOICING_SUPPLIER, Dataset.Supplier_DcEx.NX_VAT_CODE
FROM   Dataset.Supplier_DcEx LEFT OUTER JOIN
             Dataset.Supplier_Filter_Override ON Dataset.Supplier_DcEx.MIG_SITE_NAME = Dataset.Supplier_Filter_Override.MIG_SITE_NAME AND Dataset.Supplier_DcEx.NX_IDENTITY = Dataset.Supplier_Filter_Override.Supplier_ID
WHERE (Dataset.Filter_Supplier(Dataset.Supplier_DcEx.MIG_SITE_NAME, 'ex', ISNULL(Dataset.Supplier_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Supplier_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Supplier_Filter_Override.IsOnSubSetList, 0), 
             Dataset.Supplier_DcEx.NX_IDENTITY, Dataset.Supplier_DcEx.NX_NAME) > 0)
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
         Top = -144
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Supplier_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 484
               Bottom = 417
               Right = 752
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Supplier_DcEx (Dataset)"
            Begin Extent = 
               Top = 153
               Left = 57
               Bottom = 350
               Right = 427
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
         Column = 3480
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
', 'SCHEMA', N'Dataset', 'VIEW', N'Supplier_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'Supplier_ex_Filtered', NULL, NULL
GO
