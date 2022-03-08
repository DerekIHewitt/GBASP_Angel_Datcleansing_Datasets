SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE VIEW [DatasetProWat].[Work_Order_Materials_ex_Filtered]
AS


SELECT 
'GBASP'												   AS MIG_SITE_NAME,
ord_ordernum                                           AS WO_NO,
ord_account                                            AS CUSTOMER_NO, 
ORL_StockCode                                          AS PART_NO,
ol.ORL_Qty_Ord                                         AS QUANTITY_REQUIRED,
ol.ORL_Price                                           AS PRICE,
DBO.ConvertFromClarion(ORD_Request_Date)                AS DUE_DATE,
getdate()												AS MIG_CREATED_DATE 

FROM [DatasetProWat].[Syn_Orders_ex] O 
 JOIN [DatasetProWat].[Syn_OrdLines_ex] OL 
   ON O.ord_ordernum = OL.orl_ordernum 
 JOIN [DatasetProWat].[Open_Work_Orders_ex_Filtered] F
   ON F.ORDERNUMBER = O.ORD_ORDERNUM
  AND O.ORD_ORDREASON = 1
where o.ord_ordreason = 1
  AND orl_stockcode in ('BT_19L_ST','CP_BX_2KS')				--This can be expanded to include more parts
  and DBO.ShowOrderStatus(ORD_STATUS,ORD_INVFLAG) in ('New','Despatched')
  and ol.ORL_Qty_Ord != 0			-- Should not migrte lines with zero quantity?

GO
