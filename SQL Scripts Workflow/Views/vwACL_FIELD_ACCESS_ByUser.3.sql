if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_FIELD_ACCESS_ByUser')
	Drop View dbo.vwACL_FIELD_ACCESS_ByUser;
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
Create View dbo.vwACL_FIELD_ACCESS_ByUser
as
select USERS.ID as USER_ID
     , vwACL_FIELD_ACCESS_ByRole.MODULE_NAME
     , vwACL_FIELD_ACCESS_ByRole.DISPLAY_NAME
     , vwACL_FIELD_ACCESS_ByRole.FIELD_NAME
     , min(ACLACCESS) as ACLACCESS
  from       vwACL_FIELD_ACCESS_ByRole
  inner join ACL_ROLES_USERS
          on ACL_ROLES_USERS.ROLE_ID = vwACL_FIELD_ACCESS_ByRole.ROLE_ID
         and ACL_ROLES_USERS.DELETED = 0
  inner join USERS
          on USERS.ID                = ACL_ROLES_USERS.USER_ID
         and USERS.DELETED           = 0
 where vwACL_FIELD_ACCESS_ByRole.FIELD_NAME is not null
 group by USERS.ID, vwACL_FIELD_ACCESS_ByRole.MODULE_NAME, vwACL_FIELD_ACCESS_ByRole.DISPLAY_NAME, vwACL_FIELD_ACCESS_ByRole.FIELD_NAME
GO

Grant Select on dbo.vwACL_FIELD_ACCESS_ByUser to public;
GO


