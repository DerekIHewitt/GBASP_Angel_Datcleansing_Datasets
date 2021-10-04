SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Dataset].[Customer_ContactNotes_Ex_Filtered]
AS
SELECT 
Dataset.Customer_ContactNotes_DcEx.ID, 
Dataset.Customer_ContactNotes_DcEx.MIG_SITE_NAME, 
Dataset.Customer_ContactNotes_DcEx.[CUSTOMER_ID],
Dataset.Customer_ContactNotes_DcEx.[CONTACT_NAME], 
Dataset.Customer_ContactNotes_DcEx.[CONTACT_USER], 
Dataset.Customer_ContactNotes_DcEx.[NOTE_DATE],
Dataset.Customer_ContactNotes_DcEx.[NOTE_SHORT], 
Dataset.Customer_ContactNotes_DcEx.[NOTE_LONG], 
Dataset.Customer_ContactNotes_DcEx.[NOTE_REASON], 
Dataset.Filter_Customer(
	Dataset.Customer_ContactNotes_DcEx.MIG_SITE_NAME, 
	'ex', 
	ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
	ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
	ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
	Dataset.Customer_ContactNotes_DcEx.CUSTOMER_ID, 
	Dataset.Customer_Header_ex.NAME, 
	Dataset.Customer_Header_ex.CRM_ACCOUNT_TYPE
	) AS NX_FILTER_STATUS
FROM   
	Dataset.Customer_ContactNotes_DcEx 
LEFT OUTER JOIN
    Dataset.Customer_Filter_Override 
	ON	Dataset.Customer_ContactNotes_DcEx.MIG_SITE_NAME = Dataset.Customer_Filter_Override.MIG_SITE_NAME 
	AND Dataset.Customer_ContactNotes_DcEx.CUSTOMER_ID = Dataset.Customer_Filter_Override.CUSTOMER_ID 
LEFT OUTER JOIN
	Dataset.Customer_Header_ex 
	ON Dataset.Customer_ContactNotes_DcEx.MIG_SITE_NAME = Dataset.Customer_Header_ex.MIG_SITE_NAME 
	AND Dataset.Customer_ContactNotes_DcEx.CUSTOMER_ID = Dataset.Customer_Header_ex.CUSTOMER_ID
WHERE 
	(	Dataset.Filter_Customer(
			Dataset.Customer_ContactNotes_DcEx.MIG_SITE_NAME, 
			'ex', 
			ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), 
			ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
			ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), 
            Dataset.Customer_ContactNotes_DcEx.CUSTOMER_ID, 
			Dataset.Customer_Header_ex.NAME, 
			Dataset.Customer_Header_ex.CRM_ACCOUNT_TYPE
			) 
		> 0)
GO
