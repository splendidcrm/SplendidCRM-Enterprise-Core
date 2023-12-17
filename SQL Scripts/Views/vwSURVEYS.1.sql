if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEYS')
	Drop View dbo.vwSURVEYS;
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
-- 05/12/2016 Paul.  Add Tags module. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
Create View dbo.vwSURVEYS
as
select SURVEYS.ID
     , SURVEYS.NAME
     , SURVEYS.STATUS
     , SURVEYS.SURVEY_TARGET_MODULE
     , SURVEYS.SURVEY_TARGET_ASSIGNMENT
     , SURVEYS.SURVEY_STYLE
     , SURVEYS.PAGE_RANDOMIZATION
     , SURVEYS.LOOP_SURVEY
     , SURVEYS.EXIT_CODE
     , SURVEYS.TIMEOUT
     , SURVEYS.DESCRIPTION
     , SURVEYS.ASSIGNED_USER_ID
     , SURVEYS.DATE_ENTERED
     , SURVEYS.DATE_MODIFIED
     , SURVEYS.DATE_MODIFIED_UTC
     , SURVEY_THEMES.ID            as SURVEY_THEME_ID
     , SURVEY_THEMES.NAME          as SURVEY_THEME_NAME
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , SURVEYS.CREATED_BY          as CREATED_BY_ID
     , SURVEYS.MODIFIED_USER_ID
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , TAG_SETS.TAG_SET_NAME
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , SURVEYS_CSTM.*
  from            SURVEYS
  left outer join SURVEY_THEMES
               on SURVEY_THEMES.ID     = SURVEYS.SURVEY_THEME_ID
  left outer join TEAMS
               on TEAMS.ID             = SURVEYS.TEAM_ID
              and TEAMS.DELETED        = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID         = SURVEYS.TEAM_SET_ID
              and TEAM_SETS.DELETED    = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID     = SURVEYS.ID
              and TAG_SETS.DELETED     = 0
  left outer join USERS                  USERS_ASSIGNED
               on USERS_ASSIGNED.ID    = SURVEYS.ASSIGNED_USER_ID
  left outer join USERS                  USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = SURVEYS.CREATED_BY
  left outer join USERS                  USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = SURVEYS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID     = SURVEYS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED= 0
  left outer join SURVEYS_CSTM
               on SURVEYS_CSTM.ID_C    = SURVEYS.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = SURVEYS.ID
 where SURVEYS.DELETED = 0

GO

Grant Select on dbo.vwSURVEYS to public;
GO

