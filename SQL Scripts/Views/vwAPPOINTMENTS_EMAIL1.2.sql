if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwAPPOINTMENTS_EMAIL1')
	Drop View dbo.vwAPPOINTMENTS_EMAIL1;
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
-- 01/10/2012 Paul.  The iCloud sync needs the contact name. 
-- 01/10/2012 Paul.  iCloud contacts do not require an email. 
-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
Create View dbo.vwAPPOINTMENTS_EMAIL1
as
select MEETINGS.ID               as APPOINTMENT_ID
     , vwCONTACTS.EMAIL1
     , MEETINGS_CONTACTS.REQUIRED
     , MEETINGS_CONTACTS.ACCEPT_STATUS
     , vwCONTACTS.NAME
     , MEETINGS.ASSIGNED_USER_ID
  from            MEETINGS
       inner join MEETINGS_CONTACTS
               on MEETINGS_CONTACTS.MEETING_ID = MEETINGS.ID
              and MEETINGS_CONTACTS.DELETED    = 0
       inner join vwCONTACTS
               on vwCONTACTS.ID                = MEETINGS_CONTACTS.CONTACT_ID
 where MEETINGS.DELETED = 0
 union
select MEETINGS.ID               as APPOINTMENT_ID
     , vwCONTACTS.EMAIL1
     , MEETINGS_CONTACTS.REQUIRED
     , MEETINGS_CONTACTS.ACCEPT_STATUS
     , vwCONTACTS.NAME
     , MEETINGS.ASSIGNED_USER_ID
  from            MEETINGS
       inner join vwCONTACTS
               on vwCONTACTS.ID                = MEETINGS.PARENT_ID
  left outer join MEETINGS_CONTACTS
               on MEETINGS_CONTACTS.MEETING_ID = MEETINGS.ID
              and MEETINGS_CONTACTS.CONTACT_ID = vwCONTACTS.ID
              and MEETINGS_CONTACTS.DELETED    = 0
 where MEETINGS.DELETED     = 0
   and MEETINGS.PARENT_TYPE = N'Contacts'
   and MEETINGS_CONTACTS.ID is null
 union
select CALLS.ID                  as APPOINTMENT_ID
     , vwCONTACTS.EMAIL1
     , CALLS_CONTACTS.REQUIRED
     , CALLS_CONTACTS.ACCEPT_STATUS
     , vwCONTACTS.NAME
     , CALLS.ASSIGNED_USER_ID
  from            CALLS
       inner join CALLS_CONTACTS
               on CALLS_CONTACTS.CALL_ID = CALLS.ID
              and CALLS_CONTACTS.DELETED = 0
       inner join vwCONTACTS
               on vwCONTACTS.ID          = CALLS_CONTACTS.CONTACT_ID
 where CALLS.DELETED = 0
 union
select CALLS.ID                  as APPOINTMENT_ID
     , vwCONTACTS.EMAIL1
     , CALLS_CONTACTS.REQUIRED
     , CALLS_CONTACTS.ACCEPT_STATUS
     , vwCONTACTS.NAME
     , CALLS.ASSIGNED_USER_ID
  from            CALLS
       inner join vwCONTACTS
               on vwCONTACTS.ID             = CALLS.PARENT_ID
  left outer join CALLS_CONTACTS
               on CALLS_CONTACTS.CALL_ID    = CALLS.ID
              and CALLS_CONTACTS.CONTACT_ID = vwCONTACTS.ID
              and CALLS_CONTACTS.DELETED    = 0
 where CALLS.DELETED     = 0
   and CALLS.PARENT_TYPE = N'Contacts'
   and CALLS_CONTACTS.ID is null
 union
select MEETING_ID                as APPOINTMENT_ID
     , vwUSERS.EMAIL1
     , MEETINGS_USERS.REQUIRED
     , MEETINGS_USERS.ACCEPT_STATUS
     , vwUSERS.NAME
     , MEETINGS.ASSIGNED_USER_ID
  from            MEETINGS
       inner join MEETINGS_USERS
               on MEETINGS_USERS.MEETING_ID = MEETINGS.ID
              and MEETINGS_USERS.DELETED    = 0
       inner join vwUSERS
               on vwUSERS.ID                = MEETINGS_USERS.USER_ID
 where MEETINGS.DELETED = 0
 union
select MEETING_ID                as APPOINTMENT_ID
     , isnull(vwUSERS.GOOGLEAPPS_USERNAME, OUTBOUND_EMAILS.MAIL_SMTPUSER) as EMAIL1
     , MEETINGS_USERS.REQUIRED
     , MEETINGS_USERS.ACCEPT_STATUS
     , vwUSERS.NAME
     , MEETINGS.ASSIGNED_USER_ID
  from            MEETINGS
       inner join MEETINGS_USERS
               on MEETINGS_USERS.MEETING_ID = MEETINGS.ID
              and MEETINGS_USERS.DELETED    = 0
       inner join vwUSERS
               on vwUSERS.ID                = MEETINGS_USERS.USER_ID
  left outer join OUTBOUND_EMAILS
               on OUTBOUND_EMAILS.USER_ID   = vwUSERS.ID
              and OUTBOUND_EMAILS.TYPE      = N'system-override'
              and OUTBOUND_EMAILS.DELETED   = 0
 where MEETINGS.DELETED = 0
   and (vwUSERS.GOOGLEAPPS_SYNC_CONTACTS = 1 or vwUSERS.GOOGLEAPPS_SYNC_CALENDAR = 1)
   and (vwUSERS.GOOGLEAPPS_USERNAME is not null or OUTBOUND_EMAILS.MAIL_SMTPUSER is not null)
 union
select CALL_ID                   as APPOINTMENT_ID
     , vwUSERS.EMAIL1
     , CALLS_USERS.REQUIRED
     , CALLS_USERS.ACCEPT_STATUS
     , vwUSERS.NAME
     , CALLS.ASSIGNED_USER_ID
  from            CALLS
       inner join CALLS_USERS
               on CALLS_USERS.CALL_ID = CALLS.ID
              and CALLS_USERS.DELETED = 0
       inner join vwUSERS
               on vwUSERS.ID          = CALLS_USERS.USER_ID
 where CALLS.DELETED = 0
 union
select CALL_ID                   as APPOINTMENT_ID
     , isnull(vwUSERS.GOOGLEAPPS_USERNAME, OUTBOUND_EMAILS.MAIL_SMTPUSER) as EMAIL1
     , CALLS_USERS.REQUIRED
     , CALLS_USERS.ACCEPT_STATUS
     , vwUSERS.NAME
     , CALLS.ASSIGNED_USER_ID
  from            CALLS
       inner join CALLS_USERS
               on CALLS_USERS.CALL_ID = CALLS.ID
              and CALLS_USERS.DELETED = 0
       inner join vwUSERS
               on vwUSERS.ID          = CALLS_USERS.USER_ID
  left outer join OUTBOUND_EMAILS
               on OUTBOUND_EMAILS.USER_ID   = vwUSERS.ID
              and OUTBOUND_EMAILS.TYPE      = N'system-override'
              and OUTBOUND_EMAILS.DELETED   = 0
 where CALLS.DELETED = 0
   and (vwUSERS.GOOGLEAPPS_SYNC_CONTACTS = 1 or vwUSERS.GOOGLEAPPS_SYNC_CALENDAR = 1)
   and (vwUSERS.GOOGLEAPPS_USERNAME is not null or OUTBOUND_EMAILS.MAIL_SMTPUSER is not null)
 union
select MEETINGS.ID               as APPOINTMENT_ID
     , vwLEADS.EMAIL1
     , MEETINGS_LEADS.REQUIRED
     , MEETINGS_LEADS.ACCEPT_STATUS
     , vwLEADS.NAME
     , MEETINGS.ASSIGNED_USER_ID
  from            MEETINGS
       inner join MEETINGS_LEADS
               on MEETINGS_LEADS.MEETING_ID = MEETINGS.ID
              and MEETINGS_LEADS.DELETED    = 0
       inner join vwLEADS
               on vwLEADS.ID                = MEETINGS_LEADS.LEAD_ID
 where MEETINGS.DELETED = 0
 union
select MEETINGS.ID               as APPOINTMENT_ID
     , vwLEADS.EMAIL1
     , MEETINGS_LEADS.REQUIRED
     , MEETINGS_LEADS.ACCEPT_STATUS
     , vwLEADS.NAME
     , MEETINGS.ASSIGNED_USER_ID
  from            MEETINGS
       inner join vwLEADS
               on vwLEADS.ID                = MEETINGS.PARENT_ID
  left outer join MEETINGS_LEADS
               on MEETINGS_LEADS.MEETING_ID = MEETINGS.ID
              and MEETINGS_LEADS.LEAD_ID = vwLEADS.ID
              and MEETINGS_LEADS.DELETED    = 0
 where MEETINGS.DELETED     = 0
   and MEETINGS.PARENT_TYPE = N'Leads'
   and MEETINGS_LEADS.ID is null
 union
select CALLS.ID                  as APPOINTMENT_ID
     , vwLEADS.EMAIL1
     , CALLS_LEADS.REQUIRED
     , CALLS_LEADS.ACCEPT_STATUS
     , vwLEADS.NAME
     , CALLS.ASSIGNED_USER_ID
  from            CALLS
       inner join CALLS_LEADS
               on CALLS_LEADS.CALL_ID = CALLS.ID
              and CALLS_LEADS.DELETED = 0
       inner join vwLEADS
               on vwLEADS.ID          = CALLS_LEADS.LEAD_ID
 where CALLS.DELETED = 0
 union
select CALLS.ID                  as APPOINTMENT_ID
     , vwLEADS.EMAIL1
     , CALLS_LEADS.REQUIRED
     , CALLS_LEADS.ACCEPT_STATUS
     , vwLEADS.NAME
     , CALLS.ASSIGNED_USER_ID
  from            CALLS
       inner join vwLEADS
               on vwLEADS.ID             = CALLS.PARENT_ID
  left outer join CALLS_LEADS
               on CALLS_LEADS.CALL_ID    = CALLS.ID
              and CALLS_LEADS.LEAD_ID = vwLEADS.ID
              and CALLS_LEADS.DELETED    = 0
 where CALLS.DELETED     = 0
   and CALLS.PARENT_TYPE = N'Leads'
   and CALLS_LEADS.ID is null

GO

Grant Select on dbo.vwAPPOINTMENTS_EMAIL1 to public;
GO


