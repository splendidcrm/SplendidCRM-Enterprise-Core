if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_ExchangeFolder')
	Drop View dbo.vwCONTACTS_ExchangeFolder;
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
-- 05/14/2010 Paul.  We need the NEW_FOLDER flag to determine if we should perform a first SyncAll. 
-- 10/26/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
Create View dbo.vwCONTACTS_ExchangeFolder
as
select vwCONTACTS.ID
     , vwCONTACTS.NAME
     , vwCONTACTS_USERS.USER_ID
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from      vwCONTACTS
 inner join vwCONTACTS_USERS
         on vwCONTACTS_USERS.CONTACT_ID   = vwCONTACTS.ID
        and vwCONTACTS_USERS.SERVICE_NAME = N'Exchange'             
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwCONTACTS_USERS.CONTACT_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwCONTACTS_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Contacts'
 where vwCONTACTS.NAME is not null

GO

Grant Select on dbo.vwCONTACTS_ExchangeFolder to public;
GO

