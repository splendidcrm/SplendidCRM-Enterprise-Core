if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ROLES_ACTIONS')
	Drop View dbo.vwACL_ROLES_ACTIONS;
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
-- 01/15/2010 Paul.  Deleted ACL_ROLES was not being filtered. 
Create View dbo.vwACL_ROLES_ACTIONS
as
select ACL_ROLES.ID          as ROLE_ID
     , ACL_ACTIONS.NAME
     , ACL_ACTIONS.CATEGORY
     , (case when ACL_ROLES_ACTIONS.ACCESS_OVERRIDE is not null then ACL_ROLES_ACTIONS.ACCESS_OVERRIDE
             else ACL_ACTIONS.ACLACCESS
        end)                 as ACLACCESS
  from           ACL_ROLES
 left outer join ACL_ROLES_ACTIONS
              on ACL_ROLES_ACTIONS.ROLE_ID = ACL_ROLES.ID
             and ACL_ROLES_ACTIONS.DELETED = 0
 left outer join ACL_ACTIONS
              on ACL_ACTIONS.ID            = ACL_ROLES_ACTIONS.ACTION_ID
             and ACL_ACTIONS.DELETED       = 0
 where ACL_ROLES.DELETED = 0
GO

Grant Select on dbo.vwACL_ROLES_ACTIONS to public;
GO


