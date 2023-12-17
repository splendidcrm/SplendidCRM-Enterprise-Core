if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_USERS_Cross')
	Drop View dbo.vwMODULES_USERS_Cross;
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
-- 05/20/2006 Paul.  Add REPORT_ENABLED flag as we need to restrict the list to enabled and accessible modules. 
-- 10/06/2006 Paul.  Add IMPORT_ENABLED if the module can allow importing. 
-- 11/17/2007 Paul.  Add MOBILE_ENABLED. 
-- 10/26/2009 Paul.  Add PORTAL_ENABLED. 
-- 12/06/2009 Paul.  We need the ID and TABLE_NAME when generating the SemanticModel for the ReportBuilder. 
Create View dbo.vwMODULES_USERS_Cross
as
select MODULES.MODULE_NAME
     , MODULES.DISPLAY_NAME
     , MODULES.RELATIVE_PATH
     , MODULES.MODULE_ENABLED
     , MODULES.TAB_ENABLED
     , MODULES.TAB_ORDER
     , MODULES.REPORT_ENABLED
     , MODULES.IMPORT_ENABLED
     , MODULES.IS_ADMIN
     , USERS.ID           as USER_ID
     , MODULES.MOBILE_ENABLED
     , MODULES.PORTAL_ENABLED
     , MODULES.ID
     , MODULES.TABLE_NAME
  from      MODULES
 cross join USERS
 where MODULES.DELETED = 0
   and USERS.DELETED   = 0

GO

Grant Select on dbo.vwMODULES_USERS_Cross to public;
GO

