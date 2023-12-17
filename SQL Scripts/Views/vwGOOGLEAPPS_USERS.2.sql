if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwGOOGLEAPPS_USERS')
	Drop View dbo.vwGOOGLEAPPS_USERS;
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
-- 01/09/2013 Paul.  Make sure to exclude invalid users. 
-- 09/16/2015 Paul.  Google APIs use OAUTH and not username/password. 
Create View dbo.vwGOOGLEAPPS_USERS
as
select USERS.ID                 as USER_ID
     , USERS.EMAIL1
     , USERS.GOOGLEAPPS_SYNC_CONTACTS
     , USERS.GOOGLEAPPS_SYNC_CALENDAR
     , isnull(USERS.GOOGLEAPPS_USERNAME, OUTBOUND_EMAILS.MAIL_SMTPUSER) as GOOGLEAPPS_USERNAME
     , isnull(USERS.GOOGLEAPPS_PASSWORD, OUTBOUND_EMAILS.MAIL_SMTPPASS) as GOOGLEAPPS_PASSWORD
  from            USERS
  left outer join OUTBOUND_EMAILS
               on OUTBOUND_EMAILS.USER_ID         = USERS.ID
              and OUTBOUND_EMAILS.TYPE            = N'system-override'
              and OUTBOUND_EMAILS.DELETED         = 0
 where USERS.STATUS  = N'Active'
   and USERS.DELETED = 0
   and (USERS.GOOGLEAPPS_SYNC_CONTACTS = 1 or USERS.GOOGLEAPPS_SYNC_CALENDAR = 1)
   and exists(select * from OAUTH_TOKENS where NAME = 'GoogleApps' and ASSIGNED_USER_ID = USERS.ID and DELETED = 0)
--   and isnull(USERS.GOOGLEAPPS_USERNAME, OUTBOUND_EMAILS.MAIL_SMTPUSER) is not null
--   and isnull(USERS.GOOGLEAPPS_PASSWORD, OUTBOUND_EMAILS.MAIL_SMTPPASS) is not null

GO

Grant Select on dbo.vwGOOGLEAPPS_USERS to public;
GO


