
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
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TRACKER' and COLUMN_NAME = 'NUMBER') begin -- then
	print 'alter table TRACKER drop column NUMBER';
	alter table TRACKER drop column NUMBER;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TRACKER' and COLUMN_NAME = 'DELETED') begin -- then
	print 'alter table TRACKER add DELETED bit not null default(0)';
	alter table TRACKER add DELETED bit not null default(0);
end -- if;
GO

-- 11/03/2009 Paul.  This foreign key will give us trouble on the offline client. 
if exists(select * from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS where CONSTRAINT_NAME = 'FK_TRACKER_USER_ID') begin -- then
	print 'alter table TRACKER drop constraint FK_TRACKER_USER_ID;';

	alter table TRACKER drop constraint FK_TRACKER_USER_ID;
end -- if;
GO

-- 08/26/2010 Paul.  Add IDX_TRACKER_USER_MODULE to speed spTRACKER_Update. 
if not exists (select * from sys.indexes where name = 'IDX_TRACKER_USER_MODULE') begin -- then
	print 'create index IDX_TRACKER_USER_MODULE';
	create index IDX_TRACKER_USER_MODULE on dbo.TRACKER (USER_ID, MODULE_NAME, ID)
end -- if;
GO

-- 03/08/2012 Paul.  Add ACTION to the tracker table so that we can create quick user activity reports. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TRACKER' and COLUMN_NAME = 'ACTION') begin -- then
	print 'alter table TRACKER add ACTION nvarchar(25) null default(''detailview'')';
	alter table TRACKER add ACTION nvarchar(25) null default('detailview');
	exec('update TRACKER
	   set ACTION = ''detailview''
	 where ACTION is null');

	if exists (select * from sys.indexes where name = 'IDX_TRACKER_USER_ID') begin -- then
		drop index IDX_TRACKER_USER_ID on TRACKER;
	end -- if;
	if exists (select * from sys.indexes where name = 'IDX_TRACKER_ITEM_ID') begin -- then
		drop index IDX_TRACKER_ITEM_ID on TRACKER;
	end -- if;
	if exists (select * from sys.indexes where name = 'IDX_TRACKER_USER_MODULE') begin -- then
		drop index IDX_TRACKER_USER_MODULE on TRACKER;
	end -- if;

	create index IDX_TRACKER_USER_ID     on dbo.TRACKER (USER_ID, ACTION, DELETED);
	create index IDX_TRACKER_ITEM_ID     on dbo.TRACKER (ITEM_ID, ACTION, DELETED);
	create index IDX_TRACKER_USER_MODULE on dbo.TRACKER (USER_ID, ACTION, DELETED, MODULE_NAME, ID);
end -- if;
GO

