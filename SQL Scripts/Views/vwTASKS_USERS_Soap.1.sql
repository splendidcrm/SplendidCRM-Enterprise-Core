if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTASKS_USERS_Soap')
	Drop View dbo.vwTASKS_USERS_Soap;
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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwTASKS_USERS_Soap
as
select TASKS.ID    as PRIMARY_ID
     , USERS.ID    as RELATED_ID
     , TASKS.DELETED
     , TASKS.DATE_MODIFIED
     , TASKS.DATE_MODIFIED_UTC
  from      TASKS
 inner join USERS
         on USERS.ID         = TASKS.ASSIGNED_USER_ID
        and USERS.DELETED    = 0

GO

Grant Select on dbo.vwTASKS_USERS_Soap to public;
GO

