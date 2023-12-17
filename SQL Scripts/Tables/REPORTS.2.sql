
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
-- 06/17/2010 Paul.  Add support for Team Management. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table REPORTS add TEAM_ID uniqueidentifier null';
	alter table REPORTS add TEAM_ID uniqueidentifier null;

	create index IDX_REPORTS_TEAM_ID on dbo.REPORTS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table REPORTS add TEAM_SET_ID uniqueidentifier null';
	alter table REPORTS add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_REPORTS_TEAM_SET_ID on dbo.REPORTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table REPORTS add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table REPORTS add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 12/04/2010 Paul.  Add support for Business Rules Framework. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS' and COLUMN_NAME = 'PRE_LOAD_EVENT_ID') begin -- then
	print 'alter table REPORTS add PRE_LOAD_EVENT_ID uniqueidentifier null';
	alter table REPORTS add PRE_LOAD_EVENT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS' and COLUMN_NAME = 'POST_LOAD_EVENT_ID') begin -- then
	print 'alter table REPORTS add POST_LOAD_EVENT_ID uniqueidentifier null';
	alter table REPORTS add POST_LOAD_EVENT_ID uniqueidentifier null;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table REPORTS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table REPORTS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_REPORTS_ASSIGNED_SET_ID on dbo.REPORTS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'REPORTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'REPORTS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table REPORTS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table REPORTS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

