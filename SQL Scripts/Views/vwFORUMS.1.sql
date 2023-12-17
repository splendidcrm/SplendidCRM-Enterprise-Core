if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFORUMS')
	Drop View dbo.vwFORUMS;
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
-- 11/08/2008 Paul.  Move description to base view. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 04/10/2021 Paul.  The React client requires that all module tables have a NAME field. 
Create View dbo.vwFORUMS
as
select FORUMS.ID
     , FORUMS.TITLE
     , FORUMS.TITLE                   as NAME
     , FORUMS.CATEGORY
     , FORUMS.THREADCOUNT
     , FORUMS.THREADANDPOSTCOUNT
     , FORUMS.DATE_ENTERED
     , FORUMS.DATE_MODIFIED
     , FORUMS.DATE_MODIFIED_UTC
     , FORUMS.DESCRIPTION
     , cast(null as uniqueidentifier) as ASSIGNED_USER_ID
     , TEAMS.ID                       as TEAM_ID
     , TEAMS.NAME                     as TEAM_NAME
     , USERS_CREATED_BY.USER_NAME     as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME    as MODIFIED_BY
     , FORUMS.CREATED_BY              as CREATED_BY_ID
     , TEAM_SETS.ID                   as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME        as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST        as TEAM_SET_LIST
     , FORUMS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            FORUMS
  left outer join TEAMS
               on TEAMS.ID             = FORUMS.TEAM_ID
              and TEAMS.DELETED        = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID         = FORUMS.TEAM_SET_ID
              and TEAM_SETS.DELETED    = 0
  left outer join USERS                  USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = FORUMS.CREATED_BY
  left outer join USERS                  USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = FORUMS.MODIFIED_USER_ID
 where FORUMS.DELETED = 0

GO

Grant Select on dbo.vwFORUMS to public;
GO


