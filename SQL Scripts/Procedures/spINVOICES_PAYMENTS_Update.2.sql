if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_PAYMENTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_PAYMENTS_Update;
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
-- 04/23/2008 Paul.  Update the Invoice Amount Due value to account for this payment. 
Create Procedure dbo.spINVOICES_PAYMENTS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @INVOICE_ID           uniqueidentifier
	, @PAYMENT_ID           uniqueidentifier
	, @AMOUNT               money
	)
as
  begin
	set nocount on
	
	-- 06/07/2006 Paul.  Convert currency to USD. 
	declare @EXCHANGE_RATE   float;
	declare @AMOUNT_USDOLLAR money;
	select @EXCHANGE_RATE = EXCHANGE_RATE
	  from PAYMENTS
	 where ID = @PAYMENT_ID;

	if @EXCHANGE_RATE = 0.0 begin -- then
		set @EXCHANGE_RATE = 1.0;
	end -- if;

	-- 03/31/2007 Paul.  The exchange rate is stored in the object. 
	set @AMOUNT_USDOLLAR = @AMOUNT / @EXCHANGE_RATE;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from INVOICES_PAYMENTS
		 where INVOICE_ID        = @INVOICE_ID
		   and PAYMENT_ID        = @PAYMENT_ID
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into INVOICES_PAYMENTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, INVOICE_ID         
			, PAYMENT_ID       
			, AMOUNT           
			, AMOUNT_USDOLLAR  
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @INVOICE_ID         
			, @PAYMENT_ID       
			, @AMOUNT           
			, @AMOUNT_USDOLLAR  
			);
	end else begin
		update INVOICES_PAYMENTS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , AMOUNT            = @AMOUNT           
		     , AMOUNT_USDOLLAR   = @AMOUNT_USDOLLAR  
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		 where ID                = @ID               ;
	end -- if;
	-- 04/23/2008 Paul.  Update the Invoice Amount Due value to account for this payment. 
	exec dbo.spINVOICES_UpdateAmountDue @INVOICE_ID, @MODIFIED_USER_ID;
  end
GO
 
Grant Execute on dbo.spINVOICES_PAYMENTS_Update to public;
GO
 
