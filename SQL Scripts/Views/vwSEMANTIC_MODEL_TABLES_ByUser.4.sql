if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSEMANTIC_MODEL_TABLES_ByUser')
	Drop View dbo.vwSEMANTIC_MODEL_TABLES_ByUser;
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
-- 12/13/2009 Paul.  Exclude module name to prevent duplicates caused by relationship tables. 
Create View dbo.vwSEMANTIC_MODEL_TABLES_ByUser
as
select distinct
       vwSEMANTIC_MODEL_TABLES.ID
     , vwSEMANTIC_MODEL_TABLES.NAME
     , vwSEMANTIC_MODEL_TABLES.COLLECTION_NAME
     , vwSEMANTIC_MODEL_TABLES.INSTANCE_SELECTION
     , vwMODULES_USERS_Cross.USER_ID
  from            vwSEMANTIC_MODEL_TABLES
  left outer join vwRELATIONSHIPS_Reporting
               on vwRELATIONSHIPS_Reporting.JOIN_TABLE = vwSEMANTIC_MODEL_TABLES.NAME
       inner join vwMODULES_USERS_Cross
               on (vwMODULES_USERS_Cross.TABLE_NAME    = vwSEMANTIC_MODEL_TABLES.NAME
               or  vwMODULES_USERS_Cross.TABLE_NAME    = vwRELATIONSHIPS_Reporting.LHS_TABLE
               or  vwMODULES_USERS_Cross.TABLE_NAME    = vwRELATIONSHIPS_Reporting.RHS_TABLE)
  left outer join vwACL_ACTIONS
               on vwACL_ACTIONS.CATEGORY               = vwMODULES_USERS_Cross.MODULE_NAME
              and vwACL_ACTIONS.NAME                   in (N'access', N'list')
  left outer join vwACL_ACCESS_ByAccess
               on vwACL_ACCESS_ByAccess.USER_ID        = vwMODULES_USERS_Cross.USER_ID
              and vwACL_ACCESS_ByAccess.MODULE_NAME    = vwMODULES_USERS_Cross.MODULE_NAME
 where vwMODULES_USERS_Cross.MODULE_ENABLED = 1
   and vwMODULES_USERS_Cross.REPORT_ENABLED = 1
   and (   (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is not null and vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null and vwACL_ACTIONS.ACLACCESS is not null and vwACL_ACTIONS.ACLACCESS >= 0)
        or (vwACL_ACCESS_ByAccess.ACLACCESS_ACCESS is null and vwACL_ACTIONS.ACLACCESS is null)
       )

GO

Grant Select on dbo.vwSEMANTIC_MODEL_TABLES_ByUser to public;
GO


