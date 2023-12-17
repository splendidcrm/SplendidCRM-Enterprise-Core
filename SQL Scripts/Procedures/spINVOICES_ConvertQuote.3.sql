if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_ConvertQuote' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_ConvertQuote;
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
-- 04/18/2016 Paul.  TEAM_ID should have been included long ago. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spINVOICES_ConvertQuote
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
	declare @INVOICE_NUM         nvarchar(30);

	if exists(select * from vwQUOTES_ConvertToInvoice where QUOTE_ID = @QUOTE_ID) begin -- then
		if @INVOICE_NUM is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'INVOICES.INVOICE_NUM', 1, @INVOICE_NUM out;
		end -- if;
		set @ID = newid();
		insert into INVOICES
			( ID                          
			, CREATED_BY                  
			, DATE_ENTERED                
			, MODIFIED_USER_ID            
			, DATE_MODIFIED               
			, ASSIGNED_USER_ID            
			, QUOTE_ID                    
--			, ORDER_ID                    
			, OPPORTUNITY_ID              
			, INVOICE_NUM                 
			, NAME                        
			, PAYMENT_TERMS               
			, INVOICE_STAGE               
			, PURCHASE_ORDER_NUM          
			, DUE_DATE                    
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
			, TEAM_ID                     
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
--			, null                        
			, OPPORTUNITY_ID              
			, @INVOICE_NUM                
			, NAME                        
			, PAYMENT_TERMS               
			, N'Due'                      -- INVOICE_STAGE
			, PURCHASE_ORDER_NUM          
			, dbo.fnDateSpecial(N'today') -- DUE_DATE
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
			, TEAM_ID                     
			, TEAM_SET_ID                 
			, ASSIGNED_SET_ID             
		  from vwQUOTES_ConvertToInvoice
		 where QUOTE_ID = @QUOTE_ID;

		if not exists(select * from INVOICES_CSTM where ID_C = @ID) begin -- then
			insert into INVOICES_CSTM ( ID_C ) values ( @ID );
		end -- if;
	
		select @BILLING_ACCOUNT_ID  = BILLING_ACCOUNT_ID
		     , @BILLING_CONTACT_ID  = BILLING_CONTACT_ID
		     , @SHIPPING_ACCOUNT_ID = SHIPPING_ACCOUNT_ID
		     , @SHIPPING_CONTACT_ID = SHIPPING_CONTACT_ID
		  from vwQUOTES_ConvertToInvoice
		 where QUOTE_ID = @QUOTE_ID;

		if dbo.fnIsEmptyGuid(@BILLING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spINVOICES_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @BILLING_ACCOUNT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spINVOICES_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_ACCOUNT_ID, N'Ship To';
		end -- if;
		if dbo.fnIsEmptyGuid(@BILLING_CONTACT_ID) = 0 begin -- then
			exec dbo.spINVOICES_CONTACTS_Update @MODIFIED_USER_ID, @ID, @BILLING_CONTACT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_CONTACT_ID) = 0 begin -- then
			exec dbo.spINVOICES_CONTACTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_CONTACT_ID, N'Ship To';
		end -- if;

		set @LINE_ITEM_ID = null;
		set @POSITION     = 1;
		exec dbo.spINVOICES_LINE_ITEMS_ConvertQuote @LINE_ITEM_ID out, @MODIFIED_USER_ID, @QUOTE_ID, @ID, 0, @REPEAT_COMMENT, @POSITION out;

		exec dbo.spINVOICES_UpdateTotals    @ID, @MODIFIED_USER_ID;
		exec dbo.spINVOICES_UpdateAmountDue @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spINVOICES_ConvertQuote to public;
GO
 
