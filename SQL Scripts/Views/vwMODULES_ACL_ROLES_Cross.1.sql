if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_ACL_ROLES_Cross')
	Drop View dbo.vwMODULES_ACL_ROLES_Cross;
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
-- 01/16/2010 Paul.  We need the table name so that we can get the ACL Fields for a module. 
Create View dbo.vwMODULES_ACL_ROLES_Cross
as
select MODULES.MODULE_NAME
     , MODULES.TABLE_NAME
     , MODULES.DISPLAY_NAME
     , MODULES.MODULE_ENABLED
     , MODULES.TAB_ENABLED
     , MODULES.TAB_ORDER
     , MODULES.IS_ADMIN
     , ACL_ROLES.ID           as ROLE_ID
  from      MODULES
 cross join ACL_ROLES
 where MODULES.DELETED = 0
   and ACL_ROLES.DELETED = 0

GO

Grant Select on dbo.vwMODULES_ACL_ROLES_Cross to public;
GO

