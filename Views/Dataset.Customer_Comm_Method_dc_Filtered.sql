SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Dataset].[Customer_Comm_Method_dc_Filtered]
AS
SELECT Dataset.Customer_Comm_Method_dc.ID, Dataset.Customer_Comm_Method_dc.MIG_SITE_NAME, Dataset.Customer_Comm_Method_dc.MIG_COMMENT, Dataset.Customer_Comm_Method_dc.MIG_CREATED_DATE, Dataset.Customer_Comm_Method_dc.PARTY_TYPE_DB, 
             Dataset.Customer_Comm_Method_dc.[IDENTITY], Dataset.Customer_Comm_Method_dc.COMM_ID, Dataset.Customer_Comm_Method_dc.COMM_NAME, Dataset.Customer_Comm_Method_dc.COMM_DESCRIPTION, Dataset.Customer_Comm_Method_dc.METHOD_ID_DB, 
             Dataset.Customer_Comm_Method_dc.COMM_METHOD_VALUE, Dataset.Customer_Comm_Method_dc.DEFAULT_PER_METHOD, Dataset.Customer_Comm_Method_dc.EXT_NO, Dataset.Customer_Comm_Method_dc.POD_EMAIL_DB, 
             Dataset.Customer_Comm_Method_dc.NX_COMPANY, Dataset.Customer_Comm_Method_dc.NX_ADDRESS_ID, Dataset.Customer_Comm_Method_dc.NX_ADDRESS_DEFAULT, Dataset.Filter_Customer(Dataset.Customer_Comm_Method_dc.MIG_SITE_NAME, 'dc', 
             ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.Customer_Comm_Method_dc.[IDENTITY], Dataset.Customer_Header_dc.NAME, 
             Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE) AS NX_FILTER_STATUS
FROM   Dataset.Customer_Comm_Method_dc LEFT OUTER JOIN
             Dataset.Customer_Filter_Override ON Dataset.Customer_Comm_Method_dc.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND Dataset.Customer_Comm_Method_dc.[IDENTITY] = Dataset.Customer_Filter_Override.CUSTOMER_ID LEFT OUTER JOIN
             Dataset.Customer_Header_dc ON Dataset.Customer_Comm_Method_dc.MIG_SITE_NAME = Dataset.Customer_Header_dc.MIG_SITE_NAME AND Dataset.Customer_Comm_Method_dc.[IDENTITY] = Dataset.Customer_Header_dc.CUSTOMER_ID
WHERE (Dataset.Filter_Customer(Dataset.Customer_Comm_Method_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
             Dataset.Customer_Comm_Method_dc.[IDENTITY], Dataset.Customer_Header_dc.NAME, Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE) > 0)
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
         Top = -76
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Customer_Comm_Method_dc (Dataset)"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 416
               Right = 660
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Header_dc (Dataset)"
            Begin Extent = 
               Top = 15
               Left = 705
               Bottom = 413
               Right = 1079
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
         Column = 5265
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
', 'SCHEMA', N'Dataset', 'VIEW', N'Customer_Comm_Method_dc_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'Customer_Comm_Method_dc_Filtered', NULL, NULL
GO
