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
,CONCAT('"'+'Legacy Wo No: '+convert(varchar,o.ord_ordernum) +' ' +'Instructions: '+ISNULL(trim(O.ORD_Instruct1),'')+' ',ISNULL(trim(O.ORD_Instruct2),'')+' ',ISNULL(trim(O.ORD_Instruct3),'')+ ' ',ISNULL(trim(O.ORD_Instruct4),'')+' ',ISNULL(trim(O.ORD_Instruct5),'')+' ', 'GEN_MISC: '+ISNULL(OG.GEN_MISC,'')+'"') AS FAULT_DESC
,CASE WHEN O.ORD_OrdReason IN (4,35,91,107,123) THEN ISNULL(dbo.ConvertFromClarion(QLG_CollectDate),DBO.CONVERTFROMCLARION(ORD_REQUEST_DATE)) ELSE DBO.CONVERTFROMCLARION(ORD_REQUEST_DATE) END AS START_DATE
,'' AS PLAN_FINISH
,'' as PLAN_HRS
,'*'AS PREPARED_BY
,'' AS MAINT_ORG 
,CASE 
 WHEN cast(O.ORD_ORDREASON as varchar(16)) IN (7,34,90,110,126) and eq.eqh_status_flag is not null
 THEN CAST(O.ORD_ORDREASON AS VARCHAR(16)) + '-' + isnull(eq.eqh_status_flag,'')
ELSE cast(o.ORD_ORDREASON as varchar (16)) END AS WORK_TYPE  --will need to link to LOV that holds the work types relative to the order reason
,ORR_DESCRIPTION AS ACTION     --will need to refer to the action types relative to the work types
,CASE WHEN OL.ORL_IDNO != 0 THEN OL.ORL_IDNO
      ELSE CASE WHEN  (SELECT MAX(ORL_IDNO) FROM [DatasetProWat].[Syn_OrdLines_ex] x WHERE X.ORL_OrderNum = O.ORD_OrderNum ) != 0
	            THEN (SELECT MAX(ORL_IDNO) FROM [DatasetProWat].[Syn_OrdLines_ex] x WHERE X.ORL_OrderNum = O.ORD_OrderNum )
				ELSE 0
			END	  
	  END AS OBJECT_ID          --will need to map to IFS serial object at Transform stage
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
,--CASE WHEN o.ORD_OrdReason = 135 AND ol.ORL_StockCode =  'GEN_INRAIL' THEN 'INSRAIL-POU' 
	 -- WHEN o.ORD_OrdReason = 135 AND ol.ORL_StockCode =  'GEN_IMPROV' THEN 'IMP-POU'  --RS 03/03/22 PREVIOUS RULE
 --	  WHEN o.ORD_OrdReason = 135 AND ol.ORL_StockCode <>  'GEN_INRAIL' THEN 'IMP-POU'   --RS 03/02/2022 NEW RULE. All 135 need IMP-POU apart from when stock code is GEN_INRAIL
 --	  ELSE '' END
 CASE WHEN o.ORD_OrdReason = 135 THEN
                                 CASE WHEN EXISTS (SELECT 1 FROM [DatasetProWat].[Syn_OrdLines_ex] x WHERE X.ORL_OrderNum = O.ORD_OrderNum AND X.ORL_StockCode = 'GEN_INRAIL' )
								      THEN 'INSRAIL-POU'
									  ELSE 'IMP-POU'
								 END
	  ELSE '' END
	  AS STANDARD_JOB_ID	
,''   AS STANDARD_JOB_SITE
,''   AS STANDARD_JOB_REVISION
,''   AS STANDARD_JOB_DESCRIPTION
, 0   AS STANDARD_JOB_QUANTITY
, OP.price AS PRICE
,O.ORD_ORDERNUM AS ORDERNUMBER   --RS 03/03/2022 ADDED TO LINK THE ORDREASON 1 999 MATERIALS LINES
,CASE WHEN O.ORD_BookIn = 1 THEN 'TRUE'
      ELSE 'FALSE' END      
	  AS BOOK_IN_REQUIRED --RYFE 08/03/2022
--, eq.eqh_status_flag

	   from [DatasetProWat].[Syn_Orders_ex] O join [DatasetProWat].[Syn_OrdLines_ex] OL
on O.ord_ordernum = ol.Orl_ordernum
join [DatasetProWat].[Syn_OrdReason_ex] ORN
on orn.ORR_ID = o.ord_ordreason
left join [DatasetProWat].[Syn_EquipHdr_ex] EQ
on OL.ORL_IDNO = EQ.EQH_IDNO
LEFT OUTER JOIN (SELECT SUM(orl_price)  price , ORL_OrderNum , ORL_IDNo FROM DatasetProWat.Syn_OrdLines_ex GROUP BY ORL_OrderNum,ORL_IDNo
                                    ) AS OP ON OP.ORL_OrderNum = O.ORD_OrderNum AND OP.ORL_IDNo = OL.ORL_IDNo
LEFT OUTER JOIN
							   (SELECT ORL_OrderNum , STRING_AGG(CAST(TRIM(ORL_DETAILS) AS NVARCHAR(MAX)),':') AS GEN_MISC FROM DatasetProWat.Syn_OrdLines_ex
								where orl_stockcode = 'GEN_MISC'
								GROUP BY ORL_OrderNum) AS OG ON OG.ORL_OrderNum = O.ORD_OrderNum
left JOIN [DatasetProWat].[Syn_QuitItem_ex]  QI   on QI.QUI_OrderNum = ol.ORL_OrderNum
												 and qi.qui_eqhid = ol.orl_idno
left join [DatasetProWat].[Syn_QuitLog_ex]   QLG  ON QI.QUI_QuitID = QLG.QLG_id

LEFT OUTER JOIN
                         DatasetProWat.Syn_Customer_ex AS C ON C.CUS_Account = O.ORD_Account LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(VARCHAR(100), C.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

where DBO.ShowOrderStatus(ORD_STATUS,ORD_INVFLAG) in ('New','Despatched')
--decision to not pull any SER worktypes----
and ORD_OrdReason not in (0,12,13,102,118,112,128)

--decision to not pull any EXC/SWP worktypes----
and ORD_OrdReason not in (6,11,14,104,109,114,116,120,125,130,39) --Added 39

--decision to not pull any INS worktypes (going on bus opps)
and ord_ordreason not in (2,7,34,36,88,90,93,100,105,110,121,126)

--decision to not pull any TER worktypes Quit Collect --
--AND (O.ORD_OrdReason NOT IN (4,35,91,107,123))

--decision to not pull any Trial Collects
  and (O.ORD_OrdReason NOT IN (3,37,89,106,122))

--decision to not pull any COL worktypes--
AND (O.ORD_OrdReason NOT IN (8))

--103,113,119,129,			       --SITE   worktypes  Removed according to Liam Doc


AND (O.ORD_OrdReason IN (
1,							       --DEL    worktypes
10,101,111,117,127,135,136,137,    --AD-HOC worktypes
5,108,115,124,131,132,133,134,     --CMA    worktypes -- Added 134 according to Liam doc Removed 39 according to email 07/03/2022				   
4,35,91,107,123					   --TER    worktypes
)
    )
and DBO.CONVERTFROMCLARION(ORD_REQUEST_DATE) > '2020-12-31'
AND ( O.ORD_OrdReason NOT IN (4,35,91,107,123) OR OL.ORL_IDNO != 0) -- FOR TER you need to have a connected valid object
AND (Dataset.Filter_Customer('GBASP', 'ex', 
                         ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), 
                         C.CUS_Account)), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

GO
