SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Dataset].[Customer_BillingRules_dc_Filtered]
AS
SELECT Dataset.Customer_BillingRules_dc.ID, Dataset.Customer_BillingRules_dc.MIG_SITE_NAME, Dataset.Customer_BillingRules_dc.MIG_COMMENT, Dataset.Customer_BillingRules_dc.MIG_CREATED_DATE, 
                  Dataset.Customer_BillingRules_dc.CUST_ID, Dataset.Customer_BillingRules_dc.ORDER_TYPE, Dataset.Customer_BillingRules_dc.CUSTOMER_INVOICE, Dataset.Customer_BillingRules_dc.PAYMENT_TERM, 
                  Dataset.Customer_BillingRules_dc.CONS_RULE_DESC, Dataset.Filter_Customer(Dataset.Customer_BillingRules_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
                  ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.Customer_BillingRules_dc.CUST_ID, Customer_Header_dc_1.NAME, 
                  Customer_Header_dc_1.CRM_ACCOUNT_TYPE) AS NX_FILTER_STATUS
FROM     Dataset.Customer_Header_dc AS Customer_Header_dc_1 RIGHT OUTER JOIN
                  Dataset.Customer_BillingRules_dc ON Customer_Header_dc_1.MIG_SITE_NAME = Dataset.Customer_BillingRules_dc.MIG_SITE_NAME AND 
                  Customer_Header_dc_1.CUSTOMER_ID = Dataset.Customer_BillingRules_dc.CUST_ID LEFT OUTER JOIN
                  Dataset.Customer_Filter_Override ON Dataset.Customer_BillingRules_dc.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND 
                  Dataset.Customer_BillingRules_dc.CUST_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID
WHERE  (Dataset.Filter_Customer(Dataset.Customer_BillingRules_dc.MIG_SITE_NAME, 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                  ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), Dataset.Customer_BillingRules_dc.CUST_ID, Customer_Header_dc_1.NAME, Customer_Header_dc_1.CRM_ACCOUNT_TYPE) > 0)
GO
