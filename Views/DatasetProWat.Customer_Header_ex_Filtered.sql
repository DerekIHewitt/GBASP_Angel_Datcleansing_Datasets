SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DatasetProWat].[Customer_Header_ex_Filtered]
AS
SELECT        ROW_NUMBER() OVER (ORDER BY ex.CUS_Account) AS ID, 'GBASP' AS MIG_SITE_NAME, '' AS MIG_COMMENT, GETDATE() AS MIG_CREATED_DATE, TRIM(CONVERT(VARCHAR(100), ex.CUS_Account)) AS CUSTOMER_ID, 
LEFT(TRIM(ex.CUS_Company), 100) AS NAME, invoice_customer_info.CUS_PayTerms AS PAY_TERM_ID, ISNULL(TRIM(CONVERT(nvarchar(10), ex.CUS_Credit_Limit)), 0) AS CREDIT_LIMIT, 
ISNULL(CASE WHEN ex.cus_acct_to_inv = 0 THEN '' ELSE TRIM(CONVERT(VARCHAR(100), ex.cus_acct_to_inv)) END, '') AS INVOICE_CUSTOMER, '' AS INVOICE_SORT_DB, 'TRUE' AS EMAIL_ORDER_CONF_DB, 
'TRUE' AS EMAIL_INVOICE_DB, ISNULL(CONVERT(VARCHAR(10), ex.CUS_SectorID), '{NULL}') AS CRM_ACCOUNT_TYPE, invoice_customer_info.CUS_PayType AS PAYMENT_METHOD, '' AS PAY_ADDR_DESCRIPTION, 
ISNULL(CONVERT(VARCHAR(50), format(invoice_customer_info.CUS_ACNumber, '00000000')), '') AS PAY_ADDR_ACCOUNT, ISNULL(CONVERT(VARCHAR(100), format(invoice_customer_info.CUS_ACSortCode, '000000')), '') 
AS PAY_ADDR_SORT_CODE, ISNULL(TRIM(invoice_customer_info.CUS_ACName), '') AS PAY_ADDR_ACC_NAME, '' AS PAY_ADDR_BUILD_SOC_REF, '' AS PAY_ADDR_TRANS_CODE, '' AS PAY_ADDR_OUR_REF, 'CA' AS CREDIT_ANALYST, 
ISNULL(TRIM(CONVERT(nvarchar(100), ex.CUS_AcqFrom)), '') AS ACQUIRED_FROM_COMP, '' AS ASSOCIATION_NO, '0' AS NX_GROUP_ID, ex.CUS_Charge_VAT AS NX_TAX_CODE, '9999' AS NX_CUST_GRP, '0' AS NX_MARKET_CODE, 
'DIR' AS NX_ORDER_TYPE, '' AS NX_IDENTITY_TYPE_DB, CASE WHEN ex.cus_Invtype = 'O' THEN CASE WHEN ex.cus_invcons = 0 THEN 'O' ELSE 'P' END ELSE ex.cus_Invtype END AS NX_PAY_OUTPUT_MEDIA_DB, 
'FALSE' AS NX_DEFAULT_PAYMENT_METHOD, 'NO' AS NX_ACTIVE_TRIAL_DB, CASE WHEN ex.Cus_Industry = '9' THEN 'TRUE' ELSE '' END AS NX_CCA_FLAG_DB, ISNULL(LEFT(TRIM(ex.CUS_CustOrder), 99), '') 
AS NX_BLANKET_PURCHASE_ORDER, 'FALSE' AS NX_CREDIT_BLOCK, CASE WHEN ISNULL(ex.CUS_PODate, 0) = 0 THEN '' ELSE CASE WHEN ISNULL(LEFT(TRIM(ex.CUS_CustOrder), 99), '') = '' THEN '' ELSE CONVERT(nvarchar(21), 
Dataset.ConvertProwatDate(ex.CUS_PODate, NULL), 126) END END AS NX_PO_EXPIRY_DATE, CASE WHEN ISNULL(LEFT(TRIM(ex.CUS_CustOrder), 99), '') = '' THEN 0 ELSE 9999999 END AS NX_PO_EXPIRY_VALUE, 
0 AS NX_PO_VALUE_USED, CASE WHEN ex.CUS_SectorID = 1 THEN 'NATIONAL' ELSE 'ALL' END AS NX_MESSAGE_GROUP, 0 AS NX_ALLOWED_OVERDUE_AMOUNT, 0 AS NX_ALLOWED_OVERDUE_DAYS, 
'' AS NX_CREDIT_RELATIONSHIP_EXIST, '' AS NX_CREDIT_RELATIONSHIP_TYPE_DB, '' AS NX_PARENT_COMPANY, '' AS NX_PARENT_CUSTOMER_ID, '' AS NX_CUST_ORDER_INVOICING_DB, '' AS NX_CUST_ORDER_INV_TYPE_DB, 
'' AS NX_CONSOLIDATION_DAY_DB, TRIM(ex.CUS_SageCode) AS NX_SAGE_CODE, TRIM(CONVERT(VARCHAR(100), ex.CUS_Account)) AS NX_OLD_CUST_REF1, ISNULL(TRIM(ex.CUS_ImportAC), '') AS NX_OLD_CUST_REF2, 
ISNULL(TRIM(CONVERT(nvarchar(20), ex.CUS_BookIn)), 0) AS NX_BOOK_IN_DB, '' AS NX_NO_LIMIT_DB, '' AS NX_ON_SITE_RA_DB, 
/*CASE WHEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) = 0 THEN 0 ELSE 
CASE WHEN ISNULL(LEFT(TRIM(ex.CUS_CustOrder), 99), '') = '' 
	  AND ISNULL(LEFT(TRIM(ex.CUS_PORent), 99), '') = '' 
	  AND ISNULL(LEFT(TRIM(ex.CUS_POSANI), 99), '') = '' 
	  AND ISNULL(LEFT(TRIM(ex.CUS_POEL), 99), '') = '' THEN 
	  CASE WHEN ex.CUS_Acct_To_Inv = 0 THEN CASE WHEN ex.Cus_Balance > 0 THEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) ELSE 0 END 
	  ELSE CASE WHEN
					(SELECT        Cus_Balance
					  FROM            DatasetProWat.Syn_Customer_ex v
					  WHERE        v.CUS_Account = ex.CUS_Acct_To_Inv) > 0 THEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) ELSE 0 END END ELSE ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) 
END 
END AS NX_PURCHASE_ORDER_REQ_DB*/ CASE
 WHEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) = 0 THEN 0 ELSE /*when po req is false leave as false*/ CASE WHEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) = 1 AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_CustOrder)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_PORent)), 99), '') = '' AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POSANI)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POEL)), 99), '') = '' AND ISNULL(ex.CUS_Acct_To_Inv, 0) = 0 AND 
ISNULL(ex.Cus_Balance, 0) > 0 THEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) WHEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) = 1 AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_CustOrder)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_PORent)), 99), '') = '' AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POSANI)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POEL)), 99), '') = '' AND ISNULL(ex.CUS_Acct_To_Inv, 0) = 0 AND 
ISNULL(ex.Cus_Balance, 0) <= 0 THEN 0 WHEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) = 1 AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_CustOrder)), 99), '') = '' AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_PORent)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POSANI)), 99), '') = '' AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POEL)), 99), '') = '' AND ISNULL(ex.CUS_Acct_To_Inv, 0) <> 0 AND ISNULL(ex.Cus_Balance, 0) <= 0 AND
    (SELECT        ISNULL(Cus_Balance, 0)
      /*take the balance */ FROM DatasetProWat.Syn_Customer_ex v
      /*from customer*/ WHERE v.CUS_Account = ex.CUS_Acct_To_Inv) > 0 THEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) WHEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) = 1 AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_CustOrder)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_PORent)), 99), '') = '' AND 
ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POSANI)), 99), '') = '' AND ISNULL(LEFT(TRIM(NEXUS_TRANSFORM.DBO.CLEANSTRING(ex.CUS_POEL)), 99), '') = '' AND ISNULL(ex.CUS_Acct_To_Inv, 0) > 0 AND 
ISNULL(ex.Cus_Balance, 0) <= 0 AND
    (SELECT        ISNULL(Cus_Balance, 0)
      /*take the balance */ FROM DatasetProWat.Syn_Customer_ex v
      /*from customer*/ WHERE v.CUS_Account = ex.CUS_Acct_To_Inv) <= 0 THEN 0 ELSE ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) 
END /*THEN     --when all po fields are empty
	  CASE WHEN ex.CUS_Acct_To_Inv = 0 THEN										--and no invoice account
	  CASE WHEN ex.Cus_Balance > 0 THEN											--and balance is larger than zero
	  ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) ELSE 0 END			--then keep po req as is in prowat
	  ELSE CASE WHEN															--otherwise
					(SELECT        Cus_Balance									--take the balance 
					  FROM            DatasetProWat.Syn_Customer_ex v			--from customer
					  WHERE        v.CUS_Account = ex.CUS_Acct_To_Inv) > 0		--where cus account is the invoice account on main join
					  THEN ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) --keep that po req as is in prowat
					  ELSE 0 END												--otherwise zero it
					  END ELSE ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_POReq)), 0) --take the po as is as the fallback
END */ END
 AS NX_PURCHASE_ORDER_REQ_DB, '' AS NX_SHORT_TERM_DB, '' AS NX_COST_CODE, ISNULL(trim(CONVERT(nvarchar(20), ex.CUS_RepNum)), '') AS NX_MAIN_REP, 
CASE WHEN ex.CUS_PaperInvCharge != 1 THEN 'TRUE' ELSE '' END AS NX_INVOICE_FEE, '' AS NX_PRINT_TAX_CODE_TEXT, NULL AS NX_CYCLE_PERIOD, '' AS NX_ORDER_CONF_FLAG_DB, '' AS NX_PACK_LIST_FLAG_DB, 
'' AS NX_CATEGORY_DB, '' AS NX_SUMMARIZED_SOURCE_LINES_DB, '' AS NX_PRINT_AMOUNTS_INCL_TAX_DB, '' AS NX_CREDIT_CONTROL_GROUP_ID, '' AS NX_CUST_PRICE_GROUP_ID, Dataset.Filter_Customer('GBASP', 'ex', 
ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(VARCHAR(100), 
ex.CUS_Account)), LEFT(TRIM(ex.CUS_Company), 100), ISNULL(ex.CUS_Type, '{NULL}')) AS NX_FILTER_STATUS, '' AS NX_BR_ORDER_TYPE, '' AS NX_BR_BLOCKED_DD, CASE WHEN ex.cus_acct_to_inv != 0 AND 
isnull(invoice_customer_info.cus_invcons, 0) = 1 THEN 'ALL' /* 'Consolidate across all sites and order types'*/ WHEN isnull(invoice_customer_info.cus_inveachdel, 0) = 0 THEN CASE WHEN ex.cus_acct_to_inv != 0 AND 
isnull(invoice_customer_info.cus_invcons, 0) = 0 THEN 'SITE' /* 'Consolidate by sites only'*/ WHEN isnull(ex.cus_acct_to_inv, 0) = 0 THEN 'SITE' END WHEN isnull(invoice_customer_info.cus_inveachdel, 0) 
= 1 THEN CASE WHEN ex.cus_acct_to_inv != 0 AND isnull(invoice_customer_info.cus_invcons, 0) = 0 THEN 'NONE' WHEN isnull(ex.cus_acct_to_inv, 0) 
= 0 THEN 'NONE' END /* 'No Consolidation'*/ ELSE '' /* This not in RS orignal code but I think required to prevent NULLS being passed out.*/ END AS NX_BR_CONSOLIDATION, REPLACE(ISNULL(TRIM(CONVERT(VARCHAR(100), 
ex.CUS_INDUSTRY)), ''), '0', '') AS NX_LEGAL_ENTITY_DB, CASE WHEN ISNULL(TRIM(CONVERT(VARCHAR(100), ex.cus_importac)), '') = '0' THEN '' ELSE ISNULL(TRIM(CONVERT(VARCHAR(100), ex.cus_importac)), '') 
END AS NX_IMPORT_ACCOUNT,CASE WHEN ISNULL(TRIM(CONVERT(VARCHAR(100), ex.CUS_ACGroup)), '') = '0' THEN '' ELSE ISNULL(TRIM(CONVERT(VARCHAR(100), ex.CUS_ACGroup)), '') 
END AS NX_ACCOUNT_GROUP
FROM            DatasetProWat.Syn_Customer_ex ex LEFT JOIN
                         DatasetProWat.Syn_Customer_ex AS invoice_customer_info /*customer table joined to itself to pull the invoice account information, as it is its own record in customer*/ ON CASE WHEN ISNULL(ex.cus_acct_to_inv, 0) 
                         = 0 THEN ex.cus_account ELSE ex.cus_acct_to_inv END = invoice_customer_info.cus_account LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(VARCHAR(100), ex.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
WHERE        (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(VARCHAR(100), ex.CUS_Account)), LEFT(TRIM(ex.CUS_Company), 100), ISNULL(ex.CUS_Type, '{NULL}')) > 0)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[16] 4[28] 2[45] 3) )"
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
', 'SCHEMA', N'DatasetProWat', 'VIEW', N'Customer_Header_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetProWat', 'VIEW', N'Customer_Header_ex_Filtered', NULL, NULL
GO
