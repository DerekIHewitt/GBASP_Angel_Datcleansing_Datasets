SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DatasetProWat].[Customer_Address_ex_Filtered]
AS
SELECT        'GBASP' AS MIG_SITE_NAME, '' AS MIG_COMMENT, getdate() AS MIG_CREATED_DATE, TRIM(CONVERT(varchar(20), CUS_Account)) AS CUSTOMER_ID, Dataset.[ConvertMaxLenCleanString](CUS_Company, '', 100) AS [NAME], 
                         CASE WHEN ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_Addr1, '', 35), '') = '' THEN CASE WHEN ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_Addr2, '', 35), '.') 
                         = '' THEN '.' ELSE ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_Addr2, '', 35), '.') END ELSE Dataset.[ConvertMaxLenCleanString](CUS_Addr1, '', 35) END AS ADDRESS1, 
                         CASE WHEN ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_Addr1, '', 35), '') = '' THEN '' ELSE ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_Addr2, '', 35), '') END AS ADDRESS2, 
                         Dataset.[ConvertMaxLenCleanString](CUS_PCode, '''./\-!', 35) AS ZIP_CODE, ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_Addr3, '', 35), '{NULL}') AS CITY, ISNULL(Dataset.[ConvertMaxLenCleanString](CUS_County, '', 35), '') 
                         AS COUNTY, '' AS [STATE], '' AS VAT_NO, '' AS SPECIAL_INS, ISNULL(Dataset.[ConvertMaxLenCleanString](TRIM(CUS_Instruct1) + CASE WHEN trim(isnull(CUS_Instruct2, '')) <> '' THEN ' ' + trim(CUS_Instruct2) 
                         ELSE '' END + CASE WHEN trim(isnull(CUS_Instruct3, '')) <> '' THEN ' ' + trim(CUS_Instruct3) ELSE '' END + CASE WHEN trim(isnull(CUS_Instruct4, '')) <> '' THEN ' ' + trim(CUS_Instruct4) 
                         ELSE '' END + CASE WHEN trim(isnull(CUS_Instruct5, '')) <> '' THEN ' ' + trim(CUS_Instruct5) ELSE '' END, '''', 500), '') AS WORK_ORDER_NOTES, '' AS NX_DELIVERY_COUNTRY_DB, '' AS NX_SUPPLY_COUNTRY_DB, 
                         '' AS NX_LONGITUDE, '' AS NX_LATITUDE, '' AS NX_ADDRESS_ID, '' AS NX_DELIVERY_TERMS, '' AS NX_SHIP_VIA_CODE, '' AS NX_IN_CITY, '' AS NX_TAX_WITHHOLDING_DB, '' AS NX_TAX_ROUNDING_METHOD_DB, 
                         '' AS NX_TAX_ROUNDING_LEVEL_DB, '' AS NX_TAX_EXEMPT_DB, '' AS NX_INTRASTAT_EXEMPT_DB, Dataset.ConvertProwatTime(CUS_OpenAM) AS NX_OPENING_AM, Dataset.ConvertProwatTime(CUS_CloseAM) 
                         AS NX_CLOSING_AM, Dataset.ConvertProwatTime(CUS_OpenPM) AS NX_OPENING_PM, Dataset.ConvertProwatTime(CUS_ClosePM) AS NX_CLOSING_PM, CUS_OpenAMDay1 AS NX_MON_AM, 
                         CUS_OpenPMDay1 AS NX_MON_PM, CUS_OpenAMDay2 AS NX_TUE_AM, CUS_OpenPMDay2 AS NX_TUE_PM, CUS_OpenAMDay3 AS NX_WED_AM, CUS_OpenPMDay3 AS NX_WED_PM, CUS_OpenAMDay4 AS NX_THU_AM, 
                         CUS_OpenPMDay4 AS NX_THU_PM, CUS_OpenAMDay5 AS NX_FRI_AM, CUS_OpenPMDay5 AS NX_FRI_PM, CUS_OpenAMDay6 AS NX_SAT_AM, CUS_OpenPMDay6 AS NX_SAT_PM, CUS_OpenAMDay7 AS NX_SUN_AM, 
                         CUS_OpenPMDay7 AS NX_SUN_PM, 'TRUE' AS NX_DEF_ADDRESS_DELIVERY, 'TRUE' AS NX_DEF_ADDRESS_INVOICE, 'TRUE' AS NX_DEF_ADDRESS_PAY, '' AS NX_DEF_ADDRESS_HOME, 
                         '' AS NX_DEF_ADDRESS_PRIMARY, '' AS NX_DEF_ADDRESS_SECONDARY, 'TRUE' AS NX_DEF_ADDRESS_VISIT, '' AS NX_TAX_REGIME_DB, '' AS NX_COUNTRY_DB, '' AS NX_COMPANY, ROW_NUMBER() OVER (ORDER BY CUS_Account)
 AS ID, Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0),
 TRIM(CONVERT(varchar(100), CUS_Account)), LEFT(TRIM(CUS_Company), 100), ISNULL(CUS_Type, '{NULL}')) AS NX_FILTER_STATUS
FROM            DatasetProWat.Syn_Customer_ex LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
WHERE        (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS_Account)), LEFT(TRIM(CUS_Company), 100), ISNULL(CUS_Type, '{NULL}')) > 0)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[18] 4[27] 2[46] 3) )"
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
', 'SCHEMA', N'DatasetProWat', 'VIEW', N'Customer_Address_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetProWat', 'VIEW', N'Customer_Address_ex_Filtered', NULL, NULL
GO
