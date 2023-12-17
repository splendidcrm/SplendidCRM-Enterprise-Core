if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spORDERS_ConvertQuote' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spORDERS_ConvertQuote;
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
-- 09/19/2010 Paul.  When converting a quote, set the status of the quote to Closed Accepted. 
-- 12/29/2015 Paul.  TEAM_SET_ID should have been included long ago. 
Create Procedure dbo.spORDERS_ConvertQuote
	( @ID               uniqueidentifier output
	, @MODIFIED_USER_ID uniqueidentifier
	, @QUOTE_ID         uniqueidentifier
	, @REPEAT_COMMENT   nvarchar(100) = null
	)
as
  begin
	set nocount on
	
	declare @BILLING_ACCOUNT_ID  uniqueidentifier;
	declare @BILLING_CONTACT_ID  uniqueidentifier;
	declare @SHIPPING_ACCOUNT_ID uniqueidentifier;
	declare @SHIPPING_CONTACT_ID uniqueidentifier;
	declare @LINE_ITEM_ID        uniqueidentifier;
	declare @POSITION            int;
	declare @ORDER_NUM           nvarchar(30);

	if exists(select * from vwQUOTES_ConvertToOrder where QUOTE_ID = @QUOTE_ID) begin -- then
		-- 11/15/2009 Paul.  The ORDER number must be generated. 
		if @ORDER_NUM is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'ORDERS.ORDER_NUM', 1, @ORDER_NUM out;
		end -- if;
		-- 08/15/2007 Paul.  We could use spORDERS_Update to create the ORDER, 
		-- but this approach is faster and avoids currency conversions. 
		set @ID = newid();
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		insert into ORDERS
			( ID                          
			, CREATED_BY                  
			, DATE_ENTERED                
			, MODIFIED_USER_ID            
			, DATE_MODIFIED               
			, ASSIGNED_USER_ID            
			, QUOTE_ID                    
			, ORDER_NUM                   
			, NAME                        
			, PAYMENT_TERMS               
			, ORDER_STAGE                 
			, PURCHASE_ORDER_NUM          
			, DATE_ORDER_DUE              
			, EXCHANGE_RATE               
			, CURRENCY_ID                 
			, TAXRATE_ID                  
			, SHIPPER_ID                  
			, SUBTOTAL                    
			, SUBTOTAL_USDOLLAR           
			, DISCOUNT                    
			, DISCOUNT_USDOLLAR           
			, SHIPPING                    
			, SHIPPING_USDOLLAR           
			, TAX                         
			, TAX_USDOLLAR                
			, TOTAL                       
			, TOTAL_USDOLLAR              
			, BILLING_ADDRESS_STREET      
			, BILLING_ADDRESS_CITY        
			, BILLING_ADDRESS_STATE       
			, BILLING_ADDRESS_POSTALCODE  
			, BILLING_ADDRESS_COUNTRY     
			, SHIPPING_ADDRESS_STREET     
			, SHIPPING_ADDRESS_CITY       
			, SHIPPING_ADDRESS_STATE      
			, SHIPPING_ADDRESS_POSTALCODE 
			, SHIPPING_ADDRESS_COUNTRY    
			, DESCRIPTION                 
			, TEAM_SET_ID                 
			, ASSIGNED_SET_ID             
			)
		select
			  @ID                         
			, @MODIFIED_USER_ID           
			,  getdate()                  
			, @MODIFIED_USER_ID           
			,  getdate()                  
			, ASSIGNED_USER_ID            
			, QUOTE_ID                    
			, @ORDER_NUM                  
			, NAME                        
			, PAYMENT_TERMS               
			, ORDER_STAGE                 
			, PURCHASE_ORDER_NUM          
			, DATE_ORDER_DUE              
			, EXCHANGE_RATE               
			, CURRENCY_ID                 
			, TAXRATE_ID                  
			, SHIPPER_ID                  
			, SUBTOTAL                    
			, SUBTOTAL_USDOLLAR           
			, DISCOUNT                    
			, DISCOUNT_USDOLLAR           
			, SHIPPING                    
			, SHIPPING_USDOLLAR           
			, TAX                         
			, TAX_USDOLLAR                
			, TOTAL                       
			, TOTAL_USDOLLAR              
			, BILLING_ADDRESS_STREET      
			, BILLING_ADDRESS_CITY        
			, BILLING_ADDRESS_STATE       
			, BILLING_ADDRESS_POSTALCODE  
			, BILLING_ADDRESS_COUNTRY     
			, SHIPPING_ADDRESS_STREET     
			, SHIPPING_ADDRESS_CITY       
			, SHIPPING_ADDRESS_STATE      
			, SHIPPING_ADDRESS_POSTALCODE 
			, SHIPPING_ADDRESS_COUNTRY    
			, DESCRIPTION                 
			, TEAM_SET_ID                 
			, ASSIGNED_SET_ID             
		  from vwQUOTES_ConvertToOrder
		 where QUOTE_ID = @QUOTE_ID;

		if not exists(select * from ORDERS_CSTM where ID_C = @ID) begin -- then
			insert into ORDERS_CSTM ( ID_C ) values ( @ID );
		end -- if;
	
		select @BILLING_ACCOUNT_ID  = BILLING_ACCOUNT_ID
		     , @BILLING_CONTACT_ID  = BILLING_CONTACT_ID
		     , @SHIPPING_ACCOUNT_ID = SHIPPING_ACCOUNT_ID
		     , @SHIPPING_CONTACT_ID = SHIPPING_CONTACT_ID
		  from vwQUOTES_ConvertToOrder
		 where QUOTE_ID = @QUOTE_ID;

		if dbo.fnIsEmptyGuid(@BILLING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spORDERS_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @BILLING_ACCOUNT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spORDERS_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_ACCOUNT_ID, N'Ship To';
		end -- if;
		if dbo.fnIsEmptyGuid(@BILLING_CONTACT_ID) = 0 begin -- then
			exec dbo.spORDERS_CONTACTS_Update @MODIFIED_USER_ID, @ID, @BILLING_CONTACT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_CONTACT_ID) = 0 begin -- then
			exec dbo.spORDERS_CONTACTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_CONTACT_ID, N'Ship To';
		end -- if;

		-- 08/15/2007 Paul.  If we were to use spORDERS_LINE_ITEMS_Update, 
		-- we would have to create a cursor, so this approach is much faster. 
		-- 09/27/2008 Paul.  Use a stored procedure to convert line items so that it could be called separately. 

		-- 07/04/2008 Paul.  Move line items to a separate procedure so that it can be used elsewhere when managing the frequency multiplier. 
		-- 07/29/2008 Paul.  The POSITION needs to be managed externally so that it can be incremented for each row and each month. 
		set @LINE_ITEM_ID = null;
		set @POSITION     = 1;
		exec dbo.spORDERS_LINE_ITEMS_ConvertQuote @LINE_ITEM_ID out, @MODIFIED_USER_ID, @QUOTE_ID, @ID, 0, @REPEAT_COMMENT, @POSITION out;

		-- 11/14/2007 Paul.  Update totals after ORDER has been converted. 
		exec dbo.spORDERS_UpdateTotals    @ID, @MODIFIED_USER_ID;

		-- 09/19/2010 Paul.  When converting a quote, set the status of the quote to Closed Accepted. 
		if dbo.fnIsEmptyGuid(@QUOTE_ID) = 0 begin -- then
			-- BEGIN Oracle Exception
				-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
				update QUOTES_CSTM
				   set ID_C             = ID_C
				 where ID_C in
					(select ID
					   from QUOTES
					  where ID               = @QUOTE_ID
					   and DELETED          = 0
					   and QUOTE_STAGE      <> N'Closed Accepted'
					);
				update QUOTES
				   set QUOTE_STAGE      = N'Closed Accepted'
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				     , MODIFIED_USER_ID = @MODIFIED_USER_ID
				 where ID               = @QUOTE_ID
				   and DELETED          = 0
				   and QUOTE_STAGE      <> N'Closed Accepted';
			-- END Oracle Exception
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spORDERS_ConvertQuote to public;
GO
 
