
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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table PROJECT_TASK add TEAM_ID uniqueidentifier null';
	alter table PROJECT_TASK add TEAM_ID uniqueidentifier null;

	create index IDX_PROJECT_TASK_TEAM_ID on dbo.PROJECT_TASK (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 04/21/2008 Paul.  SugarCRM 5.0 has dropped TIME_START and combined it with DATE_START. 
-- We did this long ago, but we kept the use of TIME_START for compatibility with MySQL. 
-- We will eventually duplicate this behavior, but not now.  Add the fields if missing. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'TIME_DUE') begin -- then
	print 'alter table PROJECT_TASK add TIME_DUE datetime null';
	alter table PROJECT_TASK add TIME_DUE datetime null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'TIME_START') begin -- then
	print 'alter table PROJECT_TASK add TIME_START datetime null';
	alter table PROJECT_TASK add TIME_START datetime null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'STATUS') begin -- then
	print 'alter table PROJECT_TASK add STATUS nvarchar(25) null';
	alter table PROJECT_TASK add STATUS nvarchar(25) null;
end -- if;
GO

-- 04/21/2008 Paul.  SugarCRM 5.0 dropped ESTIMATED_EFFORT.  We will eventually do the same. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'ESTIMATED_EFFORT') begin -- then
	print 'alter table PROJECT_TASK add ESTIMATED_EFFORT int null';
	alter table PROJECT_TASK add ESTIMATED_EFFORT int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'ORDER_NUMBER') begin -- then
	print 'alter table PROJECT_TASK add ORDER_NUMBER int null';
	alter table PROJECT_TASK add ORDER_NUMBER int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'TASK_NUMBER') begin -- then
	print 'alter table PROJECT_TASK add TASK_NUMBER int null';
	alter table PROJECT_TASK add TASK_NUMBER int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'UTILIZATION') begin -- then
	print 'alter table PROJECT_TASK add UTILIZATION int null';
	alter table PROJECT_TASK add UTILIZATION int null;
end -- if;
GO

-- 04/21/2008 Paul.  SugarCRM 5.0 uses integers for PROJECT_TASK_ID and PARENT_TASK_ID.
-- We do not support their style of project management at this time. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'PARENT_ID') begin -- then
	print 'alter table PROJECT_TASK add PARENT_ID uniqueidentifier null';
	alter table PROJECT_TASK add PARENT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'DEPENDS_ON_ID') begin -- then
	print 'alter table PROJECT_TASK add DEPENDS_ON_ID uniqueidentifier null';
	alter table PROJECT_TASK add DEPENDS_ON_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'DATE_DUE') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'DATE_FINISH') begin -- then
		print 'alter table PROJECT_TASK rename DATE_FINISH to DATE_DUE';
		exec sp_rename 'PROJECT_TASK.DATE_FINISH', 'DATE_DUE', 'COLUMN';
	end -- if;
end -- if;
GO

-- 04/21/2008 Paul.  Not sure why TIME_START is an int in SugarCRM 5.0.
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'TIME_START' and DATA_TYPE <> 'datetime') begin -- then
	print 'alter table PROJECT_TASK drop column TIME_START';
	alter table PROJECT_TASK drop column TIME_START;
	print 'alter table PROJECT_TASK add TIME_START datetime null';
	alter table PROJECT_TASK add TIME_START datetime null;
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table PROJECT_TASK add TEAM_SET_ID uniqueidentifier null';
	alter table PROJECT_TASK add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PROJECT_TASK_TEAM_SET_ID on dbo.PROJECT_TASK (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table PROJECT_TASK add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table PROJECT_TASK add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 01/19/2010 Paul.  Some customers have requested that we allow for fractional efforts. 
if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'ESTIMATED_EFFORT' and DATA_TYPE = 'int') begin -- then
	print 'alter table PROJECT_TASK alter column ESTIMATED_EFFORT float null';
	alter table PROJECT_TASK alter column ESTIMATED_EFFORT float null;
end -- if;
GO

if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'ACTUAL_EFFORT' and DATA_TYPE = 'int') begin -- then
	print 'alter table PROJECT_TASK alter column ACTUAL_EFFORT float null';
	alter table PROJECT_TASK alter column ACTUAL_EFFORT float null;
end -- if;
GO

-- 01/19/2010 Paul.  The audit table must also be altered. 
if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK_AUDIT' and COLUMN_NAME = 'ESTIMATED_EFFORT' and DATA_TYPE = 'int') begin -- then
	print 'alter table PROJECT_TASK_AUDIT alter column ESTIMATED_EFFORT float null';
	alter table PROJECT_TASK_AUDIT alter column ESTIMATED_EFFORT float null;
end -- if;
GO

if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK_AUDIT' and COLUMN_NAME = 'ACTUAL_EFFORT' and DATA_TYPE = 'int') begin -- then
	print 'alter table PROJECT_TASK_AUDIT alter column ACTUAL_EFFORT float null';
	alter table PROJECT_TASK_AUDIT alter column ACTUAL_EFFORT float null;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table PROJECT_TASK add ASSIGNED_SET_ID uniqueidentifier null';
	alter table PROJECT_TASK add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_PROJECT_TASK_ASSIGNED_SET_ID on dbo.PROJECT_TASK (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROJECT_TASK_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROJECT_TASK_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table PROJECT_TASK_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table PROJECT_TASK_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

