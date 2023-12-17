if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ACCESS_ByUser')
	Drop View dbo.vwACL_ACCESS_ByUser;
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
-- 03/09/2010 Paul.  Allow IS_ADMIN and Team Management so that they can be managed separately. 
-- 09/26/2017 Paul.  Add Archive access right. 
Create View dbo.vwACL_ACCESS_ByUser
as
select vwACL_ACCESS_ByModule_USERS.USER_ID
     , vwACL_ACCESS_ByModule_USERS.MODULE_NAME
     , vwACL_ACCESS_ByModule_USERS.DISPLAY_NAME
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_ADMIN  is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_ADMIN  else vwACL_ACCESS_ByAccess.ACLACCESS_ADMIN  end) as ACLACCESS_ADMIN 
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_ACCESS else vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS end) as ACLACCESS_ACCESS
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_VIEW   is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_VIEW   else vwACL_ACCESS_ByAccess.ACLACCESS_VIEW   end) as ACLACCESS_VIEW  
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_LIST   is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_LIST   else vwACL_ACCESS_ByAccess.ACLACCESS_LIST   end) as ACLACCESS_LIST  
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_EDIT   is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_EDIT   else vwACL_ACCESS_ByAccess.ACLACCESS_EDIT   end) as ACLACCESS_EDIT  
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_DELETE is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_DELETE else vwACL_ACCESS_ByAccess.ACLACCESS_DELETE end) as ACLACCESS_DELETE
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_IMPORT else vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT end) as ACLACCESS_IMPORT
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_EXPORT is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_EXPORT else vwACL_ACCESS_ByAccess.ACLACCESS_EXPORT end) as ACLACCESS_EXPORT
     , (case when vwACL_ACCESS_ByAccess.ACLACCESS_ARCHIVE is null then vwACL_ACCESS_ByModule_USERS.ACLACCESS_ARCHIVE else vwACL_ACCESS_ByAccess.ACLACCESS_ARCHIVE end) as ACLACCESS_ARCHIVE
     , vwACL_ACCESS_ByModule_USERS.IS_ADMIN
  from            vwACL_ACCESS_ByModule_USERS
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID     = vwACL_ACCESS_ByModule_USERS.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME = vwACL_ACCESS_ByModule_USERS.MODULE_NAME

GO

Grant Select on dbo.vwACL_ACCESS_ByUser to public;
GO


