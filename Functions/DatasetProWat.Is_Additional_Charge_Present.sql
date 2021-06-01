SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		RYFE
-- Create date: 2021-04-15
-- Description:	Check if additional charge is present in Prowat
-- RYFE 2021/04/15 Created
-- =============================================

CREATE FUNCTION [DatasetProWat].[Is_Additional_Charge_Present]
(
	-- Add the parameters for the function here
	@EqhId nvarchar(200)
)
RETURNS bit

AS
BEGIN

	DECLARE @Found bit = 0
		
	SELECT @Found = 1
				FROM     DatasetProWat.Syn_EquipHdr_dc EQ
				JOIN     DatasetProWat.Syn_Customer_dc  C on C.CUS_ACCOUNT = EQ.EQH_ACCOUNT
			    JOIN     DatasetProWat.Syn_Stock_dc  ST   on st.sto_stock_code = eq.eqh_stock_code
				JOIN     DatasetProWat.Syn_EQType_dc ET   on et.ety_id = st.sto_eqtype
    WHERE eqh_status_flag = 'R' 
       AND ET.ety_name IN ('POU Cooler', 'Bottle Cooler','Water Heater','Hospitality','Vending m/c','Cerise','Taps','Purezza','Bottle Filling Stati','Coffee m/c')
	   and eqh_i_freq > 0
	   and eqh_rental_amnt > 0
	   AND eqh_c_value > 0
	   AND CUS_TYPE NOT IN ('STOCK')
	   and trim(eqh_id) = @EqhId ;

	RETURN @Found  

END

GO
