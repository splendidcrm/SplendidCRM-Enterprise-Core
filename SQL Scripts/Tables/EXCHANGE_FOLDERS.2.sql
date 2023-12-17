
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
-- 07/09/2015 Paul.  The Exchange Folder ID is case-significant. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EXCHANGE_FOLDERS' and COLUMN_NAME = 'REMOTE_KEY' and COLLATION_NAME <> 'SQL_Latin1_General_CP1_CS_AS') begin -- then
-- #if SQL_Server /*
	if exists (select * from sys.indexes where name = 'IDX_EXCHANGE_FOLDERS_REMOTE_KEY') begin -- then
		print 'drop index IDX_EXCHANGE_FOLDERS_REMOTE_KEY';
		drop index IDX_EXCHANGE_FOLDERS_REMOTE_KEY on EXCHANGE_FOLDERS;
	end -- if;
-- #endif SQL_Server */
	print 'alter table EXCHANGE_FOLDERS alter column REMOTE_KEY varchar(800) collate SQL_Latin1_General_CP1_CS_AS null';
	alter table EXCHANGE_FOLDERS alter column REMOTE_KEY varchar(800) collate SQL_Latin1_General_CP1_CS_AS null;

	create index IDX_EXCHANGE_FOLDERS_REMOTE_KEY on dbo.EXCHANGE_FOLDERS (ASSIGNED_USER_ID, DELETED, REMOTE_KEY);
end -- if;
GO

-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from sys.indexes where name = 'IDX_EXCHANGE_FOLDERS_DELETED') begin -- then
	print 'create index IDX_EXCHANGE_FOLDERS_DELETED';
	create index IDX_EXCHANGE_FOLDERS_DELETED on dbo.EXCHANGE_FOLDERS (DELETED, ASSIGNED_USER_ID, MODULE_NAME, PARENT_ID)
end -- if;
GO

-- 12/19/2020 Paul.  Office365 uses a DELTA_TOKEN for each folder. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EXCHANGE_FOLDERS' and COLUMN_NAME = 'DELTA_TOKEN') begin -- then
	print 'alter table EXCHANGE_FOLDERS add DELTA_TOKEN varchar(800) null';
	alter table EXCHANGE_FOLDERS add DELTA_TOKEN varchar(800) null;
end -- if;
GO

