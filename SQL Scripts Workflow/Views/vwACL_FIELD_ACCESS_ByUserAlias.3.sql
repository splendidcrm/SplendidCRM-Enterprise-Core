if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_FIELD_ACCESS_ByUserAlias')
	Drop View dbo.vwACL_FIELD_ACCESS_ByUserAlias;
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
Create View dbo.vwACL_FIELD_ACCESS_ByUserAlias
as
select vwACL_FIELD_ACCESS_ByUser.USER_ID
     , vwACL_FIELD_ACCESS_ByUser.MODULE_NAME
     , vwACL_FIELD_ACCESS_ByUser.FIELD_NAME
     , vwACL_FIELD_ACCESS_ByUser.ACLACCESS
  from vwACL_FIELD_ACCESS_ByUser
union all
select vwACL_FIELD_ACCESS_ByUser.USER_ID
     , vwACL_FIELD_ACCESS_ByUser.MODULE_NAME
     , ACL_FIELDS_ALIASES.ALIAS_NAME         as FIELD_NAME
     , vwACL_FIELD_ACCESS_ByUser.ACLACCESS
  from      vwACL_FIELD_ACCESS_ByUser
 inner join ACL_FIELDS_ALIASES
         on ACL_FIELDS_ALIASES.NAME               = vwACL_FIELD_ACCESS_ByUser.FIELD_NAME
        and (ACL_FIELDS_ALIASES.ALIAS_MODULE_NAME = vwACL_FIELD_ACCESS_ByUser.MODULE_NAME or ACL_FIELDS_ALIASES.ALIAS_MODULE_NAME is null)
        and ACL_FIELDS_ALIASES.DELETED            = 0
GO

Grant Select on dbo.vwACL_FIELD_ACCESS_ByUserAlias to public;
GO


