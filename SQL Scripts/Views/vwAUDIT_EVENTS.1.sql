if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwAUDIT_EVENTS')
	Drop View dbo.vwAUDIT_EVENTS;
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
-- 01/20/2010 Paul.  Correct for the singular module names. 
-- 03/27/2019 Paul.  Every searchable view should have a NAME field. 
-- 11/13/2020 Paul.  Add DATE_ENTERED to support default view of React Client. 
Create View dbo.vwAUDIT_EVENTS
as
select dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as FULL_NAME
     , USERS.USER_NAME
     , USERS.USER_NAME            as NAME
     , USERS.ID                   as USER_ID
     , AUDIT_EVENTS.DATE_ENTERED
     , AUDIT_EVENTS.DATE_MODIFIED
     , AUDIT_EVENTS.AUDIT_ID
     , AUDIT_EVENTS.AUDIT_TABLE
     , AUDIT_EVENTS.AUDIT_ACTION
     , AUDIT_EVENTS.AUDIT_PARENT_ID
     , MODULES.MODULE_NAME
     , (case MODULES.MODULE_NAME
        when N'Project'     then N'Projects'
        when N'ProjectTask' then N'ProjectTasks'
        else MODULES.MODULE_NAME
        end) as MODULE_FOLDER
  from      AUDIT_EVENTS
 inner join USERS
         on USERS.ID           = AUDIT_EVENTS.MODIFIED_USER_ID
 inner join MODULES
         on MODULES.TABLE_NAME + N'_AUDIT' = AUDIT_EVENTS.AUDIT_TABLE

GO

Grant Select on dbo.vwAUDIT_EVENTS to public;
GO


