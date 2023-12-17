if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPAYMENTS_TRANSACTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPAYMENTS_TRANSACTIONS_Update;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 07/26/2015 Paul.  The CVV2 value should not be stored once the transaction has been processed. 
Create Procedure dbo.spPAYMENTS_TRANSACTIONS_Update
	( @ID                   uniqueidentifier
	, @MODIFIED_USER_ID     uniqueidentifier
	, @STATUS               nvarchar(25)
	, @TRANSACTION_NUMBER   nvarchar(50)
	, @REFERENCE_NUMBER     nvarchar(50)
	, @AUTHORIZATION_CODE   nvarchar(50)
	, @AVS_CODE             nvarchar(250)
	, @ERROR_CODE           nvarchar(20)
	, @ERROR_MESSAGE        nvarchar(max)
	)
as
  begin
	set nocount on

	declare @INVOICE_ID uniqueidentifier;
	declare @CREDIT_CARD_ID uniqueidentifier;
	-- 08/26/2010 Paul.  Don't need to declare @PAYMENT_ID. 
	--declare @PAYMENT_ID uniqueidentifier;

	declare invoice_cursor cursor for
	select distinct INVOICE_ID
	  from      PAYMENTS_TRANSACTIONS
	 inner join vwPAYMENTS_INVOICES
	         on vwPAYMENTS_INVOICES.PAYMENT_ID = PAYMENTS_TRANSACTIONS.PAYMENT_ID
	 where PAYMENTS_TRANSACTIONS.ID = @ID;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	update PAYMENTS_TRANSACTIONS
	   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
	     , DATE_MODIFIED        =  getdate()           
	     , DATE_MODIFIED_UTC    =  getutcdate()        
	     , STATUS               = @STATUS              
	     , TRANSACTION_NUMBER   = @TRANSACTION_NUMBER  
	     , REFERENCE_NUMBER     = @REFERENCE_NUMBER    
	     , AUTHORIZATION_CODE   = @AUTHORIZATION_CODE  
	     , AVS_CODE             = @AVS_CODE            
	     , ERROR_CODE           = @ERROR_CODE          
	     , ERROR_MESSAGE        = @ERROR_MESSAGE       
	 where ID                   = @ID                  ;

	-- 04/23/2008 Paul.  Update the Invoice Amount Due value to account for this payment. 
	-- 07/26/2009 Paul.  We are noticing a problem with STATUS not being returned by PayPal. 
	-- The temporary solution is to check the status or the AVS_CODE. 
	if exists(select * from PAYMENTS_TRANSACTIONS where ID = @ID and TRANSACTION_TYPE = N'Sale' and (STATUS = N'Success' or (STATUS is null and AVS_CODE is not null))) begin -- then
		open invoice_cursor;
		fetch next from invoice_cursor into @INVOICE_ID;
		while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
			exec dbo.spINVOICES_UpdateAmountDue @INVOICE_ID, @MODIFIED_USER_ID;
			fetch next from invoice_cursor into @INVOICE_ID;
		end -- while;
		close invoice_cursor;
	end -- if;
	deallocate invoice_cursor;

	-- 07/26/2015 Paul.  The CVV2 value should not be stored once the transaction has been processed. 
	select @CREDIT_CARD_ID = @CREDIT_CARD_ID
	  from PAYMENTS_TRANSACTIONS
	 where ID = @ID;

	if @CREDIT_CARD_ID is not null begin -- then
		if exists(select * from CREDIT_CARDS where ID = @CREDIT_CARD_ID and SECURITY_CODE is not null) begin -- then
			update CREDIT_CARDS
			   set SECURITY_CODE        = null
			     , MODIFIED_USER_ID     = @MODIFIED_USER_ID    
			     , DATE_MODIFIED        =  getdate()           
			     , DATE_MODIFIED_UTC    =  getutcdate()        
			 where ID                   = @CREDIT_CARD_ID;
			-- 07/26/2015 Paul.  We also want to clear the AUDIT table so that there is no record of the security code. 
			-- 07/26/2015 Paul.  Delay the clearing until testing is complete. 
			/*
			update CREDIT_CARDS_AUDIT
			   set SECURITY_CODE        = null
			     , DATE_MODIFIED_UTC    =  getutcdate()        
			 where ID                   = @CREDIT_CARD_ID
			   and SECURITY_CODE is not null;
			*/
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spPAYMENTS_TRANSACTIONS_Update to public;
GO

