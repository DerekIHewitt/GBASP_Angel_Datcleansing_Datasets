SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =========================================================
-- Author:		ARG
-- Create date: 2020-02-19
-- Description:	Assign a role to a freetext field passed in
-- =========================================================

CREATE FUNCTION [Dataset].[AssignRoleToContact]
(@CUS_Field nvarchar(200))
RETURNS varchar(20)
 
BEGIN
	DECLARE @Role varchar(20)

	IF TRIM(@CUS_Field) = 'Buyer' SET @Role = 'BUYER'
	ELSE IF TRIM(@CUS_Field) = 'Location Manager' SET @Role = 'LOC MAN'	
	ELSE IF TRIM(@CUS_Field) = 'Accounts Payable' SET @Role = 'ACC PAY'	
	ELSE IF TRIM(@CUS_Field) LIKE '%Account%Pay%' SET @Role = 'ACC PAY'
	ELSE IF TRIM(@CUS_Field) = 'Business Owner' SET @Role = 'BUS OWN'	
	ELSE IF TRIM(@CUS_Field) = 'Director' SET @Role = 'DIRECTOR'	
	ELSE IF TRIM(@CUS_Field) = 'Manager' SET @Role = 'MANAGER'	
	ELSE IF TRIM(@CUS_Field) LIKE '%Manager%' SET @Role = 'MANAGER'	
	ELSE IF TRIM(@CUS_Field) LIKE '%Officer%' SET @Role = 'OFF EXEC'	
	ELSE IF TRIM(@CUS_Field) LIKE '%Executive%' SET @Role = 'OFF EXEC'	
	ELSE IF TRIM(@CUS_Field) = 'Officer / Executive' SET @Role = 'OFF EXEC'	
	ELSE IF TRIM(@CUS_Field) = 'Reception / Administration' SET @Role = 'REC ADMIN'
	ELSE IF TRIM(@CUS_Field) LIKE '%Reception%' SET @Role = 'REC ADMIN'
	ELSE IF TRIM(@CUS_Field) LIKE '%Administration%' SET @Role = 'REC ADMIN'
	ELSE IF TRIM(@CUS_Field) LIKE '%Admin%' SET @Role = 'REC ADMIN'
	ELSE IF TRIM(@CUS_Field) = 'Secretary / Personal Assistant' SET @Role = 'SEC PA'
	ELSE IF TRIM(@CUS_Field) LIKE '%Secretary%' SET @Role = 'SEC PA'
	ELSE IF TRIM(@CUS_Field) LIKE '%Personal Assistant%' SET @Role = 'SEC PA'

	RETURN @Role;
END





GO
