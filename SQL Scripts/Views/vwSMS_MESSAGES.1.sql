if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSMS_MESSAGES')
	Drop View dbo.vwSMS_MESSAGES;
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
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwSMS_MESSAGES
as
select SMS_MESSAGES.ID
     , SMS_MESSAGES.NAME
     , SMS_MESSAGES.DATE_START
     , SMS_MESSAGES.TIME_START
     , dbo.fnViewDateTime(SMS_MESSAGES.DATE_START, SMS_MESSAGES.TIME_START) as DATE_TIME
     , SMS_MESSAGES.PARENT_TYPE
     , SMS_MESSAGES.PARENT_ID
     , SMS_MESSAGES.FROM_NUMBER
     , SMS_MESSAGES.TO_NUMBER
     , SMS_MESSAGES.TO_ID
     , SMS_MESSAGES.TYPE
     , SMS_MESSAGES.STATUS
     , SMS_MESSAGES.MESSAGE_SID
     , SMS_MESSAGES.FROM_LOCATION
     , SMS_MESSAGES.TO_LOCATION
     , SMS_MESSAGES.MAILBOX_ID
     , SMS_MESSAGES.ASSIGNED_USER_ID
     , vwPARENTS.PARENT_NAME
     , vwPARENTS.PARENT_ASSIGNED_USER_ID
     , vwPARENTS.PARENT_ASSIGNED_SET_ID
     , SMS_MESSAGES.DATE_ENTERED
     , SMS_MESSAGES.DATE_MODIFIED
     , SMS_MESSAGES.DATE_MODIFIED_UTC
     , SMS_MESSAGES.IS_PRIVATE
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , SMS_MESSAGES.CREATED_BY     as CREATED_BY_ID
     , SMS_MESSAGES.MODIFIED_USER_ID
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
     , SMS_MESSAGES_CSTM.*
  from            SMS_MESSAGES
  left outer join vwPARENTS
               on vwPARENTS.PARENT_ID      = SMS_MESSAGES.PARENT_ID
  left outer join TEAMS
               on TEAMS.ID                 = SMS_MESSAGES.TEAM_ID
              and TEAMS.DELETED            = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID             = SMS_MESSAGES.TEAM_SET_ID
              and TEAM_SETS.DELETED        = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID         = SMS_MESSAGES.ID
              and TAG_SETS.DELETED         = 0
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = SMS_MESSAGES.ASSIGNED_USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = SMS_MESSAGES.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = SMS_MESSAGES.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID         = SMS_MESSAGES.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED    = 0
  left outer join SMS_MESSAGES_CSTM
               on SMS_MESSAGES_CSTM.ID_C   = SMS_MESSAGES.ID
 where SMS_MESSAGES.DELETED = 0

GO

Grant Select on dbo.vwSMS_MESSAGES to public;
GO

 
