if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ACCESS_ByAccess')
	Drop View dbo.vwACL_ACCESS_ByAccess;
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
Create View dbo.vwACL_ACCESS_ByAccess
as
select USERS.ID as USER_ID
     , vwACL_ACCESS_ByRole.MODULE_NAME
     , vwACL_ACCESS_ByRole.DISPLAY_NAME
     , min(ACLACCESS_ADMIN ) as ACLACCESS_ADMIN 
     , min(ACLACCESS_ACCESS) as ACLACCESS_ACCESS
     , min(ACLACCESS_VIEW  ) as ACLACCESS_VIEW  
     , min(ACLACCESS_LIST  ) as ACLACCESS_LIST  
     , min(ACLACCESS_EDIT  ) as ACLACCESS_EDIT  
     , min(ACLACCESS_DELETE) as ACLACCESS_DELETE
     , min(ACLACCESS_IMPORT) as ACLACCESS_IMPORT
     , min(ACLACCESS_EXPORT) as ACLACCESS_EXPORT
     , min(ACLACCESS_ARCHIVE) as ACLACCESS_ARCHIVE
     , vwACL_ACCESS_ByRole.IS_ADMIN
  from       vwACL_ACCESS_ByRole
  inner join ACL_ROLES_USERS
          on ACL_ROLES_USERS.ROLE_ID = vwACL_ACCESS_ByRole.ROLE_ID
         and ACL_ROLES_USERS.DELETED = 0
  inner join USERS
          on USERS.ID                = ACL_ROLES_USERS.USER_ID
         and USERS.DELETED           = 0
 group by USERS.ID, vwACL_ACCESS_ByRole.MODULE_NAME, vwACL_ACCESS_ByRole.DISPLAY_NAME, vwACL_ACCESS_ByRole.IS_ADMIN
GO

Grant Select on dbo.vwACL_ACCESS_ByAccess to public;
GO


