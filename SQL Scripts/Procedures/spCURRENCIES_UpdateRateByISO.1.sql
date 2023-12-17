if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCURRENCIES_UpdateRateByISO' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCURRENCIES_UpdateRateByISO;
GO


/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 *********************************************************************************************************************/
Create Procedure dbo.spCURRENCIES_UpdateRateByISO
	( @MODIFIED_USER_ID       uniqueidentifier
	, @ISO4217                nvarchar(3)
	, @CONVERSION_RATE        float(53)
	, @SYSTEM_CURRENCY_LOG_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	if exists(select * from CURRENCIES where DELETED = 0 and ISO4217 = @ISO4217 and CONVERSION_RATE <> @CONVERSION_RATE) begin -- then
		update CURRENCIES
		   set MODIFIED_USER_ID       = @MODIFIED_USER_ID      
		     , DATE_MODIFIED          =  getdate()             
		     , DATE_MODIFIED_UTC      =  getutcdate()          
		     , CONVERSION_RATE        = @CONVERSION_RATE       
		     , SYSTEM_CURRENCY_LOG_ID = @SYSTEM_CURRENCY_LOG_ID
		 where ISO4217                = @ISO4217               ;
	end -- if;
  end
GO

Grant Execute on dbo.spCURRENCIES_UpdateRateByISO to public;
GO

