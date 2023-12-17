if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ACCESS_ByModule_USERS')
	Drop View dbo.vwACL_ACCESS_ByModule_USERS;
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
-- 04/29/2006 Paul.  DB2 has a problem with cross joins, so place in a view so that it can easily be converted. 
-- 03/09/2010 Paul.  Allow IS_ADMIN and Team Management so that they can be managed separately. 
-- 09/26/2017 Paul.  Add Archive access right. 
Create View dbo.vwACL_ACCESS_ByModule_USERS
as
select vwACL_ACCESS_ByModule.MODULE_NAME
     , vwACL_ACCESS_ByModule.DISPLAY_NAME
     , vwACL_ACCESS_ByModule.ACLACCESS_ADMIN 
     , vwACL_ACCESS_ByModule.ACLACCESS_ACCESS
     , vwACL_ACCESS_ByModule.ACLACCESS_VIEW  
     , vwACL_ACCESS_ByModule.ACLACCESS_LIST  
     , vwACL_ACCESS_ByModule.ACLACCESS_EDIT  
     , vwACL_ACCESS_ByModule.ACLACCESS_DELETE
     , vwACL_ACCESS_ByModule.ACLACCESS_IMPORT
     , vwACL_ACCESS_ByModule.ACLACCESS_EXPORT
     , vwACL_ACCESS_ByModule.ACLACCESS_ARCHIVE
     , USERS.ID           as USER_ID
     , vwACL_ACCESS_ByModule.IS_ADMIN
  from      vwACL_ACCESS_ByModule
 cross join USERS
 where USERS.DELETED   = 0

GO

Grant Select on dbo.vwACL_ACCESS_ByModule_USERS to public;
GO

