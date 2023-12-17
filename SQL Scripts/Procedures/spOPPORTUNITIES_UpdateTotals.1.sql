if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOPPORTUNITIES_UpdateTotals' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOPPORTUNITIES_UpdateTotals;
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
Create Procedure dbo.spOPPORTUNITIES_UpdateTotals
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @TAX_SHIPPING       bit;
	declare @TAX_LINE_ITEMS     bit;
	declare @TAX_RATE_LINE_ITEM float;
	declare @TAX_RATE           float;
	declare @EXCHANGE_RATE      float;
	declare @SUBTOTAL_USDOLLAR  money;
	declare @SUBTOTAL           money;
	declare @DISCOUNT_USDOLLAR  money;
	declare @DISCOUNT           money;
	declare @TAX_USDOLLAR       money;
	declare @TAX                money;
	declare @SHIPPING_USDOLLAR  money;
	declare @SHIPPING           money;
	declare @TOTAL_USDOLLAR     money;
	declare @TOTAL              money;

	set @TAX_SHIPPING   = dbo.fnCONFIG_Boolean('Orders.TaxShipping');
	set @TAX_LINE_ITEMS = dbo.fnCONFIG_Boolean('Orders.TaxLineItems');
	if exists(select * from vwOPPORTUNITIES where ID = @ID) begin -- then
		-- 03/06/2016 Paul.  Opportunities does not deal with tax or exchange rate. 
		set @TAX_RATE      = 0.0;
		set @EXCHANGE_RATE = 1.0;
		set @SHIPPING      = 0.0;
		set @TAX           = 0.0;

		if @TAX_LINE_ITEMS = 1 begin -- then
			select @SUBTOTAL      = (select sum(QUANTITY * UNIT_PRICE    ) from vwOPPORTUNITIES_LINE_ITEMS where OPPORTUNITY_ID = OPPORTUNITIES.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')))
			     , @DISCOUNT      = (select sum(           DISCOUNT_PRICE) from vwOPPORTUNITIES_LINE_ITEMS where OPPORTUNITY_ID = OPPORTUNITIES.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')))
			  from OPPORTUNITIES
			 where ID = @ID;
		end else begin
			select @SUBTOTAL      = (select sum( QUANTITY * UNIT_PRICE                                           ) from vwOPPORTUNITIES_LINE_ITEMS where OPPORTUNITY_ID = OPPORTUNITIES.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')))
			     , @DISCOUNT      = (select sum(                         isnull(DISCOUNT_PRICE, 0.0)             ) from vwOPPORTUNITIES_LINE_ITEMS where OPPORTUNITY_ID = OPPORTUNITIES.ID and (NAME is not null or PRODUCT_TEMPLATE_ID is not null) and (LINE_ITEM_TYPE is null or LINE_ITEM_TYPE not in (N'Comment', N'Subtotal')))
			  from OPPORTUNITIES
			 where ID = @ID;
		end -- if;
		if @TAX_SHIPPING = 1 begin -- then
			set @TAX = @TAX + @SHIPPING * @TAX_RATE;
		end -- if;
		set @TOTAL             = isnull(@SUBTOTAL, 0.0) - isnull(@DISCOUNT, 0.0) + isnull(@TAX, 0.0) + isnull(@SHIPPING, 0.0);
		set @SUBTOTAL_USDOLLAR = @SUBTOTAL / @EXCHANGE_RATE;
		set @DISCOUNT_USDOLLAR = @DISCOUNT / @EXCHANGE_RATE;
		set @TAX_USDOLLAR      = @TAX      / @EXCHANGE_RATE;
		set @SHIPPING_USDOLLAR = @SHIPPING / @EXCHANGE_RATE;
		set @TOTAL_USDOLLAR    = @TOTAL    / @EXCHANGE_RATE;

		update OPPORTUNITIES
		   set AMOUNT            = @TOTAL
		     , AMOUNT_USDOLLAR   = @TOTAL_USDOLLAR
		--     , SUBTOTAL          = @SUBTOTAL
		--     , SUBTOTAL_USDOLLAR = @SUBTOTAL_USDOLLAR
		--     , DISCOUNT          = @DISCOUNT
		--     , DISCOUNT_USDOLLAR = @DISCOUNT_USDOLLAR
		--     , TAX               = @TAX
		--     , TAX_USDOLLAR      = @TAX_USDOLLAR
		--     , SHIPPING          = @SHIPPING
		--     , SHIPPING_USDOLLAR = @SHIPPING_USDOLLAR
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where ID                = @ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spOPPORTUNITIES_UpdateTotals to public;
GO
 
 
