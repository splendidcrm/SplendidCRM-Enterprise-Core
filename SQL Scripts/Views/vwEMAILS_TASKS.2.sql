if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_TASKS')
	Drop View dbo.vwEMAILS_TASKS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwEMAILS_TASKS
as
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwTASKS.ID              as TASK_ID
     , vwTASKS.NAME            as TASK_NAME
     , vwTASKS.*
  from            EMAILS
       inner join EMAILS_TASKS
               on EMAILS_TASKS.EMAIL_ID = EMAILS.ID
              and EMAILS_TASKS.DELETED  = 0
       inner join vwTASKS
               on vwTASKS.ID            = EMAILS_TASKS.TASK_ID
 where EMAILS.DELETED = 0
union all
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwTASKS.ID              as TASK_ID
     , vwTASKS.NAME            as TASK_NAME
     , vwTASKS.*
  from            EMAILS
       inner join vwTASKS
               on vwTASKS.ID            = EMAILS.PARENT_ID
  left outer join EMAILS_TASKS
               on EMAILS_TASKS.EMAIL_ID = EMAILS.ID
              and EMAILS_TASKS.TASK_ID   = vwTASKS.ID
              and EMAILS_TASKS.DELETED  = 0
 where EMAILS.DELETED     = 0
   and EMAILS.PARENT_TYPE = N'Tasks'
   and EMAILS_TASKS.ID is null

GO

Grant Select on dbo.vwEMAILS_TASKS to public;
GO

