if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPRODUCT_TEMPLATES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPRODUCT_TEMPLATES_Update;
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
-- 02/03/2009 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 07/10/2010 Paul.  Add Options fields. 
-- 08/13/2010 Paul.  PRICING_FACTOR and PRICING_FORMULA were moved to DISCOUNTS table. 
-- 08/17/2010 Paul.  Restore PRICING_FACTOR and PRICING_FORMULA.  Keep DISCOUNTS as a pre-defined discount. 
-- 09/20/2010 Paul.  PRICING_FACTOR is now a float. 
-- 04/11/2012 Paul.  Increase NAME to 100 to match QUOTES_LINE_ITEMS, ORDERS_LINE_ITEMS, INVOICES_LINE_ITEMS. 
-- 04/11/2012 Paul.  Increase MFT_PART_NUM and VENDOR_PART_NUM to 100. 
-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
-- 12/13/2013 Paul.  Allow each product to have a default tax rate. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
-- 01/29/2019 Paul.  Add Tags module. 
Create Procedure dbo.spPRODUCT_TEMPLATES_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @NAME                 nvarchar(100)
	, @STATUS               nvarchar(25)
	, @QUANTITY             int
	, @DATE_AVAILABLE       datetime
	, @DATE_COST_PRICE      datetime
	, @ACCOUNT_ID           uniqueidentifier
	, @MANUFACTURER_ID      uniqueidentifier
	, @CATEGORY_ID          uniqueidentifier
	, @TYPE_ID              uniqueidentifier
	, @WEBSITE              nvarchar(255)
	, @MFT_PART_NUM         nvarchar(100)
	, @VENDOR_PART_NUM      nvarchar(100)
	, @TAX_CLASS            nvarchar(25)
	, @WEIGHT               float(53)
	, @CURRENCY_ID          uniqueidentifier
	, @COST_PRICE           money
	, @LIST_PRICE           money
	, @DISCOUNT_PRICE       money
	, @PRICING_FACTOR       float(53)
	, @PRICING_FORMULA      nvarchar(25)
	, @SUPPORT_NAME         nvarchar(50)
	, @SUPPORT_CONTACT      nvarchar(50)
	, @SUPPORT_DESCRIPTION  nvarchar(255)
	, @SUPPORT_TERM         nvarchar(25)
	, @DESCRIPTION          nvarchar(max)
	, @TEAM_ID              uniqueidentifier = null
	, @TEAM_SET_LIST        varchar(8000) = null
	, @MINIMUM_OPTIONS      int = null
	, @MAXIMUM_OPTIONS      int = null
	, @DISCOUNT_ID          uniqueidentifier = null
	, @QUICKBOOKS_ACCOUNT   nvarchar(50) = null
	, @TAXRATE_ID           uniqueidentifier = null
	, @MINIMUM_QUANTITY     int = null
	, @MAXIMUM_QUANTITY     int = null
	, @LIST_ORDER           int = null
	, @TAG_SET_NAME         nvarchar(4000) = null
	)
as
  begin
	set nocount on
	
	declare @CONVERSION_RATE     float;
	declare @COST_USDOLLAR       money;
	declare @LIST_USDOLLAR       money;
	declare @DISCOUNT_USDOLLAR   money;
	declare @TEAM_SET_ID         uniqueidentifier;
	-- BEGIN Oracle Exception
		select @CONVERSION_RATE = CONVERSION_RATE
		  from CURRENCIES
		 where ID = @CURRENCY_ID;
	-- END Oracle Exception
	-- 08/13/2010 Paul.  The exchange rate might be null. 
	if @CONVERSION_RATE is null or @CONVERSION_RATE = 0.0 begin -- then
		set @CONVERSION_RATE = 1.0;
	end -- if;
	-- 06/08/2006 Paul.  We could convert all the values in a single statement, 
	-- but then it becomes a pain to convert the code to the other database platforms. 
	-- It is a minor performance issue, so lets ignore it. 
	-- 08/18/2010 Paul.  Ease conversion to Oracle. 
	set @COST_USDOLLAR     = @COST_PRICE     / @CONVERSION_RATE;
	set @LIST_USDOLLAR     = @LIST_PRICE     / @CONVERSION_RATE;
	set @DISCOUNT_USDOLLAR = @DISCOUNT_PRICE / @CONVERSION_RATE;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	if not exists(select * from PRODUCT_TEMPLATES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into PRODUCT_TEMPLATES
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, NAME                
			, STATUS              
			, QUANTITY            
			, DATE_AVAILABLE      
			, DATE_COST_PRICE     
			, ACCOUNT_ID          
			, MANUFACTURER_ID     
			, CATEGORY_ID         
			, TYPE_ID             
			, WEBSITE             
			, MFT_PART_NUM        
			, VENDOR_PART_NUM     
			, TAX_CLASS           
			, TAXRATE_ID          
			, WEIGHT              
			, MINIMUM_OPTIONS     
			, MAXIMUM_OPTIONS     
			, MINIMUM_QUANTITY    
			, MAXIMUM_QUANTITY    
			, LIST_ORDER          
			, QUICKBOOKS_ACCOUNT  
			, CURRENCY_ID         
			, COST_PRICE          
			, COST_USDOLLAR       
			, LIST_PRICE          
			, LIST_USDOLLAR       
			, DISCOUNT_PRICE      
			, DISCOUNT_USDOLLAR   
			, PRICING_FACTOR      
			, PRICING_FORMULA     
			, SUPPORT_NAME        
			, SUPPORT_CONTACT     
			, SUPPORT_DESCRIPTION 
			, SUPPORT_TERM        
			, DESCRIPTION         
			, TEAM_ID             
			, TEAM_SET_ID         
			, DISCOUNT_ID         
			)
		values 
			( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			,  getutcdate()        
			, @NAME                
			, @STATUS              
			, @QUANTITY            
			, @DATE_AVAILABLE      
			, @DATE_COST_PRICE     
			, @ACCOUNT_ID          
			, @MANUFACTURER_ID     
			, @CATEGORY_ID         
			, @TYPE_ID             
			, @WEBSITE             
			, @MFT_PART_NUM        
			, @VENDOR_PART_NUM     
			, @TAX_CLASS           
			, @TAXRATE_ID          
			, @WEIGHT              
			, @MINIMUM_OPTIONS     
			, @MAXIMUM_OPTIONS     
			, @MINIMUM_QUANTITY    
			, @MAXIMUM_QUANTITY    
			, @LIST_ORDER          
			, @QUICKBOOKS_ACCOUNT  
			, @CURRENCY_ID         
			, @COST_PRICE          
			, @COST_USDOLLAR       
			, @LIST_PRICE          
			, @LIST_USDOLLAR       
			, @DISCOUNT_PRICE      
			, @DISCOUNT_USDOLLAR   
			, @PRICING_FACTOR      
			, @PRICING_FORMULA     
			, @SUPPORT_NAME        
			, @SUPPORT_CONTACT     
			, @SUPPORT_DESCRIPTION 
			, @SUPPORT_TERM        
			, @DESCRIPTION         
			, @TEAM_ID             
			, @TEAM_SET_ID         
			, @DISCOUNT_ID         
			);
	end else begin
		update PRODUCT_TEMPLATES
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , NAME                 = @NAME                
		     , STATUS               = @STATUS              
		     , QUANTITY             = @QUANTITY            
		     , DATE_AVAILABLE       = @DATE_AVAILABLE      
		     , DATE_COST_PRICE      = @DATE_COST_PRICE     
		     , ACCOUNT_ID           = @ACCOUNT_ID          
		     , MANUFACTURER_ID      = @MANUFACTURER_ID     
		     , CATEGORY_ID          = @CATEGORY_ID         
		     , TYPE_ID              = @TYPE_ID             
		     , WEBSITE              = @WEBSITE             
		     , MFT_PART_NUM         = @MFT_PART_NUM        
		     , VENDOR_PART_NUM      = @VENDOR_PART_NUM     
		     , TAX_CLASS            = @TAX_CLASS           
		     , TAXRATE_ID           = @TAXRATE_ID          
		     , WEIGHT               = @WEIGHT              
		     , MINIMUM_OPTIONS      = @MINIMUM_OPTIONS     
		     , MAXIMUM_OPTIONS      = @MAXIMUM_OPTIONS     
		     , MINIMUM_QUANTITY     = @MINIMUM_QUANTITY    
		     , MAXIMUM_QUANTITY     = @MAXIMUM_QUANTITY    
		     , LIST_ORDER           = @LIST_ORDER          
		     , QUICKBOOKS_ACCOUNT   = @QUICKBOOKS_ACCOUNT  
		     , CURRENCY_ID          = @CURRENCY_ID         
		     , COST_PRICE           = @COST_PRICE          
		     , COST_USDOLLAR        = @COST_USDOLLAR       
		     , LIST_PRICE           = @LIST_PRICE          
		     , LIST_USDOLLAR        = @LIST_USDOLLAR       
		     , DISCOUNT_PRICE       = @DISCOUNT_PRICE      
		     , DISCOUNT_USDOLLAR    = @DISCOUNT_USDOLLAR   
		     , PRICING_FACTOR       = @PRICING_FACTOR      
		     , PRICING_FORMULA      = @PRICING_FORMULA     
		     , SUPPORT_NAME         = @SUPPORT_NAME        
		     , SUPPORT_CONTACT      = @SUPPORT_CONTACT     
		     , SUPPORT_DESCRIPTION  = @SUPPORT_DESCRIPTION 
		     , SUPPORT_TERM         = @SUPPORT_TERM        
		     , DESCRIPTION          = @DESCRIPTION         
		     , TEAM_ID              = @TEAM_ID             
		     , TEAM_SET_ID          = @TEAM_SET_ID         
		     , DISCOUNT_ID          = @DISCOUNT_ID         
		 where ID                   = @ID                  ;
	end -- if;

	-- 08/22/2009 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from PRODUCT_TEMPLATES_CSTM where ID_C = @ID) begin -- then
			insert into PRODUCT_TEMPLATES_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spPRODUCT_TEMPLATES_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
	end -- if;

	-- 01/29/2019 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'ProductTemplates', @TAG_SET_NAME;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPRODUCT_TEMPLATES_Update to public;
GO
 
