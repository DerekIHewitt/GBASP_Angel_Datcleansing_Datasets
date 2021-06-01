SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[ShowOrderStatus] (
	@OrdStatus	varchar(5),	-- OPEN COMP etc	
	@InvFlag	int) 		-- 0 - 3
RETURNS
	varchar(12)			
with execute as owner
BEGIN
DECLARE @sResult	varchar(12)

-- Initialise variables as will be NULL on declare
SET @sResult = ''

if @OrdStatus = 'COMP' and @InvFlag = 0 SET @sResult = 'Cancelled' 
if @OrdStatus <> 'COMP' and @InvFlag = 0 SET @sResult = 'New' 
if @InvFlag = 1 SET @sResult = 'Despatched' 
if @InvFlag = 2 SET @sResult = 'Confirmed' 
if @InvFlag = 3 SET @sResult = 'Invoiced' 

RETURN(@sResult)
END
GO
