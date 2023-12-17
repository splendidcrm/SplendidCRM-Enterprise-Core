if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES_QBOnline')
	Drop View dbo.vwINVOICES_QBOnline;
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
-- 02/06/2015 Paul.  Exclude invalid or duplicate names. 
-- 02/06/2015 Paul.  Reduce send errors by only including invoices with matching customers and items. 
-- 02/12/2015 Paul.  Make sure invoice has line items.  Let system generate an error when a line item is invalid to prevent masking the invalid data. 
-- 03/05/2015 Paul.  Use INVOICES table directly to increase performance. 
-- 03/06/2015 Paul.  Only include if there are line items that have a valid PRODUCT_TEMPLATE_ID. 
-- 03/06/2015 Paul.  Add support for comment lines. 
Create View dbo.vwINVOICES_QBOnline
as
select INVOICES.ID
     , INVOICES.INVOICE_NUM
     , INVOICES.NAME
     , INVOICES.PAYMENT_TERMS
     , INVOICES.INVOICE_STAGE
     , INVOICES.PURCHASE_ORDER_NUM
     , INVOICES.DUE_DATE
     , INVOICES.SHIP_DATE
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
     , INVOICES_ACCOUNTS_SHIPPING.ACCOUNT_ID as SHIPPING_ACCOUNT_ID
     , INVOICES_CONTACTS_BILLING.CONTACT_ID  as BILLING_CONTACT_ID
     , INVOICES_CONTACTS_SHIPPING.CONTACT_ID as SHIPPING_CONTACT_ID
     , TAX_RATES.NAME                        as TAXRATE_NAME
     , TAX_RATES.VALUE                       as TAXRATE_VALUE
     , SHIPPERS.NAME                         as SHIPPER_NAME
     , TEAMS.ID                              as TEAM_ID
     , TEAMS.NAME                            as TEAM_NAME
     , INVOICES.CREATED_BY                   as CREATED_BY_ID
     , INVOICES.MODIFIED_USER_ID
     , TEAM_SETS.ID                          as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME               as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST               as TEAM_SET_LIST
     , CURRENCIES.NAME                       as CURRENCY_NAME
     , CURRENCIES.SYMBOL                     as CURRENCY_SYMBOL
     , CURRENCIES.ISO4217                    as CURRENCY_ISO4217
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
  left outer join INVOICES_CONTACTS                         INVOICES_CONTACTS_BILLING
               on INVOICES_CONTACTS_BILLING.INVOICE_ID      = INVOICES.ID
              and INVOICES_CONTACTS_BILLING.CONTACT_ROLE  = N'Bill To'
              and INVOICES_CONTACTS_BILLING.DELETED       = 0
  left outer join INVOICES_CONTACTS                         INVOICES_CONTACTS_SHIPPING
               on INVOICES_CONTACTS_SHIPPING.INVOICE_ID     = INVOICES.ID
              and INVOICES_CONTACTS_SHIPPING.CONTACT_ROLE = N'Ship To'
              and INVOICES_CONTACTS_SHIPPING.DELETED      = 0
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
 where INVOICES.DELETED = 0
   and INVOICE_NUM is not null
   and INVOICE_NUM in (select INVOICE_NUM   from vwINVOICES group by INVOICE_NUM having count(*) = 1)
   and exists(select * from vwINVOICES_LINE_ITEMS where INVOICE_ID = INVOICES.ID and (PRODUCT_TEMPLATE_ID is not null or LINE_ITEM_TYPE = 'Comment'))
   and (   INVOICES_ACCOUNTS_BILLING.ACCOUNT_ID in (select SYNC_LOCAL_ID from vwACCOUNTS_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')
        or INVOICES_CONTACTS_BILLING.CONTACT_ID in (select SYNC_LOCAL_ID from vwCONTACTS_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')
       )

GO

Grant Select on dbo.vwINVOICES_QBOnline to public;
GO


