SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DatasetCariad].[SerialObject_ex_Filtered]
AS
SELECT        ID, ISNULL(MIG_COMMENT, '') AS MIG_COMMENT, MIG_CREATED_DATE, MIG_SITE_NAME, MCH_CODE, MCH_NAME, ISNULL(CUSTOMER_ID, '') AS CUSTOMER_ID, PART_NO, SERIAL_NO, INSTALLATION_DATE, 
                         ISNULL(NX_LATITUDE, '') AS NX_LATITUDE, ISNULL(NX_LONGITUDE, '') AS NX_LONGITUDE, OWNERSHIP, ISNULL(OWNER, '') AS OWNER, ISNULL(LOCATION1, '') AS LOCATION1, ISNULL(LOCATION2, '') AS LOCATION2, 
                         LEGACY_REFERENCE, DELIVERY_ADDRESS, ISNULL(NX_HAS_PEDAL, '') AS NX_HAS_PEDAL, ISNULL(NX_OPERATIONAL_STATUS, '') AS NX_OPERATIONAL_STATUS, NX_WARRANTY_END_DATE
FROM            OPENQUERY(CARIAD, 
                         'select
       rownum AS ID,
	   '''' AS MIG_COMMENT,
	   sysdate AS MIG_CREATED_DATE,
       ''GBCA1'' AS MIG_SITE_NAME,
       S.MCH_CODE,
       S.MCH_NAME,
       SUP_MCH_CODE AS CUSTOMER_ID,
       PART_NO,
       SERIAL_NO,
      NVL(PRODUCTION_DATE, to_date(''2022-01-01'',''yyyy-mm-dd'')) AS INSTALLATION_DATE,
       '''' AS NX_LATITUDE,
       '''' AS NX_LONGITUDE,
       OWNERSHIP, -- AS GOING INTO SRC TABLE, CAN EITHER DO A CASE TO CHANGE VALUE TO R / S OR CAN SET AS LOV/LEAVE AS IS AND STATE FOR GBCA1 PASS VALUES THROUGH
       OWNER,
       MCH_LOC AS LOCATION1,
       MCH_POS AS LOCATION2,
       SUP_MCH_CODE AS LEGACY_REFERENCE,
       '''' AS DELIVERY_ADDRESS,
       '''' AS NX_HAS_PEDAL,
       OPERATIONAL_STATUS_DB AS NX_OPERATIONAL_STATUS,
       s.warr_exp as NX_WARRANTY_END_DATE

  from equipment_serial_cfv S
  
')
                          AS derivedtbl_1
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[32] 2[20] 3) )"
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
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 272
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
         Column = 3270
         Alias = 6135
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
', 'SCHEMA', N'DatasetCariad', 'VIEW', N'SerialObject_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetCariad', 'VIEW', N'SerialObject_ex_Filtered', NULL, NULL
GO
