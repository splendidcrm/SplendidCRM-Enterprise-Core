if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwBUSINESS_PROCESSES')
	Drop View dbo.vwBUSINESS_PROCESSES;
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
Create View dbo.vwBUSINESS_PROCESSES
as
select BUSINESS_PROCESSES.ID
     , BUSINESS_PROCESSES.NAME
     , BUSINESS_PROCESSES.BASE_MODULE
     , BUSINESS_PROCESSES.AUDIT_TABLE
     , BUSINESS_PROCESSES.STATUS
     , BUSINESS_PROCESSES.TYPE
     , BUSINESS_PROCESSES.RECORD_TYPE
     , BUSINESS_PROCESSES.JOB_INTERVAL
     , BUSINESS_PROCESSES.LAST_RUN
     , BUSINESS_PROCESSES.LAST_USER_ID
     , BUSINESS_PROCESSES.FILTER_SQL
     , BUSINESS_PROCESSES.DESCRIPTION
     , BUSINESS_PROCESSES.BPMN
     , BUSINESS_PROCESSES.SVG
     , BUSINESS_PROCESSES.XAML
     , BUSINESS_PROCESSES.DATE_ENTERED
     , BUSINESS_PROCESSES.DATE_MODIFIED
     , BUSINESS_PROCESSES.DATE_MODIFIED_UTC
     , BUSINESS_PROCESSES.ASSIGNED_USER_ID
     , USERS_ASSIGNED.USER_NAME              as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME            as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME           as MODIFIED_BY
     , BUSINESS_PROCESSES.CREATED_BY         as CREATED_BY_ID
     , BUSINESS_PROCESSES.MODIFIED_USER_ID
  from            BUSINESS_PROCESSES
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = BUSINESS_PROCESSES.ASSIGNED_USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = BUSINESS_PROCESSES.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = BUSINESS_PROCESSES.MODIFIED_USER_ID
 where BUSINESS_PROCESSES.DELETED = 0

GO

Grant Select on dbo.vwBUSINESS_PROCESSES to public;
GO

-- exec sp_refreshview 'vwBUSINESS_PROCESSES_Edit';
-- exec sp_refreshview 'vwBUSINESS_PROCESSES_RunTimed';
