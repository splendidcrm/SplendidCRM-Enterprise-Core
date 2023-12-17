if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDATA_PRIVACY')
	Drop View dbo.vwDATA_PRIVACY;
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
Create View dbo.vwDATA_PRIVACY
as
select DATA_PRIVACY.ID
     , DATA_PRIVACY.NAME
     , DATA_PRIVACY.DATA_PRIVACY_NUMBER
     , DATA_PRIVACY.TYPE
     , DATA_PRIVACY.STATUS
     , DATA_PRIVACY.PRIORITY
     , DATA_PRIVACY.DATE_OPENED
     , DATA_PRIVACY.DATE_DUE
     , DATA_PRIVACY.DATE_CLOSED
     , DATA_PRIVACY.SOURCE
     , DATA_PRIVACY.REQUESTED_BY
     , DATA_PRIVACY.BUSINESS_PURPOSE
     , DATA_PRIVACY.DESCRIPTION
     , DATA_PRIVACY.RESOLUTION
     , DATA_PRIVACY.WORK_LOG
     , DATA_PRIVACY.FIELDS_TO_ERASE
     , DATA_PRIVACY.ASSIGNED_USER_ID
     , DATA_PRIVACY.DATE_ENTERED
     , DATA_PRIVACY.DATE_MODIFIED
     , DATA_PRIVACY.DATE_MODIFIED_UTC
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , DATA_PRIVACY.CREATED_BY     as CREATED_BY_ID
     , DATA_PRIVACY.MODIFIED_USER_ID
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
     , DATA_PRIVACY_CSTM.*
  from            DATA_PRIVACY
  left outer join TEAMS
               on TEAMS.ID                 = DATA_PRIVACY.TEAM_ID
              and TEAMS.DELETED            = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID             = DATA_PRIVACY.TEAM_SET_ID
              and TEAM_SETS.DELETED        = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID         = DATA_PRIVACY.ID
              and TAG_SETS.DELETED         = 0
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = DATA_PRIVACY.ASSIGNED_USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = DATA_PRIVACY.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = DATA_PRIVACY.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID         = DATA_PRIVACY.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED    = 0
  left outer join DATA_PRIVACY_CSTM
               on DATA_PRIVACY_CSTM.ID_C       = DATA_PRIVACY.ID
 where DATA_PRIVACY.DELETED = 0

GO

Grant Select on dbo.vwDATA_PRIVACY to public;
GO

