if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAIL_CLIENT_SYNC')
	Drop View dbo.vwEMAIL_CLIENT_SYNC;
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
-- 04/01/2010 Paul.  Add the MODULE_NAME so that the LastModifiedTime can be filtered by module. 
-- 04/04/2010 Paul.  Add PARENT_ID so that the LastModifiedTime can be filtered by record. 
-- 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
Create View dbo.vwEMAIL_CLIENT_SYNC
as
select ID                        as SYNC_ID
     , ASSIGNED_USER_ID          as SYNC_ASSIGNED_USER_ID
     , LOCAL_ID                  as SYNC_LOCAL_ID
     , LOCAL_DATE_MODIFIED       as SYNC_LOCAL_DATE_MODIFIED
     , REMOTE_DATE_MODIFIED      as SYNC_REMOTE_DATE_MODIFIED
     , LOCAL_DATE_MODIFIED_UTC   as SYNC_LOCAL_DATE_MODIFIED_UTC
     , REMOTE_DATE_MODIFIED_UTC  as SYNC_REMOTE_DATE_MODIFIED_UTC
     , REMOTE_KEY                as SYNC_REMOTE_KEY
     , MODULE_NAME               as SYNC_MODULE_NAME
     , PARENT_ID                 as SYNC_PARENT_ID
  from EMAIL_CLIENT_SYNC
 where DELETED = 0

GO

Grant Select on dbo.vwEMAIL_CLIENT_SYNC to public;
GO


