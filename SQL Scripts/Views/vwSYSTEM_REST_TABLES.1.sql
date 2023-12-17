if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSYSTEM_REST_TABLES')
	Drop View dbo.vwSYSTEM_REST_TABLES;
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
-- 05/25/2011 Paul.  Tables available to the REST API are not bound by the SYNC_ENABLED flag. 
-- 06/18/2011 Paul.  SYSTEM_REST_TABLES are nearly identical to SYSTEM_REST_TABLES,
-- but the Module tables typically refer to the base view instead of the raw table. 
-- 09/26/2016 Paul.  Use vwSqlViews so that collation can be handled in one area. 
-- 08/01/2019 Paul.  We need a ListView and EditView flags for the Rest Client. 
-- 08/02/2019 Paul.  The React Client will need access to views that require a filter, like CAMPAIGN_ID. 
Create View dbo.vwSYSTEM_REST_TABLES
as
select SYSTEM_REST_TABLES.TABLE_NAME
     , SYSTEM_REST_TABLES.IS_SYSTEM
     , SYSTEM_REST_TABLES.IS_RELATIONSHIP
     , SYSTEM_REST_TABLES.DEPENDENT_LEVEL
     , SYSTEM_REST_TABLES.VIEW_NAME
     , SYSTEM_REST_TABLES.MODULE_NAME
     , SYSTEM_REST_TABLES.MODULE_NAME_RELATED
     , SYSTEM_REST_TABLES.MODULE_SPECIFIC
     , SYSTEM_REST_TABLES.MODULE_FIELD_NAME
     , SYSTEM_REST_TABLES.IS_ASSIGNED
     , SYSTEM_REST_TABLES.ASSIGNED_FIELD_NAME
     , SYSTEM_REST_TABLES.HAS_CUSTOM
     , SYSTEM_REST_TABLES.REQUIRED_FIELDS
     , isnull(LIST_VIEWS.VIEW_NAME, SYSTEM_REST_TABLES.VIEW_NAME) as LIST_VIEW
     , isnull(EDIT_VIEWS.VIEW_NAME, SYSTEM_REST_TABLES.VIEW_NAME) as EDIT_VIEW
  from            SYSTEM_REST_TABLES
       inner join vwSqlViews                    TABLES
               on TABLES.VIEW_NAME            = SYSTEM_REST_TABLES.VIEW_NAME
  left outer join vwSqlViews                    LIST_VIEWS
               on LIST_VIEWS.VIEW_NAME        = SYSTEM_REST_TABLES.VIEW_NAME + '_List'
  left outer join vwSqlViews                    EDIT_VIEWS
               on EDIT_VIEWS.VIEW_NAME        = SYSTEM_REST_TABLES.VIEW_NAME + '_Edit'
  left outer join MODULES
               on MODULES.MODULE_NAME         = SYSTEM_REST_TABLES.MODULE_NAME
              and MODULES.DELETED             = 0
  left outer join MODULES                       RELATED_MODULES
               on RELATED_MODULES.MODULE_NAME = SYSTEM_REST_TABLES.MODULE_NAME_RELATED
              and RELATED_MODULES.DELETED     = 0
 where  SYSTEM_REST_TABLES.DELETED = 0
   and (SYSTEM_REST_TABLES.MODULE_NAME         is null or (MODULES.MODULE_ENABLED         = 1) or SYSTEM_REST_TABLES.MODULE_NAME = 'Images')
   and (SYSTEM_REST_TABLES.MODULE_NAME_RELATED is null or (RELATED_MODULES.MODULE_ENABLED = 1))

GO

/*
select *
  from vwSYSTEM_REST_TABLES
 order by IS_SYSTEM desc, IS_RELATIONSHIP, DEPENDENT_LEVEL, TABLE_NAME
*/


Grant Select on dbo.vwSYSTEM_REST_TABLES to public;
GO

