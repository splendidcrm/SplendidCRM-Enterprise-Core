if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_LINE_ITEMS')
	Drop View dbo.vwQUOTES_LINE_ITEMS;
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
-- 12/09/2007 Paul.  Only return items that are not deleted.  
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 07/11/2010 Paul.  Add PARENT_TEMPLATE_ID. 
-- 07/15/2010 Paul.  Add GROUP_ID for options management. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/12/2010 Paul.  Add Discount fields to better match Sugar. 
-- 08/13/2010 Paul.  Use LINE_GROUP_ID instead of GROUP_ID.
-- 08/17/2010 Paul.  Add PRICING fields so that they can be customized per line item. 
-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
-- 12/13/2021 Paul.  The React Client requires PRODUCT_TEMPLATE_NAME as it is defined in EditView for line items. 
Create View dbo.vwQUOTES_LINE_ITEMS
as
select QUOTES_LINE_ITEMS.ID
     , QUOTES_LINE_ITEMS.QUOTE_ID
     , QUOTES_LINE_ITEMS.LINE_GROUP_ID
     , QUOTES_LINE_ITEMS.LINE_ITEM_TYPE
     , QUOTES_LINE_ITEMS.POSITION
     , QUOTES_LINE_ITEMS.NAME
     , QUOTES_LINE_ITEMS.MFT_PART_NUM
     , QUOTES_LINE_ITEMS.VENDOR_PART_NUM
     , QUOTES_LINE_ITEMS.PRODUCT_TEMPLATE_ID
     , QUOTES_LINE_ITEMS.PARENT_TEMPLATE_ID
     , QUOTES_LINE_ITEMS.TAX_CLASS
     , QUOTES_LINE_ITEMS.TAXRATE_ID
     , QUOTES_LINE_ITEMS.QUANTITY
     , QUOTES_LINE_ITEMS.COST_PRICE
     , QUOTES_LINE_ITEMS.COST_USDOLLAR
     , QUOTES_LINE_ITEMS.LIST_PRICE
     , QUOTES_LINE_ITEMS.LIST_USDOLLAR
     , QUOTES_LINE_ITEMS.UNIT_PRICE
     , QUOTES_LINE_ITEMS.UNIT_USDOLLAR
     , QUOTES_LINE_ITEMS.TAX
     , QUOTES_LINE_ITEMS.TAX_USDOLLAR
     , QUOTES_LINE_ITEMS.EXTENDED_PRICE
     , QUOTES_LINE_ITEMS.EXTENDED_USDOLLAR
     , QUOTES_LINE_ITEMS.PRICING_FORMULA
     , QUOTES_LINE_ITEMS.PRICING_FACTOR
     , QUOTES_LINE_ITEMS.DISCOUNT_PRICE
     , QUOTES_LINE_ITEMS.DISCOUNT_USDOLLAR
     , QUOTES_LINE_ITEMS.DATE_MODIFIED
     , QUOTES_LINE_ITEMS.DATE_MODIFIED_UTC
     , QUOTES_LINE_ITEMS.DESCRIPTION
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME      as MODIFIED_BY
     , QUOTES_LINE_ITEMS.CREATED_BY     as CREATED_BY_ID
     , QUOTES_LINE_ITEMS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , DISCOUNTS.ID                     as DISCOUNT_ID
     , DISCOUNTS.NAME                   as DISCOUNT_NAME
     , TAX_RATES.NAME                   as TAXRATE_NAME
     , TAX_RATES.VALUE                  as TAXRATE_VALUE
     , QUOTES_LINE_ITEMS.NAME           as PRODUCT_TEMPLATE_NAME
     , QUOTES_LINE_ITEMS_CSTM.*
  from            QUOTES_LINE_ITEMS
  left outer join QUOTES
               on QUOTES.ID                   = QUOTES_LINE_ITEMS.QUOTE_ID
  left outer join DISCOUNTS
               on DISCOUNTS.ID                = QUOTES_LINE_ITEMS.DISCOUNT_ID
  left outer join TAX_RATES
               on TAX_RATES.ID                = QUOTES_LINE_ITEMS.TAXRATE_ID
  left outer join USERS                         USERS_CREATED_BY
               on USERS_CREATED_BY.ID         = QUOTES_LINE_ITEMS.CREATED_BY
  left outer join USERS                         USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID        = QUOTES_LINE_ITEMS.MODIFIED_USER_ID
  left outer join QUOTES_LINE_ITEMS_CSTM
               on QUOTES_LINE_ITEMS_CSTM.ID_C = QUOTES_LINE_ITEMS.ID
 where QUOTES_LINE_ITEMS.DELETED = 0

GO

Grant Select on dbo.vwQUOTES_LINE_ITEMS to public;
GO

