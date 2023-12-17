if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPAYMENTS')
	Drop View dbo.vwPAYMENTS;
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
-- 01/01/2008 Paul.  To follow the conventions, the accounts assigned field should be ACCOUNT_ASSIGNED_USER_ID. 
-- 02/21/2008 Paul.  CREDIT_CARD_NAME is used in change controls. 
-- 11/08/2008 Paul.  Move description to base view. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 03/03/2011 Paul.  All modules should have a NAME field. 
-- 02/13/2015 Paul.  CURRENCY_ISO4217 is used by QuickBooksOnline. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPAYMENTS
as
select PAYMENTS.ID
     , PAYMENTS.PAYMENT_NUM as NAME
     , PAYMENTS.PAYMENT_NUM
     , PAYMENTS.PAYMENT_TYPE
     , PAYMENTS.PAYMENT_DATE
     , PAYMENTS.CUSTOMER_REFERENCE
     , PAYMENTS.CURRENCY_ID
     , isnull(PAYMENTS.EXCHANGE_RATE, CURRENCIES.CONVERSION_RATE) as EXCHANGE_RATE
     , PAYMENTS.AMOUNT
     , PAYMENTS.AMOUNT_USDOLLAR
     , PAYMENTS.ASSIGNED_USER_ID
     , PAYMENTS.DATE_ENTERED
     , PAYMENTS.DATE_MODIFIED
     , PAYMENTS.DATE_MODIFIED_UTC
     , PAYMENTS.DESCRIPTION
     , ACCOUNTS.ID                           as ACCOUNT_ID
     , ACCOUNTS.NAME                         as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID             as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID              as ACCOUNT_ASSIGNED_SET_ID
     , CONTACTS.ID                           as B2C_CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as B2C_CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID             as B2C_CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID              as B2C_CONTACT_ASSIGNED_SET_ID
     , CREDIT_CARDS.ID                       as CREDIT_CARD_ID
     , CREDIT_CARDS.NAME                     as CREDIT_CARD_NAME
     , CREDIT_CARDS.CARD_NUMBER_DISPLAY      as CREDIT_CARD_NUMBER
     , TEAMS.ID                              as TEAM_ID
     , TEAMS.NAME                            as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME              as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME            as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME           as MODIFIED_BY
     , PAYMENTS.CREATED_BY                   as CREATED_BY_ID
     , PAYMENTS.MODIFIED_USER_ID
     , (select sum(AMOUNT_USDOLLAR) 
          from INVOICES_PAYMENTS
         where INVOICES_PAYMENTS.PAYMENT_ID = PAYMENTS.ID
           and INVOICES_PAYMENTS.DELETED    = 0
       )                                     as TOTAL_ALLOCATED_USDOLLAR
     , TEAM_SETS.ID                          as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME               as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST               as TEAM_SET_LIST
     , CURRENCIES.NAME                       as CURRENCY_NAME
     , CURRENCIES.SYMBOL                     as CURRENCY_SYMBOL
     , CURRENCIES.ISO4217                    as CURRENCY_ISO4217
     , PAYMENT_TYPES.ID                      as PAYMENT_TYPE_ID
     , PAYMENT_TYPES.NAME                    as PAYMENT_TYPE_NAME
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                      as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME       as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST       as ASSIGNED_SET_LIST
     , PAYMENTS.BANK_FEE
     , PAYMENTS.BANK_FEE_USDOLLAR
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , PAYMENTS_CSTM.*
  from            PAYMENTS
  left outer join ACCOUNTS
               on ACCOUNTS.ID                     = PAYMENTS.ACCOUNT_ID
              and ACCOUNTS.DELETED                = 0
  left outer join CONTACTS
               on CONTACTS.ID                     = PAYMENTS.B2C_CONTACT_ID
              and CONTACTS.DELETED                = 0
  left outer join CREDIT_CARDS
               on CREDIT_CARDS.ID                 = PAYMENTS.CREDIT_CARD_ID
              and CREDIT_CARDS.DELETED            = 0
  left outer join TEAMS
               on TEAMS.ID                        = PAYMENTS.TEAM_ID
              and TEAMS.DELETED                   = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                    = PAYMENTS.TEAM_SET_ID
              and TEAM_SETS.DELETED               = 0
  left outer join CURRENCIES
               on CURRENCIES.ID                   = PAYMENTS.CURRENCY_ID
  left outer join PAYMENT_TYPES
               on PAYMENT_TYPES.NAME              = PAYMENTS.PAYMENT_TYPE
  left outer join USERS                             USERS_ASSIGNED
               on USERS_ASSIGNED.ID               = PAYMENTS.ASSIGNED_USER_ID
  left outer join USERS                             USERS_CREATED_BY
               on USERS_CREATED_BY.ID             = PAYMENTS.CREATED_BY
  left outer join USERS                             USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID            = PAYMENTS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                = PAYMENTS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED           = 0
  left outer join PAYMENTS_CSTM
               on PAYMENTS_CSTM.ID_C              = PAYMENTS.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID   = PAYMENTS.ID
 where PAYMENTS.DELETED = 0

GO

Grant Select on dbo.vwPAYMENTS to public;
GO

