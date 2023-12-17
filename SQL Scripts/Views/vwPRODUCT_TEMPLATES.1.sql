if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCT_TEMPLATES')
	Drop View dbo.vwPRODUCT_TEMPLATES;
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
-- 11/08/2008 Paul.  Move description to base view. 
-- 02/03/2009 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 07/10/2010 Paul.  Add Options fields. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/17/2010 Paul.  Restore PRICING_FACTOR and PRICING_FORMULA.  Keep DISCOUNTS as a pre-defined discount. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
-- 12/13/2013 Paul.  Allow each product to have a default tax rate. 
-- 02/13/2015 Paul.  CURRENCY_ISO4217 is used by QuickBooksOnline. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 01/29/2019 Paul.  Add Tags module. 
Create View dbo.vwPRODUCT_TEMPLATES
as
select PRODUCT_TEMPLATES.ID
     , PRODUCT_TEMPLATES.NAME
     , PRODUCT_TEMPLATES.STATUS
     , PRODUCT_TEMPLATES.QUANTITY
     , PRODUCT_TEMPLATES.DATE_AVAILABLE
     , PRODUCT_TEMPLATES.DATE_COST_PRICE
     , PRODUCT_TEMPLATES.WEBSITE
     , PRODUCT_TEMPLATES.MFT_PART_NUM
     , PRODUCT_TEMPLATES.VENDOR_PART_NUM
     , PRODUCT_TEMPLATES.TAX_CLASS
     , PRODUCT_TEMPLATES.TAXRATE_ID
     , PRODUCT_TEMPLATES.WEIGHT
     , PRODUCT_TEMPLATES.MINIMUM_OPTIONS
     , PRODUCT_TEMPLATES.MAXIMUM_OPTIONS
     , PRODUCT_TEMPLATES.MINIMUM_QUANTITY
     , PRODUCT_TEMPLATES.MAXIMUM_QUANTITY
     , PRODUCT_TEMPLATES.LIST_ORDER
     , PRODUCT_TEMPLATES.QUICKBOOKS_ACCOUNT
     , PRODUCT_TEMPLATES.CURRENCY_ID
     , CURRENCIES.NAME             as CURRENCY_NAME
     , CURRENCIES.SYMBOL           as CURRENCY_SYMBOL
     , CURRENCIES.CONVERSION_RATE  as CURRENCY_CONVERSION_RATE
     , CURRENCIES.ISO4217          as CURRENCY_ISO4217
     , PRODUCT_TEMPLATES.COST_PRICE
     , PRODUCT_TEMPLATES.COST_USDOLLAR
     , PRODUCT_TEMPLATES.LIST_PRICE
     , PRODUCT_TEMPLATES.LIST_USDOLLAR
     , PRODUCT_TEMPLATES.DISCOUNT_PRICE
     , PRODUCT_TEMPLATES.DISCOUNT_USDOLLAR
     , PRODUCT_TEMPLATES.PRICING_FORMULA
     , PRODUCT_TEMPLATES.PRICING_FACTOR
     , PRODUCT_TEMPLATES.SUPPORT_NAME
     , PRODUCT_TEMPLATES.SUPPORT_CONTACT
     , PRODUCT_TEMPLATES.SUPPORT_DESCRIPTION
     , PRODUCT_TEMPLATES.SUPPORT_TERM
     , PRODUCT_TEMPLATES.ACCOUNT_ID
     , ACCOUNTS.NAME               as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID   as ACCOUNT_ASSIGNED_USER_ID
     , PRODUCT_TEMPLATES.MANUFACTURER_ID
     , MANUFACTURERS.NAME          as MANUFACTURER_NAME
     , PRODUCT_TEMPLATES.CATEGORY_ID
     , PRODUCT_CATEGORIES.NAME     as CATEGORY_NAME
     , PRODUCT_TEMPLATES.TYPE_ID
     , PRODUCT_TYPES.NAME          as TYPE_NAME
     , PRODUCT_TEMPLATES.DATE_ENTERED
     , PRODUCT_TEMPLATES.DATE_MODIFIED
     , PRODUCT_TEMPLATES.DATE_MODIFIED_UTC
     , PRODUCT_TEMPLATES.DESCRIPTION
     , TEAMS.ID                     as TEAM_ID
     , TEAMS.NAME                   as TEAM_NAME
     , USERS_CREATED_BY.USER_NAME   as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME  as MODIFIED_BY
     , PRODUCT_TEMPLATES.CREATED_BY as CREATED_BY_ID
     , PRODUCT_TEMPLATES.MODIFIED_USER_ID
     , TEAM_SETS.ID                 as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME      as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST      as TEAM_SET_LIST
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , DISCOUNTS.ID                 as DISCOUNT_ID
     , DISCOUNTS.NAME               as DISCOUNT_NAME
     , TAX_RATES.NAME               as TAXRATE_NAME
     , TAX_RATES.VALUE              as TAXRATE_VALUE
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , TAG_SETS.TAG_SET_NAME
     , PRODUCT_TEMPLATES_CSTM.*
  from            PRODUCT_TEMPLATES
  left outer join ACCOUNTS
               on ACCOUNTS.ID                = PRODUCT_TEMPLATES.ACCOUNT_ID
              and ACCOUNTS.DELETED           = 0
  left outer join MANUFACTURERS
               on MANUFACTURERS.ID            = PRODUCT_TEMPLATES.MANUFACTURER_ID
              and MANUFACTURERS.DELETED       = 0
  left outer join PRODUCT_CATEGORIES
               on PRODUCT_CATEGORIES.ID       = PRODUCT_TEMPLATES.CATEGORY_ID
              and PRODUCT_CATEGORIES.DELETED  = 0
  left outer join PRODUCT_TYPES
               on PRODUCT_TYPES.ID            = PRODUCT_TEMPLATES.TYPE_ID
              and PRODUCT_TYPES.DELETED       = 0
  left outer join CURRENCIES
               on CURRENCIES.ID               = PRODUCT_TEMPLATES.CURRENCY_ID
              and CURRENCIES.DELETED          = 0
  left outer join DISCOUNTS
               on DISCOUNTS.ID                = PRODUCT_TEMPLATES.DISCOUNT_ID
              and DISCOUNTS.DELETED           = 0
  left outer join TAX_RATES
               on TAX_RATES.ID                = PRODUCT_TEMPLATES.TAXRATE_ID
  left outer join TEAMS
               on TEAMS.ID                    = PRODUCT_TEMPLATES.TEAM_ID
              and TEAMS.DELETED               = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                = PRODUCT_TEMPLATES.TEAM_SET_ID
              and TEAM_SETS.DELETED           = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID            = PRODUCT_TEMPLATES.ID
              and TAG_SETS.DELETED            = 0
  left outer join USERS                         USERS_CREATED_BY
               on USERS_CREATED_BY.ID         = PRODUCT_TEMPLATES.CREATED_BY
  left outer join USERS                         USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID        = PRODUCT_TEMPLATES.MODIFIED_USER_ID
  left outer join PRODUCT_TEMPLATES_CSTM
               on PRODUCT_TEMPLATES_CSTM.ID_C = PRODUCT_TEMPLATES.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = PRODUCT_TEMPLATES.ID
 where PRODUCT_TEMPLATES.DELETED = 0

GO

Grant Select on dbo.vwPRODUCT_TEMPLATES to public;
GO

