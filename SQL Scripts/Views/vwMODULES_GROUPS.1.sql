if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_GROUPS')
	Drop View dbo.vwMODULES_GROUPS;
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
-- 02/24/2010 Paul.  We need to specify an order to the modules for the tab menu. 
Create View dbo.vwMODULES_GROUPS
as
select MODULES_GROUPS.ID
     , MODULES_GROUPS.GROUP_NAME
     , MODULES_GROUPS.MODULE_NAME
     , MODULES_GROUPS.MODULE_ORDER
     , MODULES_GROUPS.MODULE_MENU
     , TAB_GROUPS.TITLE
     , TAB_GROUPS.ENABLED
     , TAB_GROUPS.GROUP_ORDER
     , TAB_GROUPS.GROUP_MENU
  from      MODULES_GROUPS
 inner join TAB_GROUPS
         on TAB_GROUPS.NAME    = MODULES_GROUPS.GROUP_NAME
        and TAB_GROUPS.DELETED = 0
 where MODULES_GROUPS.DELETED = 0

GO

Grant Select on dbo.vwMODULES_GROUPS to public;
GO

