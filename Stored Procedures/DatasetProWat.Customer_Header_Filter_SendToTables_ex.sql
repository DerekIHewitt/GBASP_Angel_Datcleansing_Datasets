SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*=============================================
  Author:      RISM
  Description: Filter out unwanted Customer accounts. The criteria to allow a customer through is:
  --1.	Has Equipment
  --2.	Has open transactions
  --3.	Is an Invoice Account - a value in cus_acct_to_inv in Prowat against a delivery customer
  --4.	Is Key Account only   – a value in the cus_pricebookac in Prowat against a delivery customer
  --5.	Has confirmed orders generated in the last 24 months
  --6.	Has a Created Date in the last 24 months

--RISM 2021-05-20 Created based on GBASP Data Cleansing po send for transform
--7 RYFE 2021-06-09 Modified according to new script
--8 RISM 2021-06-28 Added declarative date as need to have 2 years from the cutover date rather than getdate
                   as each time you run it moves the timeline, but dont want to hardcode so can add the 
				   required date on the running of the proc
--9 RISM 2021-07-07 Previous rule joined the sagetran by invoice accounts. request was to join to delivery account link only
-10 RISM 2021-07-13 Requested to reduce points 5 & 6 down to 12 months
-11 RISM 2021-07-13 Changed the sagetran join got link to the delivery account to sag_delacct and the invoice account to sag_account to pull the right balance at delivery level
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Customer_Header_Filter_SendToTables_ex]

 -- @cutdate datetime,
AS
BEGIN
SET NOCOUNT ON;

	
	  -- RISM 2021-06-28
	 DECLARE  @MIG_SITE_NAME VARCHAR(5) = 'GBASP';
     DECLARE  @cutdate datetime = CONVERT(VARCHAR, '05/24/2021', 103);
	--DECLARE @FilterMode int = Dataset.Filter_Mode('ex','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Filter_Override] 
		WHERE MIG_SITE_NAME = @MIG_SITE_NAME
		COMMIT TRANSACTION
	---------------- Add records to the loading table ---------------------------------------------------------

	INSERT into	 [Dataset].[Customer_Filter_Override] 
				([MIG_SITE_NAME]
				,[MIG_CREATED_DATE]
				,[MIG_COMMENT]
				,[CUSTOMER_ID]
				,[isAlwaysIncluded]
				,[isAlwaysExcluded]
				,[IsOnSubsetList]
				)
				SELECT
				@MIG_SITE_NAME																			AS MIG_SITE_NAME,
				GETDATE()																				AS MIG_CREATED_DATE,
				''																						AS MIG_COMMENT,
				C.CUS_ACCOUNT																			AS CUSTOMER_ID,

			     CASE WHEN COUNT(E.EQH_IDNO) >0                                  THEN 1
				  -- WHEN C.CUS_TYPE IN ('INVOICE', 'KEY')                       THEN 1					--08/06/21 RS NO LONGER REQUIRED AS CUS TYPE DEEMED TOO INACCURATE. APPENDED RULES AS PER INVOICE AND KEY ACCOUNT JOINS
				     WHEN ISNULL(inv.INVOICE,0) > 0							     THEN 1					--08/06/21 RS. IF INVOICE ACCOUNT THEN IS PRESENT AS AN INVOICE ACCOUNT FOR A DELIVERY ACCOUNT SO NEEDS TO GO THROUGH
					 WHEN ISNULL([KEY].[KEY],0) > 0                              THEN 1					--08/06/21 RS. IF KEY ACCOUNT THEN IS PRESENT AS A KEY ACCOUNT FOR A DELIVERY ACCOUNT SO NEEDS TO GO THROUGH
					 WHEN ISNULL(S.SAG_UNPAID,0) <> 0                            THEN 1
					 WHEN O.ORDERNUM IS NOT NULL and C.CUS_COMPANY NOT LIKE 'ZZZ%' THEN 1
					 WHEN dbo.convertfromclarion(ISNULL(C.CUS_CREATED,0)) > @cutdate -365 and C.CUS_COMPANY NOT LIKE 'ZZZ%' THEN 1 
					 ELSE 0 END																			AS isAlwaysIncluded,
				
        
						CASE WHEN 
					 CASE WHEN COUNT(EQH_IDNO) >0                                THEN 1
				   --WHEN C.CUS_TYPE IN ('INVOICE', 'KEY')                       THEN 1				    --08/06/21 RS NO LONGER REQUIRED AS CUS TYPE DEEMED TOO INACCURATE. APPENDED RULES AS PER INVOICE AND KEY ACCOUNT JOINS
					 WHEN ISNULL(inv.INVOICE,0) > 0							     THEN 1					--08/06/21 RS. IF INVOICE ACCOUNT THEN IS PRESENT AS AN INVOICE ACCOUNT FOR A DELIVERY ACCOUNT SO NEEDS TO GO THROUGH
					 WHEN ISNULL([KEY].[KEY],0) > 0                              THEN 1					--08/06/21 RS. IF KEY ACCOUNT THEN IS PRESENT AS A KEY ACCOUNT FOR A DELIVERY ACCOUNT SO NEEDS TO GO THROUGH
					 WHEN ISNULL(SAG_UNPAID,0) <> 0                              THEN 1
					 WHEN O.ORDERNUM IS NOT NULL and C.CUS_COMPANY NOT LIKE 'ZZZ%' THEN 1
					 WHEN dbo.convertfromclarion(ISNULL(C.CUS_CREATED,0)) > @cutdate -365 and C.CUS_COMPANY NOT LIKE 'ZZZ%' THEN 1 --IF CREATED IN LAST 12 MONTHS AND IS NOT A ZZZ THEN ALOW THROUGH
     
					 ELSE 0 END
		    	 = 1 THEN 0 ELSE 1 END																    AS isAlwaysExcluded,

				0																						AS IsOnSubsetList


FROM      DatasetProWat.Syn_Customer_ex C

LEFT JOIN (select distinct cus_acct_to_inv as 'INVOICE' from DatasetProWat.Syn_Customer_ex where cus_acct_to_inv <>0) INV
       ON inv.INVOICE = c.cus_account
LEFT JOIN (select distinct cus_pricebookac as 'KEY' from DatasetProWat.Syn_Customer_ex where cus_pricebookac <>0) [key]
       ON [KEY].[KEY] = c.cus_account

LEFT JOIN DatasetProWat.Syn_EquipHdr_ex E ON C.CUS_ACCOUNT = E.EQH_ACCOUNT
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
LEFT JOIN (
			select distinct sag_account,  isdate(MAX(isnull(DBO.CONVERTFROMCLARION(SAG_TRANDATE),''))) AS SAG_TRANDATE, MAX(isnull(SAG_UNPAID,0)) AS SAG_UNPAID
			from DatasetProWat.Syn_Customer_ex C  join DatasetProwat.Syn_SageTran_ex s
			--on S.SAG_ACCOUNT = CASE WHEN C.CUS_ACCT_TO_INV = 0 THEN C.CUS_ACCOUNT ELSE C.CUS_ACCT_TO_INV END --Newer rule change to limit sage to delivery account level
			on S.SAG_account = C.CUS_ACCOUNT
			--and s.sag_account = c.cus_acct_to_inv
		
			group by  sag_account
			) S 
	  ON S.SAG_account =  C.CUS_ACCOUNT 
	 --AND S.SAG_ACCOUNT = C.CUS_ACCT_TO_INV
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

LEFT JOIN
(SELECT distinct

ord_account, 
max(ord_ordernum) as ordernum,
MAX([dbo].[ShowOrderStatus](ORD_STATUS, ORD_INVFLAG)) as OrderStatus,
max(DBO.CONVERTFROMCLARION([ORD_Request_Date])) as RequestDate
FROM DatasetProwat.Syn_Orders_ex O
JOIN DatasetProWat.Syn_OrdLines_ex  OL ON OL.ORL_ORDERNUM = O.ORD_ORDERNUM
group by ord_account, [dbo].[ShowOrderStatus](ORD_STATUS, ORD_INVFLAG)
having MAX(DBO.CONVERTFROMCLARION([ORD_Request_Date])) > @cutdate -365									--13/07/2021 RS. REDUCED TO 12 MONTHS
AND [dbo].[ShowOrderStatus](ORD_STATUS, ORD_INVFLAG) IN ('Invoiced')--,'Confirmed')
and sum(orl_qty_ord) > 0
)O
on O.ord_account = c.cus_account

GROUP BY C.CUS_ACCOUNT, C.CUS_TYPE,C.CUS_CREATED,O.ORDERNUM,S.SAG_UNPAID,O.RequestDate,o.OrderStatus, c.cus_acct_to_inv,inv.INVOICE, c.cus_pricebookac, [key].[key],C.CUS_COMPANY--,S.SAG_TRANDATE,S.SAG_UNPAID,   ,E.EQH_ID,
HAVING C.CUS_TYPE NOT LIKE 'STOCK'
AND  C.CUS_ACCOUNT > 90

END

--CONVERT(VARCHAR,@your_date_Value,103)



GO
