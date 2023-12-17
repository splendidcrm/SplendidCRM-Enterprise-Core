if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACTIVITIES_EmailReminders')
	Drop View dbo.vwACTIVITIES_EmailReminders;
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
-- 06/07/2017 Paul.  Add support for Task reminders. DATE_DUE is used and not DATE_START. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACTIVITIES_EmailReminders
as
select N'Meetings'                           as ACTIVITY_TYPE
     , N'Users'                              as INVITEE_TYPE
     , MEETINGS_USERS.USER_ID                as INVITEE_ID
     , MEETINGS_USERS.ACCEPT_STATUS
     , USERS.FIRST_NAME
     , USERS.LAST_NAME
     , USERS.EMAIL1
     , USERS.TIMEZONE_ID
     , USERS.LANG
     , MEETINGS.ID
     , MEETINGS.NAME
     , MEETINGS.LOCATION
     , MEETINGS.DURATION_HOURS
     , MEETINGS.DURATION_MINUTES
     , MEETINGS.DATE_START
     , MEETINGS.DATE_END
     , MEETINGS.STATUS
     , cast(null as nvarchar(25))            as DIRECTION
     , MEETINGS.REMINDER_TIME
     , MEETINGS.EMAIL_REMINDER_TIME
     , MEETINGS.ASSIGNED_USER_ID
     , MEETINGS.PARENT_TYPE
     , MEETINGS.PARENT_ID
     , MEETINGS.TEAM_ID
     , MEETINGS.TEAM_SET_ID
     , MEETINGS.DESCRIPTION
     , MEETINGS.DATE_ENTERED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , MEETINGS.CREATED_BY         as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            MEETINGS
       inner join MEETINGS_USERS
               on MEETINGS_USERS.MEETING_ID          = MEETINGS.ID
              and MEETINGS_USERS.DELETED             = 0
              and MEETINGS_USERS.EMAIL_REMINDER_SENT = 0
              and isnull(MEETINGS_USERS.ACCEPT_STATUS, N'none') <> N'decline'
       inner join USERS
               on USERS.ID                           =  MEETINGS_USERS.USER_ID
              and USERS.DELETED                      =  0
              and USERS.EMAIL1 is not null
  left outer join USERS                                USERS_ASSIGNED
               on USERS_ASSIGNED.ID                  = MEETINGS.ASSIGNED_USER_ID
  left outer join USERS                                USERS_CREATED_BY
               on USERS_CREATED_BY.ID                = MEETINGS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                   = MEETINGS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED              = 0
 where MEETINGS.DELETED             = 0
   and MEETINGS.EMAIL_REMINDER_TIME > 0
   and (MEETINGS.STATUS is null or MEETINGS.STATUS <> N'Held')
   and getdate() between dbo.fnDateAdd_Seconds(-MEETINGS.EMAIL_REMINDER_TIME, MEETINGS.DATE_START) and dbo.fnDateAdd_Minutes(1, MEETINGS.DATE_START)
union all
select N'Meetings'                           as ACTIVITY_TYPE
     , N'Contacts'                           as INVITEE_TYPE
     , MEETINGS_CONTACTS.CONTACT_ID          as INVITEE_ID
     , MEETINGS_CONTACTS.ACCEPT_STATUS
     , CONTACTS.FIRST_NAME
     , CONTACTS.LAST_NAME
     , CONTACTS.EMAIL1
     , cast(null as uniqueidentifier)        as TIMEZONE_ID
     , cast(null as nvarchar(10))            as LANG
     , MEETINGS.ID
     , MEETINGS.NAME
     , MEETINGS.LOCATION
     , MEETINGS.DURATION_HOURS
     , MEETINGS.DURATION_MINUTES
     , MEETINGS.DATE_START
     , MEETINGS.DATE_END
     , MEETINGS.STATUS
     , cast(null as nvarchar(25))            as DIRECTION
     , MEETINGS.REMINDER_TIME
     , MEETINGS.EMAIL_REMINDER_TIME
     , MEETINGS.ASSIGNED_USER_ID
     , MEETINGS.PARENT_TYPE
     , MEETINGS.PARENT_ID
     , MEETINGS.TEAM_ID
     , MEETINGS.TEAM_SET_ID
     , MEETINGS.DESCRIPTION
     , MEETINGS.DATE_ENTERED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , MEETINGS.CREATED_BY         as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            MEETINGS
       inner join MEETINGS_CONTACTS
               on MEETINGS_CONTACTS.MEETING_ID          = MEETINGS.ID
              and MEETINGS_CONTACTS.DELETED             = 0
              and MEETINGS_CONTACTS.EMAIL_REMINDER_SENT = 0
              and isnull(MEETINGS_CONTACTS.ACCEPT_STATUS, N'none') <> N'decline'
       inner join CONTACTS
               on CONTACTS.ID                           =  MEETINGS_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                      =  0
              and CONTACTS.EMAIL1 is not null
  left outer join USERS                                   USERS_ASSIGNED
               on USERS_ASSIGNED.ID                     = MEETINGS.ASSIGNED_USER_ID
  left outer join USERS                                   USERS_CREATED_BY
               on USERS_CREATED_BY.ID                   = MEETINGS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                      = MEETINGS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED                 = 0
 where MEETINGS.DELETED             = 0
   and MEETINGS.EMAIL_REMINDER_TIME > 0
   and (MEETINGS.STATUS is null or MEETINGS.STATUS <> N'Held')
   and getdate() between dbo.fnDateAdd_Seconds(-MEETINGS.EMAIL_REMINDER_TIME, MEETINGS.DATE_START) and dbo.fnDateAdd_Minutes(1, MEETINGS.DATE_START)
union all
select N'Meetings'                           as ACTIVITY_TYPE
     , N'Leads'                              as INVITEE_TYPE
     , MEETINGS_LEADS.LEAD_ID                as INVITEE_ID
     , MEETINGS_LEADS.ACCEPT_STATUS
     , LEADS.FIRST_NAME
     , LEADS.LAST_NAME
     , LEADS.EMAIL1
     , cast(null as uniqueidentifier)        as TIMEZONE_ID
     , cast(null as nvarchar(10))            as LANG
     , MEETINGS.ID
     , MEETINGS.NAME
     , MEETINGS.LOCATION
     , MEETINGS.DURATION_HOURS
     , MEETINGS.DURATION_MINUTES
     , MEETINGS.DATE_START
     , MEETINGS.DATE_END
     , MEETINGS.STATUS
     , cast(null as nvarchar(25))            as DIRECTION
     , MEETINGS.REMINDER_TIME
     , MEETINGS.EMAIL_REMINDER_TIME
     , MEETINGS.ASSIGNED_USER_ID
     , MEETINGS.PARENT_TYPE
     , MEETINGS.PARENT_ID
     , MEETINGS.TEAM_ID
     , MEETINGS.TEAM_SET_ID
     , MEETINGS.DESCRIPTION
     , MEETINGS.DATE_ENTERED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , MEETINGS.CREATED_BY         as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            MEETINGS
       inner join MEETINGS_LEADS
               on MEETINGS_LEADS.MEETING_ID          =  MEETINGS.ID
              and MEETINGS_LEADS.DELETED             =  0
              and MEETINGS_LEADS.EMAIL_REMINDER_SENT = 0
              and isnull(MEETINGS_LEADS.ACCEPT_STATUS, N'none') <> N'decline'
       inner join LEADS
               on LEADS.ID                           =  MEETINGS_LEADS.LEAD_ID
              and LEADS.DELETED                      =  0
              and LEADS.EMAIL1 is not null
  left outer join USERS                                USERS_ASSIGNED
               on USERS_ASSIGNED.ID                  = MEETINGS.ASSIGNED_USER_ID
  left outer join USERS                                USERS_CREATED_BY
               on USERS_CREATED_BY.ID                = MEETINGS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                   = MEETINGS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED              = 0
 where MEETINGS.DELETED             = 0
   and MEETINGS.EMAIL_REMINDER_TIME > 0
   and (MEETINGS.STATUS is null or MEETINGS.STATUS <> N'Held')
   and getdate() between dbo.fnDateAdd_Seconds(-MEETINGS.EMAIL_REMINDER_TIME, MEETINGS.DATE_START) and dbo.fnDateAdd_Minutes(1, MEETINGS.DATE_START)
union all
select N'Calls'                              as ACTIVITY_TYPE
     , N'Users'                              as INVITEE_TYPE
     , CALLS_USERS.USER_ID                   as INVITEE_ID
     , CALLS_USERS.ACCEPT_STATUS
     , USERS.FIRST_NAME
     , USERS.LAST_NAME
     , USERS.EMAIL1
     , USERS.TIMEZONE_ID
     , USERS.LANG
     , CALLS.ID
     , CALLS.NAME
     , cast(null as nvarchar(50))            as LOCATION
     , CALLS.DURATION_HOURS
     , CALLS.DURATION_MINUTES
     , CALLS.DATE_START
     , CALLS.DATE_END
     , CALLS.STATUS
     , CALLS.DIRECTION
     , CALLS.REMINDER_TIME
     , CALLS.EMAIL_REMINDER_TIME
     , CALLS.ASSIGNED_USER_ID
     , CALLS.PARENT_TYPE
     , CALLS.PARENT_ID
     , CALLS.TEAM_ID
     , CALLS.TEAM_SET_ID
     , CALLS.DESCRIPTION
     , CALLS.DATE_ENTERED
     , CALLS.DATE_MODIFIED
     , CALLS.DATE_MODIFIED_UTC
     , CALLS.CREATED_BY            as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            CALLS
       inner join CALLS_USERS
               on CALLS_USERS.CALL_ID             = CALLS.ID
              and CALLS_USERS.DELETED             = 0
              and CALLS_USERS.EMAIL_REMINDER_SENT = 0
              and isnull(CALLS_USERS.ACCEPT_STATUS, N'none') <> N'decline'
       inner join USERS
               on USERS.ID                        = CALLS_USERS.USER_ID
              and USERS.DELETED                   = 0
              and USERS.EMAIL1 is not null
  left outer join USERS                             USERS_ASSIGNED
               on USERS_ASSIGNED.ID               = CALLS.ASSIGNED_USER_ID
  left outer join USERS                             USERS_CREATED_BY
               on USERS_CREATED_BY.ID             = CALLS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                = CALLS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED           = 0
 where CALLS.DELETED             = 0
   and CALLS.EMAIL_REMINDER_TIME > 0
   and (CALLS.STATUS is null or CALLS.STATUS <> N'Held')
   and getdate() between dbo.fnDateAdd_Seconds(-CALLS.EMAIL_REMINDER_TIME, CALLS.DATE_START) and dbo.fnDateAdd_Minutes(1, CALLS.DATE_START)
union all
select N'Calls'                              as ACTIVITY_TYPE
     , N'Contacts'                           as INVITEE_TYPE
     , CALLS_CONTACTS.CONTACT_ID             as INVITEE_ID
     , CALLS_CONTACTS.ACCEPT_STATUS
     , CONTACTS.FIRST_NAME
     , CONTACTS.LAST_NAME
     , CONTACTS.EMAIL1
     , cast(null as uniqueidentifier)        as TIMEZONE_ID
     , cast(null as nvarchar(10))            as LANG
     , CALLS.ID
     , CALLS.NAME
     , cast(null as nvarchar(50))            as LOCATION
     , CALLS.DURATION_HOURS
     , CALLS.DURATION_MINUTES
     , CALLS.DATE_START
     , CALLS.DATE_END
     , CALLS.STATUS
     , CALLS.DIRECTION
     , CALLS.REMINDER_TIME
     , CALLS.EMAIL_REMINDER_TIME
     , CALLS.ASSIGNED_USER_ID
     , CALLS.PARENT_TYPE
     , CALLS.PARENT_ID
     , CALLS.TEAM_ID
     , CALLS.TEAM_SET_ID
     , CALLS.DESCRIPTION
     , CALLS.DATE_ENTERED
     , CALLS.DATE_MODIFIED
     , CALLS.DATE_MODIFIED_UTC
     , CALLS.CREATED_BY            as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            CALLS
       inner join CALLS_CONTACTS
               on CALLS_CONTACTS.CALL_ID             = CALLS.ID
              and CALLS_CONTACTS.DELETED             = 0
              and CALLS_CONTACTS.EMAIL_REMINDER_SENT = 0
              and isnull(CALLS_CONTACTS.ACCEPT_STATUS, N'none') <> N'decline'
       inner join CONTACTS
               on CONTACTS.ID                        = CALLS_CONTACTS.CONTACT_ID
              and CONTACTS.DELETED                   = 0
              and CONTACTS.EMAIL1 is not null
  left outer join USERS                                USERS_ASSIGNED
               on USERS_ASSIGNED.ID                  = CALLS.ASSIGNED_USER_ID
  left outer join USERS                                USERS_CREATED_BY
               on USERS_CREATED_BY.ID                = CALLS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                   = CALLS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED              = 0
 where CALLS.DELETED             = 0
   and CALLS.EMAIL_REMINDER_TIME > 0
   and (CALLS.STATUS is null or CALLS.STATUS <> N'Held')
   and getdate() between dbo.fnDateAdd_Seconds(-CALLS.EMAIL_REMINDER_TIME, CALLS.DATE_START) and dbo.fnDateAdd_Minutes(1, CALLS.DATE_START)
union all
select N'Calls'                              as ACTIVITY_TYPE
     , N'Leads'                              as INVITEE_TYPE
     , CALLS_LEADS.LEAD_ID                   as INVITEE_ID
     , CALLS_LEADS.ACCEPT_STATUS
     , LEADS.FIRST_NAME
     , LEADS.LAST_NAME
     , LEADS.EMAIL1
     , cast(null as uniqueidentifier)        as TIMEZONE_ID
     , cast(null as nvarchar(10))            as LANG
     , CALLS.ID
     , CALLS.NAME
     , cast(null as nvarchar(50))            as LOCATION
     , CALLS.DURATION_HOURS
     , CALLS.DURATION_MINUTES
     , CALLS.DATE_START
     , CALLS.DATE_END
     , CALLS.STATUS
     , CALLS.DIRECTION
     , CALLS.REMINDER_TIME
     , CALLS.EMAIL_REMINDER_TIME
     , CALLS.ASSIGNED_USER_ID
     , CALLS.PARENT_TYPE
     , CALLS.PARENT_ID
     , CALLS.TEAM_ID
     , CALLS.TEAM_SET_ID
     , CALLS.DESCRIPTION
     , CALLS.DATE_ENTERED
     , CALLS.DATE_MODIFIED
     , CALLS.DATE_MODIFIED_UTC
     , CALLS.CREATED_BY            as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            CALLS
       inner join CALLS_LEADS
               on CALLS_LEADS.CALL_ID             = CALLS.ID
              and CALLS_LEADS.DELETED             = 0
              and CALLS_LEADS.EMAIL_REMINDER_SENT = 0
              and isnull(CALLS_LEADS.ACCEPT_STATUS, N'none') <> N'decline'
       inner join LEADS
               on LEADS.ID                        = CALLS_LEADS.LEAD_ID
              and LEADS.DELETED                   = 0
              and LEADS.EMAIL1 is not null
  left outer join USERS                             USERS_ASSIGNED
               on USERS_ASSIGNED.ID               = CALLS.ASSIGNED_USER_ID
  left outer join USERS                             USERS_CREATED_BY
               on USERS_CREATED_BY.ID             = CALLS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                = CALLS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED           = 0
 where CALLS.DELETED             = 0
   and CALLS.EMAIL_REMINDER_TIME > 0
   and (CALLS.STATUS is null or CALLS.STATUS <> N'Held')
   and getdate() between dbo.fnDateAdd_Seconds(-CALLS.EMAIL_REMINDER_TIME, CALLS.DATE_START) and dbo.fnDateAdd_Minutes(1, CALLS.DATE_START)
union all
select N'Tasks'                              as ACTIVITY_TYPE
     , N'Users'                              as INVITEE_TYPE
     , USERS_ASSIGNED.ID                     as INVITEE_ID
     , TASKS_USERS.ACCEPT_STATUS
     , USERS_ASSIGNED.FIRST_NAME
     , USERS_ASSIGNED.LAST_NAME
     , USERS_ASSIGNED.EMAIL1
     , USERS_ASSIGNED.TIMEZONE_ID
     , USERS_ASSIGNED.LANG
     , TASKS.ID
     , TASKS.NAME
     , cast(null as nvarchar(50))            as LOCATION
     , cast(null as int)                     as DURATION_HOURS
     , cast(null as int)                     as DURATION_MINUTES
     , TASKS.DATE_START
     , TASKS.DATE_DUE                        as DATE_END
     , TASKS.STATUS
     , cast(null as nvarchar(25))            as DIRECTION
     , TASKS.REMINDER_TIME
     , TASKS.EMAIL_REMINDER_TIME
     , TASKS.ASSIGNED_USER_ID
     , TASKS.PARENT_TYPE
     , TASKS.PARENT_ID
     , TASKS.TEAM_ID
     , TASKS.TEAM_SET_ID
     , TASKS.DESCRIPTION
     , TASKS.DATE_ENTERED
     , TASKS.DATE_MODIFIED
     , TASKS.DATE_MODIFIED_UTC
     , TASKS.CREATED_BY            as CREATED_BY_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            TASKS
       inner join USERS                             USERS_ASSIGNED
               on USERS_ASSIGNED.ID               = TASKS.ASSIGNED_USER_ID
              and USERS_ASSIGNED.DELETED          = 0
              and USERS_ASSIGNED.EMAIL1           is not null
  left outer join USERS                             USERS_CREATED_BY
               on USERS_CREATED_BY.ID             = TASKS.CREATED_BY
  left outer join TASKS_USERS
               on TASKS_USERS.TASK_ID             = TASKS.ID
              and TASKS_USERS.USER_ID             = TASKS.ASSIGNED_USER_ID
              and TASKS_USERS.DELETED             = 0
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID                = TASKS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED           = 0
 where TASKS.DELETED             = 0
   and TASKS.EMAIL_REMINDER_TIME > 0
   and (TASKS.STATUS is null or TASKS.STATUS in (N'Not started', N'In progress', N'Pending input'))
   and isnull(TASKS_USERS.EMAIL_REMINDER_SENT, 0) = 0
   and isnull(TASKS_USERS.ACCEPT_STATUS, N'none') <> N'decline'
   and getdate() between dbo.fnDateAdd_Seconds(-TASKS.EMAIL_REMINDER_TIME, TASKS.DATE_DUE) and dbo.fnDateAdd_Minutes(1, TASKS.DATE_DUE)

GO

Grant Select on dbo.vwACTIVITIES_EmailReminders to public;
GO

