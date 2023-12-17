if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_ConvertToOpportunity')
	Drop View dbo.vwQUOTES_ConvertToOpportunity;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 02/04/2020 Paul.  Add Tags module. 
Create View dbo.vwQUOTES_ConvertToOpportunity
as
select QUOTES.TOTAL                        as AMOUNT
     , QUOTES.TOTAL_USDOLLAR               as AMOUNT_USDOLLAR
     , QUOTES.ID                           as QUOTE_ID
     , QUOTES.NAME                         as QUOTE_NAME
     , QUOTES.ID
     , QUOTES.QUOTE_NUM
     , QUOTES.NAME
     , QUOTES.DATE_QUOTE_EXPECTED_CLOSED   as DATE_CLOSED
     , cast(null as nvarchar(255))         as OPPORTUNITY_TYPE
     , cast(null as nvarchar(50))          as LEAD_SOURCE
     , cast(null as nvarchar(100))         as NEXT_STEP
     , cast(null as nvarchar(25))          as SALES_STAGE
     , cast(null as float)                 as PROBABILITY
     , QUOTES.CURRENCY_ID
     , QUOTES.TOTAL
     , QUOTES.TOTAL_USDOLLAR
     , QUOTES.ASSIGNED_USER_ID
     , QUOTES.DATE_ENTERED
     , QUOTES.DATE_MODIFIED
     , QUOTES.DATE_MODIFIED_UTC
     , QUOTES_ACCOUNTS_BILLING.ACCOUNT_ID  as ACCOUNT_ID
     , ACCOUNTS_BILLING.NAME               as ACCOUNT_NAME
     , ACCOUNTS_BILLING.ASSIGNED_USER_ID   as ACCOUNT_ASSIGNED_ID
     , QUOTES_CONTACTS_BILLING.CONTACT_ID  as B2C_CONTACT_ID
     , dbo.fnFullName(CONTACTS_BILLING.FIRST_NAME, CONTACTS_BILLING.LAST_NAME) as B2C_CONTACT_NAME
     , CONTACTS_BILLING.ASSIGNED_USER_ID   as B2C_CONTACT_ASSIGNED_ID
     , TEAMS.ID                            as TEAM_ID
     , TEAMS.NAME                          as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME            as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME          as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME         as MODIFIED_BY
     , QUOTES.CREATED_BY                   as CREATED_BY_ID
     , QUOTES.MODIFIED_USER_ID
     , QUOTES.DESCRIPTION
     , TEAM_SETS.ID                        as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME             as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST             as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                    as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME     as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST     as ASSIGNED_SET_LIST
     , TAG_SETS.TAG_SET_NAME
     , QUOTES_CSTM.*
  from            QUOTES
  left outer join QUOTES_ACCOUNTS                         QUOTES_ACCOUNTS_BILLING
               on QUOTES_ACCOUNTS_BILLING.QUOTE_ID      = QUOTES.ID
              and QUOTES_ACCOUNTS_BILLING.ACCOUNT_ROLE  = N'Bill To'
              and QUOTES_ACCOUNTS_BILLING.DELETED       = 0
  left outer join ACCOUNTS                                ACCOUNTS_BILLING
               on ACCOUNTS_BILLING.ID                   = QUOTES_ACCOUNTS_BILLING.ACCOUNT_ID
              and ACCOUNTS_BILLING.DELETED              = 0
  left outer join QUOTES_CONTACTS                         QUOTES_CONTACTS_BILLING
               on QUOTES_CONTACTS_BILLING.QUOTE_ID      = QUOTES.ID
              and QUOTES_CONTACTS_BILLING.CONTACT_ROLE  = N'Bill To'
              and QUOTES_CONTACTS_BILLING.DELETED       = 0
  left outer join CONTACTS                                CONTACTS_BILLING
               on CONTACTS_BILLING.ID                   = QUOTES_CONTACTS_BILLING.CONTACT_ID
              and CONTACTS_BILLING.DELETED              = 0
  left outer join TEAMS
               on TEAMS.ID                              = QUOTES.TEAM_ID
              and TEAMS.DELETED                         = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                          = QUOTES.TEAM_SET_ID
              and TEAM_SETS.DELETED                     = 0
  left outer join USERS                                   USERS_ASSIGNED
               on USERS_ASSIGNED.ID                     = QUOTES.ASSIGNED_USER_ID
  left outer join USERS                                   USERS_CREATED_BY
               on USERS_CREATED_BY.ID                   = QUOTES.CREATED_BY
  left outer join USERS                                   USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID                  = QUOTES.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                      = QUOTES.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED                 = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID                      = QUOTES.ID
              and TAG_SETS.DELETED                      = 0
  left outer join QUOTES_CSTM
               on QUOTES_CSTM.ID_C                      = QUOTES.ID
 where QUOTES.DELETED = 0

GO

Grant Select on dbo.vwQUOTES_ConvertToOpportunity to public;
GO

