
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
-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'DATA_COLUMNS') begin -- then
	print 'alter table EDITVIEWS add DATA_COLUMNS int null';
	alter table EDITVIEWS add DATA_COLUMNS int null;
end -- if;
GO

-- 10/30/2010 Paul.  Add support for Business Rules Framework. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'NEW_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS add NEW_EVENT_ID uniqueidentifier null';
	alter table EDITVIEWS add NEW_EVENT_ID uniqueidentifier null;
end -- if;
GO

-- 11/11/2010 Paul.  Change to Pre Load and Post Load. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'LOAD_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS drop column LOAD_EVENT_ID';
	alter table EDITVIEWS drop column LOAD_EVENT_ID;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'PRE_LOAD_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS add PRE_LOAD_EVENT_ID uniqueidentifier null';
	alter table EDITVIEWS add PRE_LOAD_EVENT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'POST_LOAD_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS add POST_LOAD_EVENT_ID uniqueidentifier null';
	alter table EDITVIEWS add POST_LOAD_EVENT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'VALIDATION_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS add VALIDATION_EVENT_ID uniqueidentifier null';
	alter table EDITVIEWS add VALIDATION_EVENT_ID uniqueidentifier null;
end -- if;
GO

-- 02/12/2011 Paul.  POST_VALIDATION_EVENT_ID was not used.  Instead, we use VALIDATION_EVENT_ID. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'POST_VALIDATION_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS drop column POST_VALIDATION_EVENT_ID';
	alter table EDITVIEWS drop column POST_VALIDATION_EVENT_ID;
end -- if;
GO


if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'PRE_SAVE_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS add PRE_SAVE_EVENT_ID uniqueidentifier null';
	alter table EDITVIEWS add PRE_SAVE_EVENT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'POST_SAVE_EVENT_ID') begin -- then
	print 'alter table EDITVIEWS add POST_SAVE_EVENT_ID uniqueidentifier null';
	alter table EDITVIEWS add POST_SAVE_EVENT_ID uniqueidentifier null;
end -- if;
GO

-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EDITVIEWS' and COLUMN_NAME = 'SCRIPT') begin -- then
	print 'alter table EDITVIEWS add SCRIPT nvarchar(max) null';
	alter table EDITVIEWS add SCRIPT nvarchar(max) null;
end -- if;
GO

-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from sys.indexes where name = 'IDX_EDITVIEWS_DELETED_VIEW') begin -- then
	print 'create index IDX_EDITVIEWS_DELETED_VIEW';
	create index IDX_EDITVIEWS_DELETED_VIEW on dbo.EDITVIEWS (DELETED, VIEW_NAME)
end -- if;
GO

