SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Dataset].[Customer_BillingRules_ex_Filtered]
AS
SELECT Dataset.Customer_BillingRules_dcex.ID, Dataset.Customer_BillingRules_dcex.MIG_SITE_NAME, Dataset.Customer_BillingRules_dcex.MIG_COMMENT, Dataset.Customer_BillingRules_dcex.MIG_CREATED_DATE, 
                  Dataset.Customer_BillingRules_dcex.CUST_ID, Dataset.Customer_BillingRules_dcex.ORDER_TYPE, Dataset.Customer_BillingRules_dcex.CUSTOMER_INVOICE, Dataset.Customer_BillingRules_dcex.PAYMENT_TERM, 
                  Dataset.Customer_BillingRules_dcex.CONS_RULE_DESC, 
				  Dataset.Filter_Customer(
				    Dataset.Customer_BillingRules_dcex.MIG_SITE_NAME,
					'ex', 
					ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
                    ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
					ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
					Dataset.Customer_BillingRules_dcex.CUST_ID, 
					Customer_Header_dcex.NAME, 
                    Customer_Header_dcex.CRM_ACCOUNT_TYPE) AS NX_FILTER_STATUS
FROM     Dataset.Customer_Header_dcex RIGHT OUTER JOIN
                  Dataset.Customer_BillingRules_dcex ON Customer_Header_dcex.MIG_SITE_NAME = Dataset.Customer_BillingRules_dcex.MIG_SITE_NAME AND 
                  Customer_Header_dcex.CUSTOMER_ID = Dataset.Customer_BillingRules_dcex.CUST_ID LEFT OUTER JOIN
                  Dataset.Customer_Filter_Override ON Dataset.Customer_BillingRules_dcex.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND 
                  Dataset.Customer_BillingRules_dcex.CUST_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID
WHERE  (Dataset.Filter_Customer(
  Dataset.Customer_BillingRules_dcex.MIG_SITE_NAME, 
  'ex', 
  ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
  ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
  ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
  Dataset.Customer_BillingRules_dcex.CUST_ID, 
  Customer_Header_dcex.NAME, 
  Customer_Header_dcex.CRM_ACCOUNT_TYPE) > 0)
GO
