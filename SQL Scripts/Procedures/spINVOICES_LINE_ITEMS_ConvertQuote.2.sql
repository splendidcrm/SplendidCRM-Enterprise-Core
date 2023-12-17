if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spINVOICES_LINE_ITEMS_ConvertQuote' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spINVOICES_LINE_ITEMS_ConvertQuote;
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
Create Procedure dbo.spINVOICES_LINE_ITEMS_ConvertQuote
	( @LINE_ITEM_ID     uniqueidentifier output
	, @MODIFIED_USER_ID uniqueidentifier
	, @QUOTE_ID         uniqueidentifier
	, @INVOICE_ID       uniqueidentifier
	, @REPEAT_ONLY      bit
	, @REPEAT_COMMENT   nvarchar(100)
	, @POSITION         int output
	)
as
  begin
	set nocount on
	
	declare @LINE_GROUP_ID         uniqueidentifier;
	declare @LINE_ITEM_TYPE        nvarchar( 25);
	declare @NAME                  nvarchar(100);
	declare @MFT_PART_NUM          nvarchar( 50);
	declare @VENDOR_PART_NUM       nvarchar( 50);
	declare @PRODUCT_TEMPLATE_ID   uniqueidentifier;
	declare @PARENT_TEMPLATE_ID    uniqueidentifier;
	declare @TAX_CLASS             nvarchar( 25);
	declare @QUANTITY              float;
	declare @COST_PRICE            money;
	declare @COST_USDOLLAR         money;
	declare @LIST_PRICE            money;
	declare @LIST_USDOLLAR         money;
	declare @UNIT_PRICE            money;
	declare @UNIT_USDOLLAR         money;
	-- 01/27/2015 Paul.  Move @TAX_USDOLLAR up for better Oracle processing. 
	declare @TAX_USDOLLAR          money;
	declare @TAXRATE_ID            uniqueidentifier;
	declare @TAX                   money;
	declare @EXTENDED_PRICE        money;
	declare @EXTENDED_USDOLLAR     money;
	declare @DISCOUNT_ID           uniqueidentifier;
	declare @PRICING_FORMULA       nvarchar( 25);
	declare @PRICING_FACTOR        float;
	declare @DISCOUNT_PRICE        money;
	declare @DISCOUNT_USDOLLAR     money;
	declare @DESCRIPTION           nvarchar(4000);

-- #if SQL_Server /*
	declare items_cursor cursor for
	select	  LINE_GROUP_ID       
		, LINE_ITEM_TYPE      
		, left(rtrim(NAME + ' ' + isnull(@REPEAT_COMMENT, '')), 100)
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
		, cast(DESCRIPTION as nvarchar(4000))
	  from            QUOTES_LINE_ITEMS
	  left outer join QUOTES_LINE_ITEMS_CSTM
	               on QUOTES_LINE_ITEMS_CSTM.ID_C = QUOTES_LINE_ITEMS.ID
	 where QUOTES_LINE_ITEMS.QUOTE_ID = @QUOTE_ID
	   and QUOTES_LINE_ITEMS.DELETED  = 0
	 order by POSITION;
-- #endif SQL_Server */

	open items_cursor;
	fetch next from items_cursor into 
		  @LINE_GROUP_ID       
		, @LINE_ITEM_TYPE      
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
		, @DESCRIPTION         ;
	while @@FETCH_STATUS = 0 begin -- do
		set @LINE_ITEM_ID = newid();
		insert into INVOICES_LINE_ITEMS
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, INVOICE_ID          
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
			)
		values
			( @LINE_ITEM_ID
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @INVOICE_ID                 
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
			);

		insert into INVOICES_LINE_ITEMS_CSTM
			( ID_C
			)
		values
			( @LINE_ITEM_ID
			);

		set @POSITION = @POSITION + 1;
		fetch next from items_cursor into 
			  @LINE_GROUP_ID       
			, @LINE_ITEM_TYPE      
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
			, @DESCRIPTION         ;
/* -- #if Oracle
		IF items_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close items_cursor;
	deallocate items_cursor;
  end
GO
 
Grant Execute on dbo.spINVOICES_LINE_ITEMS_ConvertQuote to public;
GO
 
