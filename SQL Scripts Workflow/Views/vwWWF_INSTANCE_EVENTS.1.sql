if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWWF_INSTANCE_EVENTS')
	Drop View dbo.vwWWF_INSTANCE_EVENTS;
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
-- 12/03/2008 Paul.  We need the AUDIT_ID to debug workflows. 
Create View dbo.vwWWF_INSTANCE_EVENTS
as
select WORKFLOW.ID
     , WORKFLOW.NAME
     , WORKFLOW.BASE_MODULE
     , WORKFLOW_RUN.AUDIT_ID
     , WWF_INSTANCES.WORKFLOW_INSTANCE_ID
     , WWF_INSTANCE_EVENTS.EVENT_ORDER
     , WWF_INSTANCE_EVENTS.EVENT_DATE_TIME
     , WWF_INSTANCE_EVENTS.TRACKING_WORKFLOW_EVENT
     , WWF_INSTANCE_EVENTS.DESCRIPTION
     , replace(WWF_TYPES.TYPE_FULL_NAME, 'System.Workflow.Runtime.Tracking.', '') as EVENT_ARG_TYPE_FULL_NAME
     , WWF_INSTANCE_EVENTS.EVENT_ARG
 from            WWF_INSTANCES
      inner join WWF_INSTANCE_EVENTS
              on WWF_INSTANCE_EVENTS.WORKFLOW_INSTANCE_INTERNAL_ID = WWF_INSTANCES.ID
 left outer join WWF_TYPES
              on WWF_TYPES.ID                      = WWF_INSTANCE_EVENTS.EVENT_ARG_TYPE_ID
 left outer join WORKFLOW_RUN
              on WORKFLOW_RUN.WORKFLOW_INSTANCE_ID = WWF_INSTANCES.WORKFLOW_INSTANCE_ID
 left outer join WORKFLOW
              on WORKFLOW.ID                       = WORKFLOW_RUN.WORKFLOW_ID

GO

Grant Select on dbo.vwWWF_INSTANCE_EVENTS to public;
GO


