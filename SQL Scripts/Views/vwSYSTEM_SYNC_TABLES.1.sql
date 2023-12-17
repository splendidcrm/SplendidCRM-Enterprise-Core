if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSYSTEM_SYNC_TABLES')
	Drop View dbo.vwSYSTEM_SYNC_TABLES;
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
-- 03/22/2011 Paul.  The Images module is an exception as images are used in various other areas of the system. 
-- 09/22/2016 Paul.  Use vwSqlTables so that collation can be handled in one area. 
Create View dbo.vwSYSTEM_SYNC_TABLES
as
select SYSTEM_SYNC_TABLES.TABLE_NAME
     , SYSTEM_SYNC_TABLES.IS_SYSTEM
     , SYSTEM_SYNC_TABLES.IS_RELATIONSHIP
     , SYSTEM_SYNC_TABLES.DEPENDENT_LEVEL
     , SYSTEM_SYNC_TABLES.VIEW_NAME
     , SYSTEM_SYNC_TABLES.MODULE_NAME
     , SYSTEM_SYNC_TABLES.MODULE_NAME_RELATED
     , SYSTEM_SYNC_TABLES.MODULE_SPECIFIC
     , SYSTEM_SYNC_TABLES.MODULE_FIELD_NAME
     , SYSTEM_SYNC_TABLES.IS_ASSIGNED
     , SYSTEM_SYNC_TABLES.ASSIGNED_FIELD_NAME
     , SYSTEM_SYNC_TABLES.HAS_CUSTOM
  from            SYSTEM_SYNC_TABLES
       inner join vwSqlTables                   TABLES
               on TABLES.TABLE_NAME           = SYSTEM_SYNC_TABLES.TABLE_NAME
  left outer join MODULES
               on MODULES.MODULE_NAME         = SYSTEM_SYNC_TABLES.MODULE_NAME
              and MODULES.DELETED             = 0
  left outer join MODULES                       RELATED_MODULES
               on RELATED_MODULES.MODULE_NAME = SYSTEM_SYNC_TABLES.MODULE_NAME_RELATED
              and RELATED_MODULES.DELETED     = 0
 where  SYSTEM_SYNC_TABLES.DELETED = 0
   and (SYSTEM_SYNC_TABLES.MODULE_NAME         is null or (MODULES.MODULE_ENABLED         = 1 and (SYSTEM_SYNC_TABLES.IS_SYSTEM = 1 or isnull(MODULES.SYNC_ENABLED        , 1) = 1)) or SYSTEM_SYNC_TABLES.MODULE_NAME = 'Images')
   and (SYSTEM_SYNC_TABLES.MODULE_NAME_RELATED is null or (RELATED_MODULES.MODULE_ENABLED = 1 and (SYSTEM_SYNC_TABLES.IS_SYSTEM = 1 or isnull(RELATED_MODULES.SYNC_ENABLED, 1) = 1)))

GO

/*
select *
  from vwSYSTEM_SYNC_TABLES
 order by IS_SYSTEM desc, IS_RELATIONSHIP, DEPENDENT_LEVEL, TABLE_NAME
*/


Grant Select on dbo.vwSYSTEM_SYNC_TABLES to public;
GO

