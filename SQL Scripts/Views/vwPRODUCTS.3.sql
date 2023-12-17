if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS')
	Drop View dbo.vwPRODUCTS;
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
-- 01/01/2008 Paul.  To follow the conventions, the accounts assigned field should be ACCOUNT_ASSIGNED_USER_ID. 
-- 01/02/2008 Paul.  We need to union with the existing PRODUCTS table to that a SugarCRM import will still display data. 
-- 04/28/2008 Paul.  Added DATE_SUPPORT_EXPIRES and DATE_SUPPORT_STARTS.
-- 06/17/2008 Paul.  Exclude deleted line items or deleted product references. 
-- 05/12/2009 Paul.  Remove the old SugarCRM PRODUCTS data.  Assume that a SugarCRM database will be properly migrated. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/27/2010 Paul.  Add custom fields table. 
-- 10/20/2010 Paul.  DATE_SUPPORT_EXPIRES and DATE_SUPPORT_STARTS were returnning NULL.
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 11/13/2011 Paul.  Add DAYS_EXPIRED and MONTHS_EXPIRED. 
-- 10/30/2013 Paul.  Add SERIAL_NUMBER and SUPPORT fields. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 04/10/2021 Paul.  React client requires DATE_MODIFIED_UTC in all tables. 
-- 04/13/2021 Paul.  React client requires ORDERS_LINE_ITEM_ID
Create View dbo.vwPRODUCTS
as
select ORDERS_LINE_ITEMS.ID
     , ORDERS_LINE_ITEMS.ID           as ORDERS_LINE_ITEM_ID
     , cast(null as uniqueidentifier) as PRODUCT_ID
     , ORDERS_LINE_ITEMS.NAME         as PRODUCT_NAME
     , ORDERS_LINE_ITEMS.ORDER_ID
     , ORDERS_LINE_ITEMS.LINE_GROUP_ID
     , ORDERS_LINE_ITEMS.LINE_ITEM_TYPE
     , ORDERS_LINE_ITEMS.POSITION
     , ORDERS_LINE_ITEMS.NAME
     , ORDERS_LINE_ITEMS.MFT_PART_NUM
     , ORDERS_LINE_ITEMS.VENDOR_PART_NUM
     , ORDERS_LINE_ITEMS.PRODUCT_TEMPLATE_ID
     , ORDERS_LINE_ITEMS.TAX_CLASS
     , ORDERS_LINE_ITEMS.QUANTITY
     , ORDERS_LINE_ITEMS.COST_PRICE
     , ORDERS_LINE_ITEMS.COST_USDOLLAR
     , ORDERS_LINE_ITEMS.LIST_PRICE
     , ORDERS_LINE_ITEMS.LIST_USDOLLAR
     , ORDERS_LINE_ITEMS.UNIT_PRICE
     , ORDERS_LINE_ITEMS.UNIT_USDOLLAR
     , ORDERS_LINE_ITEMS.EXTENDED_PRICE
     , ORDERS_LINE_ITEMS.EXTENDED_USDOLLAR
     , ORDERS_LINE_ITEMS.DESCRIPTION
     , ORDERS.NAME                    as ORDER_NAME
     , ORDERS.MODIFIED_USER_ID
     , ORDERS.ORDER_STAGE
     , ORDERS.ASSIGNED_USER_ID
     , ORDERS.ASSIGNED_SET_ID
     , ORDERS.DATE_ENTERED
     , ORDERS.DATE_MODIFIED
     , ORDERS.DATE_MODIFIED_UTC
     , isnull(ORDERS.DATE_ORDER_DUE, ORDERS.DATE_ENTERED)              as DATE_PURCHASED
     , ORDERS_LINE_ITEMS.DATE_SUPPORT_EXPIRES                          as DATE_SUPPORT_EXPIRES
     , ORDERS_LINE_ITEMS.DATE_SUPPORT_STARTS                           as DATE_SUPPORT_STARTS
     , datediff(dd, ORDERS_LINE_ITEMS.DATE_SUPPORT_EXPIRES, getdate()) as DAYS_EXPIRED
     , datediff(mm, ORDERS_LINE_ITEMS.DATE_SUPPORT_EXPIRES, getdate()) as MONTHS_EXPIRED
     , MANUFACTURERS.ID               as MANUFACTURER_ID
     , MANUFACTURERS.NAME             as MANUFACTURER_NAME
     , PRODUCT_CATEGORIES.ID          as CATEGORY_ID
     , PRODUCT_CATEGORIES.NAME        as CATEGORY_NAME
     , PRODUCT_TYPES.ID               as TYPE_ID
     , PRODUCT_TYPES.NAME             as TYPE_NAME
     , CURRENCIES.ID                  as CURRENCY_ID
     , CURRENCIES.NAME                as CURRENCY_NAME
     , CURRENCIES.SYMBOL              as CURRENCY_SYMBOL
     , CURRENCIES.CONVERSION_RATE     as CURRENCY_CONVERSION_RATE
     , ORDERS_ACCOUNTS.ACCOUNT_ID     as ACCOUNT_ID
     , ACCOUNTS.NAME                  as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID      as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID       as ACCOUNT_ASSIGNED_SET_ID
     , CONTACTS.ID                    as CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID      as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID       as CONTACT_ASSIGNED_SET_ID
     , TEAMS.ID                       as TEAM_ID
     , TEAMS.NAME                     as TEAM_NAME
     , USERS_CREATED_BY.USER_NAME     as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME    as MODIFIED_BY
     , ORDERS.CREATED_BY              as CREATED_BY_ID
     , TEAM_SETS.ID                   as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME        as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST        as TEAM_SET_LIST
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ORDERS_LINE_ITEMS.SERIAL_NUMBER
     , ORDERS_LINE_ITEMS.ASSET_NUMBER
     , ORDERS_LINE_ITEMS.SUPPORT_NAME
     , ORDERS_LINE_ITEMS.SUPPORT_CONTACT
     , ORDERS_LINE_ITEMS.SUPPORT_TERM
     , ORDERS_LINE_ITEMS.SUPPORT_DESCRIPTION
     , ORDERS_LINE_ITEMS_CSTM.*
  from            ORDERS_LINE_ITEMS
       inner join ORDERS
               on ORDERS.ID                     = ORDERS_LINE_ITEMS.ORDER_ID
              and ORDERS.DELETED                = 0
  left outer join ORDERS_LINE_ITEMS_CSTM
               on ORDERS_LINE_ITEMS_CSTM.ID_C   = ORDERS_LINE_ITEMS.ID
              and ORDERS.DELETED                = 0
  left outer join PRODUCT_TEMPLATES
               on PRODUCT_TEMPLATES.ID          = ORDERS_LINE_ITEMS.PRODUCT_TEMPLATE_ID
              and PRODUCT_TEMPLATES.DELETED     = 0
  left outer join MANUFACTURERS
               on MANUFACTURERS.ID              = PRODUCT_TEMPLATES.MANUFACTURER_ID
              and MANUFACTURERS.DELETED         = 0
  left outer join PRODUCT_CATEGORIES
               on PRODUCT_CATEGORIES.ID         = PRODUCT_TEMPLATES.CATEGORY_ID
              and PRODUCT_CATEGORIES.DELETED    = 0
  left outer join PRODUCT_TYPES
               on PRODUCT_TYPES.ID              = PRODUCT_TEMPLATES.TYPE_ID
              and PRODUCT_TYPES.DELETED         = 0
  left outer join ORDERS_ACCOUNTS
               on ORDERS_ACCOUNTS.ORDER_ID      = ORDERS.ID
              and ORDERS_ACCOUNTS.ACCOUNT_ROLE  = N'Bill To'
              and ORDERS_ACCOUNTS.DELETED       = 0
  left outer join ACCOUNTS
               on ACCOUNTS.ID                   = ORDERS_ACCOUNTS.ACCOUNT_ID
              and ACCOUNTS.DELETED              = 0
  left outer join ORDERS_CONTACTS
               on ORDERS_CONTACTS.ORDER_ID      = ORDERS.ID
              and ORDERS_CONTACTS.CONTACT_ROLE  = N'Bill To'
              and ORDERS_CONTACTS.DELETED       = 0
  left outer join CONTACTS
               on CONTACTS.ID                   = ORDERS_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED              = 0
  left outer join CURRENCIES
               on CURRENCIES.ID                 = ORDERS.CURRENCY_ID
              and CURRENCIES.DELETED            = 0
  left outer join TEAMS
               on TEAMS.ID                      = ORDERS.TEAM_ID
              and TEAMS.DELETED                 = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                  = ORDERS.TEAM_SET_ID
              and TEAM_SETS.DELETED             = 0
  left outer join USERS                           USERS_CREATED_BY
               on USERS_CREATED_BY.ID           = ORDERS.CREATED_BY
  left outer join USERS                           USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID          = ORDERS.MODIFIED_USER_ID
 where ORDERS.ORDER_STAGE in (N'Ordered', N'Confirmed', N'Partially Shipped & Invoi', N'Closed - Shipped & Invoic', N'Shipped')
   and ORDERS_LINE_ITEMS.DELETED = 0
GO

Grant Select on dbo.vwPRODUCTS to public;
GO

