if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwAPPOINTMENTS_LEADS')
	Drop View dbo.vwAPPOINTMENTS_LEADS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwAPPOINTMENTS_LEADS
as
select MEETINGS.ID               as APPOINTMENT_ID
     , N'Meetings'               as APPOINTMENT_TYPE
     , MEETINGS.NAME             as APPOINTMENT_NAME
     , MEETINGS.ASSIGNED_USER_ID as APPOINTMENT_ASSIGNED_USER_ID
     , MEETINGS.ASSIGNED_SET_ID  as APPOINTMENT_ASSIGNED_SET_ID
     , MEETINGS_LEADS.ACCEPT_STATUS
     , vwLEADS.ID                as LEAD_ID
     , vwLEADS.NAME              as LEAD_NAME
     , vwLEADS.*
  from            MEETINGS
       inner join MEETINGS_LEADS
               on MEETINGS_LEADS.MEETING_ID = MEETINGS.ID
              and MEETINGS_LEADS.DELETED    = 0
       inner join vwLEADS
               on vwLEADS.ID                = MEETINGS_LEADS.LEAD_ID
 where MEETINGS.DELETED = 0
 union all
select MEETINGS.ID               as APPOINTMENT_ID
     , N'Meetings'               as APPOINTMENT_TYPE
     , MEETINGS.NAME             as APPOINTMENT_NAME
     , MEETINGS.ASSIGNED_USER_ID as APPOINTMENT_ASSIGNED_USER_ID
     , MEETINGS.ASSIGNED_SET_ID  as APPOINTMENT_ASSIGNED_SET_ID
     , MEETINGS_LEADS.ACCEPT_STATUS
     , vwLEADS.ID                as LEAD_ID
     , vwLEADS.NAME              as LEAD_NAME
     , vwLEADS.*
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
 union all
select CALLS.ID                  as APPOINTMENT_ID
     , N'Calls'                  as APPOINTMENT_TYPE
     , CALLS.NAME                as APPOINTMENT_NAME
     , CALLS.ASSIGNED_USER_ID    as APPOINTMENT_ASSIGNED_USER_ID
     , CALLS.ASSIGNED_SET_ID     as APPOINTMENT_ASSIGNED_SET_ID
     , CALLS_LEADS.ACCEPT_STATUS
     , vwLEADS.ID                as LEAD_ID
     , vwLEADS.NAME              as LEAD_NAME
     , vwLEADS.*
  from            CALLS
       inner join CALLS_LEADS
               on CALLS_LEADS.CALL_ID = CALLS.ID
              and CALLS_LEADS.DELETED = 0
       inner join vwLEADS
               on vwLEADS.ID          = CALLS_LEADS.LEAD_ID
 where CALLS.DELETED = 0
 union all
select CALLS.ID                  as APPOINTMENT_ID
     , N'Calls'                  as APPOINTMENT_TYPE
     , CALLS.NAME                as APPOINTMENT_NAME
     , CALLS.ASSIGNED_USER_ID    as APPOINTMENT_ASSIGNED_USER_ID
     , CALLS.ASSIGNED_SET_ID     as APPOINTMENT_ASSIGNED_SET_ID
     , CALLS_LEADS.ACCEPT_STATUS
     , vwLEADS.ID                as LEAD_ID
     , vwLEADS.NAME              as LEAD_NAME
     , vwLEADS.*
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

Grant Select on dbo.vwAPPOINTMENTS_LEADS to public;
GO

