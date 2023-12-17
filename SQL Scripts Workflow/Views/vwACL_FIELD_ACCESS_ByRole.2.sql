if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_FIELD_ACCESS_ByRole')
	Drop View dbo.vwACL_FIELD_ACCESS_ByRole;
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
Create View dbo.vwACL_FIELD_ACCESS_ByRole
as
select vwMODULES_ACL_ROLES_Cross.ROLE_ID
     , vwMODULES_ACL_ROLES_Cross.MODULE_NAME
     , vwMODULES_ACL_ROLES_Cross.TABLE_NAME
     , vwMODULES_ACL_ROLES_Cross.DISPLAY_NAME
     , vwACL_ROLES_FIELDS.FIELD_NAME
     , vwACL_ROLES_FIELDS.ACLACCESS
  from            vwMODULES_ACL_ROLES_Cross
  left outer join vwACL_ROLES_FIELDS
               on vwACL_ROLES_FIELDS.ROLE_ID     = vwMODULES_ACL_ROLES_Cross.ROLE_ID
              and vwACL_ROLES_FIELDS.MODULE_NAME = vwMODULES_ACL_ROLES_Cross.MODULE_NAME
 where vwMODULES_ACL_ROLES_Cross.MODULE_ENABLED = 1
   and vwMODULES_ACL_ROLES_Cross.IS_ADMIN       = 0
GO

Grant Select on dbo.vwACL_FIELD_ACCESS_ByRole to public;
GO


