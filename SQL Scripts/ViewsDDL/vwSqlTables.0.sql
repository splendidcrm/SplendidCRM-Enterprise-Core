if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlTables')
	Drop View dbo.vwSqlTables;
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
-- 01/16/2008 Paul.  Simplify conversion to Oracle. 
-- 09/12/2008 Paul.  We need to exclude system tables, such as sysdiagrams. 
-- 09/22/2016 Paul.  Manually specify default collation to ease migration to Azure
Create View dbo.vwSqlTables
as
select TABLE_NAME  collate database_default  as TABLE_NAME
  from INFORMATION_SCHEMA.TABLES
 where TABLE_TYPE = N'BASE TABLE'
   and TABLE_NAME not in (N'dtproperties', N'sysdiagrams')
GO


Grant Select on dbo.vwSqlTables to public;
GO

