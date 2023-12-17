if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWF4_INSTANCES_RUNNABLE_Next')
	Drop View dbo.vwWF4_INSTANCES_RUNNABLE_Next;
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
Create View dbo.vwWF4_INSTANCES_RUNNABLE_Next
as
select WF4_INSTANCES_RUNNABLE.ID
     , WF4_INSTANCES_RUNNABLE.RUNNABLE_TIMER
     , WF4_INSTANCES_RUNNABLE.SURROGATE_IDENTITY_ID
     , WF4_INSTANCES_RUNNABLE.BLOCKING_BOOKMARKS
     , WF4_INSTANCES_RUNNABLE.DEFINITION_IDENTITY_ID
     , BUSINESS_PROCESSES_RUN.ID                     as BUSINESS_PROCESS_RUN_ID
     , BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_ID
     , BUSINESS_PROCESSES_RUN.AUDIT_ID
     , BUSINESS_PROCESSES_RUN.AUDIT_TABLE
     , WF4_DEFINITION_IDENTITY.XAML
  from            WF4_INSTANCES_RUNNABLE
  left outer join BUSINESS_PROCESSES_RUN
               on BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_INSTANCE_ID = WF4_INSTANCES_RUNNABLE.ID
  left outer join WF4_DEFINITION_IDENTITY
               on WF4_DEFINITION_IDENTITY.ID = WF4_INSTANCES_RUNNABLE.DEFINITION_IDENTITY_ID
 where  WF4_INSTANCES_RUNNABLE.DELETED         = 0
   and (WF4_INSTANCES_RUNNABLE.IS_READY_TO_RUN = 1 or WF4_INSTANCES_RUNNABLE.RUNNABLE_TIMER <= getutcdate())
   and  WF4_INSTANCES_RUNNABLE.IS_SUSPENDED    = 0

GO

Grant Select on dbo.vwWF4_INSTANCES_RUNNABLE_Next to public;
GO

