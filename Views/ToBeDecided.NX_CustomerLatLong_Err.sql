SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ToBeDecided].[NX_CustomerLatLong_Err]
AS
SELECT        dbo.Syn_NX_CustomerLatLong_err.MIG_SITE_NAME, dbo.Syn_NX_CustomerLatLong_err.LONGITUDE, dbo.Syn_NX_CustomerLatLong_err.LATITUDE, dbo.Syn_NX_CustomerLatLong_err.MIG_ERROR, 
                         dbo.Syn_NX_CustomerLatLong_err.[IDENTITY], dbo.Syn_NX_MAP_Customer.LEGACY_CUSTOMER_REF, dbo.Syn_NX_MAP_Customer.ExistsInLastRun, dbo.Syn_NX_MAP_Customer.GeoLong, 
                         dbo.Syn_NX_MAP_Customer.GeoLat
FROM            dbo.Syn_NX_CustomerLatLong_err INNER JOIN
                         dbo.Syn_NX_MAP_Customer ON dbo.Syn_NX_CustomerLatLong_err.[IDENTITY] = dbo.Syn_NX_MAP_Customer.IFS_CUSTOMER_ID AND 
                         dbo.Syn_NX_CustomerLatLong_err.MIG_SITE_NAME = dbo.Syn_NX_MAP_Customer.MIG_SITE_NAME
WHERE        (dbo.Syn_NX_CustomerLatLong_err.MIG_SITE_NAME = 'AUPER')
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
         Begin Table = "Syn_NX_CustomerLatLong_err"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 300
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Syn_NX_MAP_Customer"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 305
               Right = 474
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
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3585
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3810
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
', 'SCHEMA', N'ToBeDecided', 'VIEW', N'NX_CustomerLatLong_Err', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'ToBeDecided', 'VIEW', N'NX_CustomerLatLong_Err', NULL, NULL
GO
