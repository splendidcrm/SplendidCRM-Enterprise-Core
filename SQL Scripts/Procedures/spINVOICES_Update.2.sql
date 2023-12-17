if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_Update;
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
-- 05/26/2007 Paul.  DISCOUNT_USDOLLAR was being computed with SUBTOTAL. 
-- 12/29/2007 Paul.  Add TEAM_ID so that it is not updated separately. 
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 07/25/2009 Paul.  INVOICE_NUM is no longer an identity and must be formatted. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 09/19/2010 Paul.  When converting a quote, set the status of the quote to Closed Accepted. 
-- 10/05/2010 Paul.  Increase the size of the NAME field. 
-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
-- 04/06/2015 Paul.  QuickBooks Online can create records without a NAME.  Use number instead. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spINVOICES_Update
	( @ID                           uniqueidentifier output
	, @MODIFIED_USER_ID             uniqueidentifier
	, @ASSIGNED_USER_ID             uniqueidentifier
	, @NAME                         nvarchar(150)
	, @QUOTE_ID                     uniqueidentifier
	, @ORDER_ID                     uniqueidentifier
	, @OPPORTUNITY_ID               uniqueidentifier
	, @PAYMENT_TERMS                nvarchar(25)
	, @INVOICE_STAGE                nvarchar(25)
	, @PURCHASE_ORDER_NUM           nvarchar(50)
	, @DUE_DATE                     datetime
	, @EXCHANGE_RATE                float
	, @CURRENCY_ID                  uniqueidentifier
	, @TAXRATE_ID                   uniqueidentifier
	, @SHIPPER_ID                   uniqueidentifier
	, @SUBTOTAL                     money
	, @DISCOUNT                     money
	, @SHIPPING                     money
	, @TAX                          money
	, @TOTAL                        money
	, @AMOUNT_DUE                   money
	, @BILLING_ACCOUNT_ID           uniqueidentifier
	, @BILLING_CONTACT_ID           uniqueidentifier
	, @BILLING_ADDRESS_STREET       nvarchar(150)
	, @BILLING_ADDRESS_CITY         nvarchar(100)
	, @BILLING_ADDRESS_STATE        nvarchar(100)
	, @BILLING_ADDRESS_POSTALCODE   nvarchar(20)
	, @BILLING_ADDRESS_COUNTRY      nvarchar(100)
	, @SHIPPING_ACCOUNT_ID          uniqueidentifier
	, @SHIPPING_CONTACT_ID          uniqueidentifier
	, @SHIPPING_ADDRESS_STREET      nvarchar(150)
	, @SHIPPING_ADDRESS_CITY        nvarchar(100)
	, @SHIPPING_ADDRESS_STATE       nvarchar(100)
	, @SHIPPING_ADDRESS_POSTALCODE  nvarchar(20)
	, @SHIPPING_ADDRESS_COUNTRY     nvarchar(100)
	, @DESCRIPTION                  nvarchar(max)
	, @INVOICE_NUM                  nvarchar(30) = null
	, @TEAM_ID                      uniqueidentifier = null
	, @TEAM_SET_LIST                varchar(8000) = null
	, @SHIP_DATE                    datetime = null
	, @TAG_SET_NAME                 nvarchar(4000) = null
	, @ASSIGNED_SET_LIST            varchar(8000) = null
	)
as
  begin
	set nocount on
	
	-- 06/07/2006 Paul.  Convert currency to USD. 
	declare @SUBTOTAL_USDOLLAR   money;
	declare @DISCOUNT_USDOLLAR   money;
	declare @SHIPPING_USDOLLAR   money;
	declare @TAX_USDOLLAR        money;
	declare @TOTAL_USDOLLAR      money;
	declare @AMOUNT_DUE_USDOLLAR money;
	declare @TEMP_EXCHANGE_RATE  float;
	declare @TEMP_INVOICE_NUM    nvarchar(30);
	declare @TEMP_NAME           nvarchar(150);
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;

	-- 04/06/2015 Paul.  QuickBooks Online can create records without a NAME.  Use number instead. 
	set @TEMP_NAME          = @NAME;
	set @TEMP_EXCHANGE_RATE = @EXCHANGE_RATE;
	-- 07/07/2007 Paul.  If no exchange rate was provided, then pull from the currency. 
	if @TEMP_EXCHANGE_RATE is null or @TEMP_EXCHANGE_RATE = 0.0 begin -- then
		-- BEGIN Oracle Exception
			select @TEMP_EXCHANGE_RATE = CONVERSION_RATE
			  from CURRENCIES
			 where ID = @CURRENCY_ID;
		-- END Oracle Exception
	end -- if;
	if @TEMP_EXCHANGE_RATE = 0.0 begin -- then
		set @TEMP_EXCHANGE_RATE = 1.0;
	end -- if;

	-- 03/31/2007 Paul.  The exchange rate is stored in the object. 
	set @SUBTOTAL_USDOLLAR   = @SUBTOTAL   / @TEMP_EXCHANGE_RATE;
	set @DISCOUNT_USDOLLAR   = @DISCOUNT   / @TEMP_EXCHANGE_RATE;
	set @SHIPPING_USDOLLAR   = @SHIPPING   / @TEMP_EXCHANGE_RATE;
	set @TAX_USDOLLAR        = @TAX        / @TEMP_EXCHANGE_RATE;
	set @TOTAL_USDOLLAR      = @TOTAL      / @TEMP_EXCHANGE_RATE;
	set @AMOUNT_DUE_USDOLLAR = @AMOUNT_DUE / @TEMP_EXCHANGE_RATE;
	-- 08/04/2010 Paul.  The @TEMP_INVOICE_NUM field was not getting initialized. 
	set @TEMP_INVOICE_NUM    = @INVOICE_NUM;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from INVOICES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		-- 07/25/2009 Paul.  Allow the INVOICE_NUM to be imported. 
		if @TEMP_INVOICE_NUM is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'INVOICES.INVOICE_NUM', 1, @TEMP_INVOICE_NUM out;
		end -- if;
		-- 04/06/2015 Paul.  QuickBooks Online can create records without a NAME.  Use number instead. 
		if @TEMP_NAME is null begin -- then
			set @TEMP_NAME = @TEMP_INVOICE_NUM;
		end -- if;
		insert into INVOICES
			( ID                          
			, CREATED_BY                  
			, DATE_ENTERED                
			, MODIFIED_USER_ID            
			, DATE_MODIFIED               
			, DATE_MODIFIED_UTC           
			, ASSIGNED_USER_ID            
			, QUOTE_ID                    
			, ORDER_ID                    
			, OPPORTUNITY_ID              
			, INVOICE_NUM                 
			, NAME                        
			, PAYMENT_TERMS               
			, INVOICE_STAGE               
			, PURCHASE_ORDER_NUM          
			, DUE_DATE                    
			, SHIP_DATE                   
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
		values 
			( @ID                          
			, @MODIFIED_USER_ID            
			,  getdate()                   
			, @MODIFIED_USER_ID            
			,  getdate()                   
			,  getutcdate()                
			, @ASSIGNED_USER_ID            
			, @QUOTE_ID                    
			, @ORDER_ID                    
			, @OPPORTUNITY_ID              
			, @TEMP_INVOICE_NUM            
			, @TEMP_NAME                   
			, @PAYMENT_TERMS               
			, @INVOICE_STAGE               
			, @PURCHASE_ORDER_NUM          
			, @DUE_DATE                    
			, @SHIP_DATE                   
			, @TEMP_EXCHANGE_RATE          
			, @CURRENCY_ID                 
			, @TAXRATE_ID                  
			, @SHIPPER_ID                  
			, @SUBTOTAL                    
			, @SUBTOTAL_USDOLLAR           
			, @DISCOUNT                    
			, @DISCOUNT_USDOLLAR           
			, @SHIPPING                    
			, @SHIPPING_USDOLLAR           
			, @TAX                         
			, @TAX_USDOLLAR                
			, @TOTAL                       
			, @TOTAL_USDOLLAR              
			, @BILLING_ADDRESS_STREET      
			, @BILLING_ADDRESS_CITY        
			, @BILLING_ADDRESS_STATE       
			, @BILLING_ADDRESS_POSTALCODE  
			, @BILLING_ADDRESS_COUNTRY     
			, @SHIPPING_ADDRESS_STREET     
			, @SHIPPING_ADDRESS_CITY       
			, @SHIPPING_ADDRESS_STATE      
			, @SHIPPING_ADDRESS_POSTALCODE 
			, @SHIPPING_ADDRESS_COUNTRY    
			, @DESCRIPTION                 
			, @TEAM_ID                     
			, @TEAM_SET_ID                 
			, @ASSIGNED_SET_ID             
			);
		-- 09/19/2010 Paul.  When converting a quote, set the status of the quote to Closed Accepted. 
		if dbo.fnIsEmptyGuid(@QUOTE_ID) = 0 begin -- then
			-- BEGIN Oracle Exception
				-- 11/30/2017 Paul.  We should be creating the matching custom audit record. 
				-- 01/30/2019 Paul.  Correct update event. 
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
	end else begin
		-- 04/06/2015 Paul.  QuickBooks Online can create records without a NAME.  Use number instead. 
		if @TEMP_NAME is null begin -- then
			set @TEMP_NAME = @TEMP_INVOICE_NUM;
		end -- if;
		update INVOICES
		   set MODIFIED_USER_ID             = @MODIFIED_USER_ID            
		     , DATE_MODIFIED                =  getdate()                   
		     , DATE_MODIFIED_UTC            =  getutcdate()                
		     , ASSIGNED_USER_ID             = @ASSIGNED_USER_ID            
		     , QUOTE_ID                     = @QUOTE_ID                    
		     , ORDER_ID                     = @ORDER_ID                    
		     , OPPORTUNITY_ID               = @OPPORTUNITY_ID              
		     , INVOICE_NUM                  = isnull(@TEMP_INVOICE_NUM, INVOICE_NUM)
		     , NAME                         = @TEMP_NAME                   
		     , PAYMENT_TERMS                = @PAYMENT_TERMS               
		     , INVOICE_STAGE                = @INVOICE_STAGE               
		     , PURCHASE_ORDER_NUM           = @PURCHASE_ORDER_NUM          
		     , DUE_DATE                     = @DUE_DATE                    
		     , SHIP_DATE                    = @SHIP_DATE                   
		     , EXCHANGE_RATE                = @TEMP_EXCHANGE_RATE          
		     , CURRENCY_ID                  = @CURRENCY_ID                 
		     , TAXRATE_ID                   = @TAXRATE_ID                  
		     , SHIPPER_ID                   = @SHIPPER_ID                  
		     , SUBTOTAL                     = @SUBTOTAL                    
		     , SUBTOTAL_USDOLLAR            = @SUBTOTAL_USDOLLAR           
		     , DISCOUNT                     = @DISCOUNT                    
		     , DISCOUNT_USDOLLAR            = @DISCOUNT_USDOLLAR           
		     , SHIPPING                     = @SHIPPING                    
		     , SHIPPING_USDOLLAR            = @SHIPPING_USDOLLAR           
		     , TAX                          = @TAX                         
		     , TAX_USDOLLAR                 = @TAX_USDOLLAR                
		     , TOTAL                        = @TOTAL                       
		     , TOTAL_USDOLLAR               = @TOTAL_USDOLLAR              
		     , BILLING_ADDRESS_STREET       = @BILLING_ADDRESS_STREET      
		     , BILLING_ADDRESS_CITY         = @BILLING_ADDRESS_CITY        
		     , BILLING_ADDRESS_STATE        = @BILLING_ADDRESS_STATE       
		     , BILLING_ADDRESS_POSTALCODE   = @BILLING_ADDRESS_POSTALCODE  
		     , BILLING_ADDRESS_COUNTRY      = @BILLING_ADDRESS_COUNTRY     
		     , SHIPPING_ADDRESS_STREET      = @SHIPPING_ADDRESS_STREET     
		     , SHIPPING_ADDRESS_CITY        = @SHIPPING_ADDRESS_CITY       
		     , SHIPPING_ADDRESS_STATE       = @SHIPPING_ADDRESS_STATE      
		     , SHIPPING_ADDRESS_POSTALCODE  = @SHIPPING_ADDRESS_POSTALCODE 
		     , SHIPPING_ADDRESS_COUNTRY     = @SHIPPING_ADDRESS_COUNTRY    
		     , DESCRIPTION                  = @DESCRIPTION                 
		     , TEAM_ID                      = @TEAM_ID                     
		     , TEAM_SET_ID                  = @TEAM_SET_ID                 
		     , ASSIGNED_SET_ID              = @ASSIGNED_SET_ID             
		 where ID                           = @ID                          ;

		-- BEGIN Oracle Exception
			update INVOICES_ACCOUNTS
			   set DELETED          = 1
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			     , MODIFIED_USER_ID = @MODIFIED_USER_ID
			 where INVOICE_ID         = @ID
			   and DELETED          = 0;
		-- END Oracle Exception

		-- BEGIN Oracle Exception
			update INVOICES_CONTACTS
			   set DELETED          = 1
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			     , MODIFIED_USER_ID = @MODIFIED_USER_ID
			 where INVOICE_ID         = @ID
			   and DELETED          = 0;
		-- END Oracle Exception
		
		-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @TEMP_NAME;
	end -- if;

	-- 08/22/2009 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from INVOICES_CSTM where ID_C = @ID) begin -- then
			insert into INVOICES_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spINVOICES_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
		
		-- Assign any new accounts. 
		if dbo.fnIsEmptyGuid(@BILLING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spINVOICES_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @BILLING_ACCOUNT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spINVOICES_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_ACCOUNT_ID, N'Ship To';
		end -- if;
		
		-- Assign any new contacts. 
		if dbo.fnIsEmptyGuid(@BILLING_CONTACT_ID) = 0 begin -- then
			exec dbo.spINVOICES_CONTACTS_Update @MODIFIED_USER_ID, @ID, @BILLING_CONTACT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_CONTACT_ID) = 0 begin -- then
			exec dbo.spINVOICES_CONTACTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_CONTACT_ID, N'Ship To';
		end -- if;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'Invoices', @TAG_SET_NAME;
	end -- if;
  end
GO
 
Grant Execute on dbo.spINVOICES_Update to public;
GO
 
