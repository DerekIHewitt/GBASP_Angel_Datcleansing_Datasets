SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [DatasetProWat].[Open_Work_Orders_ex_Filtered]
AS

select distinct
 'GBASP' as MIG_SITE_NAME
,'1000' AS COMPANY
,'UK300' AS WO_SITE
, ORR_DESCRIPTION AS DIRECTIVE  --will need to relate to work type description
,CONCAT('"'+'Legacy Wo No: '+convert(varchar,o.ord_ordernum) +' ' +'Instructions: '+O.ORD_Instruct1,O.ORD_Instruct2,O.ORD_Instruct3,O.ORD_Instruct4,O.ORD_Instruct5+'"') AS FAULT_DESC
,DBO.CONVERTFROMCLARION(ORD_REQUEST_DATE) AS START_DATE
,'' AS PLAN_FINISH
,'' as PLAN_HRS
,'*'AS PREPARED_BY
,'' AS MAINT_ORG 
,CASE 
 WHEN cast(O.ORD_ORDREASON as varchar(16)) IN (7,34,90,110,126) and eq.eqh_status_flag is not null
 THEN CAST(O.ORD_ORDREASON AS VARCHAR(16)) + '-' + isnull(eq.eqh_status_flag,'')
ELSE cast(o.ORD_ORDREASON as varchar (16)) END AS WORK_TYPE  --will need to link to LOV that holds the work types relative to the order reason
,ORR_DESCRIPTION AS ACTION     --will need to refer to the action types relative to the work types
,ORL_IDNO AS OBJECT_ID         --will need to map to IFS serial object at Transform stage
,'UK300' AS OBJECT_SITE
,'*'AS COORDINATOR
,'' AS PM_NO	
,'' AS PM_REVISION	
,O.ORD_ACCOUNT AS CUSTOMER_NO	--will need to map to IFS customer id at transform stage
,'SEO' AS ORDER_TYPE
,'GBP' AS CURRENCY_CODE	
,'' AS CONTRACT_ID	
,'' AS CONTRACT_LINE_NO	
,'' AS SLA_ID	
,'' AS EXCLUDE_FROM_SCHEDULING	
,1 AS DELIVERY_ADDRESS_ID	
,'' AS STANDARD_JOB_ID	
,'' AS STANDARD_JOB_SITE
,'' AS STANDARD_JOB_REVISION
,'' AS STANDARD_JOB_DESCRIPTION
, 0 AS STANDARD_JOB_QUANTITY
--, eq.eqh_status_flag

	   from [DatasetProWat].[Syn_Orders_ex] O join [DatasetProWat].[Syn_OrdLines_ex] OL
on O.ord_ordernum = ol.Orl_ordernum
join [DatasetProWat].[Syn_OrdReason_ex] ORN
on orn.ORR_ID = o.ord_ordreason
left join [DatasetProWat].[Syn_EquipHdr_ex] EQ
on OL.ORL_IDNO = EQ.EQH_IDNO
LEFT OUTER JOIN
                         DatasetProWat.Syn_Customer_ex AS C ON C.CUS_Account = O.ORD_Account LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(VARCHAR(100), C.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

where DBO.ShowOrderStatus(ORD_STATUS,ORD_INVFLAG) in ('New','Despatched')
--decision to not pull any SER worktypes----
and ORD_OrdReason not in (0,12,13,102,118,112,128)

--decision to not pull any EXC/SWP worktypes----
and ORD_OrdReason not in (130,125,14,6,104,120,116,114,109,11)

--decision to not pull any INS worktypes (going on bus opps)
and ord_ordreason not in (2,7,34,36,88,90,93,100,105,110,121,126)

and ORD_OrdReason in (1,3,4,5,8,10,35,37,
39,89,91,101,103,106,107,
108,111,113,115,117,
119,122,123,124,127,129,
131,132,133,134,135,136,137)
and DBO.CONVERTFROMCLARION(ORD_REQUEST_DATE) > '2019-12-31'
AND (Dataset.Filter_Customer('GBASP', 'ex', 
                         ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), 
                         C.CUS_Account)), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

GO
