if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCHAT_CHANNELS')
	Drop View dbo.vwCHAT_CHANNELS;
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
-- 05/17/2017 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCHAT_CHANNELS
as
select CHAT_CHANNELS.ID
     , CHAT_CHANNELS.NAME
     , CHAT_CHANNELS.DATE_ENTERED
     , CHAT_CHANNELS.DATE_MODIFIED
     , CHAT_CHANNELS.DATE_MODIFIED_UTC
     , CHAT_CHANNELS.PARENT_ID
     , CHAT_CHANNELS.PARENT_TYPE
     , CHAT_CHANNELS.ASSIGNED_USER_ID
     , vwPARENTS.PARENT_NAME             as PARENT_NAME
     , vwPARENTS.PARENT_ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , vwPARENTS.PARENT_ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , TEAMS.ID                          as TEAM_ID
     , TEAMS.NAME                        as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME          as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME        as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME       as MODIFIED_BY
     , CHAT_CHANNELS.CREATED_BY          as CREATED_BY_ID
     , TEAM_SETS.ID                      as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME           as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST           as TEAM_SET_LIST
     , CHAT_CHANNELS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , TAG_SETS.TAG_SET_NAME
  from            CHAT_CHANNELS
  left outer join vwPARENTS
               on vwPARENTS.PARENT_ID  = CHAT_CHANNELS.PARENT_ID
  left outer join TEAMS
               on TEAMS.ID             = CHAT_CHANNELS.TEAM_ID
              and TEAMS.DELETED        = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID         = CHAT_CHANNELS.TEAM_SET_ID
              and TEAM_SETS.DELETED    = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID     = CHAT_CHANNELS.ID
              and TAG_SETS.DELETED     = 0
  left outer join USERS                  USERS_ASSIGNED
               on USERS_ASSIGNED.ID    = CHAT_CHANNELS.ASSIGNED_USER_ID
  left outer join USERS                  USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = CHAT_CHANNELS.CREATED_BY
  left outer join USERS                  USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = CHAT_CHANNELS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID     = CHAT_CHANNELS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED= 0
 where CHAT_CHANNELS.DELETED = 0

GO

Grant Select on dbo.vwCHAT_CHANNELS to public;
GO


