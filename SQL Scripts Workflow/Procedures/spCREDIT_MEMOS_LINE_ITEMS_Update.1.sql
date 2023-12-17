if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCREDIT_MEMOS_LINE_ITEMS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCREDIT_MEMOS_LINE_ITEMS_Update;
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
Create Procedure dbo.spCREDIT_MEMOS_LINE_ITEMS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @INVOICE_ID           uniqueidentifier
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
	, @PARENT_TEMPLATE_ID   uniqueidentifier = null
	, @DISCOUNT_ID          uniqueidentifier = null
	, @DISCOUNT_PRICE       money = null
	, @PRICING_FORMULA      nvarchar( 25) = null
	, @PRICING_FACTOR       float = null
	, @TAXRATE_ID           uniqueidentifier = null
	)
as
  begin
	-- 02/24/2015 Paul.  The CreditMemo is like a Payment, but uses Invoice line items. 
	-- We will not be matching line items to memos. 
	return;
  end
GO

Grant Execute on dbo.spCREDIT_MEMOS_LINE_ITEMS_Update to public;
GO

