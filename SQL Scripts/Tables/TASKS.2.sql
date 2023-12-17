
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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table TASKS add TEAM_ID uniqueidentifier null';
	alter table TASKS add TEAM_ID uniqueidentifier null;

	create index IDX_TASKS_TEAM_ID on dbo.TASKS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 04/21/2008 Paul.  SugarCRM 5.0 has dropped TIME_START and combined it with DATE_START. 
-- We did this long ago, but we kept the use of TIME_START for compatibility with MySQL. 
-- We will eventually duplicate this behavior, but not now.  Add the fields if missing. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'TIME_DUE') begin -- then
	print 'alter table TASKS add TIME_DUE datetime null';
	alter table TASKS add TIME_DUE datetime null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'TIME_START') begin -- then
	print 'alter table TASKS add TIME_START datetime null';
	alter table TASKS add TIME_START datetime null;
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table TASKS add TEAM_SET_ID uniqueidentifier null';
	alter table TASKS add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_TASKS_TEAM_SET_ID on dbo.TASKS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table TASKS add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table TASKS add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 06/07/2017 Paul.  Increase NAME size to 150 to support Asterisk. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table TASKS alter column NAME nvarchar(150) null';
	alter table TASKS alter column NAME nvarchar(150) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table TASKS_AUDIT alter column NAME nvarchar(150) null';
	alter table TASKS_AUDIT alter column NAME nvarchar(150) null;
end -- if;
GO

-- 06/07/2017 Paul.  Add REMINDER_TIME, EMAIL_REMINDER_TIME, SMS_REMINDER_TIME. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'REMINDER_TIME') begin -- then
	print 'alter table TASKS add REMINDER_TIME int null';
	alter table TASKS add REMINDER_TIME int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TASKS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS_AUDIT' and COLUMN_NAME = 'REMINDER_TIME') begin -- then
		print 'alter table TASKS_AUDIT add REMINDER_TIME int null';
		alter table TASKS_AUDIT add REMINDER_TIME int null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'EMAIL_REMINDER_TIME') begin -- then
	print 'alter table TASKS add EMAIL_REMINDER_TIME int null';
	alter table TASKS add EMAIL_REMINDER_TIME int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TASKS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS_AUDIT' and COLUMN_NAME = 'EMAIL_REMINDER_TIME') begin -- then
		print 'alter table TASKS_AUDIT add EMAIL_REMINDER_TIME int null';
		alter table TASKS_AUDIT add EMAIL_REMINDER_TIME int null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'SMS_REMINDER_TIME') begin -- then
	print 'alter table TASKS add SMS_REMINDER_TIME int null';
	alter table TASKS add SMS_REMINDER_TIME int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TASKS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS_AUDIT' and COLUMN_NAME = 'SMS_REMINDER_TIME') begin -- then
		print 'alter table TASKS_AUDIT add SMS_REMINDER_TIME int null';
		alter table TASKS_AUDIT add SMS_REMINDER_TIME int null;
	end -- if;
end -- if;
GO

-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'IS_PRIVATE') begin -- then
	print 'alter table TASKS add IS_PRIVATE bit null';
	alter table TASKS add IS_PRIVATE bit null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TASKS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS_AUDIT' and COLUMN_NAME = 'IS_PRIVATE') begin -- then
		print 'alter table TASKS_AUDIT add IS_PRIVATE bit null';
		alter table TASKS_AUDIT add IS_PRIVATE bit null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table TASKS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table TASKS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_TASKS_ASSIGNED_SET_ID on dbo.TASKS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TASKS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TASKS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table TASKS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table TASKS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

