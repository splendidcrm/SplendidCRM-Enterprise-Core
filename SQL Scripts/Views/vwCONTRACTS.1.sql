if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTRACTS')
	Drop View dbo.vwCONTRACTS;
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
-- 11/10/2006 Paul.  OPPORTUNITY_ID is stored in a relationship table. 
-- 11/10/2006 Paul.  Include OPPORTUNITY_ASSIGNED_USER_ID so that the view can be used in vwOPPORTUNITIES_CONTRACTS.
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 11/27/2006 Paul.  Return TEAM.ID so that a deleted team will return NULL even if a value remains in the related record. 
-- 11/30/2007 Paul.  Change TYPE to unique identifier and rename to TYPE_ID. 
-- 11/08/2008 Paul.  Move description to base view. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 09/01/2012 Paul.  Add LAST_ACTIVITY_DATE. 
-- 11/22/2012 Paul.  Join to LAST_ACTIVITY table. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCONTRACTS
as
select CONTRACTS.ID
     , CONTRACTS.NAME
     , CONTRACTS.REFERENCE_CODE
     , CONTRACTS.STATUS
     , CONTRACTS.TYPE_ID
     , CONTRACT_TYPES.NAME            as TYPE
     , CONTRACTS.START_DATE
     , CONTRACTS.END_DATE
     , CONTRACTS.COMPANY_SIGNED_DATE
     , CONTRACTS.CUSTOMER_SIGNED_DATE
     , CONTRACTS.EXPIRATION_NOTICE
     , CONTRACTS.CURRENCY_ID
     , CURRENCIES.NAME                as CURRENCY_NAME
     , CURRENCIES.SYMBOL              as CURRENCY_SYMBOL
     , CURRENCIES.CONVERSION_RATE     as CURRENCY_CONVERSION_RATE
     , CONTRACTS.TOTAL_CONTRACT_VALUE
     , CONTRACTS.TOTAL_CONTRACT_VALUE_USDOLLAR
     , CONTRACTS.ASSIGNED_USER_ID
     , CONTRACTS.DATE_ENTERED
     , CONTRACTS.DATE_MODIFIED
     , CONTRACTS.DATE_MODIFIED_UTC
     , CONTRACTS.DESCRIPTION
     , ACCOUNTS.ID                    as ACCOUNT_ID
     , ACCOUNTS.NAME                  as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID      as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID       as ACCOUNT_ASSIGNED_SET_ID
     , CONTACTS.ID                    as B2C_CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as B2C_CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID      as B2C_CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID       as B2C_CONTACT_ASSIGNED_SET_ID
     , OPPORTUNITIES.ID               as OPPORTUNITY_ID
     , OPPORTUNITIES.NAME             as OPPORTUNITY_NAME
     , OPPORTUNITIES.ASSIGNED_USER_ID as OPPORTUNITY_ASSIGNED_USER_ID
     , OPPORTUNITIES.ASSIGNED_SET_ID  as OPPORTUNITY_ASSIGNED_SET_ID
     , TEAMS.ID                       as TEAM_ID
     , TEAMS.NAME                     as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME       as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME     as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME    as MODIFIED_BY
     , CONTRACTS.CREATED_BY           as CREATED_BY_ID
     , CONTRACTS.MODIFIED_USER_ID
     , TEAM_SETS.ID                   as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME        as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST        as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , LAST_ACTIVITY.LAST_ACTIVITY_DATE
     , TAG_SETS.TAG_SET_NAME
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , CONTRACTS_CSTM.*
  from            CONTRACTS
  left outer join CONTRACT_TYPES
               on CONTRACT_TYPES.ID                   = CONTRACTS.TYPE_ID
              and CONTRACT_TYPES.DELETED              = 0
  left outer join ACCOUNTS
               on ACCOUNTS.ID                         = CONTRACTS.ACCOUNT_ID
              and ACCOUNTS.DELETED                    = 0
  left outer join CONTACTS
               on CONTACTS.ID                         = CONTRACTS.B2C_CONTACT_ID
              and CONTACTS.DELETED                    = 0
  left outer join CONTRACTS_OPPORTUNITIES
               on CONTRACTS_OPPORTUNITIES.CONTRACT_ID = CONTRACTS.ID
              and CONTRACTS_OPPORTUNITIES.DELETED     = 0
  left outer join OPPORTUNITIES
               on OPPORTUNITIES.ID                    = CONTRACTS_OPPORTUNITIES.OPPORTUNITY_ID
              and OPPORTUNITIES.DELETED               = 0
  left outer join CURRENCIES
               on CURRENCIES.ID                       = CONTRACTS.CURRENCY_ID
              and CURRENCIES.DELETED                  = 0
  left outer join TEAMS
               on TEAMS.ID                            = CONTRACTS.TEAM_ID
              and TEAMS.DELETED                       = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                        = CONTRACTS.TEAM_SET_ID
              and TEAM_SETS.DELETED                   = 0
  left outer join LAST_ACTIVITY
               on LAST_ACTIVITY.ACTIVITY_ID           = CONTRACTS.ID
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID                    = CONTRACTS.ID
              and TAG_SETS.DELETED                    = 0
  left outer join USERS                                 USERS_ASSIGNED
               on USERS_ASSIGNED.ID                   = CONTRACTS.ASSIGNED_USER_ID
  left outer join USERS                                 USERS_CREATED_BY
               on USERS_CREATED_BY.ID                 = CONTRACTS.CREATED_BY
  left outer join USERS                                 USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID                = CONTRACTS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                    = CONTRACTS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED               = 0
  left outer join CONTRACTS_CSTM
               on CONTRACTS_CSTM.ID_C                 = CONTRACTS.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID       = CONTRACTS.ID
 where CONTRACTS.DELETED = 0

GO

Grant Select on dbo.vwCONTRACTS to public;
GO


