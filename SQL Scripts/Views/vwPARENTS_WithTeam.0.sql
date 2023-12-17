if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPARENTS_WithTeam')
	Drop View dbo.vwPARENTS_WithTeam;
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
-- 11/30/2017 Paul.  ChatMessages are not used as parents. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPARENTS_WithTeam
as
select ACCOUNTS.ID                    as PARENT_ID
     , ACCOUNTS.NAME                  as PARENT_NAME
     , N'Accounts'                    as PARENT_TYPE
     , N'Accounts'                    as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            ACCOUNTS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where ACCOUNTS.DELETED = 0
union all
select BUGS.ID                        as PARENT_ID
     , BUGS.NAME                      as PARENT_NAME
     , N'Bugs'                        as PARENT_TYPE
     , N'Bugs'                        as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            BUGS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where BUGS.DELETED = 0
union all
select CASES.ID                       as PARENT_ID
     , CASES.NAME                     as PARENT_NAME
     , N'Cases'                       as PARENT_TYPE
     , N'Cases'                       as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            CASES
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where CASES.DELETED = 0
union all
select CONTACTS.ID                    as PARENT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as PARENT_NAME
     , N'Contacts'                    as PARENT_TYPE
     , N'Contacts'                    as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            CONTACTS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where CONTACTS.DELETED = 0
union all
select EMAILS.ID                      as PARENT_ID
     , EMAILS.NAME                    as PARENT_NAME
     , N'Emails'                      as PARENT_TYPE
     , N'Emails'                      as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            EMAILS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where EMAILS.DELETED = 0
union all
select LEADS.ID                       as PARENT_ID
     , dbo.fnFullName(LEADS.FIRST_NAME, LEADS.LAST_NAME) as PARENT_NAME
     , N'Leads'                       as PARENT_TYPE
     , N'Leads'                       as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            LEADS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where LEADS.DELETED = 0
union all
select OPPORTUNITIES.ID               as PARENT_ID
     , OPPORTUNITIES.NAME             as PARENT_NAME
     , N'Opportunities'               as PARENT_TYPE
     , N'Opportunities'               as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            OPPORTUNITIES
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where OPPORTUNITIES.DELETED = 0
union all
select PROJECT.ID                     as PARENT_ID
     , PROJECT.NAME                   as PARENT_NAME
     , N'Project'                     as PARENT_TYPE
     , N'Projects'                    as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            PROJECT
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where PROJECT.DELETED = 0
union all
select PROJECT_TASK.ID                as PARENT_ID
     , PROJECT_TASK.NAME              as PARENT_NAME
     , N'ProjectTask'                 as PARENT_TYPE
     , N'ProjectTasks'                as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            PROJECT_TASK
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where PROJECT_TASK.DELETED = 0
union all
select CAMPAIGNS.ID                   as PARENT_ID
     , CAMPAIGNS.NAME                 as PARENT_NAME
     , N'Campaigns'                   as PARENT_TYPE
     , N'Campaigns'                   as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            CAMPAIGNS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where CAMPAIGNS.DELETED = 0
union all
select PROSPECTS.ID                   as PARENT_ID
     , dbo.fnFullName(PROSPECTS.FIRST_NAME, PROSPECTS.LAST_NAME) as PARENT_NAME
     , N'Prospects'                   as PARENT_TYPE
     , N'Prospects'                   as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            PROSPECTS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where PROSPECTS.DELETED = 0
union all
select CONTRACTS.ID                   as PARENT_ID
     , CONTRACTS.NAME                 as PARENT_NAME
     , N'Contracts'                   as PARENT_TYPE
     , N'Contracts'                   as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            CONTRACTS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where CONTRACTS.DELETED = 0
union all
select CALLS.ID                       as PARENT_ID
     , CALLS.NAME                     as PARENT_NAME
     , N'Calls'                       as PARENT_TYPE
     , N'Calls'                       as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            CALLS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where CALLS.DELETED = 0
union all
select PRODUCTS.ID                    as PARENT_ID
     , PRODUCTS.NAME                  as PARENT_NAME
     , N'Products'                    as PARENT_TYPE
     , N'Products'                    as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(60))     as PARENT_ASSIGNED_TO
     , cast(null as nvarchar(100))    as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            PRODUCTS
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where PRODUCTS.DELETED = 0
union all
select QUOTES.ID                      as PARENT_ID
     , QUOTES.NAME                    as PARENT_NAME
     , N'Quotes'                      as PARENT_TYPE
     , N'Quotes'                      as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            QUOTES
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where QUOTES.DELETED = 0
union all
select ORDERS.ID                      as PARENT_ID
     , ORDERS.NAME                    as PARENT_NAME
     , N'Orders'                      as PARENT_TYPE
     , N'Orders'                      as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            ORDERS
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where ORDERS.DELETED = 0
union all
select INVOICES.ID                    as PARENT_ID
     , INVOICES.NAME                  as PARENT_NAME
     , N'Invoices'                    as PARENT_TYPE
     , N'Invoices'                    as MODULE
     , ASSIGNED_USER_ID               as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as PARENT_ASSIGNED_SET_ID
     , USERS.USER_NAME                as PARENT_ASSIGNED_TO
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as PARENT_ASSIGNED_TO_NAME
     , TEAMS.ID                       as PARENT_TEAM_ID
     , TEAMS.NAME                     as PARENT_TEAM_NAME
     , TEAM_SET_ID                    as PARENT_TEAM_SET_ID
  from            INVOICES
  left outer join USERS
               on USERS.ID      = ASSIGNED_USER_ID
  left outer join TEAMS
               on TEAMS.ID      = TEAM_ID
              and TEAMS.DELETED = 0
 where INVOICES.DELETED = 0
union all
select USERS.ID                       as PARENT_ID
     , USERS.USER_NAME                as PARENT_NAME
     , N'Users'                       as PARENT_TYPE
     , N'Users'                       as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(60))     as PARENT_ASSIGNED_TO
     , cast(null as nvarchar(100))    as PARENT_ASSIGNED_TO_NAME
     , cast(null as uniqueidentifier) as PARENT_TEAM_ID
     , cast(null as nvarchar(128))    as PARENT_TEAM_NAME
     , cast(null as uniqueidentifier) as PARENT_TEAM_SET_ID
  from USERS
 where DELETED = 0

GO

Grant Select on dbo.vwPARENTS_WithTeam to public;
GO

