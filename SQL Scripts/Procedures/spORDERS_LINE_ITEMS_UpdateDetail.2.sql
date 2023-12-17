if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spORDERS_LINE_ITEMS_UpdateDetail' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spORDERS_LINE_ITEMS_UpdateDetail;
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
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 05/21/2009 Paul.  Added serial number and support fields. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 07/11/2010 Paul.  Add PARENT_TEMPLATE_ID. 
-- 07/15/2010 Paul.  Add GROUP_ID for options management. 
-- 08/12/2010 Paul.  Add Discount fields to better match Sugar. 
-- 08/13/2010 Paul.  Use LINE_GROUP_ID instead of GROUP_ID. 
-- 08/17/2010 Paul.  Add PRICING fields so that they can be customized per line item. 
-- 10/08/2010 Paul.  Change QUANTITY to float. 
-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
-- 01/27/2015 Paul.  Move @TAX_USDOLLAR up for better Oracle processing. 
Create Procedure dbo.spORDERS_LINE_ITEMS_UpdateDetail
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ORDER_ID             uniqueidentifier
	, @LINE_GROUP_ID        uniqueidentifier
	, @LINE_ITEM_TYPE       nvarchar(25)
	, @POSITION             int
	, @NAME                 nvarchar(100)
	, @MFT_PART_NUM         nvarchar(50)
	, @VENDOR_PART_NUM      nvarchar(50)
	, @PRODUCT_TEMPLATE_ID  uniqueidentifier
	, @TAX_CLASS            nvarchar(25)
	, @QUANTITY             float
	, @COST_PRICE           money
	, @LIST_PRICE           money
	, @UNIT_PRICE           money
	, @DESCRIPTION          nvarchar(max)
	, @SERIAL_NUMBER        nvarchar( 50)
	, @ASSET_NUMBER         nvarchar( 50)
	, @DATE_ORDER_SHIPPED   datetime
	, @DATE_SUPPORT_EXPIRES datetime
	, @DATE_SUPPORT_STARTS  datetime
	, @SUPPORT_NAME         nvarchar( 50)
	, @SUPPORT_CONTACT      nvarchar( 50)
	, @SUPPORT_TERM         nvarchar( 25)
	, @SUPPORT_DESCRIPTION  nvarchar(max)
	, @PARENT_TEMPLATE_ID   uniqueidentifier = null
	, @DISCOUNT_ID          uniqueidentifier = null
	, @DISCOUNT_PRICE       money = null
	, @PRICING_FORMULA      nvarchar( 25) = null
	, @PRICING_FACTOR       float = null
	, @TAXRATE_ID           uniqueidentifier = null
	)
as
  begin
	set nocount on

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
		-- 07/07/2007 Paul.  Use exchange rate from order. 
		select @EXCHANGE_RATE = EXCHANGE_RATE
		  from ORDERS
		 where ID = @ORDER_ID;
	-- END Oracle Exception
	-- 05/12/2009 Paul.  The exchange rate might be null. 
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
	
	if @LINE_ITEM_TYPE = N'Comment' begin -- then
		if not exists(select * from ORDERS_LINE_ITEMS where ID = @ID) begin -- then
			if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
				set @ID = newid();
			end -- if;
			insert into ORDERS_LINE_ITEMS
				( ID                  
				, CREATED_BY          
				, DATE_ENTERED        
				, MODIFIED_USER_ID    
				, DATE_MODIFIED       
				, ORDER_ID            
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
				, DISCOUNT_PRICE      
				, PRICING_FORMULA     
				, PRICING_FACTOR      
				, DISCOUNT_USDOLLAR   
				, DESCRIPTION         
				)
			values 	( @ID                  
				, @MODIFIED_USER_ID          
				,  getdate()           
				, @MODIFIED_USER_ID    
				,  getdate()           
				, @ORDER_ID            
				, @LINE_GROUP_ID       
				, @LINE_ITEM_TYPE      
				, @POSITION            
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, null
				, @DESCRIPTION         
				);
		end else begin
			update ORDERS_LINE_ITEMS
			   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
			     , DATE_MODIFIED        =  getdate()           
			     , DATE_MODIFIED_UTC    =  getutcdate()        
			     , ORDER_ID             = @ORDER_ID            
			     , LINE_GROUP_ID        = @LINE_GROUP_ID       
			     , LINE_ITEM_TYPE       = @LINE_ITEM_TYPE      
			     , POSITION             = @POSITION            
			     , NAME                 = null
			     , MFT_PART_NUM         = null
			     , VENDOR_PART_NUM      = null
			     , PRODUCT_TEMPLATE_ID  = null
			     , PARENT_TEMPLATE_ID   = null
			     , TAX_CLASS            = null
			     , QUANTITY             = null
			     , COST_PRICE           = null
			     , COST_USDOLLAR        = null
			     , LIST_PRICE           = null
			     , LIST_USDOLLAR        = null
			     , UNIT_PRICE           = null
			     , UNIT_USDOLLAR        = null
			     , TAXRATE_ID           = null
			     , TAX                  = null
			     , TAX_USDOLLAR         = null
			     , EXTENDED_PRICE       = null
			     , EXTENDED_USDOLLAR    = null
			     , DISCOUNT_ID          = null
			     , PRICING_FORMULA      = null
			     , PRICING_FACTOR       = null
			     , DISCOUNT_PRICE       = null
			     , DISCOUNT_USDOLLAR    = null
			     , DESCRIPTION          = @DESCRIPTION         
			 where ID                   = @ID                  ;
		end -- if;
	end else begin
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
			-- 03/28/2007 Paul.  We could convert all the values in a single statement, 
			-- but then it becomes a pain to convert the code to the other database platforms. 
			-- It is a minor performance issue, so lets ignore it. 
			-- 07/07/2007 Paul.  Use exchange rate from order. 
			set @COST_USDOLLAR     = @COST_PRICE     / @EXCHANGE_RATE;
			set @LIST_USDOLLAR     = @LIST_PRICE     / @EXCHANGE_RATE;
			set @UNIT_USDOLLAR     = @UNIT_PRICE     / @EXCHANGE_RATE;
			set @EXTENDED_USDOLLAR = @EXTENDED_PRICE / @EXCHANGE_RATE;
			set @DISCOUNT_USDOLLAR = @DISCOUNT_PRICE / @EXCHANGE_RATE;
			set @TAX_USDOLLAR      = @TAX            / @EXCHANGE_RATE;
		-- END Oracle Exception


		if not exists(select * from ORDERS_LINE_ITEMS where ID = @ID) begin -- then
			if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
				set @ID = newid();
			end -- if;
			insert into ORDERS_LINE_ITEMS
				( ID                  
				, CREATED_BY          
				, DATE_ENTERED        
				, MODIFIED_USER_ID    
				, DATE_MODIFIED       
				, ORDER_ID            
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
				, SERIAL_NUMBER       
				, ASSET_NUMBER        
				, DATE_ORDER_SHIPPED  
				, DATE_SUPPORT_EXPIRES
				, DATE_SUPPORT_STARTS 
				, SUPPORT_NAME        
				, SUPPORT_CONTACT     
				, SUPPORT_TERM        
				, SUPPORT_DESCRIPTION 
				)
			values 	( @ID                  
				, @MODIFIED_USER_ID    
				,  getdate()           
				, @MODIFIED_USER_ID    
				,  getdate()           
				, @ORDER_ID            
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
				, @SERIAL_NUMBER       
				, @ASSET_NUMBER        
				, @DATE_ORDER_SHIPPED  
				, @DATE_SUPPORT_EXPIRES
				, @DATE_SUPPORT_STARTS 
				, @SUPPORT_NAME        
				, @SUPPORT_CONTACT     
				, @SUPPORT_TERM        
				, @SUPPORT_DESCRIPTION 
				);
		end else begin
			update ORDERS_LINE_ITEMS
			   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
			     , DATE_MODIFIED        =  getdate()           
			     , DATE_MODIFIED_UTC    =  getutcdate()        
			     , ORDER_ID             = @ORDER_ID            
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
			     , SERIAL_NUMBER        = @SERIAL_NUMBER       
			     , ASSET_NUMBER         = @ASSET_NUMBER        
			     , DATE_ORDER_SHIPPED   = @DATE_ORDER_SHIPPED  
			     , DATE_SUPPORT_EXPIRES = @DATE_SUPPORT_EXPIRES
			     , DATE_SUPPORT_STARTS  = @DATE_SUPPORT_STARTS 
			     , SUPPORT_NAME         = @SUPPORT_NAME        
			     , SUPPORT_CONTACT      = @SUPPORT_CONTACT     
			     , SUPPORT_TERM         = @SUPPORT_TERM        
			     , SUPPORT_DESCRIPTION  = @SUPPORT_DESCRIPTION 
			 where ID                   = @ID                  ;
		end -- if;
	end -- if;

	-- 11/11/2007 Paul.  Add matching record to custom table. 
	if not exists(select * from ORDERS_LINE_ITEMS_CSTM where ID_C = @ID) begin -- then
		insert into ORDERS_LINE_ITEMS_CSTM ( ID_C ) values ( @ID );
	end -- if;
  end
GO

Grant Execute on dbo.spORDERS_LINE_ITEMS_UpdateDetail to public;
GO

