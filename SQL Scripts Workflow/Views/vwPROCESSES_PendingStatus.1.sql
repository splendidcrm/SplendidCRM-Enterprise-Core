if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROCESSES_PendingStatus')
	Drop View dbo.vwPROCESSES_PendingStatus;
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
Create View dbo.vwPROCESSES_PendingStatus
as
select vwPROCESSES_Pending.ID
     , vwPROCESSES_Pending.PROCESS_NUMBER
     , vwPROCESSES_Pending.BUSINESS_PROCESS_INSTANCE_ID
     , vwPROCESSES_Pending.ACTIVITY_INSTANCE
     , vwPROCESSES_Pending.ACTIVITY_NAME
     , vwPROCESSES_Pending.BUSINESS_PROCESS_ID
     , BUSINESS_PROCESSES.NAME                      as BUSINESS_PROCESS_NAME
     , vwPROCESSES_Pending.PROCESS_USER_ID
     , vwPROCESSES_Pending.BOOKMARK_NAME
     , vwPROCESSES_Pending.PARENT_TYPE
     , vwPROCESSES_Pending.PARENT_ID
     , vwPROCESSES_Pending.USER_TASK_TYPE
     , vwPROCESSES_Pending.CHANGE_ASSIGNED_USER
     , vwPROCESSES_Pending.CHANGE_ASSIGNED_TEAM_ID
     , vwPROCESSES_Pending.CHANGE_PROCESS_USER
     , vwPROCESSES_Pending.CHANGE_PROCESS_TEAM_ID
     , vwPROCESSES_Pending.USER_ASSIGNMENT_METHOD
     , vwPROCESSES_Pending.STATIC_ASSIGNED_USER_ID
     , vwPROCESSES_Pending.DYNAMIC_PROCESS_TEAM_ID
     , vwPROCESSES_Pending.DYNAMIC_PROCESS_ROLE_ID
     , vwPROCESSES_Pending.READ_ONLY_FIELDS
     , vwPROCESSES_Pending.REQUIRED_FIELDS
     , vwPROCESSES_Pending.DURATION_UNITS
     , vwPROCESSES_Pending.DURATION_VALUE
     , vwPROCESSES_Pending.STATUS
     , vwPROCESSES_Pending.APPROVAL_USER_ID
     , vwPROCESSES_Pending.APPROVAL_DATE
     , vwPROCESSES_Pending.APPROVAL_RESPONSE
     , vwPROCESSES_Pending.DATE_ENTERED
     , vwPROCESSES_Pending.DATE_MODIFIED
  from      vwPROCESSES_Pending
 inner join BUSINESS_PROCESSES
         on BUSINESS_PROCESSES.ID = vwPROCESSES_Pending.BUSINESS_PROCESS_ID

GO

Grant Select on dbo.vwPROCESSES_PendingStatus to public;
GO

