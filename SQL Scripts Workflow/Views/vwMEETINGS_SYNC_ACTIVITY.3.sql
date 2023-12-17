if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMEETINGS_SYNC_ACTIVITY')
	Drop View dbo.vwMEETINGS_SYNC_ACTIVITY;
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
-- 09/16/2015 Paul.  Google APIs use OAUTH and not username/password. 
Create View dbo.vwMEETINGS_SYNC_ACTIVITY
as
select MEETINGS.ID
     , MEETINGS_USERS.USER_ID
     , USERS.GOOGLEAPPS_SYNC_CALENDAR
     , USERS.GOOGLEAPPS_USERNAME
     , USERS.ICLOUD_SYNC_CALENDAR
     , USERS.ICLOUD_USERNAME
     , (case when exists(select * from OAUTH_TOKENS where NAME = 'GoogleApps' and ASSIGNED_USER_ID = USERS.ID and DELETED = 0) then 1
        else 0
        end)  as GOOGLEAPPS_USER_ENABLED
  from            MEETINGS
       inner join MEETINGS_USERS
               on MEETINGS_USERS.MEETING_ID         = MEETINGS.ID
              and MEETINGS_USERS.DELETED            = 0
       inner join USERS
               on USERS.ID                          = MEETINGS_USERS.USER_ID
              and USERS.DELETED                     = 0
  left outer join vwEXCHANGE_USERS
               on vwEXCHANGE_USERS.ASSIGNED_USER_ID = MEETINGS_USERS.USER_ID
 where MEETINGS.DELETED = 0
   and (    vwEXCHANGE_USERS.ID is not null
        or (USERS.GOOGLEAPPS_SYNC_CALENDAR = 1 and exists(select * from OAUTH_TOKENS where NAME = 'GoogleApps' and ASSIGNED_USER_ID = USERS.ID and DELETED = 0))
        or (USERS.ICLOUD_SYNC_CALENDAR     = 1 and USERS.ICLOUD_USERNAME     is not null)
       )

GO

Grant Select on dbo.vwMEETINGS_SYNC_ACTIVITY to public;
GO


