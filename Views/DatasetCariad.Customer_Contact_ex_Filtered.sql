SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [DatasetCariad].[Customer_Contact_ex_Filtered]
AS
SELECT        MIG_SITE_NAME, ISNULL(PERSON_ID, '1') AS NX_PERSON_ID, ISNULL(FIRST_NAME, '.') AS FIRST_NAME, ISNULL(MIDDLE_NAME, '') AS MIDDLE_NAME, ISNULL(LAST_NAME, '.') AS LAST_NAME, ISNULL(TITLE, '') 
                         AS NX_TITLE, ISNULL(CUSTOMER_ID, '') AS CUSTOMER_ID, ISNULL(CUSTOMER_PRIMARY, 'TRUE') AS NX_CUSTOMER_PRIMARY, ISNULL(CUSTOMER_SECONDARY, 'FALSE') AS NX_CUSTOMER_SECONDARY, 
                         ISNULL(CUSTOMER_ADDRESS_ID, '1') AS NX_CUSTOMER_ADDRESS_ID, ISNULL(CUSTOMER_ADDRESS_PRIMARY, 'TRUE') AS NX_CUSTOMER_ADDRESS_PRIMARY, ISNULL(ROLE_DB, '') AS NX_ROLE_DB, ID, 
                         ISNULL(MIG_COMMENT, '') AS MIG_COMMENT, MIG_CREATED_DATE
FROM            OPENQUERY(cariad, 
                         'SELECT ''GBCA1'' MIG_SITE_NAME
      ,rownum ID
     ,'''' MIG_COMMENT
     ,sysdate MIG_CREATED_DATE
      ,REPLACE(P.PERSON_ID,C.CUSTOMER_ID,'''') PERSON_ID
      ,P.FIRST_NAME
      ,P.MIDDLE_NAME
      ,P.LAST_NAME
      ,P.TITLE
      ,C.CUSTOMER_ID
      ,REPLACE(C.ROLE_DB,''^'','''') ROLE_DB
      ,C.CUSTOMER_PRIMARY
      ,C.CUSTOMER_SECONDARY
      ,C.CUSTOMER_ADDRESS CUSTOMER_ADDRESS_ID
      ,C.ADDRESS_PRIMARY CUSTOMER_ADDRESS_PRIMARY
      
  FROM PERSON_INFO_ALL P
  LEFT JOIN CUSTOMER_INFO_CONTACT C ON
       C.PERSON_ID = P.PERSON_ID
  WHERE p.CUSTOMER_CONTACT_DB = ''TRUE''
   AND C.CUSTOMER_ID IS NOT NULL
')
                          AS derivedtbl_1
						  WHERE 
NOT EXISTS (SELECT 1 FROM [GBASP_Angel_DataCleansing_DataSet].[Dataset].[Customer_Filter_Override] F
            WHERE F.MIG_SITE_NAME = 'GBCA1' AND F.CUSTOMER_ID = derivedtbl_1.CUSTOMER_ID
			AND F.IsAlwaysExcluded = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[34] 2[20] 3) )"
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
               Right = 297
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
         Column = 4305
         Alias = 5970
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
', 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Contact_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Contact_ex_Filtered', NULL, NULL
GO
