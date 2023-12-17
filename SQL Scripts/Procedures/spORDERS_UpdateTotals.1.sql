if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spORDERS_UpdateTotals' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spORDERS_UpdateTotals;
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
-- 12/29/2007 Paul.  Dramatically simplify the procedure by using sum function. 
-- This also makes it easier to port to Oracle. 
-- 04/22/2008 Paul.  Make sure that the TAX is not null so that the total will be computed properly. 
-- 08/17/2010 Paul.  Do not include the Subtotal values.  They should already be incorporated into the DISCOUNT value. 	
-- 10/24/2012 Paul.  The discount needs to be recalculated, but note that the DISCOUNT_PRICE already includes the quantity. 
-- 01/22/2013 Paul.  Change procedure to perform a single ORDERS update. 
-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
-- 03/08/2015 Paul.  DISCOUNT_PRICE was null when syncing with QuickBooks. 
-- 01/30/2019 Paul.  Trigger audit record so workflow will have access to custom fields. 
Create Procedure dbo.spORDERS_UpdateTotals
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	-- 01/22/2013 Paul.  Change procedure to perform a single ORDERS update. 
	declare @TAX_SHIPPING      bit;
	declare @TAX_LINE_ITEMS    bit;
	declare @TAX_RATE_LINE_ITEM float;
	declare @TAX_RATE          float;
	declare @EXCHANGE_RATE     float;
	declare @SUBTOTAL_USDOLLAR money;
	declare @SUBTOTAL          money;
	declare @DISCOUNT_USDOLLAR money;
	declare @DISCOUNT          money;
	declare @TAX_USDOLLAR      money;
	declare @TAX               money;
	declare @SHIPPING_USDOLLAR money;
	declare @SHIPPING          money;
	declare @TOTAL_USDOLLAR    money;
	declare @TOTAL             money;

	-- 08/02/2010 Paul.  Some states require that the shipping be taxes. We will use one flag for Quotes, Orders and Invoices. 
	set @TAX_SHIPPING   = dbo.fnCONFIG_Boolean('Orders.TaxShipping');
	set @TAX_LINE_ITEMS = dbo.fnCONFIG_Boolean('Orders.TaxLineItems');
	if exists(select * from vwORDERS where ID = @ID) begin -- then
		select @TAX_RATE = min(VALUE) / 100
		  from      ORDERS
		 inner join vwTAX_RATES
		         on vwTAX_RATES.ID = ORDERS.TAXRATE_ID
		 where ORDERS.ID = @ID;
		set @TAX_RATE = isnull(@TAX_RATE, 0.0);

		-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
		-- 04/18/2016 Paul.  Check for DISCOUNT_PRICE null so that we don't get a warning. 
		if @TAX_LINE_ITEMS = 1 begin -- then
			select @SUBTOTAL      = (select sum(QUANTITY * UNIT_PRICE    ) from vwORDERS_LINE_ITEMS where ORDER_ID = ORDERS.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')))
			     , @DISCOUNT      = (select sum(           DISCOUNT_PRICE) from vwORDERS_LINE_ITEMS where ORDER_ID = ORDERS.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')) and DISCOUNT_PRICE is not null)
			     , @TAX           = (select sum(           TAX           ) from vwORDERS_LINE_ITEMS where ORDER_ID = ORDERS.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')) and TAXRATE_ID is not null)
			     , @EXCHANGE_RATE = isnull(nullif(EXCHANGE_RATE, 0.0), 1.0)
			     , @SHIPPING      = isnull(SHIPPING, 0.0)
			  from ORDERS
			 where ID = @ID;
		end else begin
			-- 08/17/2010 Paul.  Do not include the Subtotal values.  They should already be incorporated into the DISCOUNT value. 	
			-- 10/24/2012 Paul.  The discount needs to be recalculated, but note that the DISCOUNT_PRICE already includes the quantity. 
			-- 01/22/2013 Paul.  Tax should include discounts in calculation. 
			select @SUBTOTAL      = (select sum( QUANTITY * UNIT_PRICE                                           ) from vwORDERS_LINE_ITEMS where ORDER_ID = ORDERS.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')))
			     , @DISCOUNT      = (select sum(                         isnull(DISCOUNT_PRICE, 0.0)             ) from vwORDERS_LINE_ITEMS where ORDER_ID = ORDERS.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')) and DISCOUNT_PRICE is not null)
			     , @TAX           = (select sum((QUANTITY * UNIT_PRICE - isnull(DISCOUNT_PRICE, 0.0)) * @TAX_RATE) from vwORDERS_LINE_ITEMS where ORDER_ID = ORDERS.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')) and TAX_CLASS = 'Taxable')
			     , @EXCHANGE_RATE = isnull(nullif(EXCHANGE_RATE, 0.0), 1.0)
			     , @SHIPPING      = isnull(SHIPPING, 0.0)
			  from ORDERS
			 where ID = @ID;
		end -- if;
		-- 08/18/2010 Paul.  Separate tax of shipping to ease migration to Oracle. 
		if @TAX_SHIPPING = 1 begin -- then
			set @TAX = @TAX + @SHIPPING * @TAX_RATE;
		end -- if;
		set @TOTAL             = isnull(@SUBTOTAL, 0.0) - isnull(@DISCOUNT, 0.0) + isnull(@TAX, 0.0) + isnull(@SHIPPING, 0.0);
		set @SUBTOTAL_USDOLLAR = @SUBTOTAL / @EXCHANGE_RATE;
		set @DISCOUNT_USDOLLAR = @DISCOUNT / @EXCHANGE_RATE;
		set @TAX_USDOLLAR      = @TAX      / @EXCHANGE_RATE;
		set @SHIPPING_USDOLLAR = @SHIPPING / @EXCHANGE_RATE;
		set @TOTAL_USDOLLAR    = @TOTAL    / @EXCHANGE_RATE;

		-- 10/24/2012 Paul.  Need to update DISCOUNT_USDOLLAR. 
		-- 01/22/2013 Paul.  Change procedure to perform a single ORDERS update. 
		update ORDERS
		   set SUBTOTAL          = @SUBTOTAL
		     , SUBTOTAL_USDOLLAR = @SUBTOTAL_USDOLLAR
		     , DISCOUNT          = @DISCOUNT
		     , DISCOUNT_USDOLLAR = @DISCOUNT_USDOLLAR
		     , TAX               = @TAX
		     , TAX_USDOLLAR      = @TAX_USDOLLAR
		     , SHIPPING          = @SHIPPING
		     , SHIPPING_USDOLLAR = @SHIPPING_USDOLLAR
		     , TOTAL             = @TOTAL
		     , TOTAL_USDOLLAR    = @TOTAL_USDOLLAR
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where ID                = @ID;

		-- 01/30/2019 Paul.  Trigger audit record so workflow will have access to custom fields. 
		update ORDERS_CSTM
		   set ID_C              = ID_C
		 where ID_C              = @ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spORDERS_UpdateTotals to public;
GO
 
 
