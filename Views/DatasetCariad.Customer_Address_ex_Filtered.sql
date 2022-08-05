SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [DatasetCariad].[Customer_Address_ex_Filtered]
AS
SELECT        ID, MIG_SITE_NAME, '' AS MIG_COMMENT, MIG_CREATED_DATE, CUSTOMER_ID, ISNULL(NAME, '') AS NAME, ADDRESS_ID AS NX_ADDRESS_ID, ISNULL(ADDRESS1, '') AS ADDRESS1, ISNULL(ADDRESS2, '') AS ADDRESS2, 
                         ISNULL(ZIP_CODE, '') AS ZIP_CODE, ISNULL(CITY, '') AS CITY, ISNULL(COUNTY, '') AS COUNTY, '' AS STATE, ISNULL(VAT_NO, '') AS VAT_NO, ISNULL(SPECIAL_INS, '') AS SPECIAL_INS, ISNULL(WORK_ORDER_NOTES, '') 
                         AS WORK_ORDER_NOTES, ISNULL(DELIVERY_TERMS, '') AS NX_DELIVERY_TERMS, ISNULL(SHIP_VIA_CODE, '') AS NX_SHIP_VIA_CODE, ISNULL(IN_CITY, '') AS NX_IN_CITY, 
                         TAX_EXEMPTION_CERT_NO AS NX_TAX_EXEMPTION_CERT_NO, ISNULL(TAX_WITHHOLDING_DB, '') AS NX_TAX_WITHHOLDING_DB, ISNULL(TAX_ROUNDING_METHOD_DB, '') AS NX_TAX_ROUNDING_METHOD_DB, 
                         ISNULL(TAX_ROUNDING_LEVEL_DB, '') AS NX_TAX_ROUNDING_LEVEL_DB, ISNULL(TAX_EXEMPT_DB, '') AS NX_TAX_EXEMPT_DB, ISNULL(INTRASTAT_EXEMPT_DB, '') AS NX_INTRASTAT_EXEMPT_DB, 
                         OPENING_AM AS NX_OPENING_AM, CLOSING_AM AS NX_CLOSING_AM, OPENING_PM AS NX_OPENING_PM, CLOSING_PM AS NX_CLOSING_PM, MON_AM AS NX_MON_AM, MON_PM AS NX_MON_PM, 
                         TUE_AM AS NX_TUE_AM, TUE_PM AS NX_TUE_PM, WED_AM AS NX_WED_AM, WED_PM AS NX_WED_PM, THU_AM AS NX_THU_AM, THU_PM AS NX_THU_PM, FRI_AM AS NX_FRI_AM, FRI_PM AS NX_FRI_PM, 
                         SAT_AM AS NX_SAT_AM, SAT_PM AS NX_SAT_PM, SUN_AM AS NX_SUN_AM, SUN_PM AS NX_SUN_PM, DEF_ADDRESS_DELIVERY AS NX_DEF_ADDRESS_DELIVERY, 
                         DEF_ADDRESS_INVOICE AS NX_DEF_ADDRESS_INVOICE, DEF_ADDRESS_PAY AS NX_DEF_ADDRESS_PAY, DEF_ADDRESS_HOME AS NX_DEF_ADDRESS_HOME, DEF_ADDRESS_PRIMARY AS NX_DEF_ADDRESS_PRIMARY, 
                         DEF_ADDRESS_SECONDARY AS NX_DEF_ADDRESS_SECONDARY, DEF_ADDRESS_VISIT AS NX_DEF_ADDRESS_VISIT, LONGITUDE AS NX_LONGITUDE, LATITUDE AS NX_LATITUDE, 
                         SUPPLY_COUNTRY_DB AS NX_SUPPLY_COUNTRY_DB, DELIVERY_COUNTRY_DB AS NX_DELIVERY_COUNTRY_DB, TAX_REGIME_DB AS NX_TAX_REGIME_DB, COUNTRY AS NX_COUNTRY_DB, '' AS NX_COMPANY, 
                         LIABILITY_TYPE AS NX_LIABILITY_TYPE, DELIVERY_TYPE AS NX_DELIVERY_TYPE, VAT_FREE_VAT_CODE AS NX_VAT_FREE_VAT_CODE
FROM            OPENQUERY(CARIAD, 
                         'SELECT ''GBCA1'' AS MIG_SITE_NAME
      ,rownum AS ID
	  ,'''' AS MIG_COMMENT
	  ,sysdate AS MIG_CREATED_DATE
      ,C.CUSTOMER_ID
      ,C.ADDRESS_ID
      ,CH.NAME   --WLIPRD HAS NO NAME IN THE ADDRESS VIEW, DO WE NEED TO PULL AND REPLICATE FROM HEADER OR CAN WE LEAVE AS IS
      ,C.ADDRESS1
      ,C.ADDRESS2
      ,C.ZIP_CODE
      ,C.CITY
      ,C.COUNTY
      ,CO.DELIVERY_TERMS
      ,CO.SHIP_VIA_CODE
      ,C.IN_CITY
      ,CT.TAX_WITHHOLDING_DB
      ,CT.TAX_ROUNDING_METHOD_DB
      ,CT.TAX_ROUNDING_LEVEL_DB
      ,CT.TAX_EXEMPT_DB
      ,CO.INTRASTAT_EXEMPT_DB
      ,CD.VAT_NO
      ,NVL(C.CF$_OPENING_AM ,''1900-01-01 00:00:00'' )OPENING_AM
      ,NVL(C.CF$_CLOSING_AM ,''1900-01-01 00:00:00'' )CLOSING_AM
      ,NVL(C.CF$_OPENING_PM,''1900-01-01 00:00:00'') OPENING_PM
      ,NVL(C.CF$_CLOSING_PM,''1900-01-01 00:00:00'') CLOSING_PM
      ,C.CF$_MON_AM_DB MON_AM
      ,C.CF$_MON_PM_DB MON_PM
      ,C.CF$_TUES_AM_DB TUE_AM
      ,C.CF$_TUES_PM_DB TUE_PM
      ,C.CF$_WED_AM_DB WED_AM
      ,C.CF$_WED_PM_DB WED_PM
      ,C.CF$_THURS_AM_DB THU_AM
      ,C.CF$_THURS_PM_DB THU_PM
      ,C.CF$_FRI_AM_DB FRI_AM
      ,C.CF$_FRI_PM_DB FRI_PM
      ,C.CF$_SAT_AM_DB SAT_AM
      ,C.CF$_SAT_PM_DB SAT_PM
      ,C.CF$_SUN_AM_DB SUN_AM
      ,C.CF$_SUN_PM_DB SUN_PM
      ,C.STATE  --SEEMS TO HOLD CUSTOMER NAME INFO, DO WE WANT THIS TO POPULATE THE SAME AS PER CARIAD, IE PULL THE DATA FROM THIS FIELD
      ,C.CF$_SPECIAL_INS SPECIAL_INS
      ,C.CF$_WORK_ORDER_NOTES WORK_ORDER_NOTES
      ,''TRUE'' DEF_ADDRESS_DELIVERY
      ,''TRUE'' DEF_ADDRESS_INVOICE
      ,''TRUE'' DEF_ADDRESS_PAY
      ,''TRUE'' DEF_ADDRESS_HOME
      ,''TRUE'' DEF_ADDRESS_PRIMARY
      ,''TRUE'' DEF_ADDRESS_SECONDARY
      ,''TRUE'' DEF_ADDRESS_VISIT
      ,'''' LONGITUDE
      ,'''' LATITUDE
      ,CD.SUPPLY_COUNTRY_DB
      ,CD.DELIVERY_COUNTRY_DB
      ,CT.TAX_REGIME_DB
      ,C.COUNTRY_DB COUNTRY
      ,CT.COMPANY
      ,'''' LIABILITY_TYPE
      ,'''' DELIVERY_TYPE
      ,'''' VAT_FREE_VAT_CODE
      ,'''' TAX_EXEMPTION_CERT_NO
     
  FROM  CUSTOMER_INFO_ADDRESS_CFV C
  LEFT JOIN CUST_ORD_CUSTOMER_ADDRESS CO
       ON CO.CUSTOMER_NO = C.CUSTOMER_ID
        AND CO.ADDR_NO = C.ADDRESS_ID

  LEFT JOIN CUSTOMER_TAX_INFO CT 
       ON CT.CUSTOMER_ID = C.CUSTOMER_ID
     AND CT.ADDRESS_ID = C.ADDRESS_ID

  LEFT JOIN CUSTOMER_DOCUMENT_TAX_INFO CD
       ON CD.CUSTOMER_ID = C.CUSTOMER_ID
     AND CD.ADDRESS_ID = C.ADDRESS_ID

 LEFT JOIN CUSTOMER_INFO CH
      ON CH.CUSTOMER_ID = C.CUSTOMER_ID


     
--5634 CUSTOMER INFOR ADDRESS RECORDS--
')
                          AS derivedtbl_1
WHERE        (ADDRESS_ID = '1')
AND 
NOT EXISTS (SELECT 1 FROM [GBASP_Angel_DataCleansing_DataSet].[Dataset].[Customer_Filter_Override] F
            WHERE F.MIG_SITE_NAME = 'GBCA1' AND F.CUSTOMER_ID = derivedtbl_1.CUSTOMER_ID
			AND F.IsAlwaysExcluded = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[31] 2[42] 3) )"
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
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 294
               Left = 38
               Bottom = 424
               Right = 288
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
         Column = 5370
         Alias = 4920
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
', 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Address_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Address_ex_Filtered', NULL, NULL
GO
