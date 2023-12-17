
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
-- 05/24/2016 Paul.  Twitter is increasing the size of their tweets. They are going to 177, but we are going to 255. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 10/21/2017 Paul.  Twitter increased sized to 280, but we are going to go to 420 so that we don't need to keep increasing. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 420) begin -- then
	print 'alter table TWITTER_MESSAGES alter column NAME nvarchar(420) null';
	if exists (select * from sys.indexes where name = 'IDX_TWITTER_MSG_NAME') begin -- then
		drop index IDX_TWITTER_MSG_NAME on TWITTER_MESSAGES;
	end -- if;
	alter table TWITTER_MESSAGES alter column NAME nvarchar(420) null;
	create index IDX_TWITTER_MSG_NAME        on dbo.TWITTER_MESSAGES (NAME, DELETED, ID);
end -- if;
GO

-- 10/21/2017 Paul.  Twitter increased sized to 280, but we are going to go to 420 so that we don't need to keep increasing. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 420) begin -- then
	print 'alter table TWITTER_MESSAGES_AUDIT alter column NAME nvarchar(420) null';
	alter table TWITTER_MESSAGES_AUDIT alter column NAME nvarchar(420) null;
end -- if;
GO

-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from sys.indexes where name = 'IDX_TWITTER_MESSAGES_TWITTER_ID') begin -- then
	print 'create index IDX_TWITTER_MESSAGES_TWITTER_ID';
	create index IDX_TWITTER_MESSAGES_TWITTER_ID on dbo.TWITTER_MESSAGES (DELETED, TWITTER_ID)
end -- if;
GO

-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'IS_PRIVATE') begin -- then
	print 'alter table TWITTER_MESSAGES add IS_PRIVATE bit null';
	alter table TWITTER_MESSAGES add IS_PRIVATE bit null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'IS_PRIVATE') begin -- then
		print 'alter table TWITTER_MESSAGES_AUDIT add IS_PRIVATE bit null';
		alter table TWITTER_MESSAGES_AUDIT add IS_PRIVATE bit null;
	end -- if;
end -- if;
GO

-- 11/10/2017 Paul.  Twitter increased display name to 50. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'TWITTER_FULL_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES alter column TWITTER_FULL_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES alter column TWITTER_FULL_NAME nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'TWITTER_FULL_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES_AUDIT alter column TWITTER_FULL_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES_AUDIT alter column TWITTER_FULL_NAME nvarchar(50) null;
end -- if;
GO

-- 11/10/2017 Paul.  Twitter increased display name to 50. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'TWITTER_SCREEN_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES alter column TWITTER_SCREEN_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES alter column TWITTER_SCREEN_NAME nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'TWITTER_SCREEN_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES_AUDIT alter column TWITTER_SCREEN_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES_AUDIT alter column TWITTER_SCREEN_NAME nvarchar(50) null;
end -- if;
GO

-- 11/10/2017 Paul.  Twitter increased display name to 50. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'ORIGINAL_FULL_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES alter column ORIGINAL_FULL_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES alter column ORIGINAL_FULL_NAME nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'ORIGINAL_FULL_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES_AUDIT alter column ORIGINAL_FULL_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES_AUDIT alter column ORIGINAL_FULL_NAME nvarchar(50) null;
end -- if;
GO

-- 11/10/2017 Paul.  Twitter increased display name to 50. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'ORIGINAL_SCREEN_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES alter column ORIGINAL_SCREEN_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES alter column ORIGINAL_SCREEN_NAME nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'ORIGINAL_SCREEN_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_MESSAGES_AUDIT alter column ORIGINAL_SCREEN_NAME nvarchar(50) null';
	alter table TWITTER_MESSAGES_AUDIT alter column ORIGINAL_SCREEN_NAME nvarchar(50) null;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table TWITTER_MESSAGES add ASSIGNED_SET_ID uniqueidentifier null';
	alter table TWITTER_MESSAGES add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_TWITTER_MESSAGES_ASSIGNED_SET_ID on dbo.TWITTER_MESSAGES (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_MESSAGES_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table TWITTER_MESSAGES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table TWITTER_MESSAGES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

