SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RYFE
  Description: Retrieve Purchase Order details where possible
--			   RYFE 2021-02-19 Created based on GBASP Data Cleansing customer contact send for transform
--			   RISM 2021-06-23 Op status ID wasn't always pulling a correct value due to duplicate records pre pivot, so added rules to pull
--								the 1-20 route suffix only
--			   RYFE 2021-10-18 Added field price
--			   RYFE 2021-11-24 route like %999 to become SUB
=============================================*/
CREATE PROCEDURE [DatasetProWat].[PM_Actions_Non_SC_SendToTables_ex]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	--DECLARE @FilterMode int = Dataset.Filter_Mode('dc','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[PM_Actions_Non_SC_ex] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME

		DELETE FROM [Dataset].[PM_Actions_Non_SC_Material_ex]
		WHERE MIG_SITE_NAME = @MIG_SITENAME

		COMMIT TRANSACTION
	---------------- Add records to the loading table ---------------------------------------------------------
	
		
	
  
	

	INSERT into	[Dataset].[PM_Actions_Non_SC_ex] 
		(   [MIG_SITE_NAME]
      ,[PM_NO]
      ,[SITE]
      ,[OBJECT_ID]
      ,[ACTION]
      ,[WO_SITE]
      ,[WORK_TYPE]
      ,[START_VALUE]
      ,[INTERVAL]
      ,[INTERVAL_UNIT]
      ,[CUSTOMER_ID]
      ,[CONTRACT_ID]
      ,[LINE_NO]
      ,[STANDARD_JOB_ID]
      ,[STANDARD_JOB_REVISION]
      ,[QTY]
      ,[PERFORMED_DATE_BASED]
      ,[OPERATIONAL_STATUS_ID]
      ,[VENDOR_NO]
		)
		SELECT  DISTINCT
      'GBASP'																									AS MIG_SITE_NAME
	  , ''																										AS [PM_NO]
      ,'UK300'																									AS [SITE]
      ,aut_account																								AS [OBJECT_ID]
      ,CASE WHEN S.[PM ACTION TYPE] = '1-20' THEN 'CALL' WHEN S.[PM ACTION TYPE] = 'SUB'THEN 'DEL' ELSE '' END	AS [ACTION]
      ,'UK300'																									AS [WO_SITE] -- CUS_DEPOTID was removed because the WO site sould be UK300 always
      ,'DEL'																									AS [WORK_TYPE]
      ,CASE WHEN S.[PM ACTION TYPE] = '1-20' THEN '' WHEN S.[PM ACTION TYPE] = 'SUB'THEN GETDATE() ELSE '' END	AS [START_VALUE]
      ,CASE WHEN S.[PM ACTION TYPE] = '1-20' THEN '' WHEN S.[PM ACTION TYPE] = 'SUB' THEN CONVERT(varchar,AUT_FREQ) ELSE '' END AS  [INTERVAL]
      ,CASE WHEN S.[PM ACTION TYPE] = '1-20' THEN '' WHEN S.[PM ACTION TYPE] = 'SUB' THEN 'Week' ELSE '' END	AS [INTERVAL_UNIT]
      ,AUT_ACCOUNT																								AS [CUSTOMER_ID]
      ,''																										AS [CONTRACT_ID]
      ,''																										AS [LINE_NO]
      ,'SUB-NA-DEL'																								AS [STANDARD_JOB_ID]
      ,'1'																										AS [STANDARD_JOB_REVISION]
      ,CASE WHEN S.[PM ACTION TYPE] = '1-20' THEN '' WHEN S.[PM ACTION TYPE] = 'SUB'THEN 1  ELSE '' END			AS [QTY]					-- Added std job quantity as 1 because material will be migrated seperately        
      ,'No'																										AS [PERFORMED_DATE_BASED]
      -- ,CASE WHEN S.OPERATIONAL_STATUS like '%with op status' THEN right(trim(are_area),2) ELSE '' END	--RISM 2021-06-23 removed as put new logic in beloe
	  ,S.OP_STATUS_ID																							AS [OPERATIONAL_STATUS_ID]  --RISM 2021-06-23 new logic
	   , SUPPLIER_ID																							AS VENDOR_NO	
	   --S.[PM ACTION TYPE]   --only for reference, not in the pm mig job
FROM 
(
SELECT
 [AUT_Account]
,PIV.CUS_DEPOTID
,[AUT_Stock_Code]
,[AUT_Qty]
,[AUT_Last_Qty]
,[AUT_Freq]
,dbo.convertfromclarion([AUT_Last_Del]) 'Last Del'
,dbo.convertfromclarion([AUT_Next_Del]) 'Next Del'
,CASE WHEN right(trim(Are.are_area),2) in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20') THEN right(trim(Are.are_area),2)
ELSE ' ' END AS OP_STATUS_ID  --RISM 2021-06-23  added in to avoid pulling sub route suffix when two or more records to choose from
,are.are_area
,case when right(trim(Are.are_area),3) like 'SUB' then 'SUB'
      when trim(Are.are_area) like '%999' then 'SUB'
	  when right(trim(Are.are_area),2) in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20') then '1-20' 
      else 'FALLOUT' end as [CHECK]
,[AUT_ID]
,OPERATIONAL_STATUS
,[PM ACTION TYPE]
,CASE WHEN ARE_AREA LIKE'HYG SUB%' THEN '11600747' 
	  WHEN ARE_AREA LIKE 'NSCSUB' THEN '11600749'
	  WHEN ARE_AREA LIKE 'THIRSTY WORK' THEN '11000546'
	  WHEN ARE_AREA LIKE 'CONSPLUS' THEN '11000172' 
	  ELSE '' END AS SUPPLIER_ID
FROM [DatasetProWat].[Syn_Auto_ex] aut
JOIN [DatasetProWat].[Syn_Area_ex] are on aut.aut_routeid = are.are_routeid
JOIN 
  (select distinct *,
CASE WHEN PVT.[SUB] = 0 AND PVT.[1-20] > 1 THEN '1-20'         --MAKE A 1-20 ROUTE WITH BARE INFO AS PER WORD DOC
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 0 THEN 'NORECORD'
     WHEN PVT.[SUB] = 1 AND PVT.[1-20] > 1 THEN 'SUB'            --1 sub – multi 1-20 (14) – Sent to UK, leave Operational Status blank. do not create equivalent 1-20 routes, not needed
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] > 1 THEN 'SUB'            --Multi sub - multi 1-20 (4) – Sent to UK, leave Operational Status blank. do not create any 1-20's only make one SUB
	 WHEN PVT.[SUB] > 0 AND PVT.[1-20] = 0 THEN 'SUB'            --Sub route only (400) – Sent to UK, leave Operational Status blank.
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 1 THEN '1-20'  --1-20 route only – Above rules are ok. MAKW 1-20 AND CHOOSE THE SINGLE ROUTE FOR OP STAT
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] = 1 THEN 'SUB'   --2 sub – 1 1-20 route (1) – 2 Sub PM Actions with operational status the same. = ONE SUB - OP STATUS FROM 1-20. TAKE MULTI MATERIASL FROM SUBS INTO MATERIALS
	 WHEN PVT.[SUB] = 1 AND PVT.[1-20] = 1 THEN 'SUB'   --1 sub – 1 1-20 route – Above rules are ok. CREATE SUB TAKE 1-20 DATA FOR THE OP STATUS
	 ELSE NULL END AS 'PM ACTION TYPE'
,CASE WHEN PVT.[SUB] = 0 AND PVT.[1-20] > 1 THEN 'MULTI 1-20 ROUTE ONLY:bare minimum 1-20 route'         --MAKE A 1-20 ROUTE WITH BARE INFO AS PER WORD DOC
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 0 THEN 'NO ROUTES: Do not create any records'
     WHEN PVT.[SUB] = 1 AND PVT.[1-20] > 1 THEN '1 SUB MULTI 1-20: Make one SUB route ONLY op status blank'            --1 sub – multi 1-20 (14) – Sent to UK, leave Operational Status blank. do not create equivalent 1-20 routes, not needed
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] > 1 THEN 'MULTI BOTH: Make one Sub route ONLY op status blank'            --Multi sub - multi 1-20 (4) – Sent to UK, leave Operational Status blank. do not create any 1-20's only make one SUB
	 WHEN PVT.[SUB] > 0 AND PVT.[1-20] = 0 THEN 'SUB ROUTE ONLY: make one SUB route ONLY op status blank'            --Sub route only (400) – Sent to UK, leave Operational Status blank.
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 1 THEN 'SINGLE 1-20 ONLY: bare minimum 1-20 route with op status'  --1-20 route only – Above rules are ok. MAKW 1-20 AND CHOOSE THE SINGLE ROUTE FOR OP STAT
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] = 1 THEN 'MULTI SUB SINGLE 1-20: Make one SUB route ONLY with op status'   --2 sub – 1 1-20 route (1) – 2 Sub PM Actions with operational status the same. = ONE SUB - OP STATUS FROM 1-20. TAKE MULTI MATERIASL FROM SUBS INTO MATERIALS
	 WHEN PVT.[SUB] = 1 AND PVT.[1-20] = 1 THEN 'SINGLE SUB SINGLE 1-20: Make one SUB route ONLY with op status'   --1 sub – 1 1-20 route – Above rules are ok. CREATE SUB TAKE 1-20 DATA FOR THE OP STATUS
	 ELSE NULL END AS 'OPERATIONAL_STATUS'

from 
(SELECT distinct
 [AUT_Account] AS ACCOUNT
 ,case when right(trim(Are.are_area),3) like 'SUB' then 'SUB'
	   when trim(Are.are_area) like '%999' then 'SUB'
	   when right(trim(Are.are_area),2) in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20') then '1-20' 
	   else 'FALLOUT' end as [CHECK]
,right(trim(Are.are_area),2) AS '1-20 ROUTE'
,C.CUS_DEPOTID
  FROM [DatasetProWat].[Syn_Auto_ex] aut
  join [DatasetProWat].[Syn_Area_ex] are
  on aut.aut_routeid = are.are_routeid
  JOIN [DatasetProWat].[Syn_Customer_ex] C 
  ON C.CUS_ACCOUNT = AUT.AUT_ACCOUNT
  )S
  pivot
  (
  count(s.[1-20 route])
  for s.[check] in ([SUB],[1-20]) )as pvt)PIV
  ON PIV.ACCOUNT = AUT.AUT_ACCOUNT

  LEFT JOIN [DatasetProWat].[Syn_Customer_ex] C 
  ON C.CUS_ACCOUNT = AUT.AUT_ACCOUNT
  LEFT OUTER JOIN
  Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), C.[Cus_Account])) = Dataset.Customer_Filter_Override.CUSTOMER_ID
  WHERE
  (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), C.[Cus_Account])), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

  )s ORDER BY AUT_ACCOUNT


  INSERT INTO [Dataset].[PM_Actions_Non_SC_Material_ex]
  (
      [MIG_SITE_NAME]
      ,[PM_NO]
      ,[SITE]
      ,[ACTION]
      ,[WO_SITE]
      ,[INTERVAL]
      ,[CUSTOMER_ID]
      ,[OPERATIONAL_STATUS_ID]
      ,[PART_NO]
      ,[QTY]
	  ,[PRICE]
  )

  SELECT  DISTINCT
      'GBASP'																									AS MIG_SITE_NAME
	  , ''																										AS [PM_NO]
      ,'UK300'																									AS [SITE]
	   ,'DEL'																									AS [ACTION]
	   ,'UK300'																									AS [WO_SITE] -- CUS_DEPOTID was removed because the WO site sould be UK300 always
	   ,CONVERT(varchar,AUT_FREQ)																				AS [INTERVAL]
      ,aut_account																								AS [CUSTOMER_ID]
	  ,S.OP_STATUS_ID																							AS [OPERATIONAL_STATUS_ID]  --RISM 2021-06-23 new logic
      ,S.[AUT_Stock_Code]																						AS [PART_NO]   
      ,S.[AUT_Qty]																								AS [QTY]					-- Added std job quantity as 1 because material will be migrated seperately  
	  ,S.[PRICE]																								AS [PRICE]
      
FROM 
(
SELECT
 [AUT_Account]
,PIV.CUS_DEPOTID
,[AUT_Stock_Code]
,[AUT_Qty]
,[AUT_Last_Qty]
,[AUT_Freq]
,dbo.convertfromclarion([AUT_Last_Del]) 'Last Del'
,dbo.convertfromclarion([AUT_Next_Del]) 'Next Del'
,CASE WHEN right(trim(Are.are_area),2) in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20') THEN right(trim(Are.are_area),2)
ELSE ' ' END AS OP_STATUS_ID  --RISM 2021-06-23  added in to avoid pulling sub route suffix when two or more records to choose from
,are.are_area
,case when right(trim(Are.are_area),3) like 'SUB' then 'SUB'
      when trim(Are.are_area) like '%999' then 'SUB'
	  when right(trim(Are.are_area),2) in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20') then '1-20' 
      else 'FALLOUT' end as [CHECK]
,[AUT_ID]
,OPERATIONAL_STATUS
,[PM ACTION TYPE]
,ISNULL(PB.PRI_PRICE,ST.STO_PRICE) AS PRICE
FROM [DatasetProWat].[Syn_Auto_ex] aut
JOIN [DatasetProWat].[Syn_Area_ex] are on aut.aut_routeid = are.are_routeid
JOIN 
  (select distinct *,
CASE WHEN PVT.[SUB] = 0 AND PVT.[1-20] > 1 THEN '1-20'         --MAKE A 1-20 ROUTE WITH BARE INFO AS PER WORD DOC
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 0 THEN 'NORECORD'
     WHEN PVT.[SUB] = 1 AND PVT.[1-20] > 1 THEN 'SUB'            --1 sub – multi 1-20 (14) – Sent to UK, leave Operational Status blank. do not create equivalent 1-20 routes, not needed
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] > 1 THEN 'SUB'            --Multi sub - multi 1-20 (4) – Sent to UK, leave Operational Status blank. do not create any 1-20's only make one SUB
	 WHEN PVT.[SUB] > 0 AND PVT.[1-20] = 0 THEN 'SUB'            --Sub route only (400) – Sent to UK, leave Operational Status blank.
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 1 THEN '1-20'  --1-20 route only – Above rules are ok. MAKW 1-20 AND CHOOSE THE SINGLE ROUTE FOR OP STAT
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] = 1 THEN 'SUB'   --2 sub – 1 1-20 route (1) – 2 Sub PM Actions with operational status the same. = ONE SUB - OP STATUS FROM 1-20. TAKE MULTI MATERIASL FROM SUBS INTO MATERIALS
	 WHEN PVT.[SUB] = 1 AND PVT.[1-20] = 1 THEN 'SUB'   --1 sub – 1 1-20 route – Above rules are ok. CREATE SUB TAKE 1-20 DATA FOR THE OP STATUS
	 ELSE NULL END AS 'PM ACTION TYPE'
,CASE WHEN PVT.[SUB] = 0 AND PVT.[1-20] > 1 THEN 'MULTI 1-20 ROUTE ONLY:bare minimum 1-20 route'         --MAKE A 1-20 ROUTE WITH BARE INFO AS PER WORD DOC
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 0 THEN 'NO ROUTES: Do not create any records'
     WHEN PVT.[SUB] = 1 AND PVT.[1-20] > 1 THEN '1 SUB MULTI 1-20: Make one SUB route ONLY op status blank'            --1 sub – multi 1-20 (14) – Sent to UK, leave Operational Status blank. do not create equivalent 1-20 routes, not needed
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] > 1 THEN 'MULTI BOTH: Make one Sub route ONLY op status blank'            --Multi sub - multi 1-20 (4) – Sent to UK, leave Operational Status blank. do not create any 1-20's only make one SUB
	 WHEN PVT.[SUB] > 0 AND PVT.[1-20] = 0 THEN 'SUB ROUTE ONLY: make one SUB route ONLY op status blank'            --Sub route only (400) – Sent to UK, leave Operational Status blank.
     WHEN PVT.[SUB] = 0 AND PVT.[1-20] = 1 THEN 'SINGLE 1-20 ONLY: bare minimum 1-20 route with op status'  --1-20 route only – Above rules are ok. MAKW 1-20 AND CHOOSE THE SINGLE ROUTE FOR OP STAT
	 WHEN PVT.[SUB] > 1 AND PVT.[1-20] = 1 THEN 'MULTI SUB SINGLE 1-20: Make one SUB route ONLY with op status'   --2 sub – 1 1-20 route (1) – 2 Sub PM Actions with operational status the same. = ONE SUB - OP STATUS FROM 1-20. TAKE MULTI MATERIASL FROM SUBS INTO MATERIALS
	 WHEN PVT.[SUB] = 1 AND PVT.[1-20] = 1 THEN 'SINGLE SUB SINGLE 1-20: Make one SUB route ONLY with op status'   --1 sub – 1 1-20 route – Above rules are ok. CREATE SUB TAKE 1-20 DATA FOR THE OP STATUS
	 ELSE NULL END AS 'OPERATIONAL_STATUS'

from 
(SELECT distinct
 [AUT_Account] AS ACCOUNT
 ,case when right(trim(Are.are_area),3) like 'SUB' then 'SUB'
	   when trim(Are.are_area) like '%999' then 'SUB'
	   when right(trim(Are.are_area),2) in ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20') then '1-20' 
	   else 'FALLOUT' end as [CHECK]
,right(trim(Are.are_area),2) AS '1-20 ROUTE'
,C.CUS_DEPOTID
  FROM [DatasetProWat].[Syn_Auto_ex] aut
  join [DatasetProWat].[Syn_Area_ex] are
  on aut.aut_routeid = are.are_routeid
  JOIN [DatasetProWat].[Syn_Customer_ex] C 
  ON C.CUS_ACCOUNT = AUT.AUT_ACCOUNT
  )S
  pivot
  (
  count(s.[1-20 route])
  for s.[check] in ([SUB],[1-20]) )as pvt)PIV
  ON PIV.ACCOUNT = AUT.AUT_ACCOUNT

  LEFT JOIN [DatasetProWat].[Syn_Customer_ex] C 
  ON C.CUS_ACCOUNT = AUT.AUT_ACCOUNT
  LEFT OUTER JOIN
  Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), C.[Cus_Account])) = Dataset.Customer_Filter_Override.CUSTOMER_ID

  LEFT JOIN [DatasetProWat].[Syn_PriceBk_ex] PB																   --TO PULL THE RIGHT PRICE JOINED TO MASTER ACCOUNT
  ON PB.PRI_ACCOUNT = CASE WHEN C.CUS_PRICEBOOKAC = 0 THEN C.CUS_ACCOUNT ELSE C.CUS_PRICEBOOKAC END
  AND PB.PRI_STOCK_CODE = aut.AUT_Stock_Code

  LEFT JOIN [DatasetProWat].[Syn_Stock_ex] ST																				    --TO PULL THE STOCK PRICE IN LIEU OF A PRICEBOOK RECORD
  ON ST.STO_STOCK_CODE = aut.AUT_Stock_Code

  WHERE
  (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), C.[Cus_Account])), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

  )s
  WHERE S.[PM ACTION TYPE] = 'SUB'
  ORDER BY AUT_ACCOUNT


END


GO
