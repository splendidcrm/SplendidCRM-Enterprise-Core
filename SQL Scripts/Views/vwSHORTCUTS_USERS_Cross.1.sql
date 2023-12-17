if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSHORTCUTS_USERS_Cross')
	Drop View dbo.vwSHORTCUTS_USERS_Cross;
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
-- 11/22/2007 Paul.  Only show the shortcut if the module of the shortcut is enabled. 
-- 03/04/2008 Paul.  Admin modules are not ment to be disabled, so show the short cuts even if they are disabled. 
-- 03/11/2008 Paul.  Must always check the deleted flag. 
Create View dbo.vwSHORTCUTS_USERS_Cross
as
select SHORTCUTS.MODULE_NAME
     , SHORTCUTS.DISPLAY_NAME
     , SHORTCUTS.RELATIVE_PATH
     , SHORTCUTS.IMAGE_NAME
     , SHORTCUTS.SHORTCUT_ENABLED
     , SHORTCUTS.SHORTCUT_ORDER
     , SHORTCUTS.SHORTCUT_MODULE
     , SHORTCUTS.SHORTCUT_ACLTYPE
     , USERS.ID                   as USER_ID
  from      SHORTCUTS
 inner join MODULES
         on MODULES.MODULE_NAME    = SHORTCUTS.SHORTCUT_MODULE
        and MODULES.DELETED        = 0
        and (MODULES.MODULE_ENABLED = 1 or MODULES.IS_ADMIN = 1)
 cross join USERS
 where SHORTCUTS.DELETED = 0

GO

Grant Select on dbo.vwSHORTCUTS_USERS_Cross to public;
GO

