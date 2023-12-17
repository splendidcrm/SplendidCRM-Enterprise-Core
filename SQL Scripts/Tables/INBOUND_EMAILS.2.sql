
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
-- 01/08/2008 Paul.  Separate out MAILBOX_SSL for ease of coding. Sugar combines it an TLS into the SERVICE field. 
-- 01/13/2008 Paul.  ONLY_SINCE will not be stored in STORED_OPTIONS because we need high-performance access. 
-- 01/13/2008 Paul.  Correct spelling of DELETE_SEEN, which is the reverse of MARK_READ. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 09/15/2009 Paul.  CHARACTER_MAXIMUM_LENGTH will be -1 if already nvarchar(max). 
-- 01/26/2017 Paul.  LAST_EMAIL_UID needs to be a bigint to support Gmail API internalDate value. 
-- 01/28/2017 Paul.  EXCHANGE_WATERMARK for support of Exchange and Office365.
-- 01/28/2017 Paul.  SERVER_URL, EMAIL_USER, EMAIL_PASSWORD, PORT are all nullable. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME  = 'INBOUND_EMAILS' and COLUMN_NAME  = 'STORED_OPTIONS' and (CHARACTER_MAXIMUM_LENGTH > 0 and CHARACTER_MAXIMUM_LENGTH < 10000)) begin -- then
	print 'alter table INBOUND_EMAILS alter column STORED_OPTIONS nvarchar(max) null';
	alter table INBOUND_EMAILS alter column STORED_OPTIONS nvarchar(max) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'FROM_NAME') begin -- then
	print 'alter table INBOUND_EMAILS add FROM_NAME nvarchar(100) null';
	alter table INBOUND_EMAILS add FROM_NAME nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'FROM_ADDR') begin -- then
	print 'alter table INBOUND_EMAILS add FROM_ADDR nvarchar(100) null';
	alter table INBOUND_EMAILS add FROM_ADDR nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'FILTER_DOMAIN') begin -- then
	print 'alter table INBOUND_EMAILS add FILTER_DOMAIN nvarchar(100) null';
	alter table INBOUND_EMAILS add FILTER_DOMAIN nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'MAILBOX_SSL') begin -- then
	print 'alter table INBOUND_EMAILS add MAILBOX_SSL bit null';
	alter table INBOUND_EMAILS add MAILBOX_SSL bit null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'ONLY_SINCE') begin -- then
	print 'alter table INBOUND_EMAILS add ONLY_SINCE bit null default(0)';
	alter table INBOUND_EMAILS add ONLY_SINCE bit null default(0);
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'DELETE_SCEEN') begin -- then
	print 'rename INBOUND_EMAILS.DELETE_SCEEN to INBOUND_EMAILS.DELETE_SEEN';
	exec sp_rename 'INBOUND_EMAILS.DELETE_SCEEN', 'DELETE_SEEN', 'COLUMN';
end -- if;
GO

-- 04/19/2011 Paul.  Add IS_PERSONAL to exclude EmailClient inbound from being included in monitored list. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'IS_PERSONAL') begin -- then
	print 'alter table INBOUND_EMAILS add IS_PERSONAL bit null default(0)';
	alter table INBOUND_EMAILS add IS_PERSONAL bit null default(0);
	exec ('update INBOUND_EMAILS set IS_PERSONAL = 0 where IS_PERSONAL is null');
	exec ('create index IDX_INBOUND_EMAILS on dbo.INBOUND_EMAILS (DELETED, STATUS, IS_PERSONAL, MAILBOX_TYPE, ID)');
end -- if;
GO

-- 01/23/2013 Paul.  Add REPLY_TO_NAME and REPLY_TO_ADDR. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'REPLY_TO_NAME') begin -- then
	print 'alter table INBOUND_EMAILS add REPLY_TO_NAME nvarchar(100) null';
	alter table INBOUND_EMAILS add REPLY_TO_NAME nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'REPLY_TO_ADDR') begin -- then
	print 'alter table INBOUND_EMAILS add REPLY_TO_ADDR nvarchar(100) null';
	alter table INBOUND_EMAILS add REPLY_TO_ADDR nvarchar(100) null;
end -- if;
GO

-- 05/24/2014 Paul.  We need to track the Last Email UID in order to support Only Since flag. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'LAST_EMAIL_UID') begin -- then
	print 'alter table INBOUND_EMAILS add LAST_EMAIL_UID bigint null default(0)';
	alter table INBOUND_EMAILS add LAST_EMAIL_UID bigint null default(0);
	exec ('update INBOUND_EMAILS set LAST_EMAIL_UID = 0 where LAST_EMAIL_UID is null');
end -- if;
GO

-- 01/26/2017 Paul.  LAST_EMAIL_UID needs to be a bigint to support Gmail API internalDate value. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'LAST_EMAIL_UID' and DATA_TYPE = 'int') begin -- then
	print 'alter table INBOUND_EMAILS alter column LAST_EMAIL_UID bigint null';
	exec dbo.spSqlDropDefaultConstraint 'INBOUND_EMAILS', 'LAST_EMAIL_UID';
	alter table INBOUND_EMAILS alter column LAST_EMAIL_UID bigint null;
	alter table INBOUND_EMAILS add constraint DF_LAST_EMAIL_UID default(0) for LAST_EMAIL_UID;
end -- if;
GO

-- 01/28/2017 Paul.  GROUP_TEAM_ID for inbound emails. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'GROUP_TEAM_ID') begin -- then
	print 'alter table INBOUND_EMAILS add GROUP_TEAM_ID uniqueidentifier null';
	alter table INBOUND_EMAILS add GROUP_TEAM_ID uniqueidentifier null;
end -- if;
GO

-- 01/28/2017 Paul.  EXCHANGE_WATERMARK for support of Exchange and Office365.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'EXCHANGE_WATERMARK') begin -- then
	print 'alter table INBOUND_EMAILS add EXCHANGE_WATERMARK varchar(100) null';
	alter table INBOUND_EMAILS add EXCHANGE_WATERMARK varchar(100) null;
end -- if;
GO

-- 01/28/2017 Paul.  SERVER_URL, EMAIL_USER, EMAIL_PASSWORD, PORT are all nullable. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'SERVER_URL' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table INBOUND_EMAILS alter column SERVER_URL nvarchar(100) null';
	alter table INBOUND_EMAILS alter column SERVER_URL nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'EMAIL_USER' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table INBOUND_EMAILS alter column EMAIL_USER nvarchar(100) null';
	alter table INBOUND_EMAILS alter column EMAIL_USER nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'EMAIL_PASSWORD' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table INBOUND_EMAILS alter column EMAIL_PASSWORD nvarchar(100) null';
	alter table INBOUND_EMAILS alter column EMAIL_PASSWORD nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'PORT' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table INBOUND_EMAILS alter column PORT int null';
	alter table INBOUND_EMAILS alter column PORT int null;
end -- if;
GO

-- 07/19/2023 Paul.  Increase size of EXCHANGE_WATERMARK to 1000.  Badly formed token. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAILS' and COLUMN_NAME = 'EXCHANGE_WATERMARK' and CHARACTER_MAXIMUM_LENGTH < 1000) begin -- then
	print 'alter table INBOUND_EMAILS alter column EXCHANGE_WATERMARK nvarchar(1000) null';
	alter table INBOUND_EMAILS alter column EXCHANGE_WATERMARK nvarchar(1000) null;
end -- if;
GO

