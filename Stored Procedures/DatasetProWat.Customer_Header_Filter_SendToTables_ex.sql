SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RISM
  Description: Filter out unwanted Customer accounts. The criteria to allow a customer through is:
  --1.	Has Equipment
  --2.	Has open transactions
  --3.	Is Invoice Account
  --4.	Is Key Account only – Migrate consistent minimum data, bypass validation
  --5.	Has confirmed orders generated in the last 24 months
  --6.	Has a Created Date in the last 24 months

--			   RISM 2021-05-20 Created based on GBASP Data Cleansing po send for transform
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Customer_Header_Filter_SendToTables_ex]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	--DECLARE @FilterMode int = Dataset.Filter_Mode('ex','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Filter_Override] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME
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
				@MIG_SITENAME																			AS MIG_SITE_NAME,
				GETDATE()																				AS MIG_CREATED_DATE,
				''																						AS MIG_COMMENT,
				C.CUS_ACCOUNT																			AS CUSTOMER_ID,

			    CASE WHEN COUNT(E.EQH_IDNO) >0                                   THEN 1
					 WHEN C.CUS_TYPE IN ('INVOICE', 'KEY')                       THEN 1
					 WHEN ISNULL(S.SAG_UNPAID,0) <> 0                            THEN 1
					 WHEN O.ORDERNUM IS NOT NULL                                 THEN 1
					 WHEN dbo.convertfromclarion(C.CUS_CREATED) > GETDATE() -730 THEN 1
					 ELSE 0 END																			AS isAlwaysIncluded,

				CASE WHEN 
					 CASE WHEN COUNT(EQH_IDNO) >0                                THEN 1
					 WHEN C.CUS_TYPE IN ('INVOICE', 'KEY')                       THEN 1
					 WHEN ISNULL(SAG_UNPAID,0) <> 0                              THEN 1
					 WHEN O.ORDERNUM IS NOT NULL                                 THEN 1
					 WHEN dbo.convertfromclarion(C.CUS_CREATED) > GETDATE() -730 THEN 1
					 ELSE 0 END
		    	 = 1 THEN 0 ELSE 1 END																    AS isAlwaysExcluded,

				0																						AS IsOnSubsetList



FROM      DatasetProWat.Syn_Customer_ex C
LEFT JOIN DatasetProWat.Syn_EquipHdr_ex E ON C.CUS_ACCOUNT = E.EQH_ACCOUNT
LEFT JOIN (
			select distinct sag_account,  isdate(MAX(isnull(DBO.CONVERTFROMCLARION(SAG_TRANDATE),''))) AS SAG_TRANDATE, MAX(isnull(SAG_UNPAID,0)) AS SAG_UNPAID
			from DatasetProWat.Syn_Customer_ex C left join DatasetProWat.Syn_Sagetran_ex S
			on S.SAG_ACCOUNT = CASE WHEN C.CUS_ACCT_TO_INV = 0 THEN C.CUS_ACCOUNT ELSE C.CUS_ACCT_TO_INV END 
			group by s.sag_Account 
			) S 
			ON S.SAG_ACCOUNT = CASE WHEN C.CUS_ACCT_TO_INV = 0 THEN C.CUS_ACCOUNT ELSE C.CUS_ACCT_TO_INV END 
LEFT JOIN
(SELECT distinct

ord_account, 
max(ord_ordernum) as ordernum,
MAX([dbo].[ShowOrderStatus](ORD_STATUS, ORD_INVFLAG)) as OrderStatus,
max(DBO.CONVERTFROMCLARION([ORD_Request_Date])) as RequestDate
FROM DatasetProwat.Syn_Orders_ex O
JOIN DatasetProWat.Syn_OrdLines_ex  OL ON OL.ORL_ORDERNUM = O.ORD_ORDERNUM
group by ord_account, [dbo].[ShowOrderStatus](ORD_STATUS, ORD_INVFLAG)
having MAX(DBO.CONVERTFROMCLARION([ORD_Request_Date])) > GETDATE()-720
AND [dbo].[ShowOrderStatus](ORD_STATUS, ORD_INVFLAG) IN ('Invoiced')--,'Confirmed')
and sum(orl_qty_ord) > 0
)O
on O.ord_account = c.cus_account

GROUP BY C.CUS_ACCOUNT, C.CUS_TYPE,C.CUS_CREATED,O.ORDERNUM,S.SAG_UNPAID,O.RequestDate--,S.SAG_TRANDATE,S.SAG_UNPAID,   ,E.EQH_ID,
HAVING C.CUS_TYPE NOT LIKE 'STOCK'

END





GO
