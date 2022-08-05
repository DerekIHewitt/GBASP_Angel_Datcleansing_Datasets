SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CARIAD_PM_DATA]
AS
SELECT        MIG_SITE_NAME, MACHINE_LEGACY_UID, MAX(NEXT_PM_DATE) AS NEXT_PM_DATE, MAX(INTERVAL) AS PM_INTERVAL
FROM            OPENQUERY(CARIAD, 
                         'SELECT  DISTINCT    
       ''GBCA1'' AS MIG_SITE_NAME
      --,'''' as CUSTOMER_INVOICE
     -- ,O.MCH_CODE AS CUSTOMER_DELIVERY
      --,S.CONTRACT_NAME AS CONTRACT_NAME
     -- ,'''' as MATRIX_TYPE
      --,S.CONTRACT AS SITE
	  --,S.CONTRACT_TYPE
     ,NVL(INTERVAL_UNIT,''Month'') AS INTERVAL_UNIT
       ,NVL(INVOICE_RULE,''Prior'') AS INVOICE_RULE
     -- ,INVOICE_START_DATE
     ,CF$_NEXT_PLANNED_DATE AS NEXT_PM_DATE
	 ,PM_PERFORMED_DATE_BASED 
      --,[SERVICE_NEXT_PM_BASE]
      --,'''' AS PO_VALID_FROM  --LEAVE FOR NOW AS UNSURE CARIAD SOLUTION 
     -- ,'''' AS PO_EXPIRY_DATE --LEAVE FOR NOW AS UNSURE CARIAD SOLUTION
     -- ,'''' AS PO_NUMBER      --LEAVE FOR NOW AS UNSURE CARIAD SOLUTION
     -- ,'''' AS PO_VALUE       --LEAVE FOR NOW AS UNSURE CARIAD SOLUTION
     -- ,S.FIRST_REVALUATION_DATE
     -- ,S.REVALUATION_TYPE
      --,INVOICE_CATALOG_NO
     -- ,'''' AS UNIT_PRICE
     -- ,'''' AS UNIT_QTY
      ,N.MCH_CODE AS MACHINE_LEGACY_UID
     ,P.INTERVAL
     --,[PERIOD_PRICE_INV_PER_YEAR]
     -- ,[PERIOD_SERVICE_INTERVAL]
     -- ,[CURRENT_CONTRACT]
     -- ,[CURRENT_CONTRACT_NUMBER]
     -- ,[CURRENT_START_DATE]
     -- ,[ORIGINAL_CONTRACT_NUMBER]
     -- ,[ORIGINAL_END_DATE]
     -- ,[ORIGINAL_START_DATE]
     -- ,[CONTRACT_TERM]
     -- ,[OTHER1_TYPE]
     -- ,[OTHER1_UNIT]
     -- ,[OTHER1_UNIT_PRICE]
     -- ,[OTHER1_UNIT_QTY]
     -- ,[OTHER1_INTERVAL]
     -- ,[OTHER1_NEXT_INVOICE_DATE]
     -- ,[OTHER1_NEXT_PERIOD_FROM_DATE]
     -- ,[OTHER2_TYPE]
     -- ,[OTHER2_UNIT]
     -- ,[OTHER2_UNIT_PRICE]
     -- ,[OTHER2_UNIT_QTY]
     -- ,[OTHER2_INTERVAL]
     -- ,[OTHER2_NEXT_INVOICE_DATE]
     -- ,[OTHER2_NEXT_PERIOD_FROM_DATE]
     -- ,[COMMENT]
      
from psc_contr_product l
join psc_contr_product_object o
on l.contract_id = o.contract_id
and l.line_no = o.line_no

join equipment_all_object n
on o.contract_id = l.contract_id
and o.mch_code = n.from_mch_code 
--where l.contract_id = ''10203736_S'' --and line_no = ''7''

 join PM_ACTION_CFV p
on p.mch_code = n.mch_code
and p.contract_id = l.contract_id
and p.line_no = l.line_no
AND STATE =''Active''
and valid_to is null

 JOIN SC_SERVICE_CONTRACT S
ON S.CONTRACT_ID = L.CONTRACT_ID --AND S.CONTRACT_TYPE = ''BILLING''
--LEFT join psc_contr_product_object BL ON N.MCH_CODE = BL.MCH_CODE
where --l.contract_id = ''10203736_S''
--and l.line_no = ''1''
--and 
PSC_SRV_LINE_OBJECTS_API.Matching_Row(l.contract_id,
                                                l.line_no,
                                                 l.CONTRACT,
                                                 n.MCH_CODE,
                                                 ''Valid Objects'') = ''TRUE''
                                                 --and N.mch_code = ''1265461364''
												 ORDER BY N.MCH_CODE')
                          AS derivedtbl_1
GROUP BY MIG_SITE_NAME, MACHINE_LEGACY_UID
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[15] 2[49] 3) )"
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
               Right = 290
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
      Begin ColumnWidths = 12
         Column = 1440
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
', 'SCHEMA', N'dbo', 'VIEW', N'CARIAD_PM_DATA', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'CARIAD_PM_DATA', NULL, NULL
GO
