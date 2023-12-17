if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUEUE_EMAIL_ADDRESS')
	Drop View dbo.vwQUEUE_EMAIL_ADDRESS;
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
-- 06/03/2008 Paul.  Only use the Account email if the Contact email does not exist. 
-- 10/13/2011 Paul.  We need to return the recipient ID and not the parent ID. 
-- 09/28/2012 Paul.  CONTACTS.INVALID_EMAIL = 1 for Accounts to be valid. 
Create View dbo.vwQUEUE_EMAIL_ADDRESS
as
select PARENT_ID
     , PARENT_NAME
     , PARENT_TYPE
     , MODULE
     , EMAIL1
     , PARENT_ID                         as RECIPIENT_ID
     , PARENT_NAME                       as RECIPIENT_NAME
  from vwPARENTS_EMAIL_ADDRESS
union all
select CASES.ID                          as PARENT_ID
     , ACCOUNTS.NAME                     as PARENT_NAME
     , N'Cases'                          as PARENT_TYPE
     , N'Accounts'                       as MODULE
     , ACCOUNTS.EMAIL1                   as EMAIL1
     , ACCOUNTS.ID                       as RECIPIENT_ID
     , ACCOUNTS.NAME                     as RECIPIENT_NAME
  from            CASES
       inner join ACCOUNTS
               on ACCOUNTS.ID      = CASES.ACCOUNT_ID
              and ACCOUNTS.DELETED = 0
 where CASES.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
union all
select OPPORTUNITIES.ID                  as PARENT_ID
     , ACCOUNTS.NAME                     as PARENT_NAME
     , N'Opportunities'                  as PARENT_TYPE
     , N'Accounts'                       as MODULE
     , ACCOUNTS.EMAIL1                   as EMAIL1
     , ACCOUNTS.ID                       as RECIPIENT_ID
     , ACCOUNTS.NAME                     as RECIPIENT_NAME
  from            OPPORTUNITIES
       inner join ACCOUNTS_OPPORTUNITIES
               on ACCOUNTS_OPPORTUNITIES.OPPORTUNITY_ID = OPPORTUNITIES.ID
              and ACCOUNTS_OPPORTUNITIES.DELETED        = 0
       inner join ACCOUNTS
               on ACCOUNTS.ID                           = ACCOUNTS_OPPORTUNITIES.ACCOUNT_ID
              and ACCOUNTS.DELETED                      = 0
 where OPPORTUNITIES.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
union all
select PAYMENTS.ID                       as PARENT_ID
     , ACCOUNTS.NAME                     as PARENT_NAME
     , N'Payments'                       as PARENT_TYPE
     , N'Accounts'                       as MODULE
     , ACCOUNTS.EMAIL1                   as EMAIL1
     , ACCOUNTS.ID                       as RECIPIENT_ID
     , ACCOUNTS.NAME                     as RECIPIENT_NAME
  from            PAYMENTS
       inner join ACCOUNTS
               on ACCOUNTS.ID      = PAYMENTS.ACCOUNT_ID
              and ACCOUNTS.DELETED = 0
 where PAYMENTS.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
union all
select CONTRACTS.ID                      as PARENT_ID
     , ACCOUNTS.NAME                     as PARENT_NAME
     , N'Contracts'                      as PARENT_TYPE
     , N'Accounts'                       as MODULE
     , ACCOUNTS.EMAIL1                   as EMAIL1
     , ACCOUNTS.ID                       as RECIPIENT_ID
     , ACCOUNTS.NAME                     as RECIPIENT_NAME
  from            CONTRACTS
       inner join ACCOUNTS
               on ACCOUNTS.ID      = CONTRACTS.ACCOUNT_ID
              and ACCOUNTS.DELETED = 0
 where CONTRACTS.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
union all
select QUOTES.ID                      as PARENT_ID
     , ACCOUNTS.NAME                  as PARENT_NAME
     , N'Quotes'                      as PARENT_TYPE
     , N'Accounts'                    as MODULE
     , ACCOUNTS.EMAIL1                as EMAIL1
     , ACCOUNTS.ID                    as RECIPIENT_ID
     , ACCOUNTS.NAME                  as RECIPIENT_NAME
  from            QUOTES
       inner join QUOTES_ACCOUNTS                   QUOTES_ACCOUNTS
               on QUOTES_ACCOUNTS.QUOTE_ID        = QUOTES.ID
              and QUOTES_ACCOUNTS.ACCOUNT_ROLE    = N'Bill To'
              and QUOTES_ACCOUNTS.DELETED         = 0
       inner join ACCOUNTS                          ACCOUNTS
               on ACCOUNTS.ID                     = QUOTES_ACCOUNTS.ACCOUNT_ID
              and ACCOUNTS.DELETED                = 0
  left outer join QUOTES_CONTACTS                   QUOTES_CONTACTS
               on QUOTES_CONTACTS.QUOTE_ID        = QUOTES.ID
              and QUOTES_CONTACTS.CONTACT_ROLE    = N'Bill To'
              and QUOTES_CONTACTS.DELETED         = 0
  left outer join CONTACTS                          CONTACTS
               on CONTACTS.ID                     = QUOTES_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where QUOTES.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
   and (CONTACTS.ID is null or CONTACTS.EMAIL1 is null or CONTACTS.INVALID_EMAIL = 1)
union all
select QUOTES.ID                         as PARENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as PARENT_NAME
     , N'Quotes'                         as PARENT_TYPE
     , N'Contacts'                       as MODULE
     , CONTACTS.EMAIL1                   as EMAIL1
     , CONTACTS.ID                       as RECIPIENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as RECIPIENT_NAME
  from            QUOTES
       inner join QUOTES_CONTACTS                   QUOTES_CONTACTS
               on QUOTES_CONTACTS.QUOTE_ID        = QUOTES.ID
              and QUOTES_CONTACTS.CONTACT_ROLE    = N'Bill To'
              and QUOTES_CONTACTS.DELETED         = 0
       inner join CONTACTS                          CONTACTS
               on CONTACTS.ID                     = QUOTES_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where QUOTES.DELETED = 0
   and CONTACTS.EMAIL1 is not null
   and (CONTACTS.INVALID_EMAIL = 0 or CONTACTS.INVALID_EMAIL is null)
union all
select ORDERS.ID                      as PARENT_ID
     , ACCOUNTS.NAME                  as PARENT_NAME
     , N'Orders'                      as PARENT_TYPE
     , N'Accounts'                    as MODULE
     , ACCOUNTS.EMAIL1                as EMAIL1
     , ACCOUNTS.ID                    as RECIPIENT_ID
     , ACCOUNTS.NAME                  as RECIPIENT_NAME
  from            ORDERS
       inner join ORDERS_ACCOUNTS                   ORDERS_ACCOUNTS
               on ORDERS_ACCOUNTS.ORDER_ID        = ORDERS.ID
              and ORDERS_ACCOUNTS.ACCOUNT_ROLE    = N'Bill To'
              and ORDERS_ACCOUNTS.DELETED         = 0
       inner join ACCOUNTS                          ACCOUNTS
               on ACCOUNTS.ID                     = ORDERS_ACCOUNTS.ACCOUNT_ID
              and ACCOUNTS.DELETED                = 0
  left outer join ORDERS_CONTACTS                   ORDERS_CONTACTS
               on ORDERS_CONTACTS.ORDER_ID        = ORDERS.ID
              and ORDERS_CONTACTS.CONTACT_ROLE    = N'Bill To'
              and ORDERS_CONTACTS.DELETED         = 0
  left outer join CONTACTS                          CONTACTS
               on CONTACTS.ID                     = ORDERS_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where ORDERS.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
   and (CONTACTS.ID is null or CONTACTS.EMAIL1 is null or CONTACTS.INVALID_EMAIL = 1)
union all
select ORDERS.ID                         as PARENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as PARENT_NAME
     , N'Orders'                         as PARENT_TYPE
     , N'Contacts'                       as MODULE
     , CONTACTS.EMAIL1                   as EMAIL1
     , CONTACTS.ID                       as RECIPIENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as RECIPIENT_NAME
  from            ORDERS
       inner join ORDERS_CONTACTS                   ORDERS_CONTACTS
               on ORDERS_CONTACTS.ORDER_ID        = ORDERS.ID
              and ORDERS_CONTACTS.CONTACT_ROLE    = N'Bill To'
              and ORDERS_CONTACTS.DELETED         = 0
       inner join CONTACTS                          CONTACTS
               on CONTACTS.ID                     = ORDERS_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where ORDERS.DELETED = 0
   and CONTACTS.EMAIL1 is not null
   and (CONTACTS.INVALID_EMAIL = 0 or CONTACTS.INVALID_EMAIL is null)
union all
select INVOICES.ID                    as PARENT_ID
     , ACCOUNTS.NAME                  as PARENT_NAME
     , N'Invoices'                    as PARENT_TYPE
     , N'Accounts'                    as MODULE
     , ACCOUNTS.EMAIL1                as EMAIL1
     , ACCOUNTS.ID                    as RECIPIENT_ID
     , ACCOUNTS.NAME                  as RECIPIENT_NAME
  from            INVOICES
       inner join INVOICES_ACCOUNTS                 INVOICES_ACCOUNTS
               on INVOICES_ACCOUNTS.INVOICE_ID    = INVOICES.ID
              and INVOICES_ACCOUNTS.ACCOUNT_ROLE  = N'Bill To'
              and INVOICES_ACCOUNTS.DELETED       = 0
       inner join ACCOUNTS                          ACCOUNTS
               on ACCOUNTS.ID                     = INVOICES_ACCOUNTS.ACCOUNT_ID
              and ACCOUNTS.DELETED                = 0
  left outer join INVOICES_CONTACTS                 INVOICES_CONTACTS
               on INVOICES_CONTACTS.INVOICE_ID    = INVOICES.ID
              and INVOICES_CONTACTS.CONTACT_ROLE  = N'Bill To'
              and INVOICES_CONTACTS.DELETED       = 0
  left outer join CONTACTS                          CONTACTS
               on CONTACTS.ID                     = INVOICES_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where INVOICES.DELETED = 0
   and ACCOUNTS.EMAIL1 is not null
   and (CONTACTS.ID is null or CONTACTS.EMAIL1 is null or CONTACTS.INVALID_EMAIL = 1)
union all
select INVOICES.ID                       as PARENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as PARENT_NAME
     , N'Invoices'                       as PARENT_TYPE
     , N'Contacts'                       as MODULE
     , CONTACTS.EMAIL1                   as EMAIL1
     , CONTACTS.ID                       as RECIPIENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as RECIPIENT_NAME
  from            INVOICES
       inner join INVOICES_CONTACTS                 INVOICES_CONTACTS
               on INVOICES_CONTACTS.INVOICE_ID    = INVOICES.ID
              and INVOICES_CONTACTS.CONTACT_ROLE  = N'Bill To'
              and INVOICES_CONTACTS.DELETED       = 0
       inner join CONTACTS                          CONTACTS
               on CONTACTS.ID                     = INVOICES_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                = 0
 where INVOICES.DELETED = 0
   and CONTACTS.EMAIL1 is not null
   and (CONTACTS.INVALID_EMAIL = 0 or CONTACTS.INVALID_EMAIL is null)

GO

Grant Select on dbo.vwQUEUE_EMAIL_ADDRESS to public;
GO

