SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- EXECUTE ServiceContract_Raw_SendToTables_ex 

/*=============================================
  Author:      RYFE
  Description: Based on original version 
--RYFE	       19-02-2021	Created based on GBASP Data Cleansing ServiceContract_Raw_SendForTransform
--RISM         11-06-2021   Maint price needs to be divided by same rules as the service freq rules are applied, so finalmaintprice has been amended 
--RISM		   14-06-2021   Elevy needs to be ELMONTH for EL_SPAN  = 'M' and ELANNUAL for EL_SPAN = 'Y'. price needed to have same rules as maint price above so if elannual divide by 12
--RYFE         20-08-2021   CHanges done to the COMPETIT join after Validation Checks
--RYFE         07-10-2021   Added ISNULL to price,frequency values when deciding Matrix type
--RYFE         08-10-2021   Added DISTINCT to avoid duplicate rows
--RYFE         11-10-2021   Make EL price 0 if EL Frequency is 0
--RYFE         12-10-2021   SERV_FREQ 12W added as 3(months)
--RISM		   27-10-2021   ADDED STOCK TABLE LINK TO GET STOCK PRICE WHERE NOT IN PRICEBOOK
--RISM		   27-10-2021   Removed the Office Beverages competitor validation from contract type 7
--RISM		   27-10-2021   Updated the mif and non mif categories to:
--							MIF:     'POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station'
--							NON MIF: 'Recycling Scheme','Ancilliaries & Racks' ,'Management Fee', 'Vending m/c'
--RISM         27-10-2021   Specified the specific maintenance stock codes that have SILV in the code. %SILV% wildcard would otherwise include some consumables codes we do not want to 
--							Include in this ruleset
--RYFE         03-11-2021   passed blank instead of {  as the ELEVY unit for NULLs to avoid -1 generating as the price for ELEVY
--RYFE         05-11-2021   Added rules for new Matrix type FUBAR
--RISM		   05-11-2021   Removed Sif Non Mif as should fall into query types if not a Sold Non Mif
--RISM		   05-11-2021   Requested rule change for FUBAR to be a total of frequency multiplied by final price to equal zero. This is to cater for where Prowat does not bill at zero frequency but a price exists
--RISM         05-11-2021   Added to not allow TRIAL Customer Type to be created as a service contract
--RISM		   08-11-2021   Added price X freq rule to non mif so as to not come across as an sc line if no invoice generates in Prowat
--RYFE         09-11-2021   Changed rules for contract term to use [EQH_Contract_Pd1],[EQH_Span]
--RYFE		   25-11-2021   Revaluation data adjust to first of month
--RISM         25-11-2021   ADDED ISNULL TO THE USE ELPRICE SECTION
--RISM		   26-11-2021   ADDED ISNULL TO CUS_PRICEBOOKAC link as NULL stops it from providing the correct link back to the right pricebook
--RISM	       26-11-2021   Additional elevy price times frequency logic to force a dummy elevy line of 1 month at zero
--RYFE         29-11-2021   Added 12 as frequency to avoid 0 frequency error for dummy ELEVY line
--RYFE		   30-11-2021   Changed Revalution Logic according to new rules from Email 29/11/2021
=============================================*/
CREATE PROCEDURE [DatasetProWat].[ServiceContract_Raw_SendToTables_ex]

AS
BEGIN

SET NOCOUNT ON;
	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	
	 ---------------- Delete records already in the loading table for this site -----------------------------------------------
	 BEGIN TRANSACTION
		DELETE FROM [Dataset].[ServiceContract_Raw_ex] 
			WHERE MIG_SITE_NAME = @MIG_SITENAME
	 COMMIT TRANSACTION
	 ---------------- Add records to the loading table ---------------------------------------------------------


	INSERT INTO [Dataset].[ServiceContract_Raw_ex]
	([MIG_SITE_NAME]
      ,[MIG_CREATED_DATE]
      ,[CUSTOMER_INVOICE]
      ,[CUSTOMER_DELIVERY]
      ,[CONTRACT_NAME]
      ,[MATRIX_TYPES]
      ,[MACHINE_LEGACY_UID]
      ,[MACHINE_PART_NUM]
      ,[MACHINE_OWNER]
      ,[PO_NUMBER]
      ,[PO_VALUE]
      ,[PO_VALID_FROM]
      ,[PO_EXPIRY_DATE]
      ,[BILLING_IFS_FROM_DATE]
      ,[RENT_UNIT]
      ,[RENT_PER_UNIT]
      ,[RENT_INVOICE_FREQ]
      ,[RENT_IN_ADVANCE]
      ,[RENT_NEXT_INVOICE_DATE]
      ,[RENT_NEXT_PERIOD_FROM_DATE]
      ,[SERVICE_UNIT]
      ,[SERVICE_PER_UNIT]
      ,[SERVICE_INVOICE_FREQ]
      ,[SERVICE_FREQ]
      ,[SERVICE_IN_ADVANCE]
      ,[SERVICE_NEXT_INVOICE_DATE]
      ,[SERVICE_NEXT_PERIOD_FROM]
      ,[SERVICE_NEXT_PM_BASE]
      ,[SERVICE_PM_START_VALUE]
      ,[ENV_UNIT]
      ,[ENV_PRICE_PER_UNIT]
      ,[ENV_INV_FREQ]
      ,[ENV_NEXT_INVOICE_DATE]
      ,[ENV_NEXT_PERIOD_FROM]
      ,[OTHER1_TYPE]
      ,[OTHER1_SUBTYPE]
      ,[OTHER1_UNIT]
      ,[OTHER1_PRICE_PER_UNIT]
      ,[OTHER1_INVOICE_FREQ]
      ,[OTHER1_INVOICE_QTY]
      ,[OTHER1_NEXT_INVOICE_DATE]
      ,[OTHER1_NEXT_PERIOD_FROM]
      ,[OTHER2_TYPE]
      ,[OTHER2_SUBTYPE]
      ,[OTHER2_UNIT]
      ,[OTHER2_PRICE_PER_UNIT]
      ,[OTHER2_INVOICE_FREQ]
      ,[OTHER2_INVOICE_QTY]
      ,[OTHER2_NEXT_INVOICE_DATE]
      ,[OTHER2_NEXT_PERIOD_FROM]
      ,[HASADDITIONALDATA]
      ,[SLA_EXC]
      ,[SLA_SWP]
      ,[SLA_SER]
      ,[SLA_TER]
      ,[SLA_CMA]
      ,[SLA_DEL]
      ,[CURRENT_CONTRACT]
      ,[CURRENT_CONTRACT_NUMBER]
      ,[CURRENT_START_DATE]
      ,[ORIGINAL_CONTRACT_NUMBER]
      ,[ORIGINAL_END_DATE]
      ,[ORIGINAL_START_DATE]
      ,[CONTRACT_TERM]
	  ,[FIRST_REVALUATION_DATE]
	  ,[REVALUATION_TYPE]
	  ,[PO_SCHEMA]
      ,[COMMENT])
	  

	select 
			DISTINCT																												--08/10/2021 RYFE Added to avoid duplicate rows
						'GBASP'																			    AS MIG_SITE_NAME, 
						 GETDATE()																			AS MIG_CREATED_DATE, 
						 --ISNULL(CASE WHEN CUS_ACCT_TO_INV = 0 
						 --THEN '' ELSE convert(varchar,CUS_ACCT_TO_INV) END, '')								
						 
						 ''																					AS CUSTOMER_INVOICE, -- ALT customer to be left blank for UK 
                         CUS_Account																		AS CUSTOMER_DELIVERY, 
						 CUS_Company																		AS CONTRACT_NAME,
						 CASE
						 WHEN MATRIX_TYPE = 'MIF - Totalcare only'  THEN ';1;'
						 WHEN MATRIX_TYPE = 'Non MIF Rental Only'   THEN ';B;'								-- New Matrix type needed
						 WHEN MATRIX_TYPE = 'MIF - Rental Only'	    THEN ';A;'								-- New matrix type needed
						 WHEN MATRIX_TYPE = 'Maintenance Only SIF'  THEN ';3;'
						 WHEN MATRIX_TYPE = 'Maintenance Only SIF-SILVER' THEN ';4;'						-- Matrix 4 with CMA line
						 WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN	';2;3;'		    --This is the new contract type
						 WHEN MATRIX_TYPE = 'Sold Non MIF'		    THEN	';Sold Non MIF;'
						 WHEN MATRIX_TYPE = 'Sani Only SIF'	        THEN ';9;6;'
						 WHEN MATRIX_TYPE = 'SIF Non MIF'		    THEN ';SIF Non MIF;'					--Should this be 9 since they are NON mif? --should fall into sold non mif
						 WHEN MATRIX_TYPE = 'QUERY EQUIPMENT TYPES' THEN ';QUERY EQUIPMENT TYPES;'
						 WHEN MATRIX_TYPE = 'TRIAL'                 THEN ';TRIAL EQUIPMENT NO SC;'
						 WHEN MATRIX_TYPE = 'FUBAR'				    THEN ';D;'
						 ELSE ''


						 END								AS MATRIX_TYPES,
						 EQH_IDNo																			AS MACHINE_LEGACY_UID,
						 EQUIP_STOCK_CODE																	AS MACHINE_PART_NUM,
						 ISNULL(EQH_Status_Flag, '{NULL}')													AS MACHINE_OWNER,
						 --CASE CATEGORISATION
						 --WHEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POEL' THEN CUS_POEL
						 --WHEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_PORENT' THEN CUS_PORENT
						 --WHEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POSANI' THEN CUS_POSANI
						 --WHEN 'SC HEADER: CUS_POEL' THEN CUS_POEL
						 --WHEN 'SC HEADER: CUS_PORENT' THEN CUS_PORENT
						 --WHEN 'SC HEADER: CUS_POSANI' THEN CUS_POSANI
						 --WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT & CUS_POEL'  THEN CUS_PORENT
						 --WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT & CUS_POSANI' THEN
						 -- CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN CUS_PORENT
						 --      WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN CONCAT('PO_RENT:',CUS_PORENT,' PO_SANI:',CUS_POSANI)
						--	   ELSE CUS_POSANI
						--	   END

						-- WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT, CUS_POSANI, CUS_POEL' THEN 
						--	CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN CUS_PORENT
						 --      WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN CONCAT('PO_RENT:',CUS_PORENT,' PO_SANI:',CUS_POSANI)
						--	   ELSE CUS_POSANI
						--	   END

						--WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_POSANI & CUS_POEL' THEN CUS_POSANI
						--WHEN 'SC LINE: CUS_PORENT & CUS_POEL' THEN CUS_PORENT
						--WHEN 'SC LINE: CUS_PORENT & CUS_POSANI' THEN 
						-- CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN CUS_PORENT
						--       WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN CONCAT('PO_RENT:',CUS_PORENT,' PO_SANI:',CUS_POSANI)
						--	   ELSE CUS_POSANI
						--	   END

						--WHEN 'SC LINE: CUS_PORENT & CUS_POSANI & CUS_POEL' THEN 
						--	CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN CUS_PORENT
						 --      WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN CUS_PORENT
						--	   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN CONCAT('PO_RENT:',CUS_PORENT,' PO_SANI:',CUS_POSANI)
						--	   ELSE CUS_POSANI
						--	   END
						--WHEN 'SC LINE: CUS_POSANI & CUS_POEL' THEN CUS_POSANI

						-- ELSE '' 
						 --END																				
						 ''																					AS PO_NUMBER, -- Check PO details
						 0																					AS PO_VALUE,
						 NULL																				AS PO_VALID_FROM,


						/* CASE CATEGORISATION
						 WHEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POEL' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')
						 WHEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_PORENT' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','') 
						 WHEN 'CUSTOMER: CUS_CUSTORDER & SC HEADER: CUS_POSANI' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  
						 WHEN 'SC HEADER: CUS_POEL' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),''),'1800-12-28','')
						 WHEN 'SC HEADER: CUS_PORENT' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						 WHEN 'SC HEADER: CUS_POSANI' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')
						 WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT & CUS_POEL'  THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						 WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT & CUS_POSANI' THEN
						  CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						       WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','') -- recheck this
							   ELSE replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  
							   END

						 WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_PORENT, CUS_POSANI, CUS_POEL' THEN 
							CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						       WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','') -- recheck this
							   ELSE replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  
							   END

						WHEN 'CUSTOMER: CUS_CUSTORDER & SC LINE: CUS_POSANI & CUS_POEL' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  
						WHEN 'SC LINE: CUS_PORENT & CUS_POEL' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						WHEN 'SC LINE: CUS_PORENT & CUS_POSANI' THEN 
						 CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						       WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','') -- recheck this
							   ELSE replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  
							   END

						WHEN 'SC LINE: CUS_PORENT & CUS_POSANI & CUS_POEL' THEN 
							CASE WHEN MATRIX_TYPE = 'MIF - Totalcare only' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
						       WHEN MATRIX_TYPE = 'Non MIF Rental Only'  THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only'    THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','')
							   WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),''),'1800-12-28','') -- rechekc this
							   ELSE replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  
							   END
						 WHEN 'SC LINE: CUS_POSANI & CUS_POEL' THEN replace(ISNULL(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),''),'1800-12-28','')  

						 ELSE '' 
						 END */
						 ''																					AS PO_EXPIRY_DATE,



						 CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV), '1800-12-28', '')						 
						 ELSE 
						 REPLACE(CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0, 
						 DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV)), 0),103) , '1900-01-01', '')
						 END																				AS BILLING_IFS_FROM_DATE, -- This needs to be  first of the month

						 ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN RentSpan 
						 ELSE EQH_M_SPAN END, '')															AS RENT_UNIT, --03/11/2021 RYFE passed blank instead of 0 to avoid -1 generating as the price
						 
						  isnull(Rental_Price,0)															AS RENT_PER_UNIT,
						 
						 
						 ISNULL(
						 CASE WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '3M' 
						 THEN 4 
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '13W' 
						 THEN 4
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '13' 
						 THEN 4
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '13M' 
						 THEN 4
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '6M' 
						 THEN 2 
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '6' 
						 THEN 2
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '6W' 
						 THEN 2
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '26W'
						 THEN 2
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '12W'											--Recheck for 12W
						 THEN 4.33
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '12M' 
						 THEN 1
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '52W'
						 THEN 1
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '1Y' 
						 THEN 1 
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '3'
						 THEN 4
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '3W'
						 THEN 4
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '1M' 
						 THEN 12
						 WHEN CONCAT(Rental_Frequency_inv, ISNULL(CASE WHEN (CASE WHEN MAINTenance_FREQuency = 0 OR MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service' THEN 0 ELSE 1 END) = 0 
						 THEN EQH_I_SPAN 
						 ELSE EQH_M_SPAN END, 0)) = '1W' 
						 THEN 52 
						 WHEN Rental_Frequency_inv = 0 
						 THEN 0 END, 0)																		AS RENT_INVOICE_FREQ,
						 
                         1																					AS RENT_IN_ADVANCE, --Should this always be TRUE regardless of EQH_Arrears != 'Y'
						 
						 CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV), '1800-12-28', '')
						 ELSE
						 REPLACE(CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV)), 0),103) , '1900-01-01', '')
						 END																				AS RENT_NEXT_INVOICE_DATE, -- This needs to be  first of the month
						 
                         ''																					AS RENT_NEXT_PERIOD_FROM_DATE, 

						 ISNULL(EQH_M_Span, '{NULL}')														AS SERVICE_UNIT, -- Changed to get Maint span since this field is regarding invoicing

						 CASE
						 WHEN MATRIX_TYPE IN ( 'Maintenance Only SIF' , 'Maintenance Only SIF-SILVER' )
						 THEN ISNULL(FINALMAINTPRICE, 0)
						 WHEN MATRIX_TYPE = 'MIF - Rental Only Recurring Sani/Service'
						 THEN ISNULL(FINALMAINTPRICE, 0)
						 ELSE
						 ISNULL(FINALSANIPRICE, 0) END														AS SERVICE_PER_UNIT, 

                         ISNULL(
						 CASE WHEN Maint_Span = '3M' 
						 THEN 4 
						 WHEN Maint_Span = '13W' 
						 THEN 4
						 WHEN Maint_Span = '13' 
						 THEN 4
						 WHEN Maint_Span = '13M' 
						 THEN 4
						 WHEN Maint_Span = '6M' 
						 THEN 2 
						 WHEN Maint_Span = '6' 
						 THEN 2
						 WHEN Maint_Span = '6W' 
						 THEN 2
						 WHEN Maint_Span = '26W'
						 THEN 2
						 WHEN Maint_Span = '12W'											--Recheck for 12W
						 THEN 4.33
						 WHEN Maint_Span = '12M' 
						 THEN 1
						 WHEN Maint_Span = '52W'
						 THEN 1
						 WHEN Maint_Span = '1Y' 
						 THEN 1 
						 WHEN Maint_Span = '3'
						 THEN 4
						 WHEN Maint_Span = '3W'
						 THEN 4
						 WHEN Maint_Span = '1M' 
						 THEN 12 
						 WHEN MAINTenance_FREQuency = 0 
						 THEN 0 END, 0)															AS SERVICE_INVOICE_FREQ, -- Used Maint contract to find next invoice frequency
						 
						

						 ISNULL(
						 CASE WHEN CONCAT(sani_freq, EQH_S_Span) = '3M' 
						 THEN 3 
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '13W' 
						 THEN 3
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '13' 
						 THEN 3
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '13M' 
						 THEN 3
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '6M' 
						 THEN 6 
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '6' 
						 THEN 6
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '6W' 
						 THEN 6
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '26W'
						 THEN 6
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '12W'											--Recheck for 12W
						 THEN 3
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '12M' 
						 THEN 12
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '52W'
						 THEN 12
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '1Y' 
						 THEN 12 
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '3'
						 THEN 3
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '3W'
						 THEN 3
						 WHEN CONCAT(sani_freq, EQH_S_Span) = '1M' 
						 THEN 1
						 WHEN sani_freq  = 0 
						 THEN 0 END, 0)																		AS SERVICE_FREQ, 

						 0																					AS SERVICE_IN_ADVANCE,
						 
						 CASE WHEN DatasetProWat.CONVERTFROMCLARION([EQH_M_Next_Due]) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION([EQH_M_Next_Due]), '1800-12-28', '') 
						 ELSE 
						 REPLACE(CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 DatasetProWat.CONVERTFROMCLARION([EQH_M_Next_Due])), 0),103) , '1900-01-01', '') 
						 END																				AS SERVICE_NEXT_INVOICE_DATE, -- Changed to get the Maint next due date for SM SO next inv date

						 ''																					AS SERVICE_NEXT_PERIOD_FROM,
						 
                         CASE WHEN EQH_FIXSANIDATE = 1 
						 THEN 'S' 
						 WHEN EQH_FIXSANIDATE = 0 
						 THEN 'A' 
						 END																				AS	SERVICE_NEXT_PM_BASE, 
						 
						 CASE WHEN DatasetProWat.CONVERTFROMCLARION([EQH_Due_Date]) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION([EQH_Due_Date]), '1800-12-28', '') 
						 ELSE DatasetProWat.CONVERTFROMCLARION([EQH_Due_Date]) 
						 END																				AS SERVICE_PM_START_VALUE,
						 
                         ISNULL(EQH_ELSpan, '')																AS ENV_UNIT,		--03/11/2021 RYFE passed blank instead of { to avoid -1 generating as the price
						 
						 ISNULL(
						 CASE WHEN ISNULL(ELEVY_FREQ,0) = 0
						      THEN 0
							  WHEN ISNULL(ELEVY_FREQ,0)*ISNULL(FINAL_ELEVY_PRICE,0) = 0
							  THEN 0																							  -- 26/11/2021 RISM Added frequency times price logic to force a zero
							  ELSE
						      FINAL_ELEVY_PRICE
							  END	, 0)																	AS ENV_PRICE_PER_UNIT, --11/10/2021 RYFE Make EL price 0 if frequency is 0
						 
						 																	
						  ISNULL(
						 CASE 
						 WHEN ISNULL(ELEVY_FREQ,0)*ISNULL(FINAL_ELEVY_PRICE,0) = 0                      -- 26/11/2021 RISM Added frequency times price logic to force a zero
						 THEN 
							CASE WHEN MATRIX_TYPE = 'Non MIF Rental Only' THEN 0						-- 29/11/2021 RYFE Added to avoid 0 frequency error for dummy ELEVY line
								ELSE
								12 
							END
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '3M' 
						 THEN 4 
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '13W' 
						 THEN 4
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '13' 
						 THEN 4
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '13M' 
						 THEN 4
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '6M' 
						 THEN 2 
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '6' 
						 THEN 2
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '6W' 
						 THEN 2
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '26W'
						 THEN 2
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '12W'											--Recheck for 12W
						 THEN 4.33
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '12M' 
						 THEN 1
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '52W'
						 THEN 1
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '1Y' 
						 THEN 1 
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '3'
						 THEN 4
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '3W'
						 THEN 4
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '1M' 
						 THEN 12 
						 WHEN CONCAT(ELEVY_FREQ, EQH_ELSpan) = '1W' 
						 THEN 52 
						 WHEN ELEVY_FREQ = 0 
						 THEN 
						 CASE WHEN MATRIX_TYPE = 'Non MIF Rental Only' THEN 0
						 ELSE
						 12 END
						 END, CASE WHEN MATRIX_TYPE = 'Non MIF Rental Only' THEN 0 ELSE 12 END)
																											AS ENV_INV_FREQ,
						 
                         CASE WHEN DatasetProWat.CONVERTFROMCLARION(isnull(EQH_ELDue,0)) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(isnull(EQH_ELDue,0)), '1800-12-28',

						 CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV), '1800-12-28', CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 GETDATE()), 0),103))
						 ELSE
						 REPLACE(CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV)), 0),103) , '1900-01-01', CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 GETDATE()), 0),103))
						 END
						 --CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 --GETDATE()), 0),103)
						 )
						 ELSE 
						 REPLACE(CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 DatasetProWat.CONVERTFROMCLARION(isnull(EQH_ELDue,0))), 0),103) , '1900-01-01', 
						 CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV) = '1800-12-28' 
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV), '1800-12-28', CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 GETDATE()), 0),103))
						 ELSE
						 REPLACE(CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 DatasetProWat.CONVERTFROMCLARION(EQH_DUE_INV)), 0),103) , '1900-01-01', CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0,
						 GETDATE()), 0),103))
						 END) 
						 END																				AS ENV_NEXT_INVOICE_DATE, 
						 
						 NULL																				AS ENV_NEXT_PERIOD_FROM, 

						 ''																					AS OTHER1_TYPE, 
						 ''																					AS OTHER1_SUBTYPE, 
						 ''																					AS OTHER1_UNIT, 
                         0																					AS OTHER1_PRICE_PER_UNIT, 
						 0																					AS OTHER1_INVOICE_FREQ, 
						 0																					AS OTHER1_INVOICE_QTY, 
						 NULL																				AS OTHER1_NEXT_INVOICE_DATE, 
						 NULL																				AS OTHER1_NEXT_PERIOD_FROM, 
						 ''																					AS OTHER2_TYPE, 
						 ''																					AS OTHER2_SUBTYPE,
                         ''																					AS OTHER2_UNIT, 
						 0																					AS OTHER2_PRICE_PER_UNIT, 
						 0																					AS OTHER2_INVOICE_FREQ, 
						 0																					AS OTHER2_INVOICE_QTY, 
						 NULL																				AS OTHER2_NEXT_INVOICE_DATE, 
						 NULL																				AS OTHER2_NEXT_PERIOD_FROM,
						  
                         0																				    AS HASADDITIONALDATA, -- No package data TBC
						 
						 CASE WHEN slp_days IS NULL 
						 THEN 3 
						 ELSE slp_days 
						 END																				AS SLA_EXC,
						 
						 CASE WHEN slp_days IS NULL 
                         THEN 3 
						 ELSE slp_days 
						 END																				AS SLA_SWP,
						 
						 CASE WHEN slp_days IS NULL 
						 THEN 3 ELSE slp_days 
						 END																				AS SLA_SER,
						 
						 CASE WHEN slp_days IS NULL 
						 THEN 3 
						 ELSE slp_days 
						 END																				AS SLA_TER,
						 
                         CASE WHEN slp_days IS NULL 
						 THEN 3 
						 ELSE slp_days 
						 END																				AS SLA_CMA, 
						 
						 CASE WHEN slp_days IS NULL 
						 THEN 3 
						 ELSE slp_days 
						 END																				AS SLA_DEL, 
						 
						 ''																					AS CURRENT_CONTRACT, -- This will be always empty for GBASP 
						 ''																					AS CURRENT_CONTRACT_NUMBER, 
                         CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_Start_Date) = '1800-12-28'
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(EQH_Start_Date), '1800-12-28', '') 
                         ELSE ISNULL(DatasetProWat.CONVERTFROMCLARION(EQH_Start_Date),'')
						 END																				AS CURRENT_START_DATE, 
						 ''																					AS ORIGINAL_CONTRACT_NUMBER, 
						 ''																					AS ORIGINAL_END_DATE, 
						 ''																					AS ORIGINAL_START_DATE,
						 

						 --CASE WHEN CONVERT(varchar, ISNULL(EQH_Contract_Pd1,0)) = '0' THEN ''
						 --ELSE
						 --CASE WHEN 
						 --DATEDIFF(MONTH,DatasetProWat.CONVERTFROMCLARION(EQH_Start_Date)
						 --,DatasetProWat.CONVERTFROMCLARION(EQH_Expiry_Date)) = 0 THEN REPLACE(DATEDIFF(MONTH,DatasetProWat.CONVERTFROMCLARION(EQH_Start_Date)
						 --,DatasetProWat.CONVERTFROMCLARION(EQH_Expiry_Date)),0,'')
						 --ELSE 
						--CONVERT(varchar, DATEDIFF(MONTH,DatasetProWat.CONVERTFROMCLARION(EQH_Start_Date)
						 --,DatasetProWat.CONVERTFROMCLARION(EQH_Expiry_Date)))
						 --END


						 --END																				
						 CASE   WHEN CONVERT(varchar, ISNULL(EQH_Contract_Pd1,0)) = '0' THEN '12'									--09/11/2021 Ryfe Commented the above and added the below rules for contract term email dated 6/11/2021
								WHEN EQH_Span = 'Y' THEN
											CASE	WHEN EQH_Contract_Pd1 * 12 <= 12 THEN '12'
													WHEN 12 < EQH_Contract_Pd1 * 12 AND EQH_Contract_Pd1 * 12 <= 24 THEN '24'
													WHEN 24 < EQH_Contract_Pd1 * 12 AND EQH_Contract_Pd1 * 12 <= 36 THEN '36'
													WHEN 36 < EQH_Contract_Pd1 * 12 AND EQH_Contract_Pd1 * 12 <= 48 THEN '48'
													WHEN 48 < EQH_Contract_Pd1 * 12 AND EQH_Contract_Pd1 * 12 <= 60 THEN '60'
													WHEN 60 < EQH_Contract_Pd1 * 12 AND EQH_Contract_Pd1 * 12 <= 72 THEN '72'
													WHEN 72 < EQH_Contract_Pd1 * 12 AND EQH_Contract_Pd1 * 12 <= 84 THEN '84'
													WHEN 84 < EQH_Contract_Pd1 * 12 THEN '96'
											END
								WHEN EQH_Span = 'M' THEN
											CASE	WHEN EQH_Contract_Pd1 <= 12 THEN '12'
													WHEN 12 < EQH_Contract_Pd1  AND EQH_Contract_Pd1 <= 24 THEN '24'
													WHEN 24 < EQH_Contract_Pd1  AND EQH_Contract_Pd1 <= 36 THEN '36'
													WHEN 36 < EQH_Contract_Pd1  AND EQH_Contract_Pd1 <= 48 THEN '48'
													WHEN 48 < EQH_Contract_Pd1  AND EQH_Contract_Pd1 <= 60 THEN '60'
													WHEN 60 < EQH_Contract_Pd1  AND EQH_Contract_Pd1 <= 72 THEN '72'
													WHEN 72 < EQH_Contract_Pd1  AND EQH_Contract_Pd1 <= 84 THEN '84'
													WHEN 84 < EQH_Contract_Pd1  THEN '96'
											END
								WHEN EQH_Span = 'W' THEN
											CASE	WHEN EQH_Contract_Pd1 * 12/52 <= 12 THEN '12'
													WHEN 12 < EQH_Contract_Pd1 * 12/52 AND EQH_Contract_Pd1 * 12/52 <= 24 THEN '24'
													WHEN 24 < EQH_Contract_Pd1 * 12/52 AND EQH_Contract_Pd1 * 12/52 <= 36 THEN '36'
													WHEN 36 < EQH_Contract_Pd1 * 12/52 AND EQH_Contract_Pd1 * 12/52 <= 48 THEN '48'
													WHEN 48 < EQH_Contract_Pd1 * 12/52 AND EQH_Contract_Pd1 * 12/52 <= 60 THEN '60'
													WHEN 60 < EQH_Contract_Pd1 * 12/52 AND EQH_Contract_Pd1 * 12/52 <= 72 THEN '72'
													WHEN 72 < EQH_Contract_Pd1 * 12/52 AND EQH_Contract_Pd1 * 12/52 <= 84 THEN '84'
													WHEN 84 < EQH_Contract_Pd1 * 12/52 THEN '96'
											END
							ELSE '12'
							END																				AS CONTRACT_TERM,

						 CASE WHEN ISNULL(EQH_PRSchemeID,0) = 0												
						 THEN NULL
						 WHEN ISNULL(EQH_PRSchemeID,0) = 5
						 THEN NULL
						 WHEN EQH_PRSchemeID = 1 AND  DATEADD(month, DATEDIFF(month, 0,DatasetProWat.CONVERTFROMCLARION(EQH_Expiry_Date)), 0) > GETDate()	--30/11/2021 RYFE Take expiry date when reval type is genuinely 1
						 THEN CASE WHEN  ISNULL(EQH_Expiry_Date,0) = 0 THEN NULL
						      ELSE DATEADD(month, DATEDIFF(month, 0,DatasetProWat.CONVERTFROMCLARION(EQH_Expiry_Date)), 0)
							  END
						
						 ELSE																			



						 CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate) = '1800-12-28'
						 THEN REPLACE(DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate), '1800-12-28', NULL) 
                         ELSE 
						 CASE WHEN DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate) < getDate()
						      THEN CASE WHEN 
							  dateadd(year, (2021 - year( DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate))), 
							  DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate)) < getDate()
							  THEN DATEADD(month, DATEDIFF(month, 0,dateadd(year, (2022 - year( DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate))), 
							  DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate))), 0)
							  ELSE DATEADD(month, DATEDIFF(month, 0,dateadd(year, (2021 - year( DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate))), 
							  DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate))), 0)
							  END
						 ELSE
						      DATEADD(month, DATEDIFF(month, 0,DatasetProWat.CONVERTFROMCLARION(EQH_PRDueDate)), 0)
							 
					     END

						 END
						 END																				AS FIRST_REVALUATION_DATE,

						 CASE WHEN ISNULL(EQH_PRSchemeID,0) = 0												
						 THEN NULL
						 WHEN ISNULL(EQH_PRSchemeID,0) = 5
						 THEN NULL
						 ELSE 
							CASE WHEN EQH_PRSchemeID != 1 AND ISNULL(EQH_Expiry_Date,0) != 0
								 THEN CASE WHEN DATEADD(month, DATEDIFF(month, 0,DatasetProWat.CONVERTFROMCLARION(EQH_Expiry_Date)), 0) < GETDate()
											THEN 1
									  END
								 ELSE
								 EQH_PRSchemeID
								 END
						 END																				AS REVALUATION_TYPE,
						 'CUSTOMER_LEVEL'																	AS PO_SCHEMA,
						 ''																					AS COMMENT
						 
						 
     
 from 
(SELECT DISTINCT
-----------------------------------------------TOTALCARE----------------------------------------------------------
 case when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	                     --  	         	        	                	        

	-- and isnull(eqh_pwfreq,0) = 0 --RS i believe we do not wish to have this in the rules anymore, or do we want it still in -- 07/10/2021 Ryfe added isnull
	   and isnull(eqh_i_freq,0) > 0
	   and (isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0)) > 0
	   and isnull(eqh_frequency,0) > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   and ISNULL(EQH_M_FREQ,0) = 0								-- 07/10/2021 Ryfe added isnull
then 'MIF - Totalcare only'
-----------------------------------------------------------newest contract addition-----------------------------------------------
   when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	 --and isnull(eqh_pwfreq,0) = 0 --RS i believe we do not wish to have this in the rules anymore, or do we want it still in -- 07/10/2021 Ryfe added isnull
	   and isnull(eqh_i_freq,0) > 0
	   --and (eqh_rental_amnt) > 0
	   and isnull(eqh_frequency,0) > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   and ISNULL(EQH_M_FREQ,0) > 0					-- 07/10/2021 Ryfe added isnull
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,isnull(st_mnt.sto_price,0))> 0
	   --and cmp_name like 'OFFICE BEVERAGES'  --RISM		   27-10-2021   Removed the Office Beverages competitor validation from contract type 7
then 'MIF - Rental Only Recurring Sani/Service'


------------------------------------------RENTAL ONLY NON MIF--------------------INV LINE ONLY---------------------------------
when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks' ,'Management Fee')
	 --and isnull(eqh_pwfreq,0) = 0				-- 07/10/2021 Ryfe added isnull
	   and isnull(eqh_i_freq,0) * isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0) > 0 --O8/11/2021 RISM below query catered for as freq X price
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0 --Add this part bact in ? According to decision 08/11/2021
	   and isnull(eqh_frequency,0) = 0
	 --and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	 --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	 --and isnull(eqh_filter_Freq,0) = 0     -- 07/10/2021 Ryfe added isnull
	   and isnull(EQH_M_FREQ,0) = 0			-- 07/10/2021 Ryfe added isnull
then 'Non MIF Rental Only'

------------------------------------RENTAL ONLY MIF SANI BY ACTIVITY RO/SOOE--------------------------------------------------
when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	 --and isnull(eqh_pwfreq,0) = 0			-- 07/10/2021 Ryfe added isnull
	   and isnull(eqh_i_freq,0) > 0
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and isnull(eqh_frequency,0) > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) > 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and isnull(EQH_M_FREQ,0) = 0				-- 07/10/2021 Ryfe added isnull
then 'MIF - Rental Only'

-----------------------------------RENTAL ONLY MIF FUBAR----------------------------------------------------------
when eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	   --AND isnull(eqh_i_freq,0) = 0  RISM 05/11/21 AJ REQUEST THIS IS TO BE REMOVED FROM VALIDATION
	   AND isnull(eqh_i_freq,0) * (isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0)) = 0  --RISM 05-11-2021 Line above removed in isolation and added to freq * price = 0
	   AND isnull(eqh_frequency,0) * isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) = 0 --RISM 05-11-2021 freq * price
	   AND isnull(EQH_M_FREQ,0) * isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN isnull(EQH_MaintPrice,0) ELSE PBM.PRI_Price END,isnull(st_mnt.sto_price,0)) = 0 --RISM 05-11-2021 freq * price
then 'FUBAR'
---------------------------------------------SOLD NON MIF---------------------------------------------------------

when eqh_status_flag = 'S' 
       AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks' ,'Management Fee')
	 --and isnull(eqh_pwfreq,0) = 0			-- 07/10/2021 Ryfe added isnull
	   --and isnull(eqh_i_freq,0) = 0
	   and isnull(eqh_i_freq,0) * isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0) > 0 --O8/11/2021 RISM Non Mif checked as freq X price. Do not pull if doesnt generate revenue
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and isnull(eqh_frequency,0) = 0
	  -- and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN EQH_SaniPrice ELSE PB.PRI_Price END,st_san.sto_price) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	 --and isnull(eqh_filter_Freq,0) = 0		-- 07/10/2021 Ryfe added isnull
	   and isnull(EQH_M_FREQ,0) = 0				-- 07/10/2021 Ryfe added isnull
then 'Sold Non MIF'

------------------------------------------MAINTENANCE ONLY SIF GOLD---------------------------------------------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	 --and isnull(eqh_pwfreq,0) = 0				-- 07/10/2021 Ryfe added isnull
	   --and eqh_i_freq = 0  --DO WE NEED AN INVOICE FREQ FOR THE MAINTENANCE TO GENERATE???
	   and (isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0)) = 0
	   and isnull(eqh_frequency,0) > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and isnull(EQH_M_FREQ,0) > 0			-- 07/10/2021 Ryfe added isnull
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN ISNULL(EQH_MaintPrice,0) ELSE PBM.PRI_Price END,isnull(st_mnt.sto_price,0))> 0 --01/12/2021 Ryfe added isnull to EQH_MaintPrice
	   and EQH_M_Stock_Code not in ('FIX_SILVER','GEN_BLSILV','GENSILV1ST','SILV_PLUS1','SILV_PLUS3','SILV_PLUS5','SILV_SOFT1','SILV_SOFT3','SILV_SOFT5','SILVER')											--Added RYFE 07/07/2021
then 'Maintenance Only SIF'

------------------------------------------MAINTENANCE ONLY SIF SILVER---------------------------------------------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	 --and isnull(eqh_pwfreq,0) = 0				-- 07/10/2021 Ryfe added isnull
	   --and eqh_i_freq = 0  --DO WE NEED AN INVOICE FREQ FOR THE MAINTENANCE TO GENERATE???
	   and (isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0)) = 0
	   and isnull(eqh_frequency,0) > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) = 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and isnull(EQH_M_FREQ,0) > 0				-- 07/10/2021 Ryfe added isnull
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN isnull(EQH_MaintPrice,0) ELSE PBM.PRI_Price END,isnull(st_mnt.sto_price,0))> 0
--and EQH_M_Stock_Code  like ('SILV%')											--Added RYFE 07/07/2021
and EQH_M_Stock_Code in ('FIX_SILVER','GEN_BLSILV','GENSILV1ST','SILV_PLUS1','SILV_PLUS3','SILV_PLUS5','SILV_SOFT1','SILV_SOFT3','SILV_SOFT5','SILVER')

then 'Maintenance Only SIF-SILVER'
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	 --and isnull(eqh_pwfreq,0) = 0			-- 07/10/2021 Ryfe added isnull
	   and isnull(eqh_i_freq,0) = 0					-- 07/10/2021 Ryfe added isnull
	   --and (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0
	   and eqh_frequency > 0
	   and isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) > 0
	   --and isnull(CASE WHEN EQH_UseFilterPrice = 1 THEN EQH_FilterPrice ELSE PBF.PRI_Price END,st_fil.sto_price) = 0
	   --and eqh_filter_Freq = 0
	   and isnull(EQH_M_FREQ,0) = 0					-- 07/10/2021 Ryfe added isnull
	   and isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,isnull(st_mnt.sto_price,0))= 0
then 'Sani Only SIF'
-----------------------------------SOLD MIF FUBAR----------------------------------------------------------
when eqh_status_flag = 'S' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
	-- AND isnull(EQH_M_FREQ,0) = 0
	   AND isnull(eqh_i_freq,0) * (isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0)) = 0 --RISM 05-11-2021 freq * price
	   AND isnull(eqh_frequency,0) * isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) = 0 --RISM 05-11-2021 freq * price
	   AND isnull(EQH_M_FREQ,0) * isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN isnull(EQH_MaintPrice,0) ELSE PBM.PRI_Price END,isnull(st_mnt.sto_price,0)) = 0 --RISM 05-11-2021 freq * price
	   AND isnull(cmp_name,'') NOT LIKE ('%BILLI%') 
then 'FUBAR'
-------------------------------------------------------------------------------------------------------------
/*when eqh_status_flag = 'S'
AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks' ,'Management Fee', 'Vending m/c')
then 'SIF Non MIF'*/																			--05/11/21 RISM Removed as per query above. Should be captured as Sold Non Mif

WHEN ET.ety_name in ( '(None)' )
then 'QUERY EQUIPMENT TYPES'

WHEN C.CUS_TYPE LIKE '%TRIAL%' 
THEN 'TRIAL'

end
 as MATRIX_TYPE

 ,case when  eqh_status_flag = 'R'
  AND ET.ety_name IN ('Recycling Scheme','Ancilliaries & Racks','Management Fee')
  then 'Non MIF' 
  when eqh_status_flag = 'S'
  and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
  then 'SIF'

  when eqh_status_flag = 'R'
  and ET.ety_name IN  ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c')
  then 'MIF'

  end 
  as Category
  -----------------------------------these repeat below as they are in the correct sections but have added here to check the matrix rules-----------
  , eqh_status_flag as 'R/S'
  , isnull(eqh_pwfreq,0) AS PIPEWORK_FREQ
  , isnull(eqh_i_freq,0) as Rental_Frequency_inv
  ,(isnull(eqh_rental_amnt,0)+isnull(eqh_c_value,0)+isnull(eqh_sani_amnt,0)) as Rental_Price				--Added c_value and sani amnt as a fix
  , isnull(eqh_frequency,0) as sani_freq
  ,isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,isnull(st_san.sto_price,0)) AS FINALSANIPRICE
  , isnull(EQH_M_FREQ,0) AS MAINT_FREQ
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
--------------------------------------------SANI---------------------------------------------
, EQH_UseSaniPrice
, eqh_saniprice as sani_price
, PB.PRI_STOCK_CODE AS SANIPRICEBOOKSTOCKCODE
, PB.PRI_Price AS SANITISE_PRICE
, st_san.sto_price as sanistock_price
, eqh_frequency as sani_frequency
, concat(eqh_frequency,eqh_s_span) as Sani_Span
,isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,st_san.sto_price) AS FINAL_SANI_PRICE
,CASE WHEN eqh_frequency >0 AND isnull(CASE WHEN EQH_UseSaniPrice = 1 THEN isnull(EQH_SaniPrice,0) ELSE PB.PRI_Price END,st_san.sto_price) > 0 
       AND ET.ety_name IN  ('POU Cooler', 'Bottle Cooler', 'Water Heater','Hospitality','HAND SANITISER','Cerise','Taps', 'Purezza','Bottle Filling Stati','Coffee m/c', 'Filter System', 'Hand Wash Station', 'Vending m/c') THEN 'SOOE' END AS SOOE
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
, isnull(EQH_M_FREQ,0) AS MAINTenance_FREQuency
, EQH_MAINTPRICE AS MAINT_PRICE
,PBM.PRI_PRICE AS MAINT_PRICE_BOOK_PRICE
, ST_MNT.STO_PRICE AS MAINTSTOCK_PRICE
,concat(EQH_M_FREQ,EQH_M_Span) as Maint_Span
,isnull(CASE WHEN EQH_UseMaintPrice = 1 THEN EQH_MaintPrice ELSE PBM.PRI_Price END,st_mnt.sto_price) AS FINAL_MAINT_PRICE
--------------------------------------------ELEVY--------------------------------------------
, EQH_UseELPrice
, EQH_ELFREQ AS ELEVY_FREQ
, EQH_Elprice as ELEVY_PRICE
--,isnull(CASE WHEN EQH_UseELPrice = 1 THEN EQH_Elprice ELSE PBE.PRI_Price END,0) AS FINAL_ELEVY_PRICE                             --RISM 14-06-21 OLD RULE
,case when eq.eqh_elspan = 'Y' then 
				ISNULL(CASE WHEN EQH_UseELPrice = 1 THEN isnull(EQH_Elprice,0) ELSE PBE.PRI_Price END,ST_EL.STO_PRICE)	   -- RYFE 15/06/2021 Removed devide by 12 since it is catered in the preprocessor	
	  when eq.eqh_elspan = 'M' then																						   -- RISM 25/11/2021 ADDED ISNULL TO THE USE ELPRICE SECTION
				ISNULL(CASE WHEN EQH_UseELPrice = 1 THEN isnull(EQH_Elprice,0) ELSE PBE.PRI_Price END,ST_EL.STO_PRICE)     -- RISM 25/11/2021 ADDED ISNULL TO THE USE ELPRICE SECTION
	  ELSE 0 END																					 AS FINAL_ELEVY_PRICE         --RISM 14-06-2021 NEW RULE TO CATER FOR MONTHLY PRICE EQUIVALENT
																																  --RISM 27/10/2021 ADDED STOCK TABLE LINK TO GET STOCK PRICE WHERE NOT IN PRICEBOOK
,EQ.EQH_ELDue
, EQ.EQH_DUE_INV
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
,acq.cmp_name
,EQ.EQH_Span
from      DatasetProWat.Syn_EquipHdr_ex EQ
	 join DatasetProWat.Syn_Customer_ex C          on C.CUS_ACCOUNT = EQ.EQH_ACCOUNT
	 left join DatasetProWat.Syn_Competit_ex acq   on acq.cmp_id = c.cus_acqfrom
	 join DatasetProWat.Syn_Stock_ex  ST         on st.sto_stock_code = eq.eqh_stock_code
	 join DatasetProWat.Syn_EQTYPE_ex ET         on et.ety_id = st.sto_eqtype

LEFT JOIN DatasetProWat.Syn_Stock_ex  ST_SAN     ON  ST_SAN.STO_STOCKID = ST.STO_EQSANITYPE
LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PB      ON ST_SAN.STO_STOCK_CODE = PB.PRI_Stock_Code  AND CASE WHEN isnull(cus_pricebookac,0) = 0 THEN cus_account ELSE cus_pricebookac END = PB.PRI_Account --RISM 26-11-2021 ADDED ISNULL TO CUS_PRICEBOOKAC
													
LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PBF     ON EQ.EQH_F_Stock_Code = PBF.PRI_Stock_Code  AND CASE WHEN isnull(cus_pricebookac,0) = 0 THEN cus_account ELSE cus_pricebookac END = PBF.PRI_Account --RISM 26-11-2021 ADDED ISNULL TO CUS_PRICEBOOKAC
LEFT JOIN DatasetProWat.Syn_Stock_ex  ST_FIL     ON  ST_FIL.STO_STOCK_CODE = EQ.EQH_F_Stock_Code
						
LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PBM     ON EQ.EQH_M_Stock_Code = PBM.PRI_Stock_Code  AND CASE WHEN isnull(cus_pricebookac,0) = 0 THEN cus_account ELSE cus_pricebookac END = PBM.PRI_Account --RISM 26-11-2021 ADDED ISNULL TO CUS_PRICEBOOKAC
LEFT JOIN DatasetProWat.Syn_Stock_ex  ST_MNT     ON  ST_MNT.STO_STOCK_CODE = EQ.EQH_M_Stock_Code

LEFT JOIN DatasetProWat.Syn_PriceBk_ex  AS PBE     ON PBE.PRI_Stock_Code = case when eqh_elspan = 'M' then 'ELMONTH' WHEN EQH_ELSPAN = 'Y' THEN 'ELANNUAL' ELSE 'ENV_LVY' END  --RISM 14-06-2021 CHANGED LINK AS LEVY CODES ARE HARDCODED IN PROWAT
													AND CASE WHEN isnull(cus_pricebookac,0) = 0 THEN cus_account ELSE cus_pricebookac END = PBE.PRI_Account					   --RISM 26-11-2021 ADDED ISNULL TO CUS_PRICEBOOKAC
LEFT JOIN DatasetProWat.Syn_Stock_ex ST_EL       ON ST_EL.STO_STOCK_CODE = case when eqh_elspan = 'M' then 'ELMONTH' WHEN EQH_ELSPAN = 'Y' THEN 'ELANNUAL' ELSE 'ENV_LVY' END  --RISM 27-10-2021 ADDED STOCK TABLE LINK TO GET STOCK PRICE WHERE NOT IN PRICEBOOK  

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
FROM DatasetProWat.Syn_Customer_ex)C
WHERE CUS_TYPE NOT LIKE 'CANC%' AND CUS_TYPE NOT LIKE 'STOCK'
--AND CUS_ACCOUNT = 1111986

and
CONCAT(
 C.VALID_DEFAULT_PO, 
 C.VALID_RENTAL_PO,
 C.VALID_SANI_PO,
 C.VALID_ELEVY_PO) NOT LIKE '0000')V)P ON P.CUSTOMER_ID = C.CUS_ACCOUNT
  
  
  
  
  
  
  )A

 LEFT OUTER JOIN Dataset.SerialObject_Filter_Override  ON 'GBASP' = Dataset.SerialObject_Filter_Override.MIG_SITE_NAME AND A.EQH_IDNo = Dataset.SerialObject_Filter_Override.MCH_CODE
 LEFT JOIN Dataset.Customer_Filter_Override ON Dataset.Customer_Filter_Override.MIG_SITE_NAME = 'GBASP' AND Dataset.Customer_Filter_Override.CUSTOMER_ID = A.CUS_Account

  WHERE 
  --CUS_TYPE NOT LIKE ('STOCK%')
  --AND CUS_TYPE NOT LIKE ('CANC%')
  --AND CUS_Company NOT LIKE ('ZZZ%')
  --AND 
  ety_name NOT LIKE 'PEDAL'
  AND A.product_type NOT LIKE 'Management Fee' 
  --and matrix_type like 'Sani only SIF'
  --AND MATRIX_TYPE LIKE 'NEW CONTRACT'

  AND 
  (Dataset.Filter_SerialObject('GBASP', 'ex', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), '', ISNULL(A.CUS_Type, '{NULL}'), Dataset.Filter_Customer('GBASP', 'ex', 
                         ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), A.CUS_Account, 
                         LEFT(TRIM(A.CUS_Company), 100), ISNULL(A.CUS_Type, '{NULL}'))) > 0)


  END



GO
