if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spREVENUE_LINE_ITEMS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spREVENUE_LINE_ITEMS_Update;
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
Create Procedure dbo.spREVENUE_LINE_ITEMS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @OPPORTUNITY_ID       uniqueidentifier
	, @LINE_GROUP_ID        uniqueidentifier
	, @LINE_ITEM_TYPE       nvarchar(25)
	, @POSITION             int
	, @NAME                 nvarchar(150)
	, @MFT_PART_NUM         nvarchar(50)
	, @VENDOR_PART_NUM      nvarchar(50)
	, @PRODUCT_TEMPLATE_ID  uniqueidentifier
	, @TAX_CLASS            nvarchar(25)
	, @QUANTITY             float
	, @COST_PRICE           money
	, @LIST_PRICE           money
	, @UNIT_PRICE           money
	, @DESCRIPTION          nvarchar(max)
	, @PARENT_TEMPLATE_ID   uniqueidentifier
	, @DISCOUNT_ID          uniqueidentifier
	, @DISCOUNT_PRICE       money
	, @PRICING_FORMULA      nvarchar( 25)
	, @PRICING_FACTOR       float
	, @TAXRATE_ID           uniqueidentifier
	, @OPPORTUNITY_TYPE     nvarchar(255)
	, @LEAD_SOURCE          nvarchar(50)
	, @DATE_CLOSED          datetime
	, @NEXT_STEP            nvarchar(100)
	, @SALES_STAGE          nvarchar(25)
	, @PROBABILITY          float(53)
	)
as
  begin
	set nocount on
	
	declare @CURRENCY_ID       uniqueidentifier;
	declare @EXCHANGE_RATE     float;
	declare @COST_USDOLLAR     money;
	declare @LIST_USDOLLAR     money;
	declare @UNIT_USDOLLAR     money;
	-- 01/27/2015 Paul.  Move @TAX_USDOLLAR up for better Oracle processing. 
	declare @TAX_USDOLLAR      money;
	declare @TAX_RATE          float;	
	declare @TAX               money;
	declare @EXTENDED_PRICE    money;
	declare @EXTENDED_USDOLLAR money;
	declare @DISCOUNT_USDOLLAR money;

	-- BEGIN Oracle Exception
		select @CURRENCY_ID = CURRENCY_ID
		  from OPPORTUNITIES
		 where ID = @OPPORTUNITY_ID;
	-- END Oracle Exception
	-- BEGIN Oracle Exception
		select @EXCHANGE_RATE = CONVERSION_RATE
		  from CURRENCIES
		 where ID = @CURRENCY_ID;
	-- END Oracle Exception
	if @EXCHANGE_RATE is null or @EXCHANGE_RATE = 0.0 begin -- then
		set @EXCHANGE_RATE = 1.0;
	end -- if;
	
	-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
	if @TAXRATE_ID is not null begin -- then
		-- BEGIN Oracle Exception
			select @TAX_RATE = min(VALUE) / 100
			  from vwTAX_RATES
			where ID = @TAXRATE_ID;
		-- END Oracle Exception
	end -- if;
	
	if @POSITION is null begin -- then
		-- BEGIN Oracle Exception
			select @POSITION = isnull(max(POSITION) + 1, 0)
			  from vwREVENUE_LINE_ITEMS
			 where OPPORTUNITY_ID = @OPPORTUNITY_ID;
		-- END Oracle Exception
	end -- if;

	set @COST_USDOLLAR     = @COST_PRICE;
	set @LIST_USDOLLAR     = @LIST_PRICE;
	set @UNIT_USDOLLAR     = @UNIT_PRICE;
	set @EXTENDED_PRICE    = @UNIT_PRICE * @QUANTITY;
	set @EXTENDED_USDOLLAR = @EXTENDED_PRICE;
	set @DISCOUNT_USDOLLAR = @DISCOUNT_PRICE;
	-- 12/13/2013 Paul.  Make sure to apply the discount before calculating the tax. 
	set @TAX               = (@EXTENDED_PRICE - @DISCOUNT_PRICE) * @TAX_RATE;
	set @TAX_USDOLLAR      = @TAX           ;
	-- BEGIN Oracle Exception
		set @COST_USDOLLAR     = @COST_PRICE     / @EXCHANGE_RATE;
		set @LIST_USDOLLAR     = @LIST_PRICE     / @EXCHANGE_RATE;
		set @UNIT_USDOLLAR     = @UNIT_PRICE     / @EXCHANGE_RATE;
		set @EXTENDED_USDOLLAR = @EXTENDED_PRICE / @EXCHANGE_RATE;
		set @DISCOUNT_USDOLLAR = @DISCOUNT_PRICE / @EXCHANGE_RATE;
		set @TAX_USDOLLAR      = @TAX            / @EXCHANGE_RATE;
	-- END Oracle Exception


	if not exists(select * from REVENUE_LINE_ITEMS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into REVENUE_LINE_ITEMS
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, OPPORTUNITY_ID      
			, LINE_GROUP_ID       
			, LINE_ITEM_TYPE      
			, POSITION            
			, NAME                
			, MFT_PART_NUM        
			, VENDOR_PART_NUM     
			, PRODUCT_TEMPLATE_ID 
			, PARENT_TEMPLATE_ID  
			, TAX_CLASS           
			, QUANTITY            
			, COST_PRICE          
			, COST_USDOLLAR       
			, LIST_PRICE          
			, LIST_USDOLLAR       
			, UNIT_PRICE          
			, UNIT_USDOLLAR       
			, TAXRATE_ID          
			, TAX                 
			, TAX_USDOLLAR        
			, EXTENDED_PRICE      
			, EXTENDED_USDOLLAR   
			, DISCOUNT_ID         
			, PRICING_FORMULA     
			, PRICING_FACTOR      
			, DISCOUNT_PRICE      
			, DISCOUNT_USDOLLAR   
			, DESCRIPTION         
			, OPPORTUNITY_TYPE    
			, LEAD_SOURCE         
			, DATE_CLOSED         
			, NEXT_STEP           
			, SALES_STAGE         
			, PROBABILITY         
			)
		values 	( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @OPPORTUNITY_ID      
			, @LINE_GROUP_ID       
			, @LINE_ITEM_TYPE      
			, @POSITION            
			, @NAME                
			, @MFT_PART_NUM        
			, @VENDOR_PART_NUM     
			, @PRODUCT_TEMPLATE_ID 
			, @PARENT_TEMPLATE_ID  
			, @TAX_CLASS           
			, @QUANTITY            
			, @COST_PRICE          
			, @COST_USDOLLAR       
			, @LIST_PRICE          
			, @LIST_USDOLLAR       
			, @UNIT_PRICE          
			, @UNIT_USDOLLAR       
			, @TAXRATE_ID          
			, @TAX                 
			, @TAX_USDOLLAR        
			, @EXTENDED_PRICE      
			, @EXTENDED_USDOLLAR   
			, @DISCOUNT_ID         
			, @PRICING_FORMULA     
			, @PRICING_FACTOR      
			, @DISCOUNT_PRICE      
			, @DISCOUNT_USDOLLAR   
			, @DESCRIPTION         
			, @OPPORTUNITY_TYPE    
			, @LEAD_SOURCE         
			, @DATE_CLOSED         
			, @NEXT_STEP           
			, @SALES_STAGE         
			, @PROBABILITY         
			);
	end else begin
		update REVENUE_LINE_ITEMS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , OPPORTUNITY_ID       = @OPPORTUNITY_ID      
		     , LINE_GROUP_ID        = @LINE_GROUP_ID       
		     , LINE_ITEM_TYPE       = @LINE_ITEM_TYPE      
		     , POSITION             = @POSITION            
		     , NAME                 = @NAME                
		     , MFT_PART_NUM         = @MFT_PART_NUM        
		     , VENDOR_PART_NUM      = @VENDOR_PART_NUM     
		     , PRODUCT_TEMPLATE_ID  = @PRODUCT_TEMPLATE_ID 
		     , PARENT_TEMPLATE_ID   = @PARENT_TEMPLATE_ID  
		     , TAX_CLASS            = @TAX_CLASS           
		     , QUANTITY             = @QUANTITY            
		     , COST_PRICE           = @COST_PRICE          
		     , COST_USDOLLAR        = @COST_USDOLLAR       
		     , LIST_PRICE           = @LIST_PRICE          
		     , LIST_USDOLLAR        = @LIST_USDOLLAR       
		     , UNIT_PRICE           = @UNIT_PRICE          
		     , UNIT_USDOLLAR        = @UNIT_USDOLLAR       
		     , TAXRATE_ID           = @TAXRATE_ID          
		     , TAX                  = @TAX                 
		     , TAX_USDOLLAR         = @TAX_USDOLLAR        
		     , EXTENDED_PRICE       = @EXTENDED_PRICE      
		     , EXTENDED_USDOLLAR    = @EXTENDED_USDOLLAR   
		     , DISCOUNT_ID          = @DISCOUNT_ID         
		     , PRICING_FORMULA      = @PRICING_FORMULA     
		     , PRICING_FACTOR       = @PRICING_FACTOR      
		     , DISCOUNT_PRICE       = @DISCOUNT_PRICE      
		     , DISCOUNT_USDOLLAR    = @DISCOUNT_USDOLLAR   
		     , DESCRIPTION          = @DESCRIPTION         
		     , OPPORTUNITY_TYPE     = @OPPORTUNITY_TYPE    
		     , LEAD_SOURCE          = @LEAD_SOURCE         
		     , DATE_CLOSED          = @DATE_CLOSED         
		     , NEXT_STEP            = @NEXT_STEP           
		     , SALES_STAGE          = @SALES_STAGE         
		     , PROBABILITY          = @PROBABILITY         
		 where ID                   = @ID                  ;
	end -- if;

	if not exists(select * from REVENUE_LINE_ITEMS_CSTM where ID_C = @ID) begin -- then
		insert into REVENUE_LINE_ITEMS_CSTM ( ID_C ) values ( @ID );
	end -- if;
  end
GO

Grant Execute on dbo.spREVENUE_LINE_ITEMS_Update to public;
GO

