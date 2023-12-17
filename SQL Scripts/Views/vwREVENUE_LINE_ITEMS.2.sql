if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwREVENUE_LINE_ITEMS')
	Drop View dbo.vwREVENUE_LINE_ITEMS;
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
Create View dbo.vwREVENUE_LINE_ITEMS
as
select REVENUE_LINE_ITEMS.ID
     , REVENUE_LINE_ITEMS.OPPORTUNITY_ID
     , REVENUE_LINE_ITEMS.LINE_GROUP_ID
     , REVENUE_LINE_ITEMS.LINE_ITEM_TYPE
     , REVENUE_LINE_ITEMS.POSITION
     , REVENUE_LINE_ITEMS.NAME
     , REVENUE_LINE_ITEMS.MFT_PART_NUM
     , REVENUE_LINE_ITEMS.VENDOR_PART_NUM
     , REVENUE_LINE_ITEMS.PRODUCT_TEMPLATE_ID
     , REVENUE_LINE_ITEMS.PARENT_TEMPLATE_ID
     , REVENUE_LINE_ITEMS.TAX_CLASS
     , REVENUE_LINE_ITEMS.TAXRATE_ID
     , REVENUE_LINE_ITEMS.QUANTITY
     , REVENUE_LINE_ITEMS.COST_PRICE
     , REVENUE_LINE_ITEMS.COST_USDOLLAR
     , REVENUE_LINE_ITEMS.LIST_PRICE
     , REVENUE_LINE_ITEMS.LIST_USDOLLAR
     , REVENUE_LINE_ITEMS.UNIT_PRICE
     , REVENUE_LINE_ITEMS.UNIT_USDOLLAR
     , REVENUE_LINE_ITEMS.TAX
     , REVENUE_LINE_ITEMS.TAX_USDOLLAR
     , REVENUE_LINE_ITEMS.EXTENDED_PRICE
     , REVENUE_LINE_ITEMS.EXTENDED_USDOLLAR
     , REVENUE_LINE_ITEMS.PRICING_FORMULA
     , REVENUE_LINE_ITEMS.PRICING_FACTOR
     , REVENUE_LINE_ITEMS.DISCOUNT_PRICE
     , REVENUE_LINE_ITEMS.DISCOUNT_USDOLLAR
     , REVENUE_LINE_ITEMS.DATE_ENTERED
     , REVENUE_LINE_ITEMS.DATE_MODIFIED
     , REVENUE_LINE_ITEMS.DATE_MODIFIED_UTC
     , REVENUE_LINE_ITEMS.DESCRIPTION
     , REVENUE_LINE_ITEMS.OPPORTUNITY_TYPE
     , REVENUE_LINE_ITEMS.LEAD_SOURCE
     , REVENUE_LINE_ITEMS.DATE_CLOSED
     , REVENUE_LINE_ITEMS.NEXT_STEP
     , REVENUE_LINE_ITEMS.SALES_STAGE
     , REVENUE_LINE_ITEMS.PROBABILITY
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME      as MODIFIED_BY
     , REVENUE_LINE_ITEMS.CREATED_BY    as CREATED_BY_ID
     , REVENUE_LINE_ITEMS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , DISCOUNTS.ID                     as DISCOUNT_ID
     , DISCOUNTS.NAME                   as DISCOUNT_NAME
     , TAX_RATES.NAME                   as TAXRATE_NAME
     , TAX_RATES.VALUE                  as TAXRATE_VALUE
     , REVENUE_LINE_ITEMS_CSTM.*
  from            REVENUE_LINE_ITEMS
  left outer join OPPORTUNITIES
               on OPPORTUNITIES.ID            = REVENUE_LINE_ITEMS.OPPORTUNITY_ID
  left outer join DISCOUNTS
               on DISCOUNTS.ID                = REVENUE_LINE_ITEMS.DISCOUNT_ID
  left outer join TAX_RATES
               on TAX_RATES.ID                = REVENUE_LINE_ITEMS.TAXRATE_ID
  left outer join USERS                         USERS_CREATED_BY
               on USERS_CREATED_BY.ID         = REVENUE_LINE_ITEMS.CREATED_BY
  left outer join USERS                         USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID        = REVENUE_LINE_ITEMS.MODIFIED_USER_ID
  left outer join REVENUE_LINE_ITEMS_CSTM
               on REVENUE_LINE_ITEMS_CSTM.ID_C = REVENUE_LINE_ITEMS.ID
 where REVENUE_LINE_ITEMS.DELETED = 0

GO

Grant Select on dbo.vwREVENUE_LINE_ITEMS to public;
GO

