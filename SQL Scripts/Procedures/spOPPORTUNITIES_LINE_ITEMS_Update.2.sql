if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOPPORTUNITIES_LINE_ITEMS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOPPORTUNITIES_LINE_ITEMS_Update;
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
Create Procedure dbo.spOPPORTUNITIES_LINE_ITEMS_Update
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
	
	exec dbo.spREVENUE_LINE_ITEMS_Update @ID output
		, @MODIFIED_USER_ID     
		, @OPPORTUNITY_ID       
		, @LINE_GROUP_ID        
		, @LINE_ITEM_TYPE       
		, @POSITION             
		, @NAME                 
		, @MFT_PART_NUM         
		, @VENDOR_PART_NUM      
		, @PRODUCT_TEMPLATE_ID  
		, @TAX_CLASS            
		, @QUANTITY             
		, @COST_PRICE           
		, @LIST_PRICE           
		, @UNIT_PRICE           
		, @DESCRIPTION          
		, @PARENT_TEMPLATE_ID   
		, @DISCOUNT_ID          
		, @DISCOUNT_PRICE       
		, @PRICING_FORMULA      
		, @PRICING_FACTOR       
		, @TAXRATE_ID           
		, @OPPORTUNITY_TYPE     
		, @LEAD_SOURCE          
		, @DATE_CLOSED          
		, @NEXT_STEP            
		, @SALES_STAGE          
		, @PROBABILITY;
  end
GO

Grant Execute on dbo.spOPPORTUNITIES_LINE_ITEMS_Update to public;
GO

