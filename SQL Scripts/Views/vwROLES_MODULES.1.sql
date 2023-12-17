if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwROLES_MODULES')
	Drop View dbo.vwROLES_MODULES;
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
-- 12/13/2005 Paul.  Bad decision to change the name in SplendidCRM.  Change back. 
-- No need to change the output name.
Create View dbo.vwROLES_MODULES
as
select ROLES.ID   as ROLE_ID
     , ROLES.NAME as ROLE_NAME
     , ROLES_MODULES.MODULE_ID as MODULE
     , ROLES_MODULES.MODULE_ID as MODULE_NAME
     , ROLES_MODULES.ALLOW
  from           ROLES
      inner join ROLES_MODULES
              on ROLES_MODULES.ROLE_ID = ROLES.ID
             and ROLES_MODULES.DELETED = 0
 where ROLES.DELETED = 0

GO

Grant Select on dbo.vwROLES_MODULES to public;
GO

