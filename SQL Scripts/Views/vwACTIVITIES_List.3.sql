if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACTIVITIES_List')
	Drop View dbo.vwACTIVITIES_List;
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
-- 08/30/2009 Paul.  All module views must have a TEAM_SET_ID. 
-- 12/21/2012 Paul.  Add REMINDER_TIME so that we can display an alert. 
-- 12/24/2012 Paul.  Add REMINDER_DISMISSED flag. 
-- 03/07/2013 Paul.  Add ALL_DAY_EVENT. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACTIVITIES_List
as
select N'Meetings'            as ACTIVITY_TYPE
     , vwMEETINGS.ID
     , vwMEETINGS.NAME
     , vwMEETINGS.LOCATION
     , vwMEETINGS.DURATION_HOURS
     , vwMEETINGS.DURATION_MINUTES
     , vwMEETINGS.ALL_DAY_EVENT
     , vwMEETINGS.DATE_START
     , vwMEETINGS.DATE_END
     , vwMEETINGS.REMINDER_TIME
     , vwMEETINGS.STATUS
     , cast(null as nvarchar(25)) as DIRECTION
     , MEETINGS_USERS.ACCEPT_STATUS
     , MEETINGS_USERS.REMINDER_DISMISSED
     , MEETINGS_USERS.USER_ID                            as ASSIGNED_USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as ASSIGNED_FULL_NAME
     , vwMEETINGS.TEAM_ID
     , vwMEETINGS.TEAM_NAME
     , vwMEETINGS.TEAM_SET_ID
     , vwMEETINGS.TEAM_SET_NAME
     , vwMEETINGS.ASSIGNED_SET_ID
     , vwMEETINGS.ASSIGNED_SET_NAME
     , vwMEETINGS.ASSIGNED_SET_LIST
     , vwMEETINGS.DESCRIPTION
from            vwMEETINGS
       inner join MEETINGS_USERS
               on MEETINGS_USERS.MEETING_ID    =  vwMEETINGS.ID
              and MEETINGS_USERS.DELETED       =  0
       inner join USERS
               on USERS.ID                     =  MEETINGS_USERS.USER_ID
              and USERS.DELETED                =  0
union all
select N'Calls'                   as ACTIVITY_TYPE
     , vwCALLS.ID
     , vwCALLS.NAME
     , cast(null as nvarchar(50)) as LOCATION
     , vwCALLS.DURATION_HOURS
     , vwCALLS.DURATION_MINUTES
     , vwCALLS.ALL_DAY_EVENT
     , vwCALLS.DATE_START
     , vwCALLS.DATE_END
     , vwCALLS.REMINDER_TIME
     , vwCALLS.STATUS
     , vwCALLS.DIRECTION
     , CALLS_USERS.ACCEPT_STATUS
     , CALLS_USERS.REMINDER_DISMISSED
     , CALLS_USERS.USER_ID                               as ASSIGNED_USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as ASSIGNED_FULL_NAME
     , vwCALLS.TEAM_ID
     , vwCALLS.TEAM_NAME
     , vwCALLS.TEAM_SET_ID
     , vwCALLS.TEAM_SET_NAME
     , vwCALLS.ASSIGNED_SET_ID
     , vwCALLS.ASSIGNED_SET_NAME
     , vwCALLS.ASSIGNED_SET_LIST
     , vwCALLS.DESCRIPTION
  from            vwCALLS
       inner join CALLS_USERS
               on CALLS_USERS.CALL_ID          = vwCALLS.ID
              and CALLS_USERS.DELETED          = 0
       inner join USERS
               on USERS.ID                     = CALLS_USERS.USER_ID
              and USERS.DELETED                = 0

GO

Grant Select on dbo.vwACTIVITIES_List to public;
GO

