SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--NEED TO MAKE THE TABLES FOR THE NEXT ITEM IN THE PROCESS--

/*=============================================
  Author:      RISM
  Description: Retrieve cases from prowat
--			   RISM 24-06-2021

--13-01-2022	RYFE	Added Case status
--18-01-2022	RYFE	Added 12 month closed for complaints
--20-01-2022    RYFE	Added QST_ID 17,25,26 to be included in the select from quit table
--23-02-2022    RYFE	Added logic according email from Lisa 22/02/2022
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Open_Cases_SendToTables_ex]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	DECLARE @CASELOCALID INT         = 2106121  --NEED TO CHECK THIS EACH TIME FROM THE MAX CASE ID IN THE TARGET ENVIRONMENT
	DECLARE @CUTDATE varchar (10)    = '2022-02-19'
	--DECLARE @CUTOFFDATE VARCHAR(10)  = '2020-11-15'
	--DECLARE @FilterMode int = Dataset.Filter_Mode('dc','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Open_Cases_ex] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME
		COMMIT TRANSACTION
	---------------- Add records to the loading table ---------------------------------------------------------
	INSERT into	[Dataset].[Open_Cases_ex]
	( [MIG_SITE_NAME],
	  [CASE_LOCAL_ID],
	  [TITLE],
	  [CONTACT_DATE],
	  [ORGANIZATION_ID],
	  [SHOW_EXTERNALLY],
	  [DESCRIPTION],
	  [CASE_CATEGORY_ID_DB],
	  [TYPE_ID_DB],
	  [OUR_SEVERITY_DB],
	  [OUR_PRIORITY],
	  [CUSTOMER_SEVERITY_DB],
	  [OWNER],
	  [CUSTOMER_ID],
	  [CUSTOMER_SUPPORT_ORG],
	  [CALLER_EMAIL],
	  [LANG_CODE_DB],
	  [SECOND_CATEGORY],
	  [CONTACT_NAME],
	  [NX_CASE_STATUS]
	)


	SELECT 
--THIS IS CURRENT CASE MIGRATION JOB LOAD TEMPLATE--
'GBASP'					AS MIG_SITE_NAME,
@CASELOCALID	    AS CASE_LOCAL_ID,

--CASE 
	--WHEN [QLG_StatusID] = 25 
	--THEN 'Resolutions'
	--WHEN [QLG_StatusID] = 26
	--THEN 'Invoice and Finance'
	--WHEN [QLG_StatusID] = 17
	--THEN 'Failed Collection'
	--WHEN [QLG_StatusID] = 42
	--THEN 'Retention Request'
	--ELSE TRIM(QS.QST_Status)
	--END					
trim(QS.QST_Status)		AS TITLE,

DBO.CONVERTFROMCLARION([QLG_RecDate])						AS CONTACT_DATE,      --if error change to sysdate
'UKWL'					AS ORGANIZATION_ID,
'FALSE'					AS SHOW_EXTERNALLY,   --tick box do we want true or false--
CONCAT('Contacted By',' ',U.USR_USERNAME,' ','Received Date',' ',DBO.CONVERTFROMCLARION([QLG_RecDate]),' ','Next Date',' ', DBO.CONVERTFROMCLARION([QLG_NextDate]),' ',rtrim(qlg_notes),PVT.COOLERLIST)						
						AS DESCRIPTION,
						--SCREENSHOT 4/5/7 OF 11
CASE 
	WHEN [QLG_StatusID] in (35,36,37,38)
	THEN '323'
	WHEN [QLG_StatusID] in (56,60)
	THEN '341'
	WHEN [QLG_StatusID] in (52,53,54,80)
	THEN '322'
	WHEN [QLG_StatusID] = 5
	THEN '104'
	WHEN [QLG_StatusID] = 48
	THEN '321'
	WHEN [QLG_StatusID] = 49
	THEN '106'
	ELSE '112'
	END					AS CASE_CATEGORY_ID_DB,   -- is this to be hardcoded, are we only ever loading retention requests in 323 Resolution 110 Invoice Dispute 
'3'						AS TYPE_ID_DB,            -- is this to be hardcoded as global/local etc
'103'					AS OUR_SEVERITY_DB,       -- is this to be hardcoded as 3 day sla
'102'					AS OUR_PRIORITY,          -- is this to be hardcoded as 3 normal
'103'					AS CUSTOMER_SEVERITY_DB,  -- is this the same value as our severity
UPPER(REPLACE(US.USR_USERNAME,' ','')) AS OWNER,  --SCREENSHOT 8 OF 11
QLG_ACCOUNT				AS CUSTOMER_ID,																																					--SCREENSHOT 1 OF 11
'UKWL'					AS CUSTOMER_SUPPORT_ORG,  --is this UKWL as per ORGANIZATION_ID
''						AS CALLER_EMAIL,          -- IS THIS REQUIRED TO BE POPULATED
'en'					AS LANG_CODE_DB

,CASE 
 WHEN QLG.QLG_QREASONID = 17
 THEN 'Failed Collection'
 WHEN QLG.QLG_QREASONID = 20
 THEN 'Lost Cooler'
 WHEN QLG.QLG_QREASONID = 21
 THEN 'Write off'
 WHEN [QLG_StatusID] IN (35,36,37,38,5,48)
 THEN ''
 ELSE QRE_REASON      
 END					AS SECOND_CATEGORY  -- screenshot 3 of 11 (dropwdown in ifs doesnt seem to have any values- how does this work)

,qlg_contname    as CONTACT_NAME       -- 6 of 11
,CASE
 WHEN [QLG_StatusID] IN (8,59)
      THEN  'CLOSED'
 WHEN [QLG_Closed] = 0 
      THEN 'OPEN'
      ELSE 'CLOSED' 
	  END				AS NX_CASE_STATUS
						-- QST_Status needs to be part of the filter???
FROM [DatasetProWat].[Syn_QuitLog_ex] QLG
     JOIN [DatasetProWat].[Syn_QuitReason_ex] QRE ON QRE.QRE_ID     = QLG.QLG_QREASONID
LEFT JOIN [DatasetProWat].[Syn_Customer_ex]  C    ON C.CUS_ACCOUNT  = QLG.QLG_ACCOUNT
left join [DatasetProWat].[Syn_UsersMain_ex] usr       ON usr.usr_userid = qlg.qlg_userid
left join [DatasetProWat].[Syn_UsersMain_ex] U         ON U.USR_USERID   = QLG.QLG_CONTUSERID
left join [DatasetProWat].[Syn_UsersMain_ex] US        ON US.USR_USERID  = QLG.QLG_OWNEDBYID
left join  [DatasetProWat].[Syn_QuitStat_ex]QS          ON QS.qst_id      = qlg.qlg_statusid
LEFT JOIN [DatasetProWat].[Syn_QuitItem_ex] QI  ON QI.QUI_ID      = QLG.QLG_id
LEFT JOIN (
			select PVT.QUITID, 
			LTRIM(RTRIM(CONCAT([1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],
			[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],
			[43],[44],[45],[46],[47],[48],[49],	[50],[51],[52],[53],[54],[55],[56],[57],[58],[59],[60],[61],[62],[63],[64],
			[65],[66],[67],[68],[69],[70],[71],[72],[73],[74],[75],[76],[77],[78],[79],[80],[81],[82],[83],[84],[85],[86],
			[87],[88],[89],[90],[91],[92],[93],[94],[95],[96],[97],[98],[99],[100])))COOLERLIST
			FROM
			(
			  SELECT distinct
			  [QUI_QuitID] QUITID
			  ,ROW_NUMBER() OVER (PARTITION BY [QUI_QUITID] ORDER BY concat([QUI_EQHID],' ','-',e.eqh_id))ROWNUMBER

			  ,concat([QUI_EQHID],' ','-',e.eqh_id) COOLERLIST
			  FROM [DatasetProWat].[Syn_QuitItem_ex] Q
			  join [DatasetProWat].[Syn_Stock_ex] S on s.sto_stockid = q.qui_stockid
			  join [DatasetProWat].[Syn_EquipHdr_ex]E
			  on e.eqh_idno = q.qui_eqhid
			  where qui_quitid in 
				 (
				  SELECT  [QLG_ID] 
				  FROM [DatasetProWat].[Syn_QuitLog_ex] QLG
					   JOIN [DatasetProWat].[Syn_QuitReason_ex] QRE ON QRE.QRE_ID = QLG.QLG_QREASONID
				  LEFT JOIN [DatasetProWat].[Syn_Customer_ex] C ON C.CUS_ACCOUNT = QLG.QLG_ACCOUNT
				  left join [DatasetProWat].[Syn_UsersMain_ex] usr on usr.usr_userid = qlg.qlg_userid
				  left join [DatasetProWat].[Syn_UsersMain_ex] U ON U.USR_USERID = QLG.QLG_CONTUSERID
				  left join [DatasetProWat].[Syn_UsersMain_ex] US ON US.USR_USERID = QLG.QLG_OWNEDBYID
				  left join [DatasetProWat].[Syn_QuitStat_ex] QS on QS.qst_id = qlg.qlg_statusid
				  LEFT JOIN [DatasetProWat].[Syn_QuitItem_ex] QI ON QI.QUI_ID = QLG.QLG_id
				 WHERE [QLG_Closed] = 0 
				 and   QLG_cuseqtoquit > 1
				 and [QLG_StatusID] in (42,17,25,26)
				 )
			 )E
			 PIVOT
			 (MAX(COOLERLIST) FOR ROWNUMBER IN 
			 ([1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],
			[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],
			[43],[44],[45],[46],[47],[48],[49],	[50],[51],[52],[53],[54],[55],[56],[57],[58],[59],[60],[61],[62],[63],[64],
			[65],[66],[67],[68],[69],[70],[71],[72],[73],[74],[75],[76],[77],[78],[79],[80],[81],[82],[83],[84],[85],[86],
			[87],[88],[89],[90],[91],[92],[93],[94],[95],[96],[97],[98],[99],[100])
			 )PVT)PVT
			 ON PVT.QUITID = QLG.QLG_ID

	    LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), C.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		
		

WHERE --[QLG_Closed] = 0 
	  --	and [QLG_StatusID] = 42
	  --AND 
  (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), C.CUS_Account)), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

  AND case when [QLG_Closed] = 0 and [QLG_StatusID] in (42,17,25,26) then 'VALID_OPEN_CASE'
      WHEN [QLG_Closed] = 1 AND us.USR_UserID in (
								624,2637,472,966,529,1264,1155,35,
								2671,1060,1011,2655,605,500,650,569,642
								)
							AND dbo.convertfromclarion(qlg_resolveddate) > DATEADD(year, -1, @CUTDATE) 
	  THEN 'VALID_CLOSED_CASE'
	  ELSE 'INVALID' 
	  END NOT LIKE 'INVALID'

INSERT into	[Dataset].[Open_Cases_ex]
	( [MIG_SITE_NAME],
	  [CASE_LOCAL_ID],
	  [TITLE],
	  [CONTACT_DATE],
	  [ORGANIZATION_ID],
	  [SHOW_EXTERNALLY],
	  [DESCRIPTION],
	  [CASE_CATEGORY_ID_DB],
	  [TYPE_ID_DB],
	  [OUR_SEVERITY_DB],
	  [OUR_PRIORITY],
	  [CUSTOMER_SEVERITY_DB],
	  [OWNER],
	  [CUSTOMER_ID],
	  [CUSTOMER_SUPPORT_ORG],
	  [CALLER_EMAIL],
	  [LANG_CODE_DB],
	  [SECOND_CATEGORY],
	  [CONTACT_NAME],
	  [NX_CASE_STATUS]
	)
SELECT  
--THIS IS CURRENT CASE MIGRATION JOB LOAD TEMPLATE--

'GBASP'										AS MIG_SITE_NAME,
'@CASELOCALID'								AS CASE_LOCAL_ID,
'Complaint'									AS TITLE, ----------SHOULD THIS BE CHANGED

CASE  WHEN DBO.CONVERTFROMCLARION([COM_ContactDate]) = '1800-12-28' THEN GetDate()
      ELSE DBO.CONVERTFROMCLARION([COM_ContactDate])
	  END									AS CONTACT_DATE,          --  
'UKWL'										AS ORGANIZATION_ID,
'FALSE'										AS SHOW_EXTERNALLY,       --tick box do we want true or false--
						
concat(trim(com_notes),' ','Next Date:',replace(dbo.convertfromclarion(COM.COM_NextDate),'1800-12-28',''))		-- Point 12							
											AS DESCRIPTION,			  --SCREENSHOT POINT 8 & 10												--SCREENSHOT 4/5/7 OF 11
'117'										AS CASE_CATEGORY_ID_DB,   -- is this to be hardcoded, 117 for complaints 
'3'											AS TYPE_ID_DB,            -- is this to be hardcoded as global/local etc
'103'										AS OUR_SEVERITY_DB,       -- is this to be hardcoded as 3 day sla
'102'										AS OUR_PRIORITY,          -- is this to be hardcoded as 3 normal
'103'										AS CUSTOMER_SEVERITY_DB,  -- is this the same value as our severity
UPPER(REPLACE(US.USR_USERNAME,' ',''))	    AS OWNER,				  -- SCREENSHOT POINT 5         FRONT SCREEN 1/5/7/11
COM_ACCOUNT									AS CUSTOMER_ID,			  -- SCREENSHOT POINT 1			FRONT SCREEN 1/5/7/11																														--SCREENSHOT 1 OF 11
'UKWL'										AS CUSTOMER_SUPPORT_ORG,  -- is this UKWL as per ORGANIZATION_ID
''											AS CALLER_EMAIL,          -- IS THIS REQUIRED TO BE POPULATED
'en'										AS LANG_CODE_DB
,cpr_REASON									AS SECOND_CATEGORY		  -- SCREENSHOT POINT 7          FRONT SCREEN 1/5/7/11
,COM_contactname							AS CONTACT_NAME           -- SCREENSHOT POINT 2          CONTACTS TAB 2/3/4
,CASE 
 WHEN COM.COM_CloseDate = 0 
      THEN 'OPEN'
      ELSE 'CLOSED' 
	  END									AS NX_CASE_STATUS
--,COM_POSITION                               AS POSITION               -- SCREENSHOT POINT 3          CONTACTS TAB 2/3/4
--,COM_TEL									AS TELEPHONE		      -- SCREENSHOT POINT 4          CONTACTS TAB 2/3/4
--,com_status									AS STATUS                 -- SCREENSHOT POINT 11         FRONT SCREEN 1/5/7/11 This is default NEW in IFS so no need for seperate field
--dbo.convertfromclarion(qlg_resolveddate)  AS RESOLVED_DATE
--,QLG_CLOSED
--,CPR_Reason
--,QLG_STATUSID
--,QS.qst_status


FROM	  [DatasetProWat].[Syn_Complaint_ex] COM
     JOIN [DatasetProWat].[Syn_CompReas_ex] cpr      ON cpr.cpr_ID     = com.com_REASONID
LEFT JOIN [DatasetProWat].[Syn_Customer_ex]  C		   ON C.CUS_ACCOUNT  = com.com_ACCOUNT
left join [DatasetProWat].[Syn_UsersMain_ex] us      ON us.usr_userid =  COM.COM_OWNEDBY
--left join [DatasetProWat].[Syn_UsersMain_ex] U         ON U.USR_USERID   = QLG.QLG_CONTUSERID
--left join [DatasetProWat].[Syn_UsersMain_ex] US        ON US.USR_USERID  = QLG.QLG_OWNEDBYID
--left join [DatasetProWat].[Syn_QuitStat_ex]QS          ON QS.qst_id      = qlg.qlg_statusid
--LEFT JOIN [DatasetProWat].[Syn_QuitItem_ex] QI         ON QI.QUI_ID      = QLG.QLG_id
 LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), C.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

where (COM.COM_CloseDate = 0 OR dbo.convertfromclarion(COM.COM_CloseDate) > DATEADD(year, -1, @CUTDATE))		--18/01/2022 RYFE Bring one years closed data
AND (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), C.CUS_Account)), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

  UPDATE [Dataset].[Open_Cases_ex]
  SET CASE_LOCAL_ID = @CASELOCALID,@CASELOCALID = @CASELOCALID + 1
--  set interfaceID  = @i , @i = @i + 1
  WHERE MIG_SITE_NAME = 'GBASP'

END

GO
