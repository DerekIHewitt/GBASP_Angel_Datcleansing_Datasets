SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		RYFE
-- Create date: 2021-04-16
-- Description:	Validate Service contract related prowat data
--
-- Ver	Who		When		What
-- 1	DIH		15/04/2021	Template created
-- 2	Ryfe	21/04/2021	Added isActive to check rule
-- 3    RISM    27/04/2021  Removed rule 17, amended the naming of cr14 & cr20 to clarify the error
-- =============================================
CREATE PROCEDURE [DatasetCustom].[Validate_Service_Contract_Raw_Prowat_Data]
	@MIG_SITE_NAME varchar(5),
	@Iteration int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@return_value int

	-- Example of constant values used as a variable to 
	-- avoid having MAGIC numbers in the rest of the code
	DECLARE @MaxNameLength int = 100;

	-- use 'Find and Replace' to change use through the sproc
	DECLARE @Rule_CR1013_Additinal_Charge	int = -1013;			
	DECLARE @Rule_CR1024_Sani_Month_Charge int = -1024;
	DECLARE @Rule_CR1002_Filter_Charge	int = -1002;
	DECLARE @Rule_CR1025_Sani_Frequency int = -1025;
	DECLARE @Rule_CR1026_Maint_Price int = -1026;
	DECLARE @Rule_CR1005_Rental_Price int = -1005;
	DECLARE @Rule_CR1006_Filter_Stock_Code int = -1006;
	DECLARE @Rule_CR1007_Invoice_Frequency int = -1007;
	DECLARE @Rule_CR1008_Sani_Main_Positive_Inv_Freq int = -1008;
	DECLARE @Rule_CR1009_Rental_Inv_Frequency int = -1009;
	DECLARE @Rule_CR1010_Zero_Charge_Rental_Sani int = -1010;
	DECLARE @Rule_CR1011_Zero_Charge_Rental_Maint int = -1011;
	DECLARE @Rule_CR1012_Zero_Charge_Rental_Zero_Sani int = -1012;
	DECLARE @Rule_CR1014_MIF_Rent_Active_Sani int = -1014; --changed name to suit new rule amendment
	DECLARE @Rule_CR1015_Mif_Sani_No_Rental int = -1015;
	DECLARE @Rule_CR1016_Rent_Maint_No_Sani int = -1016;
	DECLARE @Rule_CR1017_Rent_Maint_Free_Sani int = -1017;
	DECLARE @Rule_CR1018_Rent_Maint_Sani_Charge int = -1018;
	DECLARE @Rule_CR1019_Mif_No_Charge int = -1019;
	DECLARE @Rule_CR1020_Sif_No_Frequencies int = -1020;
	DECLARE @Rule_CR1021_Sif_Inv_Freq int = -1021;
	DECLARE @Rule_CR1022_Non_Mif_No_Charge int = -1022;
	DECLARE @Rule_CR1023_Pipework_Charge int = -1023;

	

	-- All the rule numbers need to be in the 
	-- following string seperated by ; characters
	DECLARE @Rules varchar(1000) = ';-1013;-1023;-1002;-1024;-1025;-1005;-1006;-1007;-1008;-1009;-1010;-1011;-1012;-1014;-1015;-1016;-1017;-1018;-1019;-1020;-1021;-1022;-1023;-1026;';

	EXEC	@return_value = [DatasetSys].[sysCheck_AnyRulesActive]
			@MIG_SITE_NAME = N' ',
			@Rules = @Rules;

	IF (@return_value = 0) goto Exit_Now

	EXEC @return_value = [DatasetSys].[sysUpdate_RulesToCurrentDefectVersion] @Rules, @Iteration;
	EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 1, 0, @Iteration;




	-- ===============================================================================
	

	

	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

		SELECT
			TBL.MIG_SITE_NAME,
			TBL.CUSTOMER_ID,
			TBL.LEGACY_MACHINE_ID,
			TBL.EQH_ID,
			TBL.EQUIP_STOCK_CODE,
			TBL.CUS_Type,
			TBL.ERROR_DESCRIPTION,
			TBL.add_item_payment,
			TBL.Sanitisation_payment_MWR,
			TBL.FINALPIPEWORKPRICE,
			TBL.FINALFILTERPRICE,
			TBL.Sani_Span,
			TBL.FINALMAINTPRICE,
			TBL.FINALRENTALPRICE,
			TBL.EQH_F_STOCK_CODE,
			TBL.Rental_Frequency_Inv,
			TBL.FINALSANIPRICE,
			TBL.DEFECT_CR1013_Additinal_Charge,
			TBL.DEFECT_CR1024_Sani_Month_Charge,
			TBL.DEFECT_CR1023_Pipework_Charge,
			TBL.DEFECT_CR1002_Filter_Charge,
			TBL.DEFECT_CR1025_Sani_Frequency,
			TBL.DEFECT_CR1026_Maint_Price,
			TBL.DEFECT_CR1005_Rental_Price,
			TBL.DEFECT_CR1006_Filter_Stock_Code,
			TBL.DEFECT_CR1007_Invoice_Frequency,
			TBL.DEFECT_CR1008_Sani_Main_Positive_Inv_Freq,
			TBL.DEFECT_CR1009_Rental_Inv_Frequency,
			TBL.DEFECT_CR1010_Zero_Charge_Rental_Sani,
			TBL.DEFECT_CR1011_Zero_Charge_Rental_Maint,
			TBL.DEFECT_CR1012_Zero_Charge_Rental_Zero_Sani,
			TBL.DEFECT_CR1014_MIF_with_Rent_Active_Sani,
			TBL.DEFECT_CR1015_Mif_Sani_No_Rental,
			TBL.DEFECT_CR1016_Rent_Maint_No_Sani,
			--TBL.DEFECT_CR1017_Rent_Maint_Free_Sani,
			TBL.DEFECT_CR1018_Rent_Maint_Sani_Charge,
			TBL.DEFECT_CR1019_Mif_No_Charge,
			TBL.DEFECT_CR1020_Sif_No_Frequencies,
			TBL.DEFECT_CR1021_Sif_Inv_Freq,
			TBL.DEFECT_CR1022_Non_Mif_No_Charge,
			0 AS [SubSet]
	INTO #Result1
	FROM
	(
		SELECT DISTINCT

			 @MIG_SITE_NAME AS MIG_SITE_NAME
			,EQ.EQH_ACCOUNT AS CUSTOMER_ID
			,EQH_IDNO AS LEGACY_MACHINE_ID
			,EQ.EQH_ID
			,EQH_STOCK_CODE AS EQUIP_STOCK_CODE
			,C.CUS_TYPE

-------------------------------------------RENTAL--------------------------------------------
			, eqh_i_freq as Rental_Frequency_Inv
			, EQH_RentSpan as RentSpan
			, eqh_rental_amnt as Rental_Payment
			, eqh_c_value as add_item_payment
			, EQH_AddStockCode
			, eqh_sani_amnt as Sanitisation_payment_MWR
			, eqh_rental_amnt AS FINALRENTALPRICE
--------------------------------------------SANI---------------------------------------------
			, EQH_UseSaniPrice
			, eqh_saniprice as sani_price
			, PB.PRI_STOCK_CODE AS SANIPRICEBOOKSTOCKCODE
			, PB.PRI_Price AS SANITISE_PRICE
			, st_san.sto_price as sanistock_price
			, concat(eqh_frequency,eqh_s_span) as Sani_Span
			,isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) AS FINALSANIPRICE
			,CASE WHEN eqh_frequency >0 AND isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0 
			AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c') THEN 'SOOE' END AS SOOE
-------------------------------------------FILTER--------------------------------------------
			,EQH_F_STOCK_CODE
			, EQH_UseFilterPrice
			, EQH_FILTER_FREQ AS FILTER_FREQ
			, EQH_FilterPrice AS FILTERPRICE
			--,PBF.PRI_Stock_Code AS FILTERPRICEBOOKSTOCKCODE
			, PBF.PRI_PRICE AS FILTER_PRICE_BOOK_PRICE
			, ST_FIL.STO_PRICE AS FILTERSTOCK_PRICE
			, isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) AS FINALFILTERPRICE
--------------------------------------------MAINT--------------------------------------------
			, EQH_M_STOCK_CODE
			, EQH_UseMaintPrice
			, EQH_M_FREQ AS MAINT_FREQ
			, EQH_MAINTPRICE AS MAINT_PRICE
			, PBM.PRI_PRICE AS MAINT_PRICE_BOOK_PRICE
			, ST_MNT.STO_PRICE AS MAINTSTOCK_PRICE
			, concat(EQH_M_FREQ,EQH_M_Span) as Maint_Span
			, isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) AS FINALMAINTPRICE
--------------------------------------------PIPEWORK-----------------------------------------
			, EQH_PWStockCode
			, EQH_UsePWPrice
			, EQH_PWFreq AS PWORK_FREQ
			, EQH_PWPrice AS PWORK_PRICE
			, PBP.PRI_PRICE AS PIPEWORK_PRICE_BOOK_PRICE
			, ST_PW.STO_PRICE AS PWORKSTOCK_PRICE
			, EQH_PWFreq as Pipework_Freq
			, isnull(CASE WHEN EQH_UsePWPrice = 1 THEN EQH_PWPrice ELSE PBP.PRI_Price END,ST_PW.sto_price) AS FINALPIPEWORKPRICE
--------------------------------------------ELEVY--------------------------------------------
			, EQH_UseELPrice
			, EQH_ELFREQ AS ELEVY_FREQ
			, EQH_Elprice as ELEVY_PRICE

-------------------------------------------RULES-----------------------------------------------
			,case 
			-- Rule 1.	Prices merged into ‘Rental’ in Prowat from Add On Item and Sani with Rental 
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_i_freq > 0
			and eqh_rental_amnt > 0
			AND eqh_c_value > 0
			THEN Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1013_Additinal_Charge 

			,CASE
			-- Rule 1.	Prices merged into ‘Rental’ in Prowat from Add On Item and Sani with Rental
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_i_freq > 0
			and eqh_rental_amnt > 0
			AND eqh_sani_amnt > 0
			THEN Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1024_Sani_Month_Charge 

			,CASE
			-- Rule 2.	Prices merged from ‘Pipework’ into ‘Maintenance’ in Prowat 
			when isnull(CASE WHEN EQH_UsePWPrice = 1 THEN EQH_PWPrice ELSE PBP.PRI_Price END,ST_PW.sto_price) > 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1023_Pipework_Charge --'Error: Pipework charge needs to be cleansed'

			,CASE
			-- Rule 3.	Prices to be merged from ‘Filter’ to ‘Sanitisation’ price
			when isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) > 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1002_Filter_Charge --'Error: Filter charge needs to be cleansed'

			,CASE
			--Rule 7. We will not review the accuracy of sani frequencies before go live by product type, but will cleanse any frequencies outside 1,2,4,12 times per year 
			when concat(eqh_frequency,eqh_s_span) not in 
			('12M',
			'1Y',
			'52W',
			'26W',
			'6M',
			'12W',
			'13W',
			'3M',
			'1M',
			'0', 
			'0M',
			'0W',
			'0Y',
			'3',				-- 3 would always be 3M ,13 should always be 13W, 6 should always be 6M months added to decision log. This is added to send to raw table proc
			'3W',
			'13',
			'13M',
			'6',
			'6W'
			) 
			THEN Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1025_Sani_Frequency --'Error: Sani frequency is irregular'

			,CASE
			--Rule 20 C v.	There should be no Maint price if it’s a rented unit
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_i_freq > 0
			and eqh_rental_amnt > 0
			AND isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) > 0
			THEN Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1026_Maint_Price   --'Error: Rented equipment so Maint price needs to be cleansed'

			,CASE
			--Rule 20 C vi.	There should be no Rental price if it is a sold unit
			when eqh_status_flag = 'S' 
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1005_Rental_Price   --'Error: Sold unit cannot have rental. Rental price needs to be cleansed'

			,CASE
			--Rule 20 C ix.	There should be no stock code in Filter charge    
			when ISNULL(eqh_f_stock_code,'(None)') not like '(None)'
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1006_Filter_Stock_Code   --'Error: Filter stock code needs to be removed'

			--Rule 20 C x.	Can’t be anything set to charge AND not have an open tab 10   --RS Notes. I believe this is supposed to say that if there is a quit log open (QLG_Closed = 0) then the values should have been zeroed    

			--Rule 20 C xi.	Can’t be anything set to charge AND have an open tab 10       --RS Notes. I believe this is supposed to say that if there is a quit log closed (Qlg_Closed = 1) then the values should be zero. 
																			  --cont...   This one is difficult to determine as to which criteria to allocate for this record        

			--Rule 20 C xii.	There should be no open tab10 where there is no equipment on account               

			--Rule 20 C xiii.	There should be no open tab 10 where there is a collected date  

			--Rule 20 C xiv.	All rental units should have a frequency of >0
			,CASE    
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_i_freq = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1007_Invoice_Frequency   --'Error: Rented unit does not have a valid invoice frequency' 

			--Rule 20 C xv.	Contract pricing ETL rules already discussed to be added also

			,CASE
			when eqh_status_flag = 'S' 
			AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			--and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
			and eqh_frequency = 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			--and eqh_filter_Freq = 0
			and EQH_M_FREQ = 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)> 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1008_Sani_Main_Positive_Inv_Freq   --'Error: SIF No Sani and no Maintenance with positive invfreq '

			,CASE
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			--and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
			--and eqh_frequency > 0
			--and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			--and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			--and eqh_filter_freq = 0
			--and EQH_M_FREQ > 0
			--and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1009_Rental_Inv_Frequency   --'Error: Rental no inv_freq'

			,CASE
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			and eqh_filter_freq = 0
			and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1010_Zero_Charge_Rental_Sani   --'Error: Zero charge Rental with sani'

			,CASE
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			and eqh_filter_freq = 0
			and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) > 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1011_Zero_Charge_Rental_Maint   --'Error: Zero charge Rental with Maint'

			,CASE
			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			and eqh_filter_freq = 0
			and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1012_Zero_Charge_Rental_Zero_Sani   --'Error: Zero charge Rental with Zero Charge sani'

			,CASE
			when eqh_status_flag = 'R'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and eqh_frequency = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1014_MIF_with_Rent_Active_Sani   --'Error: Rent no Active Sani'

			,CASE
			when eqh_status_flag = 'R'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			and eqh_frequency > 0
			and EQH_M_Freq = 0
			--and eqh_filter_freq = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1015_Mif_Sani_No_Rental   --'Error: MIF Sani No Rental'

			,CASE
			when eqh_status_flag = 'R'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and eqh_frequency = 0
			and EQH_M_Freq > 1
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1016_Rent_Maint_No_Sani   --'Error: Rent & Maint charge no sani'

			/*
			-- RS Update. now allowed as new matrix rule allows sani to be set as billable via maintenance section --
			,CASE
			when eqh_status_flag = 'R'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and eqh_frequency > 0
			and EQH_M_Freq > 1
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) > 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1017_Rent_Maint_Free_Sani   --'Error: Rent & Maint charge but free sani'*/

			,CASE
			when eqh_status_flag = 'R'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and eqh_frequency > 0
			and EQH_M_Freq > 1
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) > 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1018_Rent_Maint_Sani_Charge   --'Error: Rent & Sani & Maint charge'

			,CASE
			when eqh_status_flag = 'R'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			--and eqh_i_freq > 0
			--and eqh_frequency > 0
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			--and eqh_filter_Freq = 0
			--and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)= 0
			--and EQH_M_Freq = 0
			--and eqh_filter_freq = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1019_Mif_No_Charge   --'Error: MIF Nothing charged'

			,CASE
			when eqh_status_flag = 'S'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			and eqh_frequency = 0
			and EQH_M_Freq = 0
			and eqh_filter_freq = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1020_Sif_No_Frequencies   --'Error: SIF Nothing charged due to freq = 0'

			,CASE
			when eqh_status_flag = 'S'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and eqh_frequency > 0
			--and EQH_M_Freq > 0
			--and eqh_filter_freq = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1021_Sif_Inv_Freq   --'Error: SIF With Inv Freq'

			,CASE
			when eqh_status_flag = 'R'
			AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks', 'PEDAL')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			and eqh_frequency = 0
			and EQH_M_Freq = 0
			and eqh_filter_freq = 0
			then Convert(bit, 1)
			ELSE Convert(bit, 0)
			END AS DEFECT_CR1022_Non_Mif_No_Charge   --'Error: NON-MIF Nothing charged'


			,CASE
			when eqh_status_flag = 'S' 
			AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			--and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			--and eqh_filter_Freq = 0
			and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)= 0
			then 'Query: Sani and Free Maintenance SIF '

			when eqh_status_flag = 'S' 
			AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			--and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) > 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
			--and eqh_filter_Freq = 0
			and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)= 0
			then 'Query: Sani and Free Maintenance SIF with positive invfreq '



			when eqh_status_flag = 'S' 
			AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) = 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) > 0
			and eqh_filter_Freq > 0
			and EQH_M_FREQ > 0
			and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price)> 0
			then 'Query :SIF Maint & Filter No Sani Freq'

			when eqh_status_flag = 'R' 
			AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq > 0
			and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) > 0
			and eqh_filter_freq > 0
			and EQH_M_FREQ = 0
			then 'Query: Rental with Free sani but Filter charge'

			when eqh_status_flag = 'S'
			and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
			and eqh_pwfreq = 0
			and eqh_i_freq = 0
			and eqh_frequency > 0
			and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
			--and EQH_M_Freq > 0
			and eqh_filter_freq > 0
			and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) > 0
			then 'Query: SIF With Free Sani but Filter Charge'

			end
			as ERROR_DESCRIPTION

 
 


	FROM  DatasetProWat.Syn_EquipHdr_dc   EQ
	JOIN  DatasetProWat.Syn_Customer_dc C        on C.CUS_ACCOUNT = EQ.EQH_ACCOUNT
	JOIN  DatasetProWat.Syn_Stock_dc  ST         on st.sto_stock_code = eq.eqh_stock_code
	JOIN  DatasetProWat.Syn_EQTYPE_dc ET         on et.ety_id = st.sto_eqtype

	LEFT JOIN DatasetProWat.Syn_Stock_dc  ST_SAN     ON  ST_SAN.STO_STOCKID = ST.STO_EQSANITYPE
	LEFT JOIN DatasetProWat.Syn_PriceBk_dc  AS PB      ON ST_SAN.STO_STOCK_CODE = PB.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PB.PRI_Account 

	LEFT JOIN DatasetProWat.Syn_PriceBk_dc  AS PBF     ON EQ.EQH_F_Stock_Code = PBF.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBF.PRI_Account 
	LEFT JOIN DatasetProWat.Syn_Stock_dc  ST_FIL     ON  ST_FIL.STO_STOCK_CODE = EQ.EQH_F_Stock_Code

	LEFT JOIN DatasetProWat.Syn_PriceBk_dc  AS PBM     ON EQ.EQH_M_Stock_Code = PBM.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBM.PRI_Account 
	LEFT JOIN DatasetProWat.Syn_Stock_dc  ST_MNT     ON  ST_MNT.STO_STOCK_CODE = EQ.EQH_M_Stock_Code

	LEFT JOIN DatasetProWat.Syn_PriceBk_dc  AS PBP     ON EQ.EQH_PWStockCode = PBP.PRI_Stock_Code  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBP.PRI_Account
	LEFT JOIN DatasetProWat.Syn_Stock_dc  ST_PW     ON  ST_PW.STO_STOCK_CODE = EQ.EQH_PWStockCode

	LEFT JOIN DatasetProWat.Syn_PriceBk_dc  AS PBE     ON PBE.PRI_Stock_Code = 'ENV_LVY'  AND CASE WHEN cus_pricebookac = 0 THEN cus_account ELSE cus_pricebookac END = PBE.PRI_Account

	)TBL

	WHERE CUS_TYPE NOT IN ('STOCK')
	AND 
	(ERROR_DESCRIPTION is not null 
	OR TBL.DEFECT_CR1013_Additinal_Charge <> 0
	OR TBL.DEFECT_CR1024_Sani_Month_Charge <> 0 
	OR TBL.DEFECT_CR1023_Pipework_Charge <> 0
	OR TBL.DEFECT_CR1002_Filter_Charge <> 0
	OR TBL.DEFECT_CR1025_Sani_Frequency  <> 0
	OR TBL.DEFECT_CR1026_Maint_Price  <> 0
	OR TBL.DEFECT_CR1005_Rental_Price  <> 0
	OR TBL.DEFECT_CR1006_Filter_Stock_Code  <> 0
	OR TBL.DEFECT_CR1007_Invoice_Frequency  <> 0
	OR TBL.DEFECT_CR1008_Sani_Main_Positive_Inv_Freq  <> 0
	OR TBL.DEFECT_CR1009_Rental_Inv_Frequency  <> 0
	OR TBL.DEFECT_CR1010_Zero_Charge_Rental_Sani  <> 0
	OR TBL.DEFECT_CR1011_Zero_Charge_Rental_Maint  <> 0
	OR TBL.DEFECT_CR1012_Zero_Charge_Rental_Zero_Sani  <> 0
	OR TBL.DEFECT_CR1014_MIF_with_Rent_Active_Sani  <> 0   --RS added MIF to name to specify a rented item to user
	OR TBL.DEFECT_CR1015_Mif_Sani_No_Rental  <> 0
	OR TBL.DEFECT_CR1016_Rent_Maint_No_Sani <> 0
	--OR TBL.DEFECT_CR1017_Rent_Maint_Free_Sani  <> 0
	OR TBL.DEFECT_CR1018_Rent_Maint_Sani_Charge  <> 0
	OR TBL.DEFECT_CR1019_Mif_No_Charge <> 0
	OR TBL.DEFECT_CR1020_Sif_No_Frequencies <> 0
	OR TBL.DEFECT_CR1021_Sif_Inv_Freq <>0
	OR TBL.DEFECT_CR1022_Non_Mif_No_Charge <> 0)


			---------------------------------------------------------------------------------------------
			-- Process results
			---------------------------------------------------------------------------------------------
	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1013_Additinal_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1013_Additinal_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1013_Additinal_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), add_item_payment, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1013_Additinal_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1024_Sani_Month_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1024_Sani_Month_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1024_Sani_Month_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), Sanitisation_payment_MWR, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1024_Sani_Month_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1023_Pipework_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1023_Pipework_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1023_Pipework_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), FINALPIPEWORKPRICE, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1023_Pipework_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1002_Filter_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1002_Filter_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1002_Filter_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), FINALFILTERPRICE, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1002_Filter_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1025_Sani_Frequency ) = 1)
		BEGIN
			PRINT 'New Defect {CR1025_Sani_Frequency}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1025_Sani_Frequency, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), Sani_Span, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1025_Sani_Frequency = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1026_Maint_Price ) = 1)
		BEGIN
			PRINT 'New Defect {CR1026_Maint_Price}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1026_Maint_Price, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), FINALMAINTPRICE, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1026_Maint_Price = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1005_Rental_Price ) = 1)
		BEGIN
			PRINT 'New Defect {CR1005_Rental_Price}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1005_Rental_Price, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), FINALRENTALPRICE+add_item_payment, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1005_Rental_Price = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1006_Filter_Stock_Code ) = 1)
		BEGIN
			PRINT 'New Defect {CR1006_Filter_Stock_Code}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1006_Filter_Stock_Code, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), EQH_F_STOCK_CODE, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1006_Filter_Stock_Code = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1007_Invoice_Frequency ) = 1)
		BEGIN
			PRINT 'New Defect {CR1007_Invoice_Frequency}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1007_Invoice_Frequency, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), Rental_Frequency_Inv, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1007_Invoice_Frequency = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1008_Sani_Main_Positive_Inv_Freq ) = 1)
		BEGIN
			PRINT 'New Defect {CR1008_Sani_Main_Positive_Inv_Freq}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1008_Sani_Main_Positive_Inv_Freq, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1008_Sani_Main_Positive_Inv_Freq = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1009_Rental_Inv_Frequency ) = 1)
		BEGIN
			PRINT 'New Defect {CR1009_Rental_Inv_Frequency}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1009_Rental_Inv_Frequency, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1009_Rental_Inv_Frequency = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1010_Zero_Charge_Rental_Sani ) = 1)
		BEGIN
			PRINT 'New Defect {CR1010_Zero_Charge_Rental_Sani}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1010_Zero_Charge_Rental_Sani, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1010_Zero_Charge_Rental_Sani = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1011_Zero_Charge_Rental_Maint ) = 1)
		BEGIN
			PRINT 'New Defect {CR1011_Zero_Charge_Rental_Maint}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1011_Zero_Charge_Rental_Maint, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1011_Zero_Charge_Rental_Maint = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1012_Zero_Charge_Rental_Zero_Sani ) = 1)
		BEGIN
			PRINT 'New Defect {CR1012_Zero_Charge_Rental_Zero_Sani}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1012_Zero_Charge_Rental_Zero_Sani, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1012_Zero_Charge_Rental_Zero_Sani = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1014_MIF_Rent_Active_Sani ) = 1)
		BEGIN
			PRINT 'New Defect {CR1014_MIF_Rent_Active_Sani}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1014_MIF_Rent_Active_Sani, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1014_Rent_Active_Sani = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1015_Mif_Sani_No_Rental ) = 1)
		BEGIN
			PRINT 'New Defect {CR1015_Mif_Sani_No_Rental}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1015_Mif_Sani_No_Rental, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1015_Mif_Sani_No_Rental = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1016_Rent_Maint_No_Sani ) = 1)
		BEGIN
			PRINT 'New Defect {CR1016_Rent_Maint_No_Sani}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1016_Rent_Maint_No_Sani, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1016_Rent_Maint_No_Sani = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1017_Rent_Maint_Free_Sani ) = 1)
		BEGIN
			PRINT 'New Defect {CR1017_Rent_Maint_Free_Sani}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1017_Rent_Maint_Free_Sani, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1017_Rent_Maint_Free_Sani = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1018_Rent_Maint_Sani_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1018_Rent_Maint_Sani_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1018_Rent_Maint_Sani_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), FINALMAINTPRICE+FINALSANIPRICE, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1018_Rent_Maint_Sani_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1019_Mif_No_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1019_Mif_No_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1019_Mif_No_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1019_Mif_No_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1020_Sif_No_Frequencies ) = 1)
		BEGIN
			PRINT 'New Defect {CR1020_Sif_No_Frequencies}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1020_Sif_No_Frequencies, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID),'0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1020_Sif_No_Charge = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1021_Sif_Inv_Freq ) = 1)
		BEGIN
			PRINT 'New Defect {CR1021_Sif_Inv_Freq}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1021_Sif_Inv_Freq, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), Rental_Frequency_Inv, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1021_Sif_Inv_Freq = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1022_Non_Mif_No_Charge ) = 1)
		BEGIN
			PRINT 'New Defect {CR1022_Non_Mif_No_Charge}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1022_Non_Mif_No_Charge, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1022_Non_Mif_No_Charge = 1;
		END
		





Exit_Now:
	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

    EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 0, 1, @Iteration;
	print 'Done';
END	
GO
