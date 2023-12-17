if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ACCESS_ByModule')
	Drop View dbo.vwACL_ACCESS_ByModule;
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
-- 04/26/2006 Paul.  Get the minimum ACLACCESS just in case vwACL_ACTIONS contains multiple records. 
-- Normally, we would use a unique index on the ACL_ACTIONS table, but we cannot because 
-- near identical rows are allowed because of the use of the DELETED flag. 
-- 12/05/2006 Paul.  iFrames should not be excluded because the My Portal tab can be disabled and edited. 
-- 02/03/2009 Paul.  Exclude Teams from role management. 
-- 03/09/2010 Paul.  Allow IS_ADMIN and Team Management so that they can be managed separately. 
-- 04/17/2016 Paul.  Allow Calendar to be disabled. 
-- 09/26/2017 Paul.  Add Archive access right. 
-- 01/11/2019 Paul.  Activities should not be excluded as started treating Activities separately on 06/02/2016. 
Create View dbo.vwACL_ACCESS_ByModule
as
select vwMODULES.MODULE_NAME
     , vwMODULES.DISPLAY_NAME
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'admin' ),  1) as ACLACCESS_ADMIN 
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'access'), 89) as ACLACCESS_ACCESS
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'view'  ), 90) as ACLACCESS_VIEW  
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'list'  ), 90) as ACLACCESS_LIST  
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'edit'  ), 90) as ACLACCESS_EDIT  
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'delete'), 90) as ACLACCESS_DELETE
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'import'), 90) as ACLACCESS_IMPORT
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'export'), 90) as ACLACCESS_EXPORT
     , isnull((select min(ACLACCESS) from vwACL_ACTIONS where CATEGORY = vwMODULES.MODULE_NAME and NAME = N'archive'), 90) as ACLACCESS_ARCHIVE
     , vwMODULES.IS_ADMIN
  from vwMODULES
 where vwMODULES.MODULE_NAME not in (N'Home')
GO

Grant Select on dbo.vwACL_ACCESS_ByModule to public;
GO


