if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES')
	Drop View dbo.vwINVOICES;
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
-- 05/10/2009 Paul.  Add currency name. 
-- 06/04/2009 Paul.  Add Quote Num and Order Num for reference in Invoice DetailView. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 09/01/2012 Paul.  Add LAST_ACTIVITY_DATE. 
-- 11/22/2012 Paul.  Join to LAST_ACTIVITY table. 
-- 02/13/2015 Paul.  CURRENCY_ISO4217 is used by QuickBooksOnline. 
-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
-- 03/07/2016 Paul.  Add DAYS_PAST_DUE. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwINVOICES
as
select INVOICES.ID
     , INVOICES.INVOICE_NUM
     , INVOICES.NAME
     , INVOICES.PAYMENT_TERMS
     , INVOICES.INVOICE_STAGE
     , INVOICES.PURCHASE_ORDER_NUM
     , INVOICES.DUE_DATE
     , INVOICES.SHIP_DATE
     , (case when INVOICE_STAGE = 'Due' then datediff(dd, INVOICES.DUE_DATE, getdate()) end) as DAYS_PAST_DUE
     , cast(null as int)           as SHOW_LINE_NUMS
     , cast(null as int)           as CALC_GRAND_TOTAL
     , INVOICES.CURRENCY_ID
     , isnull(INVOICES.EXCHANGE_RATE, CURRENCIES.CONVERSION_RATE) as EXCHANGE_RATE
     , INVOICES.SUBTOTAL
     , INVOICES.SUBTOTAL_USDOLLAR
     , INVOICES.DISCOUNT
     , INVOICES.DISCOUNT_USDOLLAR
     , INVOICES.SHIPPING
     , INVOICES.SHIPPING_USDOLLAR
     , INVOICES.TAX
     , INVOICES.TAX_USDOLLAR
     , INVOICES.TOTAL
     , INVOICES.TOTAL_USDOLLAR
     , INVOICES.AMOUNT_DUE
     , INVOICES.AMOUNT_DUE_USDOLLAR
     , INVOICES.BILLING_ADDRESS_STREET
     , INVOICES.BILLING_ADDRESS_CITY
     , INVOICES.BILLING_ADDRESS_STATE
     , INVOICES.BILLING_ADDRESS_POSTALCODE
     , INVOICES.BILLING_ADDRESS_COUNTRY
     , INVOICES.SHIPPING_ADDRESS_STREET
     , INVOICES.SHIPPING_ADDRESS_CITY
     , INVOICES.SHIPPING_ADDRESS_STATE
     , INVOICES.SHIPPING_ADDRESS_POSTALCODE
     , INVOICES.SHIPPING_ADDRESS_COUNTRY
     , INVOICES.TAXRATE_ID
     , INVOICES.SHIPPER_ID
     , INVOICES.ASSIGNED_USER_ID
     , INVOICES.DATE_ENTERED
     , INVOICES.DATE_MODIFIED
     , INVOICES.DATE_MODIFIED_UTC
     , INVOICES.DESCRIPTION
     , INVOICES_ACCOUNTS_BILLING.ACCOUNT_ID  as BILLING_ACCOUNT_ID
     , ACCOUNTS_BILLING.NAME                 as BILLING_ACCOUNT_NAME
     , ACCOUNTS_BILLING.ASSIGNED_USER_ID     as BILLING_ACCOUNT_ASSIGNED_ID
     , ACCOUNTS_BILLING.ASSIGNED_USER_ID     as BILLING_ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS_BILLING.ASSIGNED_SET_ID      as BILLING_ACCOUNT_ASSIGNED_SET_ID
     , ACCOUNTS_BILLING.EMAIL1               as BILLING_ACCOUNT_EMAIL1
     , INVOICES_ACCOUNTS_SHIPPING.ACCOUNT_ID as SHIPPING_ACCOUNT_ID
     , ACCOUNTS_SHIPPING.NAME                as SHIPPING_ACCOUNT_NAME
     , ACCOUNTS_SHIPPING.ASSIGNED_USER_ID    as SHIPPING_ACCOUNT_ASSIGNED_ID
     , ACCOUNTS_SHIPPING.ASSIGNED_USER_ID    as SHIPPING_ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS_SHIPPING.ASSIGNED_SET_ID     as SHIPPING_ACCOUNT_ASSIGNED_SET_ID
     , ACCOUNTS_SHIPPING.EMAIL1              as SHIPPING_ACCOUNT_EMAIL1
     , INVOICES_CONTACTS_BILLING.CONTACT_ID  as BILLING_CONTACT_ID
     , dbo.fnFullName(CONTACTS_BILLING.FIRST_NAME, CONTACTS_BILLING.LAST_NAME) as BILLING_CONTACT_NAME
     , CONTACTS_BILLING.ASSIGNED_USER_ID     as BILLING_CONTACT_ASSIGNED_ID
     , CONTACTS_BILLING.ASSIGNED_USER_ID     as BILLING_CONTACT_ASSIGNED_USER_ID
     , CONTACTS_BILLING.ASSIGNED_SET_ID      as BILLING_CONTACT_ASSIGNED_SET_ID
     , CONTACTS_BILLING.EMAIL1               as BILLING_CONTACT_EMAIL1
     , INVOICES_CONTACTS_SHIPPING.CONTACT_ID as SHIPPING_CONTACT_ID
     , dbo.fnFullName(CONTACTS_SHIPPING.FIRST_NAME, CONTACTS_SHIPPING.LAST_NAME) as SHIPPING_CONTACT_NAME
     , CONTACTS_SHIPPING.ASSIGNED_USER_ID    as SHIPPING_CONTACT_ASSIGNED_ID
     , CONTACTS_SHIPPING.ASSIGNED_USER_ID    as SHIPPING_CONTACT_ASSIGNED_USER_ID
     , CONTACTS_SHIPPING.ASSIGNED_SET_ID     as SHIPPING_CONTACT_ASSIGNED_SET_ID
     , CONTACTS_SHIPPING.EMAIL1              as SHIPPING_CONTACT_EMAIL1
     , OPPORTUNITIES.ID                      as OPPORTUNITY_ID
     , OPPORTUNITIES.NAME                    as OPPORTUNITY_NAME
     , OPPORTUNITIES.ASSIGNED_USER_ID        as OPPORTUNITY_ASSIGNED_USER_ID
     , OPPORTUNITIES.ASSIGNED_SET_ID         as OPPORTUNITY_ASSIGNED_SET_ID
     , OPPORTUNITIES.LEAD_SOURCE             as LEAD_SOURCE
     , OPPORTUNITIES.NEXT_STEP               as NEXT_STEP
     , QUOTES.ID                             as QUOTE_ID
     , QUOTES.NAME                           as QUOTE_NAME
     , QUOTES.QUOTE_NUM                      as QUOTE_NUM
     , ORDERS.ID                             as ORDER_ID
     , ORDERS.NAME                           as ORDER_NAME
     , ORDERS.ORDER_NUM                      as ORDER_NUM
     , TAX_RATES.NAME                        as TAXRATE_NAME
     , TAX_RATES.VALUE                       as TAXRATE_VALUE
     , SHIPPERS.NAME                         as SHIPPER_NAME
     , TEAMS.ID                              as TEAM_ID
     , TEAMS.NAME                            as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME              as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME            as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME           as MODIFIED_BY
     , INVOICES.CREATED_BY                   as CREATED_BY_ID
     , INVOICES.MODIFIED_USER_ID
     , TEAM_SETS.ID                          as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME               as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST               as TEAM_SET_LIST
     , CURRENCIES.NAME                       as CURRENCY_NAME
     , CURRENCIES.SYMBOL                     as CURRENCY_SYMBOL
     , CURRENCIES.ISO4217                    as CURRENCY_ISO4217
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , LAST_ACTIVITY.LAST_ACTIVITY_DATE
     , TAG_SETS.TAG_SET_NAME
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , INVOICES_CSTM.*
  from            INVOICES
  left outer join INVOICES_ACCOUNTS                         INVOICES_ACCOUNTS_BILLING
               on INVOICES_ACCOUNTS_BILLING.INVOICE_ID    = INVOICES.ID
              and INVOICES_ACCOUNTS_BILLING.ACCOUNT_ROLE  = N'Bill To'
              and INVOICES_ACCOUNTS_BILLING.DELETED       = 0
  left outer join ACCOUNTS                                  ACCOUNTS_BILLING
               on ACCOUNTS_BILLING.ID                     = INVOICES_ACCOUNTS_BILLING.ACCOUNT_ID
              and ACCOUNTS_BILLING.DELETED                = 0
  left outer join INVOICES_ACCOUNTS                         INVOICES_ACCOUNTS_SHIPPING
               on INVOICES_ACCOUNTS_SHIPPING.INVOICE_ID     = INVOICES.ID
              and INVOICES_ACCOUNTS_SHIPPING.ACCOUNT_ROLE = N'Ship To'
              and INVOICES_ACCOUNTS_SHIPPING.DELETED      = 0
  left outer join ACCOUNTS                                  ACCOUNTS_SHIPPING
               on ACCOUNTS_SHIPPING.ID                    = INVOICES_ACCOUNTS_SHIPPING.ACCOUNT_ID
              and ACCOUNTS_SHIPPING.DELETED               = 0
  left outer join INVOICES_CONTACTS                         INVOICES_CONTACTS_BILLING
               on INVOICES_CONTACTS_BILLING.INVOICE_ID      = INVOICES.ID
              and INVOICES_CONTACTS_BILLING.CONTACT_ROLE  = N'Bill To'
              and INVOICES_CONTACTS_BILLING.DELETED       = 0
  left outer join CONTACTS                                  CONTACTS_BILLING
               on CONTACTS_BILLING.ID                     = INVOICES_CONTACTS_BILLING.CONTACT_ID
              and CONTACTS_BILLING.DELETED                = 0
  left outer join INVOICES_CONTACTS                         INVOICES_CONTACTS_SHIPPING
               on INVOICES_CONTACTS_SHIPPING.INVOICE_ID     = INVOICES.ID
              and INVOICES_CONTACTS_SHIPPING.CONTACT_ROLE = N'Ship To'
              and INVOICES_CONTACTS_SHIPPING.DELETED      = 0
  left outer join CONTACTS                                  CONTACTS_SHIPPING
               on CONTACTS_SHIPPING.ID                    = INVOICES_CONTACTS_SHIPPING.CONTACT_ID
              and CONTACTS_SHIPPING.DELETED               = 0
  left outer join OPPORTUNITIES
               on OPPORTUNITIES.ID                        = INVOICES.OPPORTUNITY_ID
              and OPPORTUNITIES.DELETED                   = 0
  left outer join QUOTES
               on QUOTES.ID                               = INVOICES.QUOTE_ID
              and QUOTES.DELETED                          = 0
  left outer join ORDERS
               on ORDERS.ID                               = INVOICES.ORDER_ID
              and ORDERS.DELETED                          = 0
  left outer join TAX_RATES
               on TAX_RATES.ID                            = INVOICES.TAXRATE_ID
  left outer join SHIPPERS
               on SHIPPERS.ID                             = INVOICES.SHIPPER_ID
  left outer join TEAMS
               on TEAMS.ID                                = INVOICES.TEAM_ID
              and TEAMS.DELETED                           = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                            = INVOICES.TEAM_SET_ID
              and TEAM_SETS.DELETED                       = 0
  left outer join CURRENCIES
               on CURRENCIES.ID                           = INVOICES.CURRENCY_ID
  left outer join LAST_ACTIVITY
               on LAST_ACTIVITY.ACTIVITY_ID               = INVOICES.ID
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID                        = INVOICES.ID
              and TAG_SETS.DELETED                        = 0
  left outer join USERS                                     USERS_ASSIGNED
               on USERS_ASSIGNED.ID                       = INVOICES.ASSIGNED_USER_ID
  left outer join USERS                                     USERS_CREATED_BY
               on USERS_CREATED_BY.ID                     = INVOICES.CREATED_BY
  left outer join USERS                                     USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID                    = INVOICES.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                        = INVOICES.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED                   = 0
  left outer join INVOICES_CSTM
               on INVOICES_CSTM.ID_C                      = INVOICES.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID           = INVOICES.ID
 where INVOICES.DELETED = 0

GO

Grant Select on dbo.vwINVOICES to public;
GO

