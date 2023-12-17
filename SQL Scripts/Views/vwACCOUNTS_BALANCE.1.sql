if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_BALANCE')
	Drop View dbo.vwACCOUNTS_BALANCE;
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
-- 07/26/2009 Paul.  Make sure not to return amounts for invalid payments. 
-- 08/30/2009 Paul.  All module views must have a TEAM_SET_ID, so use the ACCOUNTS value. 
-- 10/07/2010 Paul.  Add Bank Fee so that it can be included in the balance calculation. 
-- 10/27/2015 Paul.  DATE_MODIFIED_UTC should be included as a fallback on HTML5 layout. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_BALANCE
as
select PAYMENTS.ID
     , PAYMENTS.PAYMENT_NUM                  as NAME
     , PAYMENTS.PAYMENT_DATE                 as BALANCE_DATE
     , N'Payments'                           as BALANCE_TYPE
     , PAYMENTS.CURRENCY_ID                  as CURRENCY_ID
     , PAYMENTS.EXCHANGE_RATE                as EXCHANGE_RATE
     , (case when dbo.fnPAYMENTS_IsValid(PAYMENTS.ID, PAYMENTS.PAYMENT_TYPE) = 1 
             then PAYMENTS.AMOUNT
             else 0.0
        end)                                 as AMOUNT
     , (case when dbo.fnPAYMENTS_IsValid(PAYMENTS.ID, PAYMENTS.PAYMENT_TYPE) = 1 
             then PAYMENTS.AMOUNT_USDOLLAR
             else 0.0
        end)                                 as AMOUNT_USDOLLAR
     , PAYMENTS.BANK_FEE                     as BANK_FEE_USDOLLAR
     , cast(null as money)                   as BALANCE_USDOLLAR
     , ACCOUNTS.ID                           as ACCOUNT_ID
     , ACCOUNTS.NAME                         as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID             as ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID              as ASSIGNED_SET_ID
     , ACCOUNTS.TEAM_ID
     , ACCOUNTS.TEAM_SET_ID
     , PAYMENTS.DATE_MODIFIED_UTC
  from            PAYMENTS
       inner join ACCOUNTS
               on ACCOUNTS.ID      = PAYMENTS.ACCOUNT_ID
              and ACCOUNTS.DELETED = 0
 where PAYMENTS.DELETED = 0
 union all
select INVOICES.ID
     , INVOICES.INVOICE_NUM                  as NAME
     , isnull(INVOICES.DUE_DATE, INVOICES.DATE_ENTERED) as BALANCE_DATE
     , N'Invoices'                           as BALANCE_TYPE
     , INVOICES.CURRENCY_ID                  as CURRENCY_ID
     , INVOICES.EXCHANGE_RATE                as EXCHANGE_RATE
     , (case when INVOICE_STAGE <> 'Cancelled'
             then INVOICES.TOTAL          * -1
             else 0.0
        end)                                 as AMOUNT
     , (case when INVOICE_STAGE <> 'Cancelled'
             then INVOICES.TOTAL_USDOLLAR * -1
             else 0.0
        end)                                 as AMOUNT_USDOLLAR
     , cast(null as money)                   as BANK_FEE_USDOLLAR
     , cast(null as money)                   as BALANCE_USDOLLAR
     , ACCOUNTS.ID                           as ACCOUNT_ID
     , ACCOUNTS.NAME                         as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID             as ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID              as ASSIGNED_SET_ID
     , ACCOUNTS.TEAM_ID
     , ACCOUNTS.TEAM_SET_ID
     , INVOICES.DATE_MODIFIED_UTC
  from            INVOICES
       inner join INVOICES_ACCOUNTS                         INVOICES_ACCOUNTS_BILLING
               on INVOICES_ACCOUNTS_BILLING.INVOICE_ID    = INVOICES.ID
              and INVOICES_ACCOUNTS_BILLING.ACCOUNT_ROLE  = N'Bill To'
              and INVOICES_ACCOUNTS_BILLING.DELETED       = 0
       inner join ACCOUNTS
               on ACCOUNTS.ID                             = INVOICES_ACCOUNTS_BILLING.ACCOUNT_ID
              and ACCOUNTS.DELETED                        = 0
 where INVOICES.DELETED = 0

GO

Grant Select on dbo.vwACCOUNTS_BALANCE to public;
GO

