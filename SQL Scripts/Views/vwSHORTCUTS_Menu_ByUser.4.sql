if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSHORTCUTS_Menu_ByUser')
	Drop View dbo.vwSHORTCUTS_Menu_ByUser;
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
-- 04/28/2006 Paul.  We need to look at both the access right and either the edit right or the list right. 
-- Although we could combine the union into a single query, it seems too complex. 
-- 09/09/2006 Paul.  Include import in types that can appear in shortcuts. 
-- 12/05/2006 Paul.  We need to filter on access rights for vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE, not the rights for the module being displayed. 
-- 12/05/2006 Paul.  Literals should be in unicode to reduce conversions at runtime. 
-- 09/26/2017 Paul.  Add Archive access right. 
Create View dbo.vwSHORTCUTS_Menu_ByUser
as
select vwSHORTCUTS_USERS_Cross.USER_ID
     , vwSHORTCUTS_USERS_Cross.MODULE_NAME
     , vwSHORTCUTS_USERS_Cross.DISPLAY_NAME
     , vwSHORTCUTS_USERS_Cross.RELATIVE_PATH
     , vwSHORTCUTS_USERS_Cross.IMAGE_NAME
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ORDER
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE
  from            vwSHORTCUTS_USERS_Cross
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_AccessOnly
               on vwACL_ACTIONS_AccessOnly.CATEGORY = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_AccessOnly.NAME     = N'access'
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_EditOnly
               on vwACL_ACTIONS_EditOnly.CATEGORY   = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_EditOnly.NAME       = N'edit'
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID     = vwSHORTCUTS_USERS_Cross.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
 where vwSHORTCUTS_USERS_Cross.SHORTCUT_ENABLED = 1
   and vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE = N'edit'
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is not null and vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is not null and vwACL_ACTIONS_AccessOnly.ACLACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is null)
       )
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_EDIT   is not null and vwACL_ACCESS_ByAccess.ACLACCESS_EDIT >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_EDIT   is null     and vwACL_ACTIONS_EditOnly.ACLACCESS is not null   and vwACL_ACTIONS_EditOnly.ACLACCESS   >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_EDIT   is null     and vwACL_ACTIONS_EditOnly.ACLACCESS is null)
       )
union all
select vwSHORTCUTS_USERS_Cross.USER_ID
     , vwSHORTCUTS_USERS_Cross.MODULE_NAME
     , vwSHORTCUTS_USERS_Cross.DISPLAY_NAME
     , vwSHORTCUTS_USERS_Cross.RELATIVE_PATH
     , vwSHORTCUTS_USERS_Cross.IMAGE_NAME
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ORDER
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE
  from            vwSHORTCUTS_USERS_Cross
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_AccessOnly
               on vwACL_ACTIONS_AccessOnly.CATEGORY = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_AccessOnly.NAME     = N'access'
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_ListOnly
               on vwACL_ACTIONS_ListOnly.CATEGORY   = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_ListOnly.NAME       = N'list'
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID     = vwSHORTCUTS_USERS_Cross.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
 where vwSHORTCUTS_USERS_Cross.SHORTCUT_ENABLED = 1
   and vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE = N'list'
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is not null and vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is not null and vwACL_ACTIONS_AccessOnly.ACLACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is null)
       )
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_LIST   is not null and vwACL_ACCESS_ByAccess.ACLACCESS_LIST >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_LIST   is null     and vwACL_ACTIONS_ListOnly.ACLACCESS is not null   and vwACL_ACTIONS_ListOnly.ACLACCESS   >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_LIST   is null     and vwACL_ACTIONS_ListOnly.ACLACCESS is null)
       )
union all
select vwSHORTCUTS_USERS_Cross.USER_ID
     , vwSHORTCUTS_USERS_Cross.MODULE_NAME
     , vwSHORTCUTS_USERS_Cross.DISPLAY_NAME
     , vwSHORTCUTS_USERS_Cross.RELATIVE_PATH
     , vwSHORTCUTS_USERS_Cross.IMAGE_NAME
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ORDER
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE
  from            vwSHORTCUTS_USERS_Cross
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_AccessOnly
               on vwACL_ACTIONS_AccessOnly.CATEGORY = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_AccessOnly.NAME     = N'access'
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_ListOnly
               on vwACL_ACTIONS_ListOnly.CATEGORY   = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_ListOnly.NAME       = N'import'
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID     = vwSHORTCUTS_USERS_Cross.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
 where vwSHORTCUTS_USERS_Cross.SHORTCUT_ENABLED = 1
   and vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE = N'import'
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is not null and vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is not null and vwACL_ACTIONS_AccessOnly.ACLACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is null)
       )
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT   is not null and vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT   is null     and vwACL_ACTIONS_ListOnly.ACLACCESS is not null   and vwACL_ACTIONS_ListOnly.ACLACCESS   >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT   is null     and vwACL_ACTIONS_ListOnly.ACLACCESS is null)
       )
union all
select vwSHORTCUTS_USERS_Cross.USER_ID
     , vwSHORTCUTS_USERS_Cross.MODULE_NAME
     , vwSHORTCUTS_USERS_Cross.DISPLAY_NAME
     , vwSHORTCUTS_USERS_Cross.RELATIVE_PATH
     , vwSHORTCUTS_USERS_Cross.IMAGE_NAME
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ORDER
     , vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE
  from            vwSHORTCUTS_USERS_Cross
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_AccessOnly
               on vwACL_ACTIONS_AccessOnly.CATEGORY = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_AccessOnly.NAME     = N'access'
  left outer join vwACL_ACTIONS                       vwACL_ACTIONS_ListOnly
               on vwACL_ACTIONS_ListOnly.CATEGORY   = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
              and vwACL_ACTIONS_ListOnly.NAME       = N'archive'
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID     = vwSHORTCUTS_USERS_Cross.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME = vwSHORTCUTS_USERS_Cross.SHORTCUT_MODULE
 where vwSHORTCUTS_USERS_Cross.SHORTCUT_ENABLED = 1
   and vwSHORTCUTS_USERS_Cross.SHORTCUT_ACLTYPE = N'archive'
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is not null and vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is not null and vwACL_ACTIONS_AccessOnly.ACLACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null     and vwACL_ACTIONS_AccessOnly.ACLACCESS is null)
       )
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT   is not null and vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT   is null     and vwACL_ACTIONS_ListOnly.ACLACCESS is not null   and vwACL_ACTIONS_ListOnly.ACLACCESS   >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_IMPORT   is null     and vwACL_ACTIONS_ListOnly.ACLACCESS is null)
       )

GO

Grant Select on dbo.vwSHORTCUTS_Menu_ByUser to public;
GO

