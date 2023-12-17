if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOW_ALERT_SHELLS')
	Drop View dbo.vwWORKFLOW_ALERT_SHELLS;
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
-- 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
-- 04/15/2021 Paul.  Every module must have DATE_MODIFIED for the React client. 
-- 04/15/2021 Paul.  React client treats this as a relationship table with Workflows, so it needs a Workflow ID. 
-- 10/08/2023 Paul.  WF4 conversion requires CUSTOM_TEMPLATE_NAME. 
Create View dbo.vwWORKFLOW_ALERT_SHELLS
as
select WORKFLOW_ALERT_SHELLS.ID
     , WORKFLOW_ALERT_SHELLS.ID         as WORKFLOW_ALERT_SHELL_ID
     , WORKFLOW_ALERT_SHELLS.DATE_ENTERED
     , WORKFLOW_ALERT_SHELLS.DATE_MODIFIED
     , WORKFLOW_ALERT_SHELLS.NAME
     , WORKFLOW_ALERT_SHELLS.ALERT_TEXT
     , WORKFLOW_ALERT_SHELLS.ALERT_TYPE
     , WORKFLOW_ALERT_SHELLS.SOURCE_TYPE
     , WORKFLOW_ALERT_SHELLS.PARENT_ID
     , WORKFLOW_ALERT_SHELLS.PARENT_ID  as WORKFLOW_ID
     , WORKFLOW_ALERT_SHELLS.CUSTOM_TEMPLATE_ID
     , WORKFLOW_ALERT_TEMPLATES.NAME    as CUSTOM_TEMPLATE_NAME
     , WORKFLOW_ALERT_SHELLS.CUSTOM_XOML
     , WORKFLOW_ALERT_SHELLS.ASSIGNED_USER_ID
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
  from            WORKFLOW_ALERT_SHELLS
  left outer join WORKFLOW_ALERT_TEMPLATES
               on WORKFLOW_ALERT_TEMPLATES.ID = WORKFLOW_ALERT_SHELLS.CUSTOM_TEMPLATE_ID
  left outer join TEAMS
               on TEAMS.ID                 = WORKFLOW_ALERT_SHELLS.TEAM_ID
              and TEAMS.DELETED            = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID             = WORKFLOW_ALERT_SHELLS.TEAM_SET_ID
              and TEAM_SETS.DELETED        = 0
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = WORKFLOW_ALERT_SHELLS.ASSIGNED_USER_ID
 where WORKFLOW_ALERT_SHELLS.DELETED = 0

GO

Grant Select on dbo.vwWORKFLOW_ALERT_SHELLS to public;
GO

