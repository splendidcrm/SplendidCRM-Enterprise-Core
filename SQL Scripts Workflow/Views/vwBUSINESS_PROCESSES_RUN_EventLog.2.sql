if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwBUSINESS_PROCESSES_RUN_EventLog')
	Drop View dbo.vwBUSINESS_PROCESSES_RUN_EventLog;
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
Create View dbo.vwBUSINESS_PROCESSES_RUN_EventLog
as
select BUSINESS_PROCESSES_RUN.ID
     , BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_VERSION
     , BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_ID
     , BUSINESS_PROCESSES_RUN.AUDIT_ID
     , BUSINESS_PROCESSES_RUN.AUDIT_TABLE
     , BUSINESS_PROCESSES_RUN.STATUS
     , BUSINESS_PROCESSES_RUN.START_DATE
     , BUSINESS_PROCESSES_RUN.END_DATE
     , BUSINESS_PROCESSES_RUN.DATE_ENTERED
     , BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_INSTANCE_ID
     , BUSINESS_PROCESSES_RUN.DESCRIPTION
     , BUSINESS_PROCESSES.NAME
     , BUSINESS_PROCESSES.BASE_MODULE
     , (case when WF4_INSTANCES_RUNNABLE.ID is null then 0 else 1 end) as ALLOW_TERMINATION
  from            BUSINESS_PROCESSES_RUN
       inner join BUSINESS_PROCESSES
               on BUSINESS_PROCESSES.ID          = BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_ID
              and BUSINESS_PROCESSES.DELETED     = 0
  left outer join WF4_INSTANCES_RUNNABLE
               on WF4_INSTANCES_RUNNABLE.ID      = BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_INSTANCE_ID
              and WF4_INSTANCES_RUNNABLE.DELETED = 0
 where BUSINESS_PROCESSES_RUN.DELETED = 0

GO

Grant Select on dbo.vwBUSINESS_PROCESSES_RUN_EventLog to public;
GO

