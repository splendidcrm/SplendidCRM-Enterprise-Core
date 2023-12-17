if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwROLES_USERS')
	Drop View dbo.vwROLES_USERS;
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
-- 10/03/2008 Paul.  Include EMAIL1 to simplify workflow. 
Create View dbo.vwROLES_USERS
as
select ROLES.ID   as ROLE_ID
     , ROLES.NAME as ROLE_NAME
     , USERS.ID   as USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as FULL_NAME
     , USERS.USER_NAME
     , USERS.TITLE
     , USERS.DEPARTMENT
     , ROLES_USERS.DATE_ENTERED
     , USERS.EMAIL1
  from           ROLES
      inner join ROLES_USERS
              on ROLES_USERS.ROLE_ID = ROLES.ID
             and ROLES_USERS.DELETED = 0
      inner join USERS
              on USERS.ID            = ROLES_USERS.USER_ID
             and USERS.DELETED       = 0
 where ROLES.DELETED = 0

GO

Grant Select on dbo.vwROLES_USERS to public;
GO

