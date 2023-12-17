if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwAPPOINTMENTS_SYNC')
	Drop View dbo.vwAPPOINTMENTS_SYNC;
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
-- 03/28/2010 Paul.  Exchange Web Services returns dates in local time, so lets store both local time and UTC time. 
-- 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_CONTACT is not, then the user has stopped syncing the contact. 
-- 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
-- 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
Create View dbo.vwAPPOINTMENTS_SYNC
as
select APPOINTMENTS_SYNC.ID                        as SYNC_ID
     , APPOINTMENTS_SYNC.ASSIGNED_USER_ID          as SYNC_ASSIGNED_USER_ID
     , APPOINTMENTS_SYNC.LOCAL_ID                  as SYNC_LOCAL_ID
     , APPOINTMENTS_SYNC.LOCAL_DATE_MODIFIED       as SYNC_LOCAL_DATE_MODIFIED
     , APPOINTMENTS_SYNC.REMOTE_DATE_MODIFIED      as SYNC_REMOTE_DATE_MODIFIED
     , APPOINTMENTS_SYNC.LOCAL_DATE_MODIFIED_UTC   as SYNC_LOCAL_DATE_MODIFIED_UTC
     , APPOINTMENTS_SYNC.REMOTE_DATE_MODIFIED_UTC  as SYNC_REMOTE_DATE_MODIFIED_UTC
     , APPOINTMENTS_SYNC.REMOTE_KEY                as SYNC_REMOTE_KEY
     , APPOINTMENTS_SYNC.SERVICE_NAME              as SYNC_SERVICE_NAME
     , APPOINTMENTS_SYNC.RAW_CONTENT               as SYNC_RAW_CONTENT
     , (case when vwAPPOINTMENTS_USERS.APPOINTMENT_ID is null then 0 else 1 end) as SYNC_APPOINTMENT
     , vwAPPOINTMENTS.ID
     , vwAPPOINTMENTS.DATE_MODIFIED
     , vwAPPOINTMENTS.DATE_MODIFIED_UTC
  from            APPOINTMENTS_SYNC
  left outer join vwAPPOINTMENTS
               on vwAPPOINTMENTS.ID                   = APPOINTMENTS_SYNC.LOCAL_ID
  left outer join vwAPPOINTMENTS_USERS                                
               on vwAPPOINTMENTS_USERS.APPOINTMENT_ID = vwAPPOINTMENTS.ID
              and vwAPPOINTMENTS_USERS.USER_ID        = APPOINTMENTS_SYNC.ASSIGNED_USER_ID
 where APPOINTMENTS_SYNC.DELETED = 0

GO

Grant Select on dbo.vwAPPOINTMENTS_SYNC to public;
GO


