if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROCESSES_HISTORY')
	Drop View dbo.vwPROCESSES_HISTORY;
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
Create View dbo.vwPROCESSES_HISTORY
as
select PROCESSES_HISTORY.BUSINESS_PROCESS_INSTANCE_ID
     , PROCESSES_HISTORY.ID
     , PROCESSES_HISTORY.PROCESS_ACTION
     , PROCESSES_HISTORY.STATUS
     , PROCESSES_HISTORY.DATE_ENTERED
     , PROCESSES_HISTORY.DATE_MODIFIED
     , PROCESSES.ID                       as PROCESS_ID
     , PROCESSES.PROCESS_NUMBER
     , PROCESSES.ACTIVITY_NAME
     , BUSINESS_PROCESSES.ID              as BUSINESS_PROCESS_ID
     , BUSINESS_PROCESSES.NAME            as BUSINESS_PROCESS_NAME
     , vwPARENTS.PARENT_ID
     , vwPARENTS.PARENT_NAME
     , vwPARENTS.PARENT_ASSIGNED_USER_ID
     , PROCESSES_HISTORY.CREATED_BY       as CREATED_BY_ID
     , PROCESSES_HISTORY.PROCESS_USER_ID
     , PROCESSES_HISTORY.ASSIGNED_USER_ID
     , PROCESSES_HISTORY.APPROVAL_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME, USERS_CREATED_BY.LAST_NAME) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_PROCESS.FIRST_NAME   , USERS_PROCESS.LAST_NAME   ) as PROCESS_USER_NAME
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME  , USERS_ASSIGNED.LAST_NAME  ) as ASSIGNED_USER_NAME
     , dbo.fnFullName(USERS_APPROVAL.FIRST_NAME  , USERS_APPROVAL.LAST_NAME  ) as APPROVAL_USER_NAME
     , USERS_CREATED_BY.PICTURE
  from            PROCESSES_HISTORY
       inner join PROCESSES
               on PROCESSES.ID                 = PROCESSES_HISTORY.PROCESS_ID
       inner join BUSINESS_PROCESSES
               on BUSINESS_PROCESSES.ID        = PROCESSES.BUSINESS_PROCESS_ID
  left outer join vwPARENTS
               on vwPARENTS.PARENT_ID          = PROCESSES.PARENT_ID
  left outer join USERS                          USERS_CREATED_BY
               on USERS_CREATED_BY.ID          = PROCESSES_HISTORY.CREATED_BY
  left outer join USERS                          USERS_PROCESS
               on USERS_PROCESS.ID             = PROCESSES_HISTORY.PROCESS_USER_ID
  left outer join USERS                          USERS_ASSIGNED
               on USERS_ASSIGNED.ID            = PROCESSES_HISTORY.ASSIGNED_USER_ID
  left outer join USERS                          USERS_APPROVAL
               on USERS_APPROVAL.ID            = PROCESSES_HISTORY.APPROVAL_USER_ID

GO

Grant Select on dbo.vwPROCESSES_HISTORY to public;
GO

