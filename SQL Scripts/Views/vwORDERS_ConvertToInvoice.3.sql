if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_ConvertToInvoice')
	Drop View dbo.vwORDERS_ConvertToInvoice;
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
-- 04/29/2007 Paul.  Start with QUOTES, but join to INVOICES_CSTM as the order page may use custom fields. 
-- Even though we are joining to the INVOICES_CSTM table, we do not expect to return any data. 
-- 04/22/2008 Paul.  New invoices default to a stage of Due. 
-- 05/01/2009 Paul.  We want to be able to copy Orders custom fields to Invoices custom fields, 
-- so we must join to the ORDERS_CSTM table and just expect a matching set of fields in INVOICES_CSTM. 
-- 08/08/2009 Paul.  QUOTE_NUM, ORDER_NUM and INVOICE_NUM are all strings now.
-- 08/30/2009 Paul.  All module views must have a TEAM_SET_ID. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 03/31/2016 Paul.  Add DATE_MODIFIED_UTC. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 02/04/2020 Paul.  Add Tags module. 
Create View dbo.vwORDERS_ConvertToInvoice
as
select cast(null as nvarchar(30))     as INVOICE_NUM
     , cast(N'Due' as varchar(25))    as INVOICE_STAGE
     , DATE_ORDER_DUE                 as DUE_DATE
     , ORDERS.TOTAL                   as AMOUNT_DUE
     , ORDERS.TOTAL_USDOLLAR          as AMOUNT_DUE_USDOLLAR
     , ORDERS.ID                      as ORDER_ID
     , ORDERS.NAME                    as ORDER_NAME
     , ORDERS.ID
     , ORDERS.ORDER_NUM
     , ORDERS.NAME
     , ORDERS.PAYMENT_TERMS
     , ORDERS.ORDER_STAGE
     , ORDERS.PURCHASE_ORDER_NUM
     , ORDERS.ORIGINAL_PO_DATE
     , ORDERS.DATE_ORDER_DUE
     , ORDERS.DATE_ORDER_SHIPPED
     , ORDERS.SHOW_LINE_NUMS
     , ORDERS.CALC_GRAND_TOTAL
     , ORDERS.CURRENCY_ID
     , ORDERS.EXCHANGE_RATE
     , ORDERS.SUBTOTAL
     , ORDERS.SUBTOTAL_USDOLLAR
     , ORDERS.DISCOUNT
     , ORDERS.DISCOUNT_USDOLLAR
     , ORDERS.SHIPPING
     , ORDERS.SHIPPING_USDOLLAR
     , ORDERS.TAX
     , ORDERS.TAX_USDOLLAR
     , ORDERS.TOTAL
     , ORDERS.TOTAL_USDOLLAR
     , ORDERS.BILLING_ADDRESS_STREET
     , ORDERS.BILLING_ADDRESS_CITY
     , ORDERS.BILLING_ADDRESS_STATE
     , ORDERS.BILLING_ADDRESS_POSTALCODE
     , ORDERS.BILLING_ADDRESS_COUNTRY
     , ORDERS.SHIPPING_ADDRESS_STREET
     , ORDERS.SHIPPING_ADDRESS_CITY
     , ORDERS.SHIPPING_ADDRESS_STATE
     , ORDERS.SHIPPING_ADDRESS_POSTALCODE
     , ORDERS.SHIPPING_ADDRESS_COUNTRY
     , ORDERS.TAXRATE_ID
     , ORDERS.SHIPPER_ID
     , ORDERS.ASSIGNED_USER_ID
     , ORDERS.DATE_ENTERED
     , ORDERS.DATE_MODIFIED
     , ORDERS.DATE_MODIFIED_UTC
     , ORDERS_ACCOUNTS_BILLING.ACCOUNT_ID  as BILLING_ACCOUNT_ID
     , ACCOUNTS_BILLING.NAME               as BILLING_ACCOUNT_NAME
     , ACCOUNTS_BILLING.ASSIGNED_USER_ID   as BILLING_ACCOUNT_ASSIGNED_ID
     , ACCOUNTS_BILLING.ASSIGNED_USER_ID   as BILLING_ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS_BILLING.ASSIGNED_SET_ID    as BILLING_ACCOUNT_ASSIGNED_SET_ID
     , ORDERS_ACCOUNTS_SHIPPING.ACCOUNT_ID as SHIPPING_ACCOUNT_ID
     , ACCOUNTS_SHIPPING.NAME              as SHIPPING_ACCOUNT_NAME
     , ACCOUNTS_SHIPPING.ASSIGNED_USER_ID  as SHIPPING_ACCOUNT_ASSIGNED_ID
     , ACCOUNTS_SHIPPING.ASSIGNED_USER_ID  as SHIPPING_ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS_SHIPPING.ASSIGNED_SET_ID   as SHIPPING_ACCOUNT_ASSIGNED_SET_ID
     , ORDERS_CONTACTS_BILLING.CONTACT_ID  as BILLING_CONTACT_ID
     , dbo.fnFullName(CONTACTS_BILLING.FIRST_NAME, CONTACTS_BILLING.LAST_NAME) as BILLING_CONTACT_NAME
     , CONTACTS_BILLING.ASSIGNED_USER_ID   as BILLING_CONTACT_ASSIGNED_ID
     , CONTACTS_BILLING.ASSIGNED_USER_ID   as BILLING_CONTACT_ASSIGNED_USER_ID
     , CONTACTS_BILLING.ASSIGNED_SET_ID    as BILLING_CONTACT_ASSIGNED_SET_ID
     , ORDERS_CONTACTS_SHIPPING.CONTACT_ID as SHIPPING_CONTACT_ID
     , dbo.fnFullName(CONTACTS_SHIPPING.FIRST_NAME, CONTACTS_SHIPPING.LAST_NAME) as SHIPPING_CONTACT_NAME
     , CONTACTS_SHIPPING.ASSIGNED_USER_ID  as SHIPPING_CONTACT_ASSIGNED_ID
     , CONTACTS_SHIPPING.ASSIGNED_USER_ID  as SHIPPING_CONTACT_ASSIGNED_USER_ID
     , CONTACTS_SHIPPING.ASSIGNED_SET_ID   as SHIPPING_CONTACT_ASSIGNED_SET_ID
     , OPPORTUNITIES.ID                    as OPPORTUNITY_ID
     , OPPORTUNITIES.NAME                  as OPPORTUNITY_NAME
     , OPPORTUNITIES.ASSIGNED_USER_ID      as OPPORTUNITY_ASSIGNED_USER_ID
     , OPPORTUNITIES.ASSIGNED_SET_ID       as OPPORTUNITY_ASSIGNED_SET_ID
     , OPPORTUNITIES.LEAD_SOURCE           as LEAD_SOURCE
     , OPPORTUNITIES.NEXT_STEP             as NEXT_STEP
     , QUOTES.ID                           as QUOTE_ID
     , QUOTES.NAME                         as QUOTE_NAME
     , TAX_RATES.NAME                      as TAXRATE_NAME
     , TAX_RATES.VALUE                     as TAXRATE_VALUE
     , SHIPPERS.NAME                       as SHIPPER_NAME
     , TEAMS.ID                            as TEAM_ID
     , TEAMS.NAME                          as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME            as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME          as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME         as MODIFIED_BY
     , ORDERS.CREATED_BY                   as CREATED_BY_ID
     , ORDERS.MODIFIED_USER_ID
     , ORDERS.DESCRIPTION
     , TEAM_SETS.ID                        as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME             as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST             as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , TAG_SETS.TAG_SET_NAME
     , ORDERS_CSTM.*
  from            ORDERS
  left outer join ORDERS_ACCOUNTS                         ORDERS_ACCOUNTS_BILLING
               on ORDERS_ACCOUNTS_BILLING.ORDER_ID      = ORDERS.ID
              and ORDERS_ACCOUNTS_BILLING.ACCOUNT_ROLE  = N'Bill To'
              and ORDERS_ACCOUNTS_BILLING.DELETED       = 0
  left outer join ACCOUNTS                                ACCOUNTS_BILLING
               on ACCOUNTS_BILLING.ID                   = ORDERS_ACCOUNTS_BILLING.ACCOUNT_ID
              and ACCOUNTS_BILLING.DELETED              = 0
  left outer join ORDERS_ACCOUNTS                         ORDERS_ACCOUNTS_SHIPPING
               on ORDERS_ACCOUNTS_SHIPPING.ORDER_ID     = ORDERS.ID
              and ORDERS_ACCOUNTS_SHIPPING.ACCOUNT_ROLE = N'Ship To'
              and ORDERS_ACCOUNTS_SHIPPING.DELETED      = 0
  left outer join ACCOUNTS                                ACCOUNTS_SHIPPING
               on ACCOUNTS_SHIPPING.ID                  = ORDERS_ACCOUNTS_SHIPPING.ACCOUNT_ID
              and ACCOUNTS_SHIPPING.DELETED             = 0
  left outer join ORDERS_CONTACTS                         ORDERS_CONTACTS_BILLING
               on ORDERS_CONTACTS_BILLING.ORDER_ID      = ORDERS.ID
              and ORDERS_CONTACTS_BILLING.CONTACT_ROLE  = N'Bill To'
              and ORDERS_CONTACTS_BILLING.DELETED       = 0
  left outer join CONTACTS                                CONTACTS_BILLING
               on CONTACTS_BILLING.ID                   = ORDERS_CONTACTS_BILLING.CONTACT_ID
              and CONTACTS_BILLING.DELETED              = 0
  left outer join ORDERS_CONTACTS                         ORDERS_CONTACTS_SHIPPING
               on ORDERS_CONTACTS_SHIPPING.ORDER_ID     = ORDERS.ID
              and ORDERS_CONTACTS_SHIPPING.CONTACT_ROLE = N'Ship To'
              and ORDERS_CONTACTS_SHIPPING.DELETED      = 0
  left outer join CONTACTS                                CONTACTS_SHIPPING
               on CONTACTS_SHIPPING.ID                  = ORDERS_CONTACTS_SHIPPING.CONTACT_ID
              and CONTACTS_SHIPPING.DELETED             = 0
  left outer join ORDERS_OPPORTUNITIES
               on ORDERS_OPPORTUNITIES.ORDER_ID         = ORDERS.ID
              and ORDERS_OPPORTUNITIES.DELETED          = 0
  left outer join OPPORTUNITIES
               on OPPORTUNITIES.ID                      = ORDERS_OPPORTUNITIES.OPPORTUNITY_ID
              and OPPORTUNITIES.DELETED                 = 0
  left outer join QUOTES
               on QUOTES.ID                             = ORDERS.QUOTE_ID
              and QUOTES.DELETED                        = 0
  left outer join TAX_RATES
               on TAX_RATES.ID                          = ORDERS.TAXRATE_ID
  left outer join SHIPPERS
               on SHIPPERS.ID                           = ORDERS.SHIPPER_ID
  left outer join TEAMS
               on TEAMS.ID                              = ORDERS.TEAM_ID
              and TEAMS.DELETED                         = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                          = ORDERS.TEAM_SET_ID
              and TEAM_SETS.DELETED                     = 0
  left outer join USERS                                   USERS_ASSIGNED
               on USERS_ASSIGNED.ID                     = ORDERS.ASSIGNED_USER_ID
  left outer join USERS                                   USERS_CREATED_BY
               on USERS_CREATED_BY.ID                   = ORDERS.CREATED_BY
  left outer join USERS                                   USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID                  = ORDERS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                      = ORDERS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED                 = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID                      = ORDERS.ID
              and TAG_SETS.DELETED                      = 0
  left outer join ORDERS_CSTM
               on ORDERS_CSTM.ID_C                      = ORDERS.ID
 where ORDERS.DELETED = 0

GO

Grant Select on dbo.vwORDERS_ConvertToInvoice to public;
GO

