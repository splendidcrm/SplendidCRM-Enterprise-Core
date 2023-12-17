
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
-- 12/13/2005 Paul.  Bad decision to change the name to MODULE in SplendidCRM.  Change back. 
-- 09/15/2009 Paul.  Use new syntax to drop an index. 
-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ROLES_MODULES' and COLUMN_NAME = 'MODULE_ID') begin -- then
	print 'alter table ROLES_MODULES add MODULE_ID varchar(36) null';
	alter table ROLES_MODULES add MODULE_ID varchar(36) null;
end -- if;
GO

-- 12/13/2005 Paul.  Need to separate MODULE_ID creation, otherwise SQL Server generates "Invalid column name 'MODULE_ID'." error. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ROLES_MODULES' and COLUMN_NAME = 'MODULE') begin -- then
	if exists (select * from sys.indexes where name = 'IDX_ROLES_MODULES_ROLE_ID_MODULE_ID') begin -- then
		exec ('drop index IDX_ROLES_MODULES_ROLE_ID_MODULE_ID on dbo.ROLES_MODULES');
	end -- if;

	-- 12/21/2005 Paul.  Use EXEC, otherwise SQL Server will complain if the MODULE column does not exist. 
	exec ('update ROLES_MODULES set MODULE_ID = cast(MODULE as varchar(36))');
	exec ('alter table ROLES_MODULES drop column MODULE');
	exec ('alter table ROLES_MODULES alter column MODULE_ID varchar(36) not null');
	
	exec ('create index IDX_ROLES_MODULES_ROLE_ID_MODULE_ID  on dbo.ROLES_MODULES ( ROLE_ID, MODULE_ID )');
end -- if;
GO

