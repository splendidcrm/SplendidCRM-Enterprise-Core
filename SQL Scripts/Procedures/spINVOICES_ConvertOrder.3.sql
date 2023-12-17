if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_ConvertOrder' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_ConvertOrder;
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
-- 04/23/2008 Paul.  Update the Invoice Amount Due.
-- 09/27/2008 Paul.  Use a stored procedure to convert line items so that it could be called separately. 
-- 11/15/2009 Paul.  The invoice number must be generated. 
-- 12/29/2015 Paul.  TEAM_SET_ID should have been included long ago. 
-- 04/18/2016 Paul.  TEAM_ID should have been included long ago. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spINVOICES_ConvertOrder
	( @ID               uniqueidentifier output
	, @MODIFIED_USER_ID uniqueidentifier
	, @ORDER_ID         uniqueidentifier
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

	if exists(select * from vwORDERS_ConvertToInvoice where ORDER_ID = @ORDER_ID) begin -- then
		-- 11/15/2009 Paul.  The invoice number must be generated. 
		if @INVOICE_NUM is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'INVOICES.INVOICE_NUM', 1, @INVOICE_NUM out;
		end -- if;
		-- 08/15/2007 Paul.  We could use spINVOICES_Update to create the invoice, 
		-- but this approach is faster and avoids currency conversions. 
		set @ID = newid();
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		insert into INVOICES
			( ID                          
			, CREATED_BY                  
			, DATE_ENTERED                
			, MODIFIED_USER_ID            
			, DATE_MODIFIED               
			, ASSIGNED_USER_ID            
--			, QUOTE_ID                    
			, ORDER_ID                    
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
--			, null                        
			, ORDER_ID                    
			, OPPORTUNITY_ID              
			, @INVOICE_NUM                
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
		  from vwORDERS_ConvertToInvoice
		 where ORDER_ID = @ORDER_ID;

		if not exists(select * from INVOICES_CSTM where ID_C = @ID) begin -- then
			insert into INVOICES_CSTM ( ID_C ) values ( @ID );
		end -- if;
	
		select @BILLING_ACCOUNT_ID  = BILLING_ACCOUNT_ID
		     , @BILLING_CONTACT_ID  = BILLING_CONTACT_ID
		     , @SHIPPING_ACCOUNT_ID = SHIPPING_ACCOUNT_ID
		     , @SHIPPING_CONTACT_ID = SHIPPING_CONTACT_ID
		  from vwORDERS_ConvertToInvoice
		 where ORDER_ID = @ORDER_ID;

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

		-- 08/15/2007 Paul.  If we were to use spINVOICES_LINE_ITEMS_Update, 
		-- we would have to create a cursor, so this approach is much faster. 
		-- 09/27/2008 Paul.  Use a stored procedure to convert line items so that it could be called separately. 

		-- 07/04/2008 Paul.  Move line items to a separate procedure so that it can be used elsewhere when managing the frequency multiplier. 
		-- 07/29/2008 Paul.  The POSITION needs to be managed externally so that it can be incremented for each row and each month. 
		set @LINE_ITEM_ID = null;
		set @POSITION     = 1;
		exec dbo.spINVOICES_LINE_ITEMS_ConvertOrder @LINE_ITEM_ID out, @MODIFIED_USER_ID, @ORDER_ID, @ID, 0, @REPEAT_COMMENT, @POSITION out;

		-- 11/14/2007 Paul.  Update totals after invoice has been converted. 
		exec dbo.spINVOICES_UpdateTotals    @ID, @MODIFIED_USER_ID;
		-- 04/23/2008 Paul.  Update amount due after invoice has been converted. 
		exec dbo.spINVOICES_UpdateAmountDue @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spINVOICES_ConvertOrder to public;
GO
 
