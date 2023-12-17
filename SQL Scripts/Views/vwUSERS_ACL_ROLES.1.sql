if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_ACL_ROLES')
	Drop View dbo.vwUSERS_ACL_ROLES;
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
-- 05/05/2016 Paul.  The User Primary Role is used with role-based views. 
Create View dbo.vwUSERS_ACL_ROLES
as
select USERS.ID              as USER_ID
     , ACL_ROLES.ID          as ROLE_ID
     , ACL_ROLES.NAME        as ROLE_NAME
     , ACL_ROLES.DESCRIPTION
     , ACL_ROLES_USERS.DATE_ENTERED
     , (case when USERS.PRIMARY_ROLE_ID = ACL_ROLES.ID then 1 else 0 end) as IS_PRIMARY_ROLE
  from           USERS
      inner join ACL_ROLES_USERS
              on ACL_ROLES_USERS.USER_ID = USERS.ID
             and ACL_ROLES_USERS.DELETED = 0
      inner join ACL_ROLES
              on ACL_ROLES.ID            = ACL_ROLES_USERS.ROLE_ID
             and ACL_ROLES.DELETED       = 0
 where USERS.DELETED = 0

GO

Grant Select on dbo.vwUSERS_ACL_ROLES to public;
GO

