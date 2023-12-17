if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOPPORTUNITIES_ConvertToOrder')
	Drop View dbo.vwOPPORTUNITIES_ConvertToOrder;
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
-- 03/31/2016 Paul.  Add DATE_MODIFIED_UTC. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 02/04/2020 Paul.  Add Tags module. 
Create View dbo.vwOPPORTUNITIES_ConvertToOrder
as
select cast(null as nvarchar(30))          as ORDER_NUM
     , OPPORTUNITIES.DATE_CLOSED           as DATE_ORDER_DUE
     , OPPORTUNITIES.ID                    as OPPORTUNITY_ID
     , OPPORTUNITIES.NAME                  as OPPORTUNITY_NAME
     , OPPORTUNITIES.LEAD_SOURCE
     , OPPORTUNITIES.NEXT_STEP
     , OPPORTUNITIES.ID
     , OPPORTUNITIES.NAME
     , cast(null as nvarchar(25))          as PAYMENT_TERMS
     , cast(null as nvarchar(25))          as ORDER_STAGE
     , cast(null as nvarchar(50))          as PURCHASE_ORDER_NUM
     , cast(null as datetime)              as ORIGINAL_PO_DATE
     , cast(null as datetime)              as DATE_ORDER_SHIPPED
     , cast(null as bit)                   as SHOW_LINE_NUMS
     , cast(null as bit)                   as CALC_GRAND_TOTAL
     , OPPORTUNITIES.CURRENCY_ID
     , cast(null as float)                 as EXCHANGE_RATE
     , OPPORTUNITIES.AMOUNT                as SUBTOTAL
     , OPPORTUNITIES.AMOUNT_USDOLLAR       as SUBTOTAL_USDOLLAR
     , cast(null as money)                 as DISCOUNT
     , cast(null as money)                 as DISCOUNT_USDOLLAR
     , cast(null as money)                 as SHIPPING
     , cast(null as money)                 as SHIPPING_USDOLLAR
     , cast(null as money)                 as TAX
     , cast(null as money)                 as TAX_USDOLLAR
     , OPPORTUNITIES.AMOUNT                as TOTAL
     , OPPORTUNITIES.AMOUNT_USDOLLAR       as TOTAL_USDOLLAR
     , ACCOUNTS.BILLING_ADDRESS_STREET
     , ACCOUNTS.BILLING_ADDRESS_CITY
     , ACCOUNTS.BILLING_ADDRESS_STATE
     , ACCOUNTS.BILLING_ADDRESS_POSTALCODE
     , ACCOUNTS.BILLING_ADDRESS_COUNTRY
     , ACCOUNTS.SHIPPING_ADDRESS_STREET
     , ACCOUNTS.SHIPPING_ADDRESS_CITY
     , ACCOUNTS.SHIPPING_ADDRESS_STATE
     , ACCOUNTS.SHIPPING_ADDRESS_POSTALCODE
     , ACCOUNTS.SHIPPING_ADDRESS_COUNTRY
     , cast(null as uniqueidentifier)      as TAXRATE_ID
     , cast(null as uniqueidentifier)      as SHIPPER_ID
     , OPPORTUNITIES.ASSIGNED_USER_ID
     , OPPORTUNITIES.DATE_ENTERED
     , OPPORTUNITIES.DATE_MODIFIED
     , OPPORTUNITIES.DATE_MODIFIED_UTC
     , ACCOUNTS.ID                         as BILLING_ACCOUNT_ID
     , ACCOUNTS.NAME                       as BILLING_ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID           as BILLING_ACCOUNT_ASSIGNED_ID
     , ACCOUNTS.ASSIGNED_USER_ID           as BILLING_ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID            as BILLING_ACCOUNT_ASSIGNED_SET_ID
     , ACCOUNTS.ID                         as SHIPPING_ACCOUNT_ID
     , ACCOUNTS.NAME                       as SHIPPING_ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID           as SHIPPING_ACCOUNT_ASSIGNED_ID
     , ACCOUNTS.ASSIGNED_USER_ID           as SHIPPING_ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID            as SHIPPING_ACCOUNT_ASSIGNED_SET_ID
     , CONTACTS.ID                         as BILLING_CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as BILLING_CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID           as BILLING_CONTACT_ASSIGNED_ID
     , CONTACTS.ASSIGNED_USER_ID           as BILLING_CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID            as BILLING_CONTACT_ASSIGNED_SET_ID
     , CONTACTS.ID                         as SHIPPING_CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as SHIPPING_CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID           as SHIPPING_CONTACT_ASSIGNED_ID
     , CONTACTS.ASSIGNED_USER_ID           as SHIPPING_CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID            as SHIPPING_CONTACT_ASSIGNED_SET_ID
     , cast(null as uniqueidentifier)      as QUOTE_ID
     , cast(null as nvarchar(150))         as QUOTE_NAME
     , cast(null as nvarchar(50))          as TAXRATE_NAME
     , cast(null as money)                 as TAXRATE_VALUE
     , cast(null as nvarchar(50))          as SHIPPER_NAME
     , TEAMS.ID                            as TEAM_ID
     , TEAMS.NAME                          as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME            as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME          as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME         as MODIFIED_BY
     , OPPORTUNITIES.CREATED_BY            as CREATED_BY_ID
     , OPPORTUNITIES.MODIFIED_USER_ID
     , OPPORTUNITIES.DESCRIPTION
     , TEAM_SETS.ID                        as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME             as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST             as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
     , TAG_SETS.TAG_SET_NAME
     , OPPORTUNITIES_CSTM.*
  from            OPPORTUNITIES
  left outer join ACCOUNTS_OPPORTUNITIES
               on ACCOUNTS_OPPORTUNITIES.OPPORTUNITY_ID = OPPORTUNITIES.ID
              and ACCOUNTS_OPPORTUNITIES.DELETED        = 0
  left outer join ACCOUNTS
               on ACCOUNTS.ID                           = ACCOUNTS_OPPORTUNITIES.ACCOUNT_ID
              and ACCOUNTS.DELETED                      = 0
  left outer join CONTACTS
               on CONTACTS.ID                           = OPPORTUNITIES.B2C_CONTACT_ID
              and CONTACTS.DELETED                      = 0
  left outer join QUOTES_OPPORTUNITIES
               on QUOTES_OPPORTUNITIES.QUOTE_ID         = OPPORTUNITIES.ID
              and QUOTES_OPPORTUNITIES.DELETED          = 0
  left outer join TEAMS
               on TEAMS.ID                              = OPPORTUNITIES.TEAM_ID
              and TEAMS.DELETED                         = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                          = OPPORTUNITIES.TEAM_SET_ID
              and TEAM_SETS.DELETED                     = 0
  left outer join USERS                                   USERS_ASSIGNED
               on USERS_ASSIGNED.ID                     = OPPORTUNITIES.ASSIGNED_USER_ID
  left outer join USERS                                   USERS_CREATED_BY
               on USERS_CREATED_BY.ID                   = OPPORTUNITIES.CREATED_BY
  left outer join USERS                                   USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID                  = OPPORTUNITIES.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                      = OPPORTUNITIES.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED                 = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID                      = OPPORTUNITIES.ID
              and TAG_SETS.DELETED                      = 0
  left outer join OPPORTUNITIES_CSTM
               on OPPORTUNITIES_CSTM.ID_C               = OPPORTUNITIES.ID
 where OPPORTUNITIES.DELETED = 0

GO

Grant Select on dbo.vwOPPORTUNITIES_ConvertToOrder to public;
GO

