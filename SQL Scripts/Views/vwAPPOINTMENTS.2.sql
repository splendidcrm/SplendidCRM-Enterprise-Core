if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwAPPOINTMENTS')
	Drop View dbo.vwAPPOINTMENTS;
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
-- 03/20/2013 Paul.  Add ALL_DAY_EVENT. 
-- 03/20/2013 Paul.  Add REPEAT fields. 
-- 09/13/2015 Paul.  We need a DATE_TIME field so that conversion to spAPPOINTMENTS_Update will copy the date. 
-- 09/13/2015 Paul.  We need a EMAIL_REMINDER_TIME field so that conversion to spAPPOINTMENTS_Update will copy the value. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwAPPOINTMENTS
as
select ID
     , NAME
     , N'Meetings' as APPOINTMENT_TYPE
     , LOCATION
     , DURATION_HOURS
     , DURATION_MINUTES
     , DATE_START          as DATE_TIME
     , DATE_START
     , DATE_END
     , PARENT_TYPE
     , STATUS
     , cast(null as nvarchar(25)) as DIRECTION
     , ASSIGNED_USER_ID
     , REMINDER_TIME
     , EMAIL_REMINDER_TIME
     , PARENT_ID
     , PARENT_NAME
     , PARENT_ASSIGNED_USER_ID
     , PARENT_ASSIGNED_SET_ID
     , DATE_ENTERED
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , DESCRIPTION
     , TEAM_ID
     , TEAM_NAME
     , ASSIGNED_TO
     , CREATED_BY
     , MODIFIED_BY
     , CREATED_BY_ID
     , MODIFIED_USER_ID
     , TEAM_SET_ID
     , TEAM_SET_NAME
     , ALL_DAY_EVENT
     , REPEAT_TYPE
     , REPEAT_INTERVAL
     , REPEAT_DOW
     , REPEAT_UNTIL
     , REPEAT_COUNT
     , RECURRING_SOURCE
     , ASSIGNED_SET_ID
     , ASSIGNED_SET_NAME
     , ASSIGNED_SET_LIST
  from vwMEETINGS
 where REPEAT_PARENT_ID is null
 union all
select ID
     , NAME
     , N'Calls' as APPOINTMENT_TYPE
     , cast(null as nvarchar(50)) as LOCATION
     , DURATION_HOURS
     , DURATION_MINUTES
     , DATE_START          as DATE_TIME
     , DATE_START
     , DATE_END
     , PARENT_TYPE
     , STATUS
     , DIRECTION
     , ASSIGNED_USER_ID
     , REMINDER_TIME
     , EMAIL_REMINDER_TIME
     , PARENT_ID
     , PARENT_NAME
     , PARENT_ASSIGNED_USER_ID
     , PARENT_ASSIGNED_SET_ID
     , DATE_ENTERED
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , DESCRIPTION
     , TEAM_ID
     , TEAM_NAME
     , ASSIGNED_TO
     , CREATED_BY
     , MODIFIED_BY
     , CREATED_BY_ID
     , MODIFIED_USER_ID
     , TEAM_SET_ID
     , TEAM_SET_NAME
     , ALL_DAY_EVENT
     , REPEAT_TYPE
     , REPEAT_INTERVAL
     , REPEAT_DOW
     , REPEAT_UNTIL
     , REPEAT_COUNT
     , RECURRING_SOURCE
     , ASSIGNED_SET_ID
     , ASSIGNED_SET_NAME
     , ASSIGNED_SET_LIST
  from vwCALLS
 where REPEAT_PARENT_ID is null

GO

Grant Select on dbo.vwAPPOINTMENTS to public;
GO


