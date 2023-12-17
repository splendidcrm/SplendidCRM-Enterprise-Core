if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDASHBOARDS_PANELS')
	Drop View dbo.vwDASHBOARDS_PANELS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 05/26/2019 Paul.  Dashboard Name is needed by the React client. 
Create View dbo.vwDASHBOARDS_PANELS
as
select DASHBOARDS_PANELS.ID
     , DASHBOARDS_PANELS.DATE_ENTERED
     , DASHBOARDS_PANELS.DATE_MODIFIED
     , DASHBOARDS_PANELS.DATE_MODIFIED_UTC
     , DASHBOARDS_PANELS.PANEL_ORDER
     , DASHBOARDS_PANELS.ROW_INDEX
     , DASHBOARDS_PANELS.COLUMN_WIDTH
     , DASHBOARDS.ID                     as DASHBOARD_ID
     , DASHBOARDS.NAME                   as DASHBOARD_NAME
     , DASHBOARDS.ASSIGNED_USER_ID       as PARENT_ASSIGNED_USER_ID
     , DASHBOARDS.ASSIGNED_SET_ID        as PARENT_ASSIGNED_SET_ID
     , DASHBOARDS.TEAM_ID
     , DASHBOARDS.TEAM_SET_ID
     , DASHBOARD_APPS.ID                 as DASHBOARD_APP_ID
     , DASHBOARD_APPS.NAME
     , DASHBOARD_APPS.CATEGORY
     , DASHBOARD_APPS.MODULE_NAME
     , DASHBOARD_APPS.TITLE
     , DASHBOARD_APPS.SETTINGS_EDITVIEW
     , DASHBOARD_APPS.IS_ADMIN
     , DASHBOARD_APPS.APP_ENABLED
     , DASHBOARD_APPS.SCRIPT_URL
     , DASHBOARD_APPS.DEFAULT_SETTINGS
  from            DASHBOARDS_PANELS
       inner join DASHBOARDS
               on DASHBOARDS.ID            = DASHBOARDS_PANELS.DASHBOARD_ID
              and DASHBOARDS.DELETED       = 0
       inner join DASHBOARD_APPS
               on DASHBOARD_APPS.ID        = DASHBOARDS_PANELS.DASHBOARD_APP_ID
              and DASHBOARD_APPS.DELETED   = 0
 where DASHBOARDS_PANELS.DELETED = 0

GO

Grant Select on dbo.vwDASHBOARDS_PANELS to public;
GO

