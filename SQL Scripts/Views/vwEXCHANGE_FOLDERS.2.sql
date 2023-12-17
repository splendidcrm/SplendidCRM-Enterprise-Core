if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEXCHANGE_FOLDERS')
	Drop View dbo.vwEXCHANGE_FOLDERS;
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
-- 04/05/2010 Paul.  We need the WELL_KNOWN_FOLDER flag to detect the difference between well known Contacts and SplendidCRM Contacts. 
-- 04/05/2010 Paul.  We need to keep the PARENT_ID and the PARENT_NAME so that we can detect a name change. 
-- 12/19/2020 Paul.  Office365 uses a DELTA_TOKEN for each folder. 
Create View dbo.vwEXCHANGE_FOLDERS
as
select ID
     , ASSIGNED_USER_ID
     , REMOTE_KEY
     , MODULE_NAME
     , PARENT_ID
     , PARENT_NAME
     , WELL_KNOWN_FOLDER
     , DELTA_TOKEN
  from EXCHANGE_FOLDERS
 where DELETED = 0

GO

Grant Select on dbo.vwEXCHANGE_FOLDERS to public
GO


