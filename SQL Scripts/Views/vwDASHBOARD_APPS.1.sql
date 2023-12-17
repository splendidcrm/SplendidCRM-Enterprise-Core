if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDASHBOARD_APPS')
	Drop View dbo.vwDASHBOARD_APPS;
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
-- 06/16/2017 Paul.  Add DEFAULT_SETTINGS. 
Create View dbo.vwDASHBOARD_APPS
as
select DASHBOARD_APPS.ID
     , DASHBOARD_APPS.NAME
     , DASHBOARD_APPS.CATEGORY
     , DASHBOARD_APPS.MODULE_NAME
     , DASHBOARD_APPS.TITLE
     , DASHBOARD_APPS.SETTINGS_EDITVIEW
     , DASHBOARD_APPS.IS_ADMIN
     , DASHBOARD_APPS.APP_ENABLED
     , DASHBOARD_APPS.SCRIPT_URL
     , DASHBOARD_APPS.DEFAULT_SETTINGS
  from      DASHBOARD_APPS
 inner join MODULES
         on MODULES.MODULE_NAME    = DASHBOARD_APPS.MODULE_NAME
        and MODULES.DELETED        = 0
        and MODULES.MODULE_ENABLED = 1
 where DASHBOARD_APPS.DELETED = 0

GO

Grant Select on dbo.vwDASHBOARD_APPS to public;
GO

