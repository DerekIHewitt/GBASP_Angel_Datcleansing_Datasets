SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Dataset].[SerialObject_ex_Filtered]
AS
SELECT        Dataset.SerialObject_DcEx.ID, Dataset.SerialObject_DcEx.MIG_SITE_NAME, Dataset.SerialObject_DcEx.MIG_CREATED_DATE, Dataset.SerialObject_DcEx.MIG_COMMENT, Dataset.SerialObject_DcEx.MCH_CODE, 
                         Dataset.SerialObject_DcEx.MCH_NAME, Dataset.SerialObject_DcEx.CUSTOMER_ID, Dataset.SerialObject_DcEx.PART_NO, Dataset.SerialObject_DcEx.SERIAL_NO, Dataset.SerialObject_DcEx.INSTALLATION_DATE, 
                         Dataset.SerialObject_DcEx.OWNERSHIP, Dataset.SerialObject_DcEx.LOCATION1, Dataset.SerialObject_DcEx.LOCATION2, Dataset.SerialObject_DcEx.NX_LATITUDE, Dataset.SerialObject_DcEx.NX_LONGITUDE, 
                         Dataset.SerialObject_DcEx.NX_OPERATIONAL_STATUS, Dataset.SerialObject_DcEx.OWNER, Dataset.SerialObject_DcEx.NX_HAS_PEDAL, Dataset.SerialObject_DcEx.NX_WARRANTY_END_DATE
FROM            Dataset.SerialObject_DcEx LEFT OUTER JOIN
                         Dataset.SerialObject_Filter_Override ON Dataset.SerialObject_DcEx.MIG_SITE_NAME = Dataset.SerialObject_Filter_Override.MIG_SITE_NAME AND 
                         Dataset.SerialObject_DcEx.MCH_CODE = Dataset.SerialObject_Filter_Override.MCH_CODE LEFT OUTER JOIN
                         Dataset.Customer_Header_DcEx ON Dataset.SerialObject_DcEx.MIG_SITE_NAME = Dataset.Customer_Header_DcEx.MIG_SITE_NAME AND 
                         Dataset.SerialObject_DcEx.CUSTOMER_ID = Dataset.Customer_Header_DcEx.CUSTOMER_ID LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override ON Dataset.Customer_Header_DcEx.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND 
                         Dataset.Customer_Header_DcEx.CUSTOMER_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID
WHERE        (Dataset.Filter_SerialObject(Dataset.SerialObject_DcEx.MIG_SITE_NAME, 'ex', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), Dataset.SerialObject_DcEx.NX_OPERATIONAL_STATUS, Dataset.Customer_Header_DcEx.CRM_ACCOUNT_TYPE, 
                         Dataset.Filter_Customer(Dataset.SerialObject_DcEx.MIG_SITE_NAME, 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.SerialObject_DcEx.CUSTOMER_ID, Dataset.Customer_Header_DcEx.NAME, Dataset.Customer_Header_DcEx.CRM_ACCOUNT_TYPE)) > 0)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[26] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[40] 4) )"
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
         Begin Table = "SerialObject_DcEx (Dataset)"
            Begin Extent = 
               Top = 12
               Left = 373
               Bottom = 544
               Right = 694
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SerialObject_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 6
               Left = 18
               Bottom = 508
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Header_DcEx (Dataset)"
            Begin Extent = 
               Top = 58
               Left = 881
               Bottom = 255
               Right = 1286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer_Filter_Override (Dataset)"
            Begin Extent = 
               Top = 41
               Left = 1439
               Bottom = 238
               Right = 1707
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
         Column = 29775
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
', 'SCHEMA', N'Dataset', 'VIEW', N'SerialObject_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Dataset', 'VIEW', N'SerialObject_ex_Filtered', NULL, NULL
GO
