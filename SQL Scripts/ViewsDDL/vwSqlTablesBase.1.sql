if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlTablesBase')
	Drop View dbo.vwSqlTablesBase;
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
-- 05/01/2009 Paul.  We need to isolate tables that are non CRM tables. 
-- 09/08/2009 Paul.  Azura requires the use of aliases when dealing with INFORMATION_SCHEMA. 
-- 09/22/2016 Paul.  Manually specify default collation to ease migration to Azure
Create View dbo.vwSqlTablesBase
as
select TABLES.TABLE_NAME  collate database_default  as TABLE_NAME
  from      INFORMATION_SCHEMA.TABLES   TABLES
 inner join INFORMATION_SCHEMA.COLUMNS  COLUMNS
         on COLUMNS.TABLE_NAME        = TABLES.TABLE_NAME
 where TABLES.TABLE_TYPE = N'BASE TABLE'
   and TABLES.TABLE_NAME   not in (N'dtproperties', N'sysdiagrams')
   and COLUMNS.COLUMN_NAME in (N'ID', N'ID_C')
   and COLUMNS.DATA_TYPE   = N'uniqueidentifier'
GO


Grant Select on dbo.vwSqlTablesBase to public;
GO

