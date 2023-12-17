if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS_Legacy')
	Drop View dbo.vwPRODUCTS_Legacy;
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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 11/27/2006 Paul.  Return TEAM.ID so that a deleted team will return NULL even if a value remains in the related record. 
-- 11/09/2007 Paul.  ASSIGNED_USER_ID is needed for ACL. 
-- 11/11/2007 Paul.  ASSIGNED_USER_ID must be a valid value, otherwise the select will succeed, but no results will be displayed. 
-- 01/02/2008 Paul.  Restore editing of items in the PRODUCTS table, but make sure that we still allow the display of order line items. 
-- 08/30/2009 Paul.  All module views must have a TEAM_SET_ID. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 04/10/2021 Paul.  React client requires DATE_MODIFIED_UTC in all tables. 
Create View dbo.vwPRODUCTS_Legacy
as
select PRODUCTS.ID
     , PRODUCTS.NAME
     , PRODUCTS.STATUS
     , PRODUCTS.QUANTITY
     , PRODUCTS.DATE_PURCHASED
     , PRODUCTS.DATE_SUPPORT_EXPIRES
     , PRODUCTS.DATE_SUPPORT_STARTS
     , PRODUCTS.WEBSITE
     , PRODUCTS.MFT_PART_NUM
     , PRODUCTS.VENDOR_PART_NUM
     , PRODUCTS.SERIAL_NUMBER
     , PRODUCTS.ASSET_NUMBER
     , PRODUCTS.TAX_CLASS
     , PRODUCTS.WEIGHT
     , PRODUCTS.CURRENCY_ID
     , CURRENCIES.NAME             as CURRENCY_NAME
     , CURRENCIES.SYMBOL           as CURRENCY_SYMBOL
     , CURRENCIES.CONVERSION_RATE  as CURRENCY_CONVERSION_RATE
     , PRODUCTS.COST_PRICE
     , PRODUCTS.COST_USDOLLAR
     , PRODUCTS.LIST_PRICE
     , PRODUCTS.LIST_USDOLLAR
     , PRODUCTS.BOOK_VALUE
     , PRODUCTS.BOOK_VALUE_DATE
     , PRODUCTS.DISCOUNT_PRICE
     , PRODUCTS.DISCOUNT_USDOLLAR
     , PRODUCTS.PRICING_FACTOR
     , PRODUCTS.PRICING_FORMULA
     , PRODUCTS.SUPPORT_NAME
     , PRODUCTS.SUPPORT_CONTACT
     , PRODUCTS.SUPPORT_DESCRIPTION
     , PRODUCTS.SUPPORT_TERM
     , PRODUCTS.PRODUCT_TEMPLATE_ID
     , PRODUCTS.ACCOUNT_ID
     , ACCOUNTS.ASSIGNED_USER_ID   as ASSIGNED_USER_ID
     , ACCOUNTS.NAME               as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID   as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID    as ACCOUNT_ASSIGNED_SET_ID
     , PRODUCTS.CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID   as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID    as CONTACT_ASSIGNED_SET_ID
     , PRODUCTS.MANUFACTURER_ID
     , MANUFACTURERS.NAME          as MANUFACTURER_NAME
     , PRODUCTS.CATEGORY_ID
     , PRODUCT_CATEGORIES.NAME     as CATEGORY_NAME
     , PRODUCTS.TYPE_ID
     , PRODUCT_TYPES.NAME          as TYPE_NAME
     , PRODUCTS.QUOTE_ID
     , QUOTES.NAME                 as QUOTE_NAME
     , QUOTES.QUOTE_NUM
     , PRODUCTS.DATE_ENTERED
     , PRODUCTS.DATE_MODIFIED
     , PRODUCTS.DATE_MODIFIED_UTC
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , PRODUCTS.CREATED_BY         as CREATED_BY_ID
     , PRODUCTS.MODIFIED_USER_ID
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , PRODUCTS_CSTM.*
  from            PRODUCTS
  left outer join ACCOUNTS
               on ACCOUNTS.ID                = PRODUCTS.ACCOUNT_ID
              and ACCOUNTS.DELETED           = 0
  left outer join CONTACTS
               on CONTACTS.ID                = PRODUCTS.CONTACT_ID
              and CONTACTS.DELETED           = 0
  left outer join MANUFACTURERS
               on MANUFACTURERS.ID           = PRODUCTS.MANUFACTURER_ID
              and MANUFACTURERS.DELETED      = 0
  left outer join PRODUCT_CATEGORIES
               on PRODUCT_CATEGORIES.ID      = PRODUCTS.CATEGORY_ID
              and PRODUCT_CATEGORIES.DELETED = 0
  left outer join PRODUCT_TYPES
               on PRODUCT_TYPES.ID           = PRODUCTS.TYPE_ID
              and PRODUCT_TYPES.DELETED      = 0
  left outer join QUOTES
               on QUOTES.ID                  = PRODUCTS.QUOTE_ID
              and QUOTES.DELETED             = 0
  left outer join CURRENCIES
               on CURRENCIES.ID              = PRODUCTS.CURRENCY_ID
              and CURRENCIES.DELETED         = 0
  left outer join TEAMS
               on TEAMS.ID                   = PRODUCTS.TEAM_ID
              and TEAMS.DELETED              = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID               = PRODUCTS.TEAM_SET_ID
              and TEAM_SETS.DELETED          = 0
  left outer join USERS                        USERS_CREATED_BY
               on USERS_CREATED_BY.ID        = PRODUCTS.CREATED_BY
  left outer join USERS                        USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID       = PRODUCTS.MODIFIED_USER_ID
  left outer join PRODUCTS_CSTM
               on PRODUCTS_CSTM.ID_C         = PRODUCTS.ID
 where PRODUCTS.DELETED = 0

GO

Grant Select on dbo.vwPRODUCTS_Legacy to public;
GO

