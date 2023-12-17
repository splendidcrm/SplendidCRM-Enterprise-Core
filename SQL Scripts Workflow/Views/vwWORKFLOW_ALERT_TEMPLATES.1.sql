if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOW_ALERT_TEMPLATES')
	Drop View dbo.vwWORKFLOW_ALERT_TEMPLATES;
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
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
Create View dbo.vwWORKFLOW_ALERT_TEMPLATES
as
select WORKFLOW_ALERT_TEMPLATES.ID
     , WORKFLOW_ALERT_TEMPLATES.NAME
     , WORKFLOW_ALERT_TEMPLATES.BASE_MODULE
     , WORKFLOW_ALERT_TEMPLATES.FROM_ADDR
     , WORKFLOW_ALERT_TEMPLATES.FROM_NAME
     , WORKFLOW_ALERT_TEMPLATES.SUBJECT
     , WORKFLOW_ALERT_TEMPLATES.DESCRIPTION
     , WORKFLOW_ALERT_TEMPLATES.BODY
     , WORKFLOW_ALERT_TEMPLATES.BODY_HTML
     , WORKFLOW_ALERT_TEMPLATES.DATE_ENTERED
     , WORKFLOW_ALERT_TEMPLATES.DATE_MODIFIED
     , USERS_CREATED_BY.USER_NAME                  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME                 as MODIFIED_BY
     , WORKFLOW_ALERT_TEMPLATES.CREATED_BY         as CREATED_BY_ID
     , WORKFLOW_ALERT_TEMPLATES.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            WORKFLOW_ALERT_TEMPLATES
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = WORKFLOW_ALERT_TEMPLATES.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = WORKFLOW_ALERT_TEMPLATES.MODIFIED_USER_ID
 where WORKFLOW_ALERT_TEMPLATES.DELETED = 0

GO

Grant Select on dbo.vwWORKFLOW_ALERT_TEMPLATES to public;
GO

