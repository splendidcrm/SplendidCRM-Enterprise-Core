if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTASKS')
	Drop View dbo.vwTASKS;
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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 11/27/2006 Paul.  Return TEAM.ID so that a deleted team will return NULL even if a value remains in the related record. 
-- 11/08/2008 Paul.  Move description to base view. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 09/12/2011 Paul.  Add aliases DATE_TIME_DUE and DATE_TIME_START for the workflow engine. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 05/17/2017 Paul.  Add Tags module. 
-- 06/07/2017 Paul.  Add REMINDER_TIME, EMAIL_REMINDER_TIME, SMS_REMINDER_TIME. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwTASKS
as
select TASKS.ID
     , TASKS.NAME
     , TASKS.STATUS
     , TASKS.DATE_DUE_FLAG
     , TASKS.DATE_DUE
     , TASKS.TIME_DUE
     , TASKS.DATE_START_FLAG
     , TASKS.DATE_START
     , TASKS.TIME_START
     , dbo.fnViewDateTime(TASKS.DATE_DUE  , TASKS.TIME_DUE  ) as DATE_TIME_DUE
     , dbo.fnViewDateTime(TASKS.DATE_START, TASKS.TIME_START) as DATE_TIME_START
     , TASKS.PARENT_TYPE
     , TASKS.PARENT_ID
     , TASKS.CONTACT_ID
     , TASKS.PRIORITY
     , TASKS.ASSIGNED_USER_ID
     , TASKS.REMINDER_TIME
     , TASKS.EMAIL_REMINDER_TIME
     , TASKS.SMS_REMINDER_TIME
     , TASKS.IS_PRIVATE
     , vwPARENTS.PARENT_NAME
     , vwPARENTS.PARENT_ASSIGNED_USER_ID
     , vwPARENTS.PARENT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID   as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID    as CONTACT_ASSIGNED_SET_ID
     , CONTACTS.PHONE_WORK         as CONTACT_PHONE
     , CONTACTS.EMAIL1             as CONTACT_EMAIL
     , TASKS.DATE_ENTERED
     , TASKS.DATE_MODIFIED
     , TASKS.DATE_MODIFIED_UTC
     , TASKS.DESCRIPTION
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , TASKS.CREATED_BY            as CREATED_BY_ID
     , TASKS.MODIFIED_USER_ID
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
     , TASKS_CSTM.*
  from            TASKS
  left outer join vwPARENTS
               on vwPARENTS.PARENT_ID      = TASKS.PARENT_ID
  left outer join CONTACTS
               on CONTACTS.ID              = TASKS.CONTACT_ID
              and CONTACTS.DELETED         = 0
  left outer join TEAMS
               on TEAMS.ID                 = TASKS.TEAM_ID
              and TEAMS.DELETED            = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID             = TASKS.TEAM_SET_ID
              and TEAM_SETS.DELETED        = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID         = TASKS.ID
              and TAG_SETS.DELETED         = 0
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = TASKS.ASSIGNED_USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = TASKS.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = TASKS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID         = TASKS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED    = 0
  left outer join TASKS_CSTM
               on TASKS_CSTM.ID_C          = TASKS.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = TASKS.ID
 where TASKS.DELETED = 0

GO

Grant Select on dbo.vwTASKS to public;
GO

