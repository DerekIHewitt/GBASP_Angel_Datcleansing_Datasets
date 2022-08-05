SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [DatasetCariad].[Customer_Header_ex_Filtered]
AS
SELECT        ID, MIG_SITE_NAME, '' AS MIG_COMMENT, MIG_CREATED_DATE, CUSTOMER_ID, NAME, ISNULL(NX_GROUP_ID, '') AS NX_GROUP_ID, ISNULL(PAY_TERM_ID, '') AS PAY_TERM_ID, ISNULL(NX_TAX_CODE, '') 
                         AS NX_TAX_CODE, ISNULL(NX_CUST_GRP, '') AS NX_CUST_GRP, ISNULL(CREDIT_LIMIT, '') AS CREDIT_LIMIT, ISNULL(NX_MARKET_CODE, '') AS NX_MARKET_CODE, ISNULL(INVOICE_CUSTOMER, '') AS INVOICE_CUSTOMER, 
                         ISNULL(NX_ORDER_TYPE, '') AS NX_ORDER_TYPE, ISNULL(NX_IDENTITY_TYPE_DB, '') AS NX_IDENTITY_TYPE_DB, NX_CYCLE_PERIOD, 'C' AS INVOICE_SORT_DB, ISNULL(NX_CATEGORY_DB, '') AS NX_CATEGORY_DB, 
                         ISNULL(NX_CREDIT_CONTROL_GROUP_ID, '') AS NX_CREDIT_CONTROL_GROUP_ID, ISNULL(EMAIL_ORDER_CONF_DB, 'FALSE') AS EMAIL_ORDER_CONF_DB, ISNULL(EMAIL_INVOICE_DB, 'FALSE') AS EMAIL_INVOICE_DB, 
                         ISNULL(NX_CREDIT_BLOCK, '') AS NX_CREDIT_BLOCK, ISNULL(NX_PAY_OUTPUT_MEDIA_DB, '') AS NX_PAY_OUTPUT_MEDIA_DB, ISNULL(NX_DEFAULT_PAYMENT_METHOD, '') AS NX_DEFAULT_PAYMENT_METHOD, 
                         'Core' AS CRM_ACCOUNT_TYPE, ISNULL(NX_ACTIVE_TRIAL_DB, 'NO') AS NX_ACTIVE_TRIAL_DB, ISNULL(NX_CCA_FLAG_DB, '') AS NX_CCA_FLAG_DB, ISNULL(NX_BLANKET_PURCHASE_ORDER, '') 
                         AS NX_BLANKET_PURCHASE_ORDER, ISNULL(NX_PO_EXPIRY_DATE, '') AS NX_PO_EXPIRY_DATE, ISNULL(NX_PO_EXPIRY_VALUE, '') AS NX_PO_EXPIRY_VALUE, ISNULL(NX_PO_VALUE_USED, '') AS NX_PO_VALUE_USED, 
                         ISNULL(PAYMENT_METHOD, '') AS PAYMENT_METHOD, ISNULL(PAY_ADDR_DESCRIPTION, '') AS PAY_ADDR_DESCRIPTION, ISNULL(PAY_ADDR_ACCOUNT, '') AS PAY_ADDR_ACCOUNT, ISNULL(PAY_ADDR_SORT_CODE, '') 
                         AS PAY_ADDR_SORT_CODE, ISNULL(PAY_ADDR_ACC_NAME, '') AS PAY_ADDR_ACC_NAME, ISNULL(NX_PAY_ADDR_BUILD_SOC_REF, '') AS NX_PAY_ADDR_BUILD_SOC_REF, ISNULL(NX_PAY_ADDR_TRANS_CODE, '') 
                         AS NX_PAY_ADDR_TRANS_CODE, ISNULL(NX_PAY_ADDR_OUR_REF, '') AS NX_PAY_ADDR_OUR_REF, 'CA04' AS CREDIT_ANALYST, ISNULL(NX_MESSAGE_GROUP, '') AS NX_MESSAGE_GROUP, 
                         ISNULL(NX_ALLOWED_OVERDUE_AMOUNT, '') AS NX_ALLOWED_OVERDUE_AMOUNT, ISNULL(NX_ALLOWED_OVERDUE_DAYS, '') AS NX_ALLOWED_OVERDUE_DAYS, ISNULL(NX_CREDIT_RELATIONSHIP_EXIST, '') 
                         AS NX_CREDIT_RELATIONSHIP_EXIST, ISNULL(NX_CREDIT_RELATIONSHIP_TYPE_DB, '') AS NX_CREDIT_RELATIONSHIP_TYPE_DB, ISNULL(NX_PARENT_COMPANY, '') AS NX_PARENT_COMPANY, 
                         ISNULL(NX_PARENT_CUSTOMER_ID, '') AS NX_PARENT_CUSTOMER_ID, ISNULL(NX_MAIN_REP, '') AS NX_MAIN_REP, ISNULL(NX_CUST_ORDER_INVOICING_DB, '') AS NX_CUST_ORDER_INVOICING_DB, 
                         ISNULL(NX_CUST_ORDER_INV_TYPE_DB, '') AS NX_CUST_ORDER_INV_TYPE_DB, ISNULL(NX_CONSOLIDATION_DAY_DB, '') AS NX_CONSOLIDATION_DAY_DB, ISNULL(NX_ORDER_CONF_FLAG_DB, '') 
                         AS NX_ORDER_CONF_FLAG_DB, ISNULL(NX_PACK_LIST_FLAG_DB, '') AS NX_PACK_LIST_FLAG_DB, ISNULL(NX_SUMMARIZED_SOURCE_LINES_DB, '') AS NX_SUMMARIZED_SOURCE_LINES_DB, 
                         ISNULL(NX_PRINT_AMOUNTS_INCL_TAX_DB, '') AS NX_PRINT_AMOUNTS_INCL_TAX_DB, ISNULL(NX_CUST_PRICE_GROUP_ID, '') AS NX_CUST_PRICE_GROUP_ID, ISNULL(NX_SAGE_CODE, '') AS NX_SAGE_CODE, 
                         ISNULL(NX_OLD_CUST_REF1, '') AS NX_OLD_CUST_REF1, ISNULL(NX_OLD_CUST_REF2, '') AS NX_OLD_CUST_REF2, 'CARIAD' AS ACQUIRED_FROM_COMP, ISNULL(NX_BOOK_IN_DB, 'NO') AS NX_BOOK_IN_DB, 
                         ISNULL(NX_NO_LIMIT_DB, '') AS NX_NO_LIMIT_DB, ISNULL(NX_ON_SITE_RA_DB, '') AS NX_ON_SITE_RA_DB, ISNULL(NX_PURCHASE_ORDER_REQ_DB, '') AS NX_PURCHASE_ORDER_REQ_DB, ISNULL(ASSOCIATION_NO, '') 
                         AS ASSOCIATION_NO, ISNULL(NX_SHORT_TERM_DB, '') AS NX_SHORT_TERM_DB, ISNULL(NX_COST_CODE, '') AS NX_COST_CODE, ISNULL(NX_BR_ORDER_TYPE, '') AS NX_BR_ORDER_TYPE, 
                         ISNULL(NX_BR_CONSOLIDATION, '') AS NX_BR_CONSOLIDATION, ISNULL(NX_BR_BLOCKED_DD, '') AS NX_BR_BLOCKED_DD, ISNULL(NX_INVOICE_FEE, '') AS NX_INVOICE_FEE, ISNULL(NX_PRINT_TAX_CODE_TEXT, '') 
                         AS NX_PRINT_TAX_CODE_TEXT, ISNULL(NX_LEGAL_ENTITY_DB, '') AS NX_LEGAL_ENTITY_DB, ISNULL(NX_IMPORT_ACCOUNT, '') AS NX_IMPORT_ACCOUNT, ISNULL(NX_ACCOUNT_GROUP, '') 
                         AS NX_ACCOUNT_GROUP
FROM            OPENQUERY(CARIAD, 
                         '--decision made to not pull payment info on the customer header but will be output separately for Andrew
--and Roanne to decide rules for mandate management load
SELECT rownum AS ID,
       ''GBCA1'' AS MIG_SITE_NAME,
	   ''''  AS MIG_COMMENT,
	   sysdate AS MIG_CREATED_DATE,
       C.CUSTOMER_ID,
       C.NAME,
       I.GROUP_ID AS NX_GROUP_ID,
       I.PAY_TERM_ID,
       I.DEF_VAT_CODE NX_TAX_CODE,
       CO.CUST_GRP AS NX_CUST_GRP,
       CR.CREDIT_LIMIT,
       CO.MARKET_CODE AS NX_MARKET_CODE,
       CO.CUSTOMER_NO_PAY INVOICE_CUSTOMER,
       CO.ORDER_ID NX_ORDER_TYPE,
       IDENTITY_TYPE_DB AS NX_IDENTITY_TYPE_DB,
       CYCLE_PERIOD AS NX_CYCLE_PERIOD,
       CO.INVOICE_SORT_DB,
       CATEGORY_DB AS NX_CATEGORY_DB,
       CREDIT_CONTROL_GROUP_ID AS NX_CREDIT_CONTROL_GROUP_ID,
       CO.EMAIL_ORDER_CONF_DB,
       CO.EMAIL_INVOICE_DB,
       CR.CREDIT_BLOCK AS NX_CREDIT_BLOCK,
       IP.output_media_db NX_PAY_OUTPUT_MEDIA_DB,
       '''' NX_DEFAULT_PAYMENT_METHOD,
       C.CF$_CRM_ACCOUNT_TYPE CRM_ACCOUNT_TYPE,
       c.CF$_ACTIVE_TRIAL_DB NX_ACTIVE_TRIAL_DB,
       c.CF$_CCA_CUST_HEADER_DB AS NX_CCA_FLAG_DB,
       C.CF$_BLANKET_PURCHASE_ORDER NX_BLANKET_PURCHASE_ORDER,
       to_char(C.CF$_PO_EXPIRY_DATE,''yyyy-mm-dd'') NX_PO_EXPIRY_DATE,
       C.CF$_PO_EXPIRY_VALUE NX_PO_EXPIRY_VALUE,
       C.CF$_PO_VALUE_USED NX_PO_VALUE_USED,
       '''' PAYMENT_METHOD,
       '''' PAY_ADDR_DESCRIPTION,
       '''' PAY_ADDR_ACCOUNT,
       '''' PAY_ADDR_SORT_CODE,
       '''' PAY_ADDR_ACC_NAME,
       '''' NX_PAY_ADDR_BUILD_SOC_REF,
       '''' NX_PAY_ADDR_TRANS_CODE,
       '''' NX_PAY_ADDR_OUR_REF,
       CR.CREDIT_ANALYST_CODE CREDIT_ANALYST,
       CR.MESSAGE_TYPE NX_MESSAGE_GROUP,
       CR.allowed_due_amount NX_ALLOWED_OVERDUE_AMOUNT,
       CR.allowed_due_days NX_ALLOWED_OVERDUE_DAYS,
       CR.corp_credit_relation_exist NX_CREDIT_RELATIONSHIP_EXIST,
       CREDIT_RELATIONSHIP_TYPE_DB NX_CREDIT_RELATIONSHIP_TYPE_DB,
       PARENT_COMPANY NX_PARENT_COMPANY,
       CR.PARENT_IDENTITY NX_PARENT_CUSTOMER_ID,
       --MR.MAIN_REPRESENTATIVE_ID NX_MAIN_REP, --MAIN_REP MIGHT BE MAIN REPRESENTATIVE AS TWO OPTIONS IN THE VIEW,
	   C.CUSTOMER_ID NX_MAIN_REP,
       CO.CF$_CUST_ORDER_INVOICING_DB NX_CUST_ORDER_INVOICING_DB,
       CO.CF$_CUST_ORDER_INV_TYPE_DB NX_CUST_ORDER_INV_TYPE_DB,
       CO.CF$_CONSOLIDATION_DAY_DB NX_CONSOLIDATION_DAY_DB,
	   CO.ORDER_CONF_FLAG_DB AS NX_ORDER_CONF_FLAG_DB,
	   CO.PACK_LIST_FLAG_DB AS NX_PACK_LIST_FLAG_DB,
	   CO.SUMMARIZED_SOURCE_LINES_DB AS NX_SUMMARIZED_SOURCE_LINES_DB,
	   CO.PRINT_AMOUNTS_INCL_TAX_DB AS NX_PRINT_AMOUNTS_INCL_TAX_DB,
	   CO.CUST_PRICE_GROUP_ID AS NX_CUST_PRICE_GROUP_ID,
       C.CF$_SAGE_CODE NX_SAGE_CODE,
       C.CUSTOMER_ID AS NX_OLD_CUST_REF1, --AMENDED THIS TO TAKE THE CARIAD CUSTOMER ID AS OLD CUST REF1
       C.CF$_OLD_CUSTOMER_REF2 NX_OLD_CUST_REF2,
       C.CF$_ACQUIRED_FROM_COMP ACQUIRED_FROM_COMP,
       C.CF$_BOOK_IN_DB NX_BOOK_IN_DB,
       C.CF$_NO_LIMIT_DB NX_NO_LIMIT_DB,
       C.CF$_ON_SITE_RA_DB NX_ON_SITE_RA_DB,
       C.CF$_PURCHASE_ORDER_REQ_DB NX_PURCHASE_ORDER_REQ_DB,
       C.ASSOCIATION_NO ASSOCIATION_NO,
       C.CF$_SHORT_TERM_DB NX_SHORT_TERM_DB,
       '''' NX_COST_CODE,
       '''' AS NX_BR_ORDER_TYPE,
       '''' AS NX_BR_CONSOLIDATION,
	   '''' AS NX_BR_BLOCKED_DD,
       INVOICE_FEE NX_INVOICE_FEE,
	   I.PRINT_TAX_CODE_TEXT AS NX_PRINT_TAX_CODE_TEXT,
       '''' AS NX_LEGAL_ENTITY_DB,
       C.CF$_IMPORT_ACCOUNT NX_IMPORT_ACCOUNT
       ,'''' NX_ACCOUNT_GROUP --THis is not used in the latest mig job CO.CF$_WL_ACC_GROUP_DB

  FROM CUSTOMER_INFO_CFV C
  LEFT JOIN CUST_ORD_CUSTOMER_CFV CO
    ON CO.customer_no = C.CUSTOMER_ID
  LEFT JOIN IDENTITY_INVOICE_INFO I
    ON C.CUSTOMER_ID = I.IDENTITY
   AND C.PARTY_TYPE_DB = I.PARTY_TYPE_DB
  LEFT JOIN identity_pay_info IP
    ON IP.IDENTITY = C.CUSTOMER_ID
   AND C.PARTY_TYPE_DB = IP.PARTY_TYPE_DB
  LEFT JOIN CUSTOMER_CREDIT_INFO_CUST CR
    ON CR.IDENTITY = C.CUSTOMER_ID
   AND CR.PARTY_TYPE_DB = C.PARTY_TYPE_DB

 LEFT JOIN CRM_CUST_INFO MR ON
    MR.CUSTOMER_ID = C.CUSTOMER_ID

  /*LEFT JOIN PAYMENT_WAY_PER_IDENTITY PW --DECISION MADE TO OMIT BANKING INFORMATION AND RETIREVED SEPARATELY--                               
    ON PW.IDENTITY = C.CUSTOMER_ID
   AND PW.PARTY_TYPE_DB = C.PARTY_TYPE_DB
  left JOIN PAYMENT_ADDRESS PA --SAME WITH PAYMENT ADDRESS
    ON PA.IDENTITY = C.CUSTOMER_ID
   AND PA.PARTY_TYPE_DB = C.PARTY_TYPE_DB
   */

--5596 CUSTOMER HEADER RECORDS 23/05/2022
')
                          AS derivedtbl_1
WHERE        (NOT EXISTS
                             (SELECT        1 AS Expr1
                               FROM            Dataset.Customer_Filter_Override AS F
                               WHERE        (MIG_SITE_NAME = 'GBCA1') AND (CUSTOMER_ID = derivedtbl_1.CUSTOMER_ID) AND (IsAlwaysExcluded = 1)))
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[31] 2[31] 3) )"
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
               Right = 327
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
', 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Header_ex_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetCariad', 'VIEW', N'Customer_Header_ex_Filtered', NULL, NULL
GO
