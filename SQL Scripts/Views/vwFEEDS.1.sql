if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFEEDS')
	Drop View dbo.vwFEEDS;
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
-- 12/29/2006 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwFEEDS
as
select FEEDS.ID
     , FEEDS.TITLE
     , FEEDS.URL
     , FEEDS.ASSIGNED_USER_ID
     , FEEDS.DATE_ENTERED
     , FEEDS.DATE_MODIFIED
     , FEEDS.DATE_MODIFIED_UTC
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , FEEDS_CSTM.*
  from            FEEDS
  left outer join TEAMS
               on TEAMS.ID             = FEEDS.TEAM_ID
              and TEAMS.DELETED        = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID         = FEEDS.TEAM_SET_ID
              and TEAM_SETS.DELETED    = 0
  left outer join USERS                  USERS_ASSIGNED
               on USERS_ASSIGNED.ID    = FEEDS.ASSIGNED_USER_ID
  left outer join USERS                  USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = FEEDS.CREATED_BY
  left outer join USERS                  USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = FEEDS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID     = FEEDS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED= 0
  left outer join FEEDS_CSTM
               on FEEDS_CSTM.ID_C      = FEEDS.ID
 where FEEDS.DELETED = 0

GO

Grant Select on dbo.vwFEEDS to public;
GO

 
