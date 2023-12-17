if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_SYNC_ACTIVITY')
	Drop View dbo.vwCONTACTS_SYNC_ACTIVITY;
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
-- 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
Create View dbo.vwCONTACTS_SYNC_ACTIVITY
as
select CONTACTS.ID
     , CONTACTS_USERS.USER_ID
     , USERS.GOOGLEAPPS_SYNC_CONTACTS
     , USERS.GOOGLEAPPS_USERNAME
     , USERS.ICLOUD_SYNC_CONTACTS
     , USERS.ICLOUD_USERNAME
     , (case when exists(select * from OAUTH_TOKENS where NAME = 'GoogleApps' and ASSIGNED_USER_ID = USERS.ID and DELETED = 0) then 1 else 0 end)  as GOOGLEAPPS_USER_ENABLED
     , (case when vwEXCHANGE_USERS.ID is not null then 1 else 0 end) as EXCHANGE_USER_ENABLED
     , CONTACTS_USERS.SERVICE_NAME
  from            CONTACTS
       inner join CONTACTS_USERS
               on CONTACTS_USERS.CONTACT_ID         = CONTACTS.ID
              and CONTACTS_USERS.DELETED            = 0
       inner join USERS
               on USERS.ID                          = CONTACTS_USERS.USER_ID
              and USERS.DELETED                     = 0
  left outer join vwEXCHANGE_USERS
               on vwEXCHANGE_USERS.ASSIGNED_USER_ID = CONTACTS_USERS.USER_ID
 where CONTACTS.DELETED = 0
   and (    vwEXCHANGE_USERS.ID is not null
        or (USERS.GOOGLEAPPS_SYNC_CONTACTS = 1 and exists(select * from OAUTH_TOKENS where NAME = 'GoogleApps' and ASSIGNED_USER_ID = USERS.ID and DELETED = 0))
        or (USERS.ICLOUD_SYNC_CONTACTS     = 1 and USERS.ICLOUD_USERNAME     is not null)
       )

GO

Grant Select on dbo.vwCONTACTS_SYNC_ACTIVITY to public;
GO


