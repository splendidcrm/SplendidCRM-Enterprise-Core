if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROCESSES_MyList')
	Drop View dbo.vwPROCESSES_MyList;
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
Create View dbo.vwPROCESSES_MyList
as
select PROCESSES.ID
     , PROCESSES.PROCESS_NUMBER
     , PROCESSES.BUSINESS_PROCESS_INSTANCE_ID
     , PROCESSES.ACTIVITY_INSTANCE
     , PROCESSES.ACTIVITY_NAME
     , PROCESSES.BUSINESS_PROCESS_ID
     , BUSINESS_PROCESSES.NAME               as BUSINESS_PROCESS_NAME
     , PROCESSES.PROCESS_USER_ID
     , PROCESSES.BOOKMARK_NAME
     , PROCESSES.PARENT_TYPE
     , PROCESSES.PARENT_ID
     , vwPARENTS.PARENT_NAME
     , vwPARENTS.PARENT_ASSIGNED_USER_ID
     , USERS_ASSIGNED.USER_NAME              as ASSIGNED_USER_NAME
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME, USERS_ASSIGNED.LAST_NAME) as ASSIGNED_FULL_NAME
     , PROCESSES.USER_TASK_TYPE
     , PROCESSES.CHANGE_ASSIGNED_USER
     , PROCESSES.CHANGE_ASSIGNED_TEAM_ID
     , PROCESSES.CHANGE_PROCESS_USER
     , PROCESSES.CHANGE_PROCESS_TEAM_ID
     , PROCESSES.USER_ASSIGNMENT_METHOD
     , PROCESSES.STATIC_ASSIGNED_USER_ID
     , PROCESSES.DYNAMIC_PROCESS_TEAM_ID
     , PROCESSES.DYNAMIC_PROCESS_ROLE_ID
     , PROCESSES.READ_ONLY_FIELDS
     , PROCESSES.REQUIRED_FIELDS
     , PROCESSES.DURATION_UNITS
     , PROCESSES.DURATION_VALUE
     , PROCESSES.STATUS
     , PROCESSES.APPROVAL_USER_ID
     , PROCESSES.APPROVAL_DATE
     , PROCESSES.APPROVAL_RESPONSE
     , PROCESSES.DATE_ENTERED
     , PROCESSES.DATE_MODIFIED
  from            PROCESSES
       inner join BUSINESS_PROCESSES
               on BUSINESS_PROCESSES.ID    = PROCESSES.BUSINESS_PROCESS_ID
       inner join vwPARENTS
               on vwPARENTS.PARENT_ID      = PROCESSES.PARENT_ID
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = vwPARENTS.PARENT_ASSIGNED_USER_ID
 where PROCESSES.DELETED = 0
   and PROCESSES.APPROVAL_USER_ID is null
   and (PROCESSES.STATUS is null or PROCESSES.STATUS in (N'In Progress', N'Unclaimed'))

GO

Grant Select on dbo.vwPROCESSES_MyList to public;
GO

