if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ROLES_USERS')
	Drop View dbo.vwACL_ROLES_USERS;
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
-- 12/07/2006 Paul.  Only show active users. 
Create View dbo.vwACL_ROLES_USERS
as
select ACL_ROLES.ID   as ROLE_ID
     , ACL_ROLES.NAME as ROLE_NAME
     , USERS.ID   as USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as FULL_NAME
     , USERS.USER_NAME
     , USERS.EMAIL1
     , USERS.PHONE_WORK
     , ACL_ROLES_USERS.DATE_ENTERED
  from           ACL_ROLES
      inner join ACL_ROLES_USERS
              on ACL_ROLES_USERS.ROLE_ID = ACL_ROLES.ID
             and ACL_ROLES_USERS.DELETED = 0
      inner join USERS
              on USERS.ID                = ACL_ROLES_USERS.USER_ID
             and USERS.DELETED           = 0
 where ACL_ROLES.DELETED = 0
  and (USERS.STATUS is null or USERS.STATUS = N'Active')

GO

Grant Select on dbo.vwACL_ROLES_USERS to public;
GO

