SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [DatasetCariad].[ServiceContract_Raw_Processed_ex_Filtered]
AS
SELECT        1 AS [ID], 'GBCA1' AS MIG_SITE_NAME, '' AS CUSTOMER_INVOICE, V.MIG_Customer AS CUSTOMER_DELIVERY, LEFT(ISNULL(C.IFS_CUSTOMER_NAME, N'No Mapping'), 40) AS CONTRACT_NAME, 
                         CASE V.[MIG_NISP_Type] WHEN 'RS' THEN '1' WHEN 'RO' THEN 'A' WHEN 'SM' THEN '3' WHEN 'SO' THEN '4' WHEN 'ROSM-RO' THEN '2' WHEN 'ROSM-SM' THEN '3' WHEN 'SA' THEN '9' WHEN '9999' THEN 'D' END AS MATRIX_TYPE,
                          '' AS SITE, 'Month' AS INTERVAL_UNIT, 'Prior' AS NX_INVOICE_RULE, V.MIG_Line_Date AS INVOICE_START_DATE,V.MIG_SER_Date AS NEXT_PM_DATE, 'A' AS NX_SERVICE_NEXT_PM_BASE, CAST(NULL AS DATE) AS PO_VALID_FROM, 
                         CAST(NULL AS DATE) AS PO_EXPIRY_DATE, '' AS PO_NUMBER, 0 AS PO_VALUE, CAST(NULL AS DATE) AS NX_FIRST_REVALUATION_DATE, '' AS NX_REVALUATION_TYPE, V.MIG_Part AS PART_NO, V.MIG_Price AS PRICE, 
                         1 AS NX_UNIT_QTY, V.MIG_Object AS [LEGACY_MACHINE_ID], CAST(12 / V.MIG_IP_Freq AS INT) AS PERIOD_PRICE_INV_PER_YEAR, CAST(ISNULL(ISNULL(12 / V.MIG_SER_Freq, 6),0) AS INT) AS PM_SERVICE_INTERVAL, 
                         '' AS CURRENT_CONTRACT, '' AS CURRENT_CONTRACT_NUMBER, CAST(NULL AS DATE) AS CURRENT_CONTRACT_START_DATE, '' AS ORIGINAL_CONTRACT_NUMBER, CAST(NULL AS DATE) 
                         AS ORIGINAL_CONTRACT_END_DATE, CAST(NULL AS DATE) AS ORIGINAL_CONTRACT_START_DATE, '' AS CONTRACT_TERM, 
                         CASE V.[MIG_NISP_Type] WHEN 'RS' THEN 'GB:LEVY' WHEN 'RO' THEN 'GB:LEVY' WHEN 'SM' THEN 'GB:LEVY' WHEN 'SO' THEN 'GB:LEVY' WHEN 'ROSM-RO' THEN 'GB:LEVY' WHEN 'ROSM-SM' THEN '' WHEN 'SA' THEN '' WHEN
                          '9999' THEN 'GB:LEVY' END AS NX_OTHER1_TYPE, 'Month' AS NX_OTHER1_UNIT, ISNULL(EL.MIG_Price, 0) AS NX_OTHER1_UNIT_PRICE, 1 AS NX_OTHER1_UNIT_QTY, CAST(ISNULL(12 / EL.MIG_IP_Freq, 12) AS INT) 
                         AS NX_OTHER1_INTERVAL, ISNULL(EL.MIG_Line_Date, V.MIG_Line_Date) AS NX_OTHER1_NEXT_INVOICE_DATE, CAST(NULL AS DATE) AS NX_OTHER1_NEXT_PERIOD_FROM_DATE, '' AS OTHER2_TYPE, '' AS OTHER2_UNIT, 
                         0 AS OTHER2_UNIT_PRICE, 0 AS OTHER2_UNIT_QTY, 0 AS OTHER2_INTERVAL, CAST(NULL AS DATE) AS OTHER2_NEXT_INVOICE_DATE, CAST(NULL AS DATE) AS OTHER2_NEXT_PERIOD_FROM_DATE, '' AS NX_COMMENT, 
                         GETDATE() AS MIG_CREATED_DATE, GETDATE() AS MIG_SRC_CREATED_DATE, V.MIG_Object, V.MIG_Customer, V.MIG_Line_Date, V.MIG_NISP_Type, V.MIG_Price, V.MIG_IP_Freq, V.MIG_SER_Freq, EL.MIG_Price AS EL_PRICE,
                          EL.MIG_IP_Freq AS EL_FREQ, EL.MIG_Line_Date AS EL_DATE,  '' AS [NX_CURRENT_CONTRACT]
FROM            dbo.SC_DATA_ROANNE AS V LEFT OUTER JOIN
                         NEXUS_Transform.dbo.MAP_Customer AS C ON C.MIG_SITE_NAME = 'GBCA1' AND C.LEGACY_CUSTOMER_REF = V.MIG_Customer 
						 --LEFT OUTER JOIN
                         --dbo.CARIAD_PM_DATA_LOAD_FILE AS P ON P.MACHINE_LEGACY_UID = V.MIG_Object 
						 LEFT OUTER JOIN
                         dbo.SC_DATA_ROANNE AS EL ON EL.MIG_Object = V.MIG_Object AND EL.MIG_NISP_Type = 'EL'
WHERE        (V.MIG_NISP_Type <> 'EL')
UNION
SELECT        1 AS [ID], 'GBCA1' AS MIG_SITE_NAME, '' AS CUSTOMER_INVOICE, V.MIG_Customer AS CUSTOMER_DELIVERY, LEFT(ISNULL(C.IFS_CUSTOMER_NAME, N'No Mapping'), 40) AS CONTRACT_NAME, '6' AS MATRIX_TYPE, 
                         '' AS SITE, 'Month' AS INTERVAL_UNIT, 'Prior' AS NX_INVOICE_RULE, V.MIG_Line_Date AS INVOICE_START_DATE, V.MIG_SER_Date AS NEXT_PM_DATE, 'A' AS NX_SERVICE_NEXT_PM_BASE, CAST(NULL AS DATE) AS PO_VALID_FROM, 
                         CAST(NULL AS DATE) AS PO_EXPIRY_DATE, '' AS PO_NUMBER, 0 AS PO_VALUE, CAST(NULL AS DATE) AS NX_FIRST_REVALUATION_DATE, '' AS NX_REVALUATION_TYPE, V.MIG_Part AS PART_NO, ISNULL(EL.MIG_Price, 0) 
                         AS PRICE, 1 AS NX_UNIT_QTY, V.MIG_Object AS [LEGACY_MACHINE_ID], CAST(12 / V.MIG_IP_Freq AS INT) AS PERIOD_PRICE_INV_PER_YEAR, CAST(ISNULL(isnull(12 / V.MIG_SER_Freq, 6),0) AS INT) AS PM_SERVICE_INTERVAL, 
                         '' AS CURRENT_CONTRACT, '' AS CURRENT_CONTRACT_NUMBER, CAST(NULL AS DATE) AS CURRENT_CONTRACT_START_DATE, '' AS ORIGINAL_CONTRACT_NUMBER, CAST(NULL AS DATE) 
                         AS ORIGINAL_CONTRACT_END_DATE, CAST(NULL AS DATE) AS ORIGINAL_CONTRACT_START_DATE, '' AS CONTRACT_TERM, '' AS NX_OTHER1_TYPE, 'Month' AS NX_OTHER1_UNIT, ISNULL(EL.MIG_Price, 0) 
                         AS NX_OTHER1_UNIT_PRICE, 1 AS NX_OTHER1_UNIT_QTY, CAST(ISNULL(12 / EL.MIG_IP_Freq, 12) AS INT) AS NX_OTHER1_INTERVAL, ISNULL(EL.MIG_Line_Date, V.MIG_Line_Date) AS NX_OTHER1_NEXT_INVOICE_DATE, 
                         CAST(NULL AS DATE) AS NX_OTHER1_NEXT_PERIOD_FROM_DATE, '' AS OTHER2_TYPE, '' AS OTHER2_UNIT, 0 AS OTHER2_UNIT_PRICE, 0 AS OTHER2_UNIT_QTY, 0 AS OTHER2_INTERVAL, CAST(NULL AS DATE) 
                         AS OTHER2_NEXT_INVOICE_DATE, CAST(NULL AS DATE) AS OTHER2_NEXT_PERIOD_FROM_DATE, '' AS NX_COMMENT, GETDATE() AS MIG_CREATED_DATE, GETDATE() AS MIG_SRC_CREATED_DATE, V.MIG_Object, 
                         V.MIG_Customer, V.MIG_Line_Date, V.MIG_NISP_Type, V.MIG_Price, V.MIG_IP_Freq, V.MIG_SER_Freq, EL.MIG_Price AS EL_PRICE, EL.MIG_IP_Freq AS EL_FREQ, EL.MIG_Line_Date AS EL_DATE,  
                         '' AS [NX_CURRENT_CONTRACT]
FROM            dbo.SC_DATA_ROANNE AS V LEFT OUTER JOIN
                         NEXUS_Transform.dbo.MAP_Customer AS C ON C.MIG_SITE_NAME = 'GBCA1' AND C.LEGACY_CUSTOMER_REF = V.MIG_Customer 
						 --LEFT OUTER JOIN
                         --dbo.CARIAD_PM_DATA_LOAD_FILE AS P ON P.MACHINE_LEGACY_UID = V.MIG_Object 
						 LEFT OUTER JOIN
                         dbo.SC_DATA_ROANNE AS EL ON EL.MIG_Object = V.MIG_Object AND EL.MIG_NISP_Type = 'EL'
WHERE        (V.MIG_NISP_Type = 'SA')
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[13] 4[17] 3[27] 2) )"
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
         Column = 1440
         Alias = 6210
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
', 'SCHEMA', N'DatasetCariad', 'VIEW', N'ServiceContract_Raw_Processed_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetCariad', 'VIEW', N'ServiceContract_Raw_Processed_ex_Filtered', NULL, NULL
GO
