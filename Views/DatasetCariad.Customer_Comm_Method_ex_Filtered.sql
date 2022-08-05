SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [DatasetCariad].[Customer_Comm_Method_ex_Filtered]
AS
SELECT        MIG_SITE_NAME, PARTY_TYPE_DB, [IDENTITY], COMM_ID, ISNULL(COMM_NAME, METHOD_ID_DB) AS COMM_NAME, ISNULL(COMM_DESCRIPTION, METHOD_ID_DB) AS COMM_DESCRIPTION, METHOD_ID_DB, 
                         COMM_METHOD_VALUE, ISNULL(DEFAULT_PER_METHOD, 'FALSE') AS DEFAULT_PER_METHOD, ISNULL(ADDRESS_ID, '') AS NX_ADDRESS_ID, ADDRESS_DEFAULT AS NX_ADDRESS_DEFAULT, ISNULL(CONVERT(VARCHAR, 
                         EXT_NO), '') AS EXT_NO, ISNULL(POD_EMAIL_DB, 'FALSE') AS POD_EMAIL_DB, ISNULL(COMPANY, '') AS NX_COMPANY, ID, ISNULL(MIG_COMMENT, '') AS MIG_COMMENT, MIG_CREATED_DATE
FROM            OPENQUERY(cariad, 
                         'SELECT ''GBCA1'' as MIG_SITE_NAME
     ,rownum AS ID
    ,'''' AS MIG_COMMENT
   ,sysdate AS MIG_CREATED_DATE
      ,V.PARTY_TYPE_DB
      ,DECODE(V.PARTY_TYPE_DB,''PERSON'' , REPLACE(V.IDENTITY,C.CUSTOMER_ID,'''')||''{''||C.CUSTOMER_ID||''}'',V.IDENTITY) AS IDENTITY
      ,V.COMM_ID
      ,V.NAME COMM_NAME
      ,DECODE(NVL(P.output_media_db,''0''),''2'',''AR Customer Contact'',V.DESCRIPTION) COMM_DESCRIPTION
      ,V.METHOD_ID_DB
      ,V.VALUE COMM_METHOD_VALUE
      ,V.METHOD_DEFAULT DEFAULT_PER_METHOD
      ,V.ADDRESS_ID
      ,V.ADDRESS_DEFAULT
      ,V.CF$_EXT_NO EXT_NO
      ,V.CF$_POD_EMAIL_DB POD_EMAIL_DB
      ,'''' AS COMPANY
	 

 FROM COMM_METHOD_CFV V
 LEFT JOIN CUSTOMER_INFO_CONTACT C ON
       C.PERSON_ID = V.IDENTITY
	   AND V.PARTY_TYPE_DB = ''PERSON''

 LEFT JOIN IDENTITY_PAY_INFO P ON
      P.IDENTITY = V.IDENTITY
	  AND P.PARTY_TYPE_DB = ''CUSTOMER''
	  AND P.COMM_ID = V.COMM_ID

 WHERE V.PARTY_TYPE_DB != ''SUPPLIER''--ONLY NEED TO LIMIT BY THIS IF WE ARE PULLING 1 LINE PER SUPPLIER THAT INCLUDES THE COMM METHOD INFO
                                  --IF COMM METHOD FOR SUPPLIER OS TO BE LOADED SEPARATELY, ARGUABLY THIS CAN STAY IN 
 AND ((V.PARTY_TYPE_DB = ''PERSON'' AND C.CUSTOMER_ID IS NOT NULL) OR V.PARTY_TYPE_DB != ''PERSON'' ) 
  --25341 from comm method cfv
')
                          AS derivedtbl_1
						  WHERE 
NOT EXISTS (SELECT 1 FROM [GBASP_Angel_DataCleansing_DataSet].[Dataset].[Customer_Filter_Override] F
            WHERE F.MIG_SITE_NAME = 'GBCA1' AND  derivedtbl_1.[IDENTITY] LIKE ('%'+F.CUSTOMER_ID+'%')
			AND F.IsAlwaysExcluded = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[38] 2[20] 3) )"
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
               Right = 260
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
         Column = 5565
         Alias = 4395
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
', 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Comm_Method_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Comm_Method_ex_Filtered', NULL, NULL
GO
