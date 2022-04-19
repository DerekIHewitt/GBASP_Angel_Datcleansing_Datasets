SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
















CREATE VIEW [DatasetProWat].[Work_Order_Materials_ex_Filtered]
AS
--RS 08/03/2022 - Added additional stock codes in. Stock codes have a part mapping in Map_Part
--RS 30/03/2022 - Requested to bring Online Orders in scope, need to adopt same logic as 999 materials
-- online order reason is ordreason 140

SELECT 
'GBASP'												   AS MIG_SITE_NAME,
ord_ordernum                                           AS WO_NO,
ord_account                                            AS CUSTOMER_NO, 
trim(ORL_StockCode)                                     AS PART_NO,
ol.ORL_Qty_Ord                                         AS QUANTITY_REQUIRED,
ol.ORL_Price                                           AS PRICE,
DBO.ConvertFromClarion(ORD_Request_Date)                AS DUE_DATE,
getdate()												AS MIG_CREATED_DATE 

FROM [DatasetProWat].[Syn_Orders_ex] O 
 JOIN [DatasetProWat].[Syn_OrdLines_ex] OL 
   ON O.ord_ordernum = OL.orl_ordernum 
 JOIN [DatasetProWat].[Open_Work_Orders_ex_Filtered] F
   ON F.ORDERNUMBER = O.ORD_ORDERNUM
  AND O.ORD_ORDREASON in ( 1,140)
where o.ord_ordreason in  (1,140)
  AND orl_stockcode NOT IN (
						'ABRKDWVEND','ADMIN_CHG.','WRNTY_EXCH','AFLAVIA','AQE-MAINT','AQUADSAS11','ART1_CREAT',
'BIL_WARP','BT_13L_CR','BT_15L_CR','BT_19L_CR','BT_COLL_EM','BT_DEP','BT_DEP_15','BT_DEP_FT',
'BT_EMP','BT_EMP_13L','BT_EMP_19L','BT_RK_COLL','BT_RK_DEP','BT_RK_RE1','BWC_TRI_0A','CER_COMP',
'CER_RENTAL','CER_SANI','CF_SERV','COMMISSION','CON_DEL','CR_CNE_5K','CR_COMSET','CR_CUP_RE',
'CR_CUP_RE1','CR_REINV','DUP_FIXMTC','ELANNUAL','ELMONTH','ENV_LVY','FIX_BRONZE','FIX_GOLD','FIX_SILVER',
'FIXED M/C','GEN_AQUA3','GEN_ARTWRK','GEN_BCTOMF','GEN_BIL_1','GEN_BIL_2','GEN_BIL_3','GEN_BIL_4',
'GEN_BILCAL','GEN_BILLAB','GEN_BILREP','GEN_BOOKIN','GEN_CABLE','GEN_CALOUT','GEN_CAN_MF','GEN_CAN_SA',
'GEN_CANCEL','GEN_CARPAC','GEN_COL_RK','GEN_COLL','GEN_CONGES','GEN_DAMAGE','GEN_DEL','GEN_DEL_OF','GEN_DEL_ST',
'GEN_DESCAL','GEN_DISCON','GEN_DISP','GEN_DRIP','GEN_DRIP1','GEN_DT_PST','GEN_ECEAU','GEN_ECEAU1','GEN_ECEAU2',
'GEN_ECEAU3','GEN_EX_COL','GEN_EXCH','GEN_FACIA','GEN_FAD5L','GEN_FAIL','GEN_FALSE','GEN_FIL_D','GEN_FMASK',
'GEN_GL1000','GEN_GLOVE','GEN_GLOVES','GEN_HYGPK1','GEN_IN_REP','GEN_INRAIL','GEN_INSFAI','GEN_INSFEE',
'GEN_INSTAL','GEN_LAB15','GEN_LABOUR','GEN_LEVINS','GEN_LFWIPE','GEN_LITMUS','GEN_LOST','GEN_MAIN_1',
'GEN_MAIN_2','GEN_MAIN_3','GEN_MAIN_6','GEN_MAN_F','GEN_MFTOBC','GEN_MISC','GEN_MOR_DC','GEN_NADEL',
'GEN_NFAULT','GEN_PA_5L','GEN_PAYHAN','GEN_PBC','GEN_PEDINS','GEN_PORTAL','GEN_QUA_C5','GEN_RELOC',
'GEN_RENT_A','GEN_RENT_H','GEN_RENT_P','GEN_RENT_T','GEN_REP_CU','GEN_REP_EX','GEN_REQ','GEN_RNTSAN','GEN_ROLL',
'GEN_SAN_CD','GEN_SAN_CO','GEN_SAN_FC','GEN_SAN_SW','GEN_SAN_WP','GEN_SANI_P','GEN_SANIWP','GEN_SANOS',
'GEN_SCOUR','GEN_SHT_TM','GEN_SITING','GEN_SLPMAT','GEN_SMF_SW','GEN_SN_DOS','GEN_SN_IN','GEN_SN_LOC',
'GEN_SN_OUT','GEN_SN_SUP','GEN_SPL_MT','GEN_SS_CL1','GEN_STILLA','GEN_SUP_20','GEN_SUP_5L','GEN_SURVEY',
'GEN_TAP','GEN_TAP_BR','GEN_TAPCC','GEN_TAPHC','GEN_TRG_HD','GEN_TRI_BT','GEN_WARR_Y','GEN_WIPE15',
'GEN_WIPE20','GEN_WL_REP','GEN_WR_OFF','GEN_ZIPREP','LB_MFW1250','LV_LOSTCOO','MAINT','MAINT_WB',
'MISC','PAT_TEST','PIA_COMP','REC_BAG','REC_BIN_CO','REC_CP_COL','REC_CUP','RENTAL','REP_BIL_TP',
'REP_BOI_CT','REP_BOI_WM','REP_NIA_CT','REP_NIA_FS','REP_V_TP','REP_ZIP_TP','SANI_ ADD','SANI_BILLI',
'SANI_HOSP','SANI_ZIPT','SANICHARGE','SANIMF','SANITISE','SP_LEAKDET','SURV_COMP','VEN_SERV','VOUCHER',''
						)				--This can be expanded to exclude more parts
  and DBO.ShowOrderStatus(ORD_STATUS,ORD_INVFLAG) in ('New','Despatched')
  and ol.ORL_Qty_Ord != 0			-- Should not migrte lines with zero quantity?

GO
