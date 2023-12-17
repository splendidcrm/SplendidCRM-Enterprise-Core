if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROCESSES')
	Drop View dbo.vwPROCESSES;
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
-- 03/21/2020 Paul.  CREATED_BY_NAME and APPROVAL_USER_NAME were missing. 
-- 03/21/2020 Paul.  APPROVAL_VALUE is used in the layout, but never defined. 
Create View dbo.vwPROCESSES
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
     , vwPARENTS.PARENT_NAME                 as PARENT_NAME
     , vwPARENTS.PARENT_ASSIGNED_USER_ID     as PARENT_ASSIGNED_USER_ID
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
     , PROCESSES.DATE_MODIFIED_UTC
     , PROCESSES.MODIFIED_USER_ID
     , cast(null as int)                     as APPROVAL_VALUE
     , BUSINESS_PROCESSES.ASSIGNED_USER_ID   as PROCESS_OWNER_ID
     , USERS_PROCESS.USER_NAME               as PROCESS_USER
     , USERS_OWNER.USER_NAME                 as PROCESS_OWNER
     , USERS_ASSIGNED.USER_NAME              as ASSIGNED_TO
     , USERS_MODIFIED_BY.USER_NAME           as MODIFIED_BY
     , USERS_APPROVED_BY.USER_NAME           as APPROVED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_PROCESS.FIRST_NAME    , USERS_PROCESS.LAST_NAME    ) as PROCESS_USER_NAME
     , dbo.fnFullName(USERS_OWNER.FIRST_NAME      , USERS_OWNER.LAST_NAME      ) as PROCESS_OWNER_NAME
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , dbo.fnFullName(USERS_APPROVED_BY.FIRST_NAME, USERS_APPROVED_BY.LAST_NAME) as APPROVED_BY_NAME
     , dbo.fnFullName(USERS_APPROVED_BY.FIRST_NAME, USERS_APPROVED_BY.LAST_NAME) as APPROVAL_USER_NAME
     , cast(null as uniqueidentifier)        as ASSIGNED_SET_ID
     , cast(USERS_ASSIGNED.ID as char(36))   as ASSIGNED_SET_LIST
     , USERS_ASSIGNED.USER_NAME              as ASSIGNED_SET_NAME
  from            PROCESSES
       inner join BUSINESS_PROCESSES
               on BUSINESS_PROCESSES.ID    = PROCESSES.BUSINESS_PROCESS_ID
       inner join vwPARENTS
               on vwPARENTS.PARENT_ID      = PROCESSES.PARENT_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = PROCESSES.CREATED_BY
  left outer join USERS                      USERS_PROCESS
               on USERS_PROCESS.ID         = PROCESSES.PROCESS_USER_ID
  left outer join USERS                      USERS_OWNER
               on USERS_OWNER.ID           = BUSINESS_PROCESSES.ASSIGNED_USER_ID
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = vwPARENTS.PARENT_ASSIGNED_USER_ID
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = PROCESSES.MODIFIED_USER_ID
  left outer join USERS                      USERS_APPROVED_BY
               on USERS_APPROVED_BY.ID     = PROCESSES.APPROVAL_USER_ID
 where PROCESSES.DELETED = 0

GO

Grant Select on dbo.vwPROCESSES to public;
GO

-- exec sp_refreshview 'vwPROCESSES_List';

