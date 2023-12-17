if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROCESSES_Pending')
	Drop View dbo.vwPROCESSES_Pending;
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
-- 08/26/2016 Paul.  A completed process will need to set thte status. 
Create View dbo.vwPROCESSES_Pending
as
select ID
     , PROCESS_NUMBER
     , BUSINESS_PROCESS_INSTANCE_ID
     , ACTIVITY_INSTANCE
     , ACTIVITY_NAME
     , BUSINESS_PROCESS_ID
     , PROCESS_USER_ID
     , BOOKMARK_NAME
     , PARENT_TYPE
     , PARENT_ID
     , USER_TASK_TYPE
     , CHANGE_ASSIGNED_USER
     , CHANGE_ASSIGNED_TEAM_ID
     , CHANGE_PROCESS_USER
     , CHANGE_PROCESS_TEAM_ID
     , USER_ASSIGNMENT_METHOD
     , STATIC_ASSIGNED_USER_ID
     , DYNAMIC_PROCESS_TEAM_ID
     , DYNAMIC_PROCESS_ROLE_ID
     , READ_ONLY_FIELDS
     , REQUIRED_FIELDS
     , DURATION_UNITS
     , DURATION_VALUE
     , STATUS
     , APPROVAL_USER_ID
     , APPROVAL_DATE
     , APPROVAL_RESPONSE
     , DATE_ENTERED
     , DATE_MODIFIED
  from PROCESSES
 where DELETED = 0
   and APPROVAL_USER_ID is null
   and STATUS in (N'In Progress', N'Unclaimed', N'Claimed')

GO

Grant Select on dbo.vwPROCESSES_Pending to public;
GO

