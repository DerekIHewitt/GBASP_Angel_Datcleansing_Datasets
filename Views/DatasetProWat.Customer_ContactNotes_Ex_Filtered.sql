SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*-HI DEREK, PLEASE CAN WE REFERENCE THE MIG CONTROL DATE SO IS ALWAYS 12 MONTHS FROM THE CUT DATE*/
CREATE VIEW [DatasetProWat].[Customer_ContactNotes_Ex_Filtered]
AS
SELECT DISTINCT 
                  CL.CLG_Account AS Customer_ID, dbo.ConvertFromClarion(CL.CLG_ContactDate) AS Note_date, CL.CLG_ContactName AS Contact_Name, REPLACE(REPLACE(CL.CLG_ShortNotes, CHAR(10), ''), CHAR(13), '') AS Note_Short, 
                  REPLACE(REPLACE(CL.CLG_LongNotes, CHAR(10), ''), CHAR(13), '') AS Note_Long, R.REA_Description AS Note_Reason, 'IFSAPP' AS Contact_User, 'GBASP' AS MIG_SITE_NAME
FROM     DatasetProWat.Syn_ContLog_ex AS CL WITH (NOLOCK) INNER JOIN
                  DatasetProWat.Syn_Reason_ex AS R WITH (NOLOCK) ON R.REA_ReasonID = CL.CLG_ReasonID INNER JOIN
                      (SELECT CUSTOMER_ID, isAlwaysIncluded
                       FROM      Dataset.Customer_Filter_Override
                       WHERE   (isAlwaysIncluded = 1)) AS F ON F.CUSTOMER_ID = CL.CLG_Account
WHERE  (dbo.ConvertFromClarion(CL.CLG_ContactDate) >
                      (SELECT CONVERT(datetime, ParamValue) AS Expr1
                       FROM      NEXUS_Transform.dbo.MIG_Control
                       WHERE   (MIG_SITE_NAME = 'GBASP') AND (Param = 'ServiceContract:DefaultStartDate')) - 365)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[25] 2[41] 3) )"
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
         Configuration = "(H (4[52] 2) )"
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
      ActivePaneConfig = 11
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CL"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 266
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "R"
            Begin Extent = 
               Top = 7
               Left = 314
               Bottom = 170
               Right = 518
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent = 
               Top = 7
               Left = 556
               Bottom = 126
               Right = 764
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5400
         Alias = 3900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1692
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'DatasetProWat', 'VIEW', N'Customer_ContactNotes_Ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetProWat', 'VIEW', N'Customer_ContactNotes_Ex_Filtered', NULL, NULL
GO
