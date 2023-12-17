
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
-- 09/06/2005 Paul.  Version 3.5.0 added the BODY_HTML field. 
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/19/2006 Paul.  Add READ_ONLY flag. 
-- 12/25/2007 Paul.  TEXT_ONLY was added in SugarCRM 4.5.1
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'BODY_HTML') begin -- then
	print 'alter table EMAIL_TEMPLATES add BODY_HTML nvarchar(max) null';
	alter table EMAIL_TEMPLATES add BODY_HTML nvarchar(max) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table EMAIL_TEMPLATES add TEAM_ID uniqueidentifier null';
	alter table EMAIL_TEMPLATES add TEAM_ID uniqueidentifier null;

	create index IDX_EMAIL_TEMPLATES_TEAM_ID on dbo.EMAIL_TEMPLATES (TEAM_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'READ_ONLY') begin -- then
	print 'alter table EMAIL_TEMPLATES add READ_ONLY bit null default(0)';
	alter table EMAIL_TEMPLATES add READ_ONLY bit null default(0);
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'TEXT_ONLY') begin -- then
	print 'alter table EMAIL_TEMPLATES add TEXT_ONLY bit null default(0)';
	alter table EMAIL_TEMPLATES add TEXT_ONLY bit null default(0);
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table EMAIL_TEMPLATES add TEAM_SET_ID uniqueidentifier null';
	alter table EMAIL_TEMPLATES add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_EMAIL_TEMPLATES_TEAM_SET_ID on dbo.EMAIL_TEMPLATES (TEAM_SET_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table EMAIL_TEMPLATES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table EMAIL_TEMPLATES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'ASSIGNED_USER_ID') begin -- then
	print 'alter table EMAIL_TEMPLATES add ASSIGNED_USER_ID uniqueidentifier null';
	alter table EMAIL_TEMPLATES add ASSIGNED_USER_ID uniqueidentifier null;

	create index IDX_EMAIL_TEMPLATES_ASSIGNED_USER_ID on dbo.EMAIL_TEMPLATES (ASSIGNED_USER_ID, DELETED, ID);
	-- 04/27/2014 Paul.  Disable triggers as this is a system change that does not need to be tracked. 
	-- 09/11/2015 Paul.  Do not change the DATE_MODIFIED field as it will look like an end-user changed the value. 
	exec dbo.spSqlTableDisableTriggers 'EMAIL_TEMPLATES';
	exec('update EMAIL_TEMPLATES
	   set ASSIGNED_USER_ID  = MODIFIED_USER_ID
	     , DATE_MODIFIED_UTC = getutcdate()
	 where ASSIGNED_USER_ID is null
	   and DELETED = 0');
	exec dbo.spSqlTableEnableTriggers 'EMAIL_TEMPLATES';
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAIL_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES_AUDIT' and COLUMN_NAME = 'ASSIGNED_USER_ID') begin -- then
		print 'alter table EMAIL_TEMPLATES_AUDIT add ASSIGNED_USER_ID uniqueidentifier null';
		alter table EMAIL_TEMPLATES_AUDIT add ASSIGNED_USER_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table EMAIL_TEMPLATES add ASSIGNED_SET_ID uniqueidentifier null';
	alter table EMAIL_TEMPLATES add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_EMAIL_TEMPLATES_ASSIGNED_SET_ID on dbo.EMAIL_TEMPLATES (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAIL_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_TEMPLATES_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table EMAIL_TEMPLATES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table EMAIL_TEMPLATES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

