if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS_FromTemplate')
	Drop View dbo.vwPRODUCTS_FromTemplate;
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
-- 08/08/2009 Paul.  QUOTE_NUM, ORDER_NUM and INVOICE_NUM are all strings now.
-- 09/01/2009 Paul.  Add TEAM_SET_ID so that the team filter will not fail. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/13/2010 Paul.  PRICING_FACTOR and PRICING_FORMULA were moved to DISCOUNTS table. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPRODUCTS_FromTemplate
as
select PRODUCT_TEMPLATES.ID
     , PRODUCT_TEMPLATES.NAME
     , PRODUCT_TEMPLATES.STATUS
     , PRODUCT_TEMPLATES.QUANTITY
     , cast(null as datetime)         as DATE_PURCHASED
     , cast(null as datetime)         as DATE_SUPPORT_EXPIRES
     , cast(null as datetime)         as DATE_SUPPORT_STARTS
     , PRODUCT_TEMPLATES.WEBSITE
     , PRODUCT_TEMPLATES.MFT_PART_NUM
     , PRODUCT_TEMPLATES.VENDOR_PART_NUM
     , cast(null as nvarchar(50))     as SERIAL_NUMBER
     , cast(null as nvarchar(50))     as ASSET_NUMBER
     , PRODUCT_TEMPLATES.TAX_CLASS
     , PRODUCT_TEMPLATES.WEIGHT
     , PRODUCT_TEMPLATES.CURRENCY_ID
     , CURRENCIES.NAME                as CURRENCY_NAME
     , CURRENCIES.SYMBOL              as CURRENCY_SYMBOL
     , CURRENCIES.CONVERSION_RATE     as CURRENCY_CONVERSION_RATE
     , PRODUCT_TEMPLATES.COST_PRICE
     , PRODUCT_TEMPLATES.COST_USDOLLAR
     , PRODUCT_TEMPLATES.LIST_PRICE
     , PRODUCT_TEMPLATES.LIST_USDOLLAR
     , cast(null as money)            as BOOK_VALUE
     , cast(null as datetime)         as BOOK_VALUE_DATE
     , PRODUCT_TEMPLATES.DISCOUNT_PRICE
     , PRODUCT_TEMPLATES.DISCOUNT_USDOLLAR
     , PRODUCT_TEMPLATES.DISCOUNT_ID
     , PRODUCT_TEMPLATES.SUPPORT_NAME
     , PRODUCT_TEMPLATES.SUPPORT_CONTACT
     , PRODUCT_TEMPLATES.SUPPORT_DESCRIPTION
     , PRODUCT_TEMPLATES.SUPPORT_TERM
     , PRODUCT_TEMPLATES.ID           as PRODUCT_TEMPLATE_ID
     , PRODUCT_TEMPLATES.ACCOUNT_ID
     , ACCOUNTS.NAME                  as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID      as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID       as ACCOUNT_ASSIGNED_SET_ID
     , cast(null as uniqueidentifier) as CONTACT_ID
     , cast(null as nvarchar(255))    as CONTACT_NAME
     , cast(null as uniqueidentifier) as CONTACT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as CONTACT_ASSIGNED_SET_ID
     , PRODUCT_TEMPLATES.MANUFACTURER_ID
     , MANUFACTURERS.NAME             as MANUFACTURER_NAME
     , PRODUCT_TEMPLATES.CATEGORY_ID
     , PRODUCT_CATEGORIES.NAME        as CATEGORY_NAME
     , PRODUCT_TEMPLATES.TYPE_ID
     , PRODUCT_TYPES.NAME             as TYPE_NAME
     , cast(null as uniqueidentifier) as QUOTE_ID
     , cast(null as nvarchar(50))     as QUOTE_NAME
     , cast(null as nvarchar(30))     as QUOTE_NUM
     , PRODUCT_TEMPLATES.DATE_ENTERED
     , PRODUCT_TEMPLATES.DATE_MODIFIED
     , cast(null as uniqueidentifier) as TEAM_ID
     , cast(null as nvarchar(128))    as TEAM_NAME
     , cast(null as uniqueidentifier) as TEAM_SET_ID
     , cast(null as nvarchar(200))    as TEAM_SET_NAME
     , USERS_CREATED_BY.USER_NAME     as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME    as MODIFIED_BY
     , PRODUCT_TEMPLATES.CREATED_BY   as CREATED_BY_ID
     , PRODUCT_TEMPLATES.MODIFIED_USER_ID
     , PRODUCT_TEMPLATES.DESCRIPTION
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , PRODUCTS_CSTM.*
  from            PRODUCT_TEMPLATES
  left outer join ACCOUNTS
               on ACCOUNTS.ID                = PRODUCT_TEMPLATES.ACCOUNT_ID
              and ACCOUNTS.DELETED           = 0
  left outer join MANUFACTURERS
               on MANUFACTURERS.ID           = PRODUCT_TEMPLATES.MANUFACTURER_ID
              and MANUFACTURERS.DELETED      = 0
  left outer join PRODUCT_CATEGORIES
               on PRODUCT_CATEGORIES.ID      = PRODUCT_TEMPLATES.CATEGORY_ID
              and PRODUCT_CATEGORIES.DELETED = 0
  left outer join PRODUCT_TYPES
               on PRODUCT_TYPES.ID           = PRODUCT_TEMPLATES.TYPE_ID
              and PRODUCT_TYPES.DELETED      = 0
  left outer join CURRENCIES
               on CURRENCIES.ID              = PRODUCT_TEMPLATES.CURRENCY_ID
              and CURRENCIES.DELETED         = 0
  left outer join USERS                        USERS_CREATED_BY
               on USERS_CREATED_BY.ID        = PRODUCT_TEMPLATES.CREATED_BY
  left outer join USERS                        USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID       = PRODUCT_TEMPLATES.MODIFIED_USER_ID
  left outer join PRODUCTS_CSTM
               on PRODUCTS_CSTM.ID_C         = PRODUCT_TEMPLATES.ID
 where PRODUCT_TEMPLATES.DELETED = 0

GO

Grant Select on dbo.vwPRODUCTS_FromTemplate to public;
GO

