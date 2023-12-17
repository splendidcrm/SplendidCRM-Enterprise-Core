if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_LINE_ITEMS')
	Drop View dbo.vwORDERS_LINE_ITEMS;
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
-- 05/12/2009 Paul.  DATE_MODIFIED is needed to check for last modified. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 07/11/2010 Paul.  Add PARENT_TEMPLATE_ID. 
-- 07/15/2010 Paul.  Add GROUP_ID for options management. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/12/2010 Paul.  Add Discount fields to better match Sugar. 
-- 08/13/2010 Paul.  Use LINE_GROUP_ID instead of GROUP_ID.
-- 08/17/2010 Paul.  Add PRICING fields so that they can be customized per line item. 
-- 03/15/2012 Paul.  Move Date Supported fields to the base view so that they can be used by the workflow engine. 
-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
-- 12/13/2021 Paul.  The React Client requires PRODUCT_TEMPLATE_NAME as it is defined in EditView for line items. 
Create View dbo.vwORDERS_LINE_ITEMS
as
select ORDERS_LINE_ITEMS.ID
     , ORDERS_LINE_ITEMS.ORDER_ID
     , ORDERS_LINE_ITEMS.LINE_GROUP_ID
     , ORDERS_LINE_ITEMS.LINE_ITEM_TYPE
     , ORDERS_LINE_ITEMS.POSITION
     , ORDERS_LINE_ITEMS.NAME
     , ORDERS_LINE_ITEMS.MFT_PART_NUM
     , ORDERS_LINE_ITEMS.VENDOR_PART_NUM
     , ORDERS_LINE_ITEMS.PRODUCT_TEMPLATE_ID
     , ORDERS_LINE_ITEMS.PARENT_TEMPLATE_ID
     , ORDERS_LINE_ITEMS.TAX_CLASS
     , ORDERS_LINE_ITEMS.TAXRATE_ID
     , ORDERS_LINE_ITEMS.QUANTITY
     , ORDERS_LINE_ITEMS.COST_PRICE
     , ORDERS_LINE_ITEMS.COST_USDOLLAR
     , ORDERS_LINE_ITEMS.LIST_PRICE
     , ORDERS_LINE_ITEMS.LIST_USDOLLAR
     , ORDERS_LINE_ITEMS.UNIT_PRICE
     , ORDERS_LINE_ITEMS.UNIT_USDOLLAR
     , ORDERS_LINE_ITEMS.TAX
     , ORDERS_LINE_ITEMS.TAX_USDOLLAR
     , ORDERS_LINE_ITEMS.EXTENDED_PRICE
     , ORDERS_LINE_ITEMS.EXTENDED_USDOLLAR
     , ORDERS_LINE_ITEMS.PRICING_FORMULA
     , ORDERS_LINE_ITEMS.PRICING_FACTOR
     , ORDERS_LINE_ITEMS.DISCOUNT_PRICE
     , ORDERS_LINE_ITEMS.DISCOUNT_USDOLLAR
     , ORDERS_LINE_ITEMS.DATE_ENTERED
     , ORDERS_LINE_ITEMS.DATE_MODIFIED
     , ORDERS_LINE_ITEMS.DATE_MODIFIED_UTC
     , ORDERS_LINE_ITEMS.DESCRIPTION
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME      as MODIFIED_BY
     , ORDERS_LINE_ITEMS.CREATED_BY     as CREATED_BY_ID
     , ORDERS_LINE_ITEMS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , DISCOUNTS.ID                     as DISCOUNT_ID
     , DISCOUNTS.NAME                   as DISCOUNT_NAME
     , TAX_RATES.NAME                   as TAXRATE_NAME
     , TAX_RATES.VALUE                  as TAXRATE_VALUE
     , ORDERS_LINE_ITEMS.DATE_ORDER_SHIPPED
     , ORDERS_LINE_ITEMS.DATE_SUPPORT_EXPIRES
     , ORDERS_LINE_ITEMS.DATE_SUPPORT_STARTS
     , ORDERS_LINE_ITEMS.NAME           as PRODUCT_TEMPLATE_NAME
     , ORDERS_LINE_ITEMS_CSTM.*
  from            ORDERS_LINE_ITEMS
  left outer join ORDERS
               on ORDERS.ID                   = ORDERS_LINE_ITEMS.ORDER_ID
  left outer join DISCOUNTS
               on DISCOUNTS.ID                = ORDERS_LINE_ITEMS.DISCOUNT_ID
  left outer join TAX_RATES
               on TAX_RATES.ID                = ORDERS_LINE_ITEMS.TAXRATE_ID
  left outer join USERS                         USERS_CREATED_BY
               on USERS_CREATED_BY.ID         = ORDERS_LINE_ITEMS.CREATED_BY
  left outer join USERS                         USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID        = ORDERS_LINE_ITEMS.MODIFIED_USER_ID
  left outer join ORDERS_LINE_ITEMS_CSTM
               on ORDERS_LINE_ITEMS_CSTM.ID_C = ORDERS_LINE_ITEMS.ID
 where ORDERS_LINE_ITEMS.DELETED = 0

GO

Grant Select on dbo.vwORDERS_LINE_ITEMS to public;
GO

