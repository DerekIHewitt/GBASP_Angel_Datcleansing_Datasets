SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Dataset].[Customer_ContactNotes_dc_Filtered]
AS
SELECT 
Dataset.Customer_ContactNotes_dc.ID, 
Dataset.Customer_ContactNotes_dc.MIG_SITE_NAME, 
Dataset.Customer_ContactNotes_dc.[CUSTOMER_ID],
Dataset.Customer_ContactNotes_dc.[CONTACT_NAME], 
Dataset.Customer_ContactNotes_dc.[CONTACT_USER], 
Dataset.Customer_ContactNotes_dc.[NOTE_DATE],
Dataset.Customer_ContactNotes_dc.[NOTE_SHORT], 
Dataset.Customer_ContactNotes_dc.[NOTE_LONG], 
Dataset.Customer_ContactNotes_dc.[NOTE_REASON], 
Dataset.Filter_Customer(
	Dataset.Customer_ContactNotes_dc.MIG_SITE_NAME, 
	'dc', 
	ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
	ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
	ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
	Dataset.Customer_ContactNotes_dc.CUSTOMER_ID, 
	Dataset.Customer_Header_dc.NAME, 
	Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE
	) AS NX_FILTER_STATUS
FROM   
	Dataset.Customer_ContactNotes_dc 
LEFT OUTER JOIN
    Dataset.Customer_Filter_Override 
	ON	Dataset.Customer_ContactNotes_dc.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME 
	AND Dataset.Customer_ContactNotes_dc.CUSTOMER_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID 
LEFT OUTER JOIN
	Dataset.Customer_Header_dc 
	ON Dataset.Customer_ContactNotes_dc.MIG_SITE_NAME = Dataset.Customer_Header_dc.MIG_SITE_NAME 
	AND Dataset.Customer_ContactNotes_dc.CUSTOMER_ID = Dataset.Customer_Header_dc.CUSTOMER_ID
WHERE 
	(	Dataset.Filter_Customer(
			Dataset.Customer_ContactNotes_dc.MIG_SITE_NAME, 
			'dc', 
			ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
			ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
			ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
            Dataset.Customer_ContactNotes_dc.CUSTOMER_ID, 
			Dataset.Customer_Header_dc.NAME, 
			Dataset.Customer_Header_dc.CRM_ACCOUNT_TYPE
			) 
		> 0)
GO
