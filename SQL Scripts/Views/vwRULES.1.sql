if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwRULES')
	Drop View dbo.vwRULES;
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
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 02/23/2021 Paul.  DATE_MODIFIED_UTC for React client. 
-- 05/25/2021 Paul.  Add Tags module. 
Create View dbo.vwRULES
as
select RULES.ID
     , RULES.NAME
     , RULES.MODULE_NAME
     , RULES.RULE_TYPE
     , RULES.DESCRIPTION
     , RULES.ASSIGNED_USER_ID
     , RULES.DATE_ENTERED
     , RULES.DATE_MODIFIED
     , RULES.DATE_MODIFIED_UTC
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , cast(null as uniqueidentifier)      as ASSIGNED_SET_ID
     , cast(USERS_ASSIGNED.ID as char(36)) as ASSIGNED_SET_LIST
     , USERS_ASSIGNED.USER_NAME            as ASSIGNED_SET_NAME
     , TAG_SETS.TAG_SET_NAME
  from            RULES
  left outer join TEAMS
               on TEAMS.ID             = RULES.TEAM_ID
              and TEAMS.DELETED        = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID         = RULES.TEAM_SET_ID
              and TEAM_SETS.DELETED    = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID     = RULES.ID
              and TAG_SETS.DELETED     = 0
  left outer join USERS USERS_ASSIGNED
               on USERS_ASSIGNED.ID    = RULES.ASSIGNED_USER_ID
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = RULES.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = RULES.MODIFIED_USER_ID
 where RULES.DELETED = 0

GO

Grant Select on dbo.vwRULES to public;
GO


