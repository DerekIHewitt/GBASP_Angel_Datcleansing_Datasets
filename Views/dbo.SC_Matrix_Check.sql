SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[SC_Matrix_Check]

as

SELECT DISTINCT
-----------------------------------------------TOTALCARE----------------------------------------------------------
 case when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_pwfreq = 0 --RS i believe we do not wish to have this in the rules anymore, or do we want it still in 
	   and eqh_i_freq > 0
	   and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   and EQH_M_FREQ = 0
then 'MIF - Totalcare only'
-----------------------------------------------------------newest contract addition-----------------------------------------------
   when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_pwfreq = 0 --RS i believe we do not wish to have this in the rules anymore, or do we want it still in 
	   and eqh_i_freq > 0
	   --and (eqh_rental_amnt) > 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   and EQH_M_FREQ > 0
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)> 0
	   and cmp_name like 'OFFICE BEVERAGES'
then 'MIF - Rental Only Recurring Sani/Service'


------------------------------------------RENTAL ONLY NON MIF--------------------INV LINE ONLY---------------------------------
when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks' , 'Vending m/c')
	   and eqh_pwfreq = 0
	   and eqh_i_freq > 0
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and eqh_frequency = 0
	  -- and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   and eqh_filter_Freq = 0
	   and EQH_M_FREQ = 0
then 'Non MIF Rental Only'

------------------------------------RENTAL ONLY MIF SANI BY ACTIVITY RO/SOOE--------------------------------------------------
when eqh_status_flag = 'R' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_pwfreq = 0
	   and eqh_i_freq > 0
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and EQH_M_FREQ = 0
then 'MIF - Rental Only'

---------------------------------------------SOLD NON MIF---------------------------------------------------------

when eqh_status_flag = 'S' 
       AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks','Vending m/c')
	   and eqh_pwfreq = 0
	   and eqh_i_freq = 0
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and eqh_frequency = 0
	  -- and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   and eqh_filter_Freq = 0
	   and EQH_M_FREQ = 0
then 'Sold Non MIF'

------------------------------------------MAINTENANCE ONLY SIF GOLD---------------------------------------------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_pwfreq = 0
	   --and eqh_i_freq = 0  --DO WE NEED AN INVOICE FREQ FOR THE MAINTENANCE TO GENERATE???
	   and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and EQH_M_FREQ > 0
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)> 0
	   and EQH_M_Stock_Code not like ('SILV%')											--Added RYFE 07/07/2021
then 'Maintenance Only SIF'

------------------------------------------MAINTENANCE ONLY SIF SILVER---------------------------------------------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_pwfreq = 0
	   --and eqh_i_freq = 0  --DO WE NEED AN INVOICE FREQ FOR THE MAINTENANCE TO GENERATE???
	   and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and EQH_M_FREQ > 0
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)> 0
	   and EQH_M_Stock_Code  like ('SILV%')											--Added RYFE 07/07/2021
then 'Maintenance Only SIF-SILVER'
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_pwfreq = 0
	   and eqh_i_freq = 0
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and EQH_M_FREQ = 0
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)= 0
then 'Sani Only SIF'

when eqh_status_flag = 'S'
AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks','Vending m/c')
then 'SIF Non MIF'

WHEN ET.ety_name in ('HAND SANITISER', '(None)' )
then 'QUERY EQUIPMENT TYPES'


end
 as MATRIX_TYPE

 ,case when  eqh_status_flag = 'R'
  AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks', 'PEDAL','Vending m/c')
  then 'Non MIF' 
  when eqh_status_flag = 'S'
  and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
  then 'SIF'

  when eqh_status_flag = 'R'
  and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
  then 'MIF'

  end 
  as Category
  -----------------------------------these repeat below as they are in the correct sections but have added here to check the matrix rules-----------
  , eqh_status_flag as 'R/S'
  , eqh_pwfreq AS PIPEWORK_FREQ
  , eqh_i_freq as Rental_Frequency_inv
  ,(eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) as Rental_Price				--Added c_value and sani amnt as a fix
  , eqh_frequency as sani_freq
  ,isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) AS FINALSANIPRICE
  , EQH_M_FREQ AS MAINT_FREQ
  --,isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) AS FINALMAINTPRICE   --RISM         11-06-2021 NEEDED EXTRA VALIDATION TO GET CORRECT UNIT PRICE
    ,case when concat(eqh_m_freq,eqh_m_span) = '1M' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)	-- RYFE 15/06/2021 Changed the code only to devide by        
	 when concat(eqh_m_freq,eqh_m_span) = '1Y' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)					--  EQH_M_FREQ since Y and W are catered for in the pre processor
	 when concat(eqh_m_freq,eqh_m_span) = '2M' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '2Y' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '3M' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '3Y' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '4W' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '5Y' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '6M' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
	 when concat(eqh_m_freq,eqh_m_span) = '12M' then round(isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)/EQH_M_FREQ,2)    
ELSE isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)    
END AS  FINALMAINTPRICE																							--RISM         11-06-2021 REPLACES FINALMAINTPRICE TO GET UNITARY VALUE
 ------------------------------------validation end-------------------------------------------------------------------------------------------------
 ,EQ.EQH_ACCOUNT
 ,C.CUS_TYPE
 ,EQH_IDNO
 ,EQ.EQH_ID
 ,PDL.PEDAL_ID AS HASPEDAL
 ,EQH_STOCK_CODE AS EQUIP_STOCK_CODE
 ,et.ety_name as product_type
 ,ST.STO_STOCK_CODE AS STOCK_EQUIP_CODE
 ,ST_SAN.STO_STOCK_CODE AS SANI_STOCK_CODE
 ,ST.STO_EQSANITYPE AS SANISTOCKCODELINK
 --,ST.STO_FILTER1 AS FILTERSTOCKCODELINK
 --,ST_FIL.STO_Stock_Code AS FILTER_STOCK_CODE


, eqh_status_flag
, eqh_pwfreq AS PW_FREQ
-------------------------------------------RENTAL--------------------------------------------
, EQH_RentSpan as RentSpan
, eqh_rental_amnt as Rental_Payment
, eqh_c_value as add_item_payment
,EQH_AddStockCode
, eqh_sani_amnt as Sanitisation_payment_MWR
, (eqh_rental_amnt) AS FINALRENTALPRICE
,EQ.EQH_I_SPAN
,eq.EQH_I_FREQ
,EQ.EQH_RENTSPAN
--------------------------------------------SANI---------------------------------------------
, EQH_UseSaniPrice
, eqh_saniprice as sani_price
, PB.PRI_STOCK_CODE AS SANIPRICEBOOKSTOCKCODE
, PB.PRI_Price AS SANITISE_PRICE
, st_san.sto_price as sanistock_price
, eqh_frequency as sani_frequency
, concat(eqh_frequency,eqh_s_span) as Sani_Span
,isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) AS FINAL_SANI_PRICE
,CASE WHEN eqh_frequency >0 AND isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','HAND SANITISER','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c') THEN 'SOOE' END AS SOOE
-------------------------------------------FILTER--------------------------------------------
,EQH_F_STOCK_CODE
, EQH_UseFilterPrice
, EQH_FILTER_FREQ AS FILTER_FREQ
, EQH_FilterPrice AS FILTERPRICE
--,PBF.PRI_Stock_Code AS FILTERPRICEBOOKSTOCKCODE
,PBF.PRI_PRICE AS FILTER_PRICE_BOOK_PRICE
, ST_FIL.STO_PRICE AS FILTERSTOCK_PRICE
,isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) AS FINALFILTERPRICE
--------------------------------------------MAINT--------------------------------------------
, EQH_M_STOCK_CODE
, EQH_UseMaintPrice
, EQH_M_FREQ AS MAINTenance_FREQuency
, EQH_MAINTPRICE AS MAINT_PRICE
,PBM.PRI_PRICE AS MAINT_PRICE_BOOK_PRICE
, ST_MNT.STO_PRICE AS MAINTSTOCK_PRICE
,concat(EQH_M_FREQ,EQH_M_Span) as Maint_Span
,isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) AS FINAL_MAINT_PRICE
--------------------------------------------ELEVY--------------------------------------------
, EQH_UseELPrice
, EQH_ELFREQ AS ELEVY_FREQ
, EQH_Elprice as ELEVY_PRICE
, PBE.PRI_Price
, PBE.PRI_Stock_Code
--,isnull(CASE WHEN EQH_UseELPrice = 1 THEN EQH_Elprice ELSE PBE.PRI_Price END,0) AS FINAL_ELEVY_PRICE                             --RISM 14-06-21 OLD RULE
,case when eq.eqh_elspan = 'Y' then 
				ISNULL(CASE WHEN EQH_UseELPrice = 1 THEN EQH_Elprice ELSE PBE.PRI_Price END,ST_EL.STO_PRICE)	   -- RYFE 15/06/2021 Removed devide by 12 since it is catered in the preprocessor	
	  when eq.eqh_elspan = 'M' then 
				ISNULL(CASE WHEN EQH_UseELPrice = 1 THEN EQH_Elprice ELSE PBE.PRI_Price END,ST_EL.STO_PRICE) 
	  ELSE 0 END																					 AS FINAL_ELEVY_PRICE          --RISM 14-06-2021 NEW RULE TO CATER FOR MONTHLY PRICE EQUIVALENT
,EQ.EQH_ELDue
, EQ.EQH_DUE_INV
,ST_EL.STO_STOCK_CODE
,C.CUS_ACCT_TO_INV
,C.CUS_Account
,C.CUS_Company
,C.CUS_CustOrder
,C.CUS_PODate
,EQH_M_SPAN
,EQ.EQH_Arrears
,EQ.EQH_S_Span
,EQ.EQH_Due_Date
,EQ.EQH_FixSaniDate
,EQ.EQH_ELSpan
,EQ.EQH_M_Next_Due
,EQ.EQH_PRSchemeID
,EQ.EQH_PRDueDate
,S.slp_days
,P.CATEGORISATION
,EQ.EQH_Start_Date
,EQ.EQH_Contract_Pd1
,EQ.EQH_Expiry_Date
, p.CUS_PORENT
,p.CUS_PORENTDATE
,p.CUS_POSANI
,p.CUS_POSANIDATE
,p.CUS_POEL
,p.CUS_POELDate
,PDL.PEDAL_ID
,ET.ety_name
from      DatasetProWat.Syn_EquipHdr_ex EQ
	 join DatasetProWat.Syn_Customer_ex C          on C.CUS_ACCOUNT = EQ.EQH_ACCOUNT
	 join DatasetProWat.Syn_Competit_ex acq        on acq.cmp_id = c.cus_acqfrom
	 join DatasetProWat.Syn_Stock_ex  ST         on st.sto_stock_code = eq.eqh_stock_code
	 join DatasetProWat.Syn_EQTYPE_ex ET         on et.ety_id = st.sto_eqtype

LEFT JOIN DatasetProWat.Syn_Stock_ex  ST_SAN     ON  ST_SAN.STO_STOCKID = ST.STO_EQSANITYPE
LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PB      ON ST_SAN.STO_STOCK_CODE = PB.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PB.PRI_Account 

LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PBF     ON EQ.EQH_F_Stock_Code = PBF.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBF.PRI_Account 
LEFT JOIN DatasetProWat.Syn_Stock_ex  ST_FIL     ON  ST_FIL.STO_STOCK_CODE = EQ.EQH_F_Stock_Code

LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PBM     ON EQ.EQH_M_Stock_Code = PBM.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBM.PRI_Account 
LEFT JOIN DatasetProWat.Syn_Stock_ex  ST_MNT     ON  ST_MNT.STO_STOCK_CODE = EQ.EQH_M_Stock_Code

LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PBE     ON PBE.PRI_Stock_Code = case when eqh_elspan = 'M' then 'ELMONTH' WHEN EQH_ELSPAN = 'Y' THEN 'ELANNUAL' ELSE 'ENV_LVY' END  --RISM 14-06-2021 CHANGED LINK AS LEVY CODES ARE HARDCODED IN PROWAT
													AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBE.PRI_Account   
LEFT JOIN DatasetProWat.Syn_Stock_ex ST_EL       ON ST_EL.STO_STOCK_CODE = case when eqh_elspan = 'M' then 'ELMONTH' WHEN EQH_ELSPAN = 'Y' THEN 'ELANNUAL' ELSE 'ENV_LVY' END

LEFT OUTER JOIN
                         DatasetProWat.Syn_SLPCode_ex AS S ON 
						 S.SLP_PCode = SUBSTRING(C.CUS_PCode, 1, CASE WHEN CHARINDEX(' ', c.cus_pcode) = 0 THEN LEN(c.cus_pcode) ELSE CHARINDEX(' ', c.cus_pcode) - 1 END) 

LEFT JOIN (select 
EQH_ACCOUNT 
 ,EQH_IDNO AS PEDAL_ID
 , REPLACE(REPLACE(SUBSTRING(EQH_ID,4,100),' ',''),'-','') AS SERIALLINK
 , EQH_ID
 ,EQH_STOCK_CODE AS EQUIP_STOCK_CODE
  , et.ety_name as product_type
from      DatasetProWat.Syn_EquipHdr_ex EQ
	 join DatasetProWat.Syn_Customer_ex C          on C.CUS_ACCOUNT = EQ.EQH_ACCOUNT
	 join DatasetProWat.Syn_Stock_ex  ST         on st.sto_stock_code = eq.eqh_stock_code
	 join DatasetProWat.Syn_EQTYPE_ex ET         on et.ety_id = st.sto_eqtype
where et.ety_name like 'PEDAL')PDL ON PDL.SERIALLINK = EQ.EQH_ID

  
   LEFT JOIN (
  SELECT distinct
---RULES. IF THE DEFAULT PO IS VALID AND POPULATED, THIS GOES TO CUSTOMER LEVEL WHETHER THE RENT/SANI/ELEVY PO'S ARE POPULATED OR NOT
----------IF ANY OF THE RENT/SANI/ELEVY ARE POPULATED AND ALL HAVE THE SAME VALUES AS DEFAULT THEN DISREGARD AS THE VALUE EXISTS AT CUSTOMER LEVEL
----------IF THE RENT/SANI/ELEVY ARE ALL POPULATED AND HAVE DIFFERENT VALUES TO EACH OTHER THEN THIS GOES TO SERVICE CONTRACT LINE LEVEL TO PULL ALL UNIQUE VALUES THROUGH
----------IF THE RENT/SANI/ELEVY HAVE THE SAME VALUES BETWEEN THEM BUT DIFFERENT TO THE DEFAULT THEN THIS SINGLE UNIQUE VALUE GOES TO SERVICE CONTRACT HEADER LEVEL AND THE DIFFERENT DEFAULT VALUE STILL GOES TO CUSTOMER LEVEL
 CASE 
 --------------------------------------------------------------------------------------------SINGLES------------------------------------------------------------------------------------------------
 WHEN V.VALIDATION = 1000 THEN 'CUSTOMER: CUS_CUSTORDER'  ---------IF ONLY DEFAULT PO THEN CUSTOMER LEVEL
 WHEN V.VALIDATION = 0001 THEN 'SC HEADER: CUS_POEL'     ---------IF ONLY ELEVY PO THEN SC HEADER LEVEL
 WHEN V.VALIDATION = 0010 THEN 'SC HEADER: CUS_POSANI'    ---------IF ONLY SANI PO THEN SC HEADER LEVEL
 WHEN V.VALIDATION = 0100 THEN 'SC HEADER: CUS_PORENT'    ---------IF ONLY RENT PO THEN SC HEADER LEVEL
 --------------------------------------------------------------------------------------------DOUBLES------------------------------------------------------------------------------------------------
 WHEN V.VALIDATION = 1100 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER'  --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER LEVEL
 WHEN V.VALIDATION = 1100 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_PORENT'--IF NOT THE SAME NEED TO TAKE BOTH, DEFAULT AT CUSTOMER AND RENT AT SC HEADER
 WHEN V.VALIDATION = 1010 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER'  --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER
 WHEN V.VALIDATION = 1010 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POSANI' --IF NOT THE SAME NEED TO TAKE BOTH, DEFAULT AT CUSTOMER AND SANI AT SC HEADER
 WHEN V.VALIDATION = 1001 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER'      --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER
 WHEN V.VALIDATION = 1001 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POEL' --IF NOT THE SAME NEED TO TAKE BOTH, DEFAULT AT CUSTOMER AND ELEVY AT SC HEADER
 WHEN V.VALIDATION = 0110 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) THEN 'SC HEADER: CUS_PORENT'  --IF MATCH ONLY NEED TO TAKE RENT TO SC HEADER LEVEL
 WHEN V.VALIDATION = 0110 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) THEN 'SC LINE: CUS_PORENT & CUS_POSANI'
 WHEN V.VALIDATION = 0101 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'SC HEADER: CUS_PORENT'
 WHEN V.VALIDATION = 0101 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'SC LINE: CUS_PORENT & CUS_POEL'
 WHEN V.VALIDATION = 0011 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'SC HEADER: CUS_POSANI'
 WHEN V.VALIDATION = 0011 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'SC LINE: CUS_POSANI & CUS_POEL'
 -------------------------------------------------------------------------------------------TRIPLES--------------------------------------------------------------------------------------------------
 WHEN V.VALIDATION = 1110 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER' --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER
 WHEN V.VALIDATION = 1110 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
						    OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))) 
						   AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_PORENT'
 WHEN V.VALIDATION = 1110 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
						    OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))) 
						   AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))THEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT & CUS_POSANI'
 WHEN V.VALIDATION = 1101 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER' --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER
 WHEN V.VALIDATION = 1101 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
						    OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))) 
						   AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_PORENT'
 WHEN V.VALIDATION = 1101 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
						    OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))) 
						   AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))THEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT & CUS_POEL'
---
 WHEN V.VALIDATION = 1011 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER'  --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER

 WHEN V.VALIDATION = 1011 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
						    OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))) 
						   AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POSANI'

 WHEN V.VALIDATION = 1011 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
						    OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))) 
						   AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))THEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_POSANI & CUS_POEL'


 WHEN V.VALIDATION = 0111 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
                          AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))
						  OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))) THEN 'SC HEADER: CUS_PORENT'

 WHEN V.VALIDATION = 0111 AND (CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))
						  OR CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))) THEN 'SC LINE: CUS_PORENT & CUS_POSANI & CUS_POEL'


-------------------------------------------------------------------------------------------QUAD-----------------------------------------------------------------------------------------------------
 WHEN V.VALIDATION = 1111 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
						  AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))  = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))  THEN 'CUSTOMER: CUS_CUSTORDER'  --IF MATCH THEN ONLY DEFAULT GOES TO CUSTOMER

 WHEN V.VALIDATION = 1111 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
						  AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28',''))  THEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT, CUS_POSANI, CUS_POEL'

 WHEN V.VALIDATION = 1111 AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','')) <> CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28',''))
                          AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_PORENT,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28',''))
						  AND CONCAT(LTRIM(RTRIM(ISNULL(CUS_POSANI,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) = CONCAT(LTRIM(RTRIM(ISNULL(CUS_POEL,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')) THEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_PORENT'

 END AS CATEGORISATION
	 ,CUSTOMER_ID 
	 ,CUS_PORENT
,CUS_PORENTDATE
,CUS_POSANI
,CUS_POSANIDATE
,CUS_POEL
,CUS_POELDate


FROM
(SELECT 

CONCAT(
 C.VALID_DEFAULT_PO, 
 C.VALID_RENTAL_PO,
 C.VALID_SANI_PO,
 C.VALID_ELEVY_PO) AS VALIDATION,


 *
FROM 
(SELECT 


 CUS_ACCOUNT AS CUSTOMER_ID

 -----------------------------------------------------------DEFAULT PO SECTION----------------------------------------------------------
,LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) AS DEFAULT_PO
,CASE WHEN LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) NOT LIKE '' THEN 1 ELSE 0 END AS 'VALID_DEFAULT_PO'
,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','') AS DEFAULT_PO_EXPIRY
,CONCAT(LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))),replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),''),'1800-12-28','')) AS 'DEFAULT_PO_EXPIRY_CONCAT'
,CASE WHEN ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),'') NOT IN ('','1800-12-28') THEN 1 ELSE 0 END AS 'VALID_DEFAULT_EXPIRY'
 
 -----------------------------------------------------------RENT PO SECTION--------------------------------------------------------------
,CASE WHEN LTRIM(RTRIM(ISNULL(CUS_PORent,''))) = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_PORent,''))) END as PO_RENT

,CASE WHEN CASE WHEN LTRIM(RTRIM(ISNULL(CUS_PORent,''))) = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_PORent,''))) END NOT LIKE '' THEN 1 ELSE 0 END AS 'VALID_RENTAL_PO'
,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','') AS PO_RENT_EXPIRY
,CONCAT(CASE WHEN LTRIM(RTRIM(ISNULL(CUS_PORent,''))) = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_PORent,''))) END,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')) AS 'RENT_PO_EXPIRY_CONCAT'
,CASE WHEN ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),'') NOT IN ('','1800-12-28') THEN 1 ELSE 0 END AS 'VALID_RENT_EXPIRY'

-----------------------------------------------------------SANI PO SECTION------------------------------------------------------------------
,CASE WHEN LTRIM(RTRIM(ISNULL(CUS_POSani,'')))  = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_POSANI,''))) END as PO_SANI
,CASE WHEN CASE WHEN LTRIM(RTRIM(ISNULL(CUS_POSani,'')))  = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_POSANI,''))) END NOT LIKE '' THEN 1 ELSE 0 END AS 'VALID_SANI_PO'
,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','') AS PO_SANI_EXPIRY
,CONCAT(CASE WHEN LTRIM(RTRIM(ISNULL(CUS_POSani,'')))  = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_POSANI,''))) END,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')) AS 'SANI_PO_EXPIRY_CONCAT'
,CASE WHEN ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),'') NOT IN ('','1800-12-28') THEN 1 ELSE 0 END AS 'VALID_SANI_EXPIRY'
-----------------------------------------------------------ELEVY PO SECTION-----------------------------------------------------------------
,CASE WHEN LTRIM(RTRIM(ISNULL(CUS_POEL,'')))  = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_POEL,''))) END AS ENV_LEVY
,CASE WHEN CASE WHEN LTRIM(RTRIM(ISNULL(CUS_POEL,'')))  = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_POEL,''))) END NOT LIKE '' THEN 1 ELSE 0 END AS 'VALID_ELEVY_PO'
,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','') AS ENV_LEVY_EXPIRY
,CONCAT(CASE WHEN LTRIM(RTRIM(ISNULL(CUS_POEL,'')))  = LTRIM(RTRIM(ISNULL(CUS_CUSTORDER,''))) THEN '' ELSE LTRIM(RTRIM(ISNULL(CUS_POEL,''))) END,replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','') ) AS 'EL_PO_EXPIRY_CONCAT'
,CASE WHEN ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),'') NOT IN ('','1800-12-28') THEN 1 ELSE 0 END AS 'VALID_ELEVY_EXPIRY'

,ISNULL(CUS_POREQ,0) AS PO_REQUIRED            --IF CUS_POREQ = 1 THEN WE NEED TO SET PO REQUIRED TICK IN IFS AT CUSTOMER LEVEL TO TRUE (NEED TO FIND IFS FIELD NAME)
,ISNULL(CUS_POSANIREQ,0) AS SANI_PO_REQ  




,CUS_Company as CUSTOMER_NAME
,CUS_Addr1 as ADDRESS1
,CUS_Type
,CUS_CUSTORDER
,CUS_PODATE
,CUS_PORENT
,CUS_PORENTDATE
,CUS_POSANI
,CUS_POSANIDATE
,CUS_POEL
,CUS_POELDate
FROM DatasetProWat.Syn_Customer_ex
)C
WHERE CUS_TYPE NOT LIKE 'CANC%' AND CUS_TYPE NOT LIKE 'STOCK'
--AND CUS_ACCOUNT = 1111986

--and
--CONCAT(C.VALID_DEFAULT_PO, C.VALID_RENTAL_PO,C.VALID_SANI_PO,C.VALID_ELEVY_PO) NOT LIKE '0000'
)V)P ON P.CUSTOMER_ID = C.CUS_ACCOUNT
 
WHERE -- EQH_IDNO in (62927)
 CMP_NAME LIKE 'OFFICE BEVERAGES'
  
  
  
GO
