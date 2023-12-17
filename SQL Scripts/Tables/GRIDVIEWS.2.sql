
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
-- 11/22/2010 Paul.  Add support for Business Rules Framework. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'GRIDVIEWS' and COLUMN_NAME = 'PRE_LOAD_EVENT_ID') begin -- then
	print 'alter table GRIDVIEWS add PRE_LOAD_EVENT_ID uniqueidentifier null';
	alter table GRIDVIEWS add PRE_LOAD_EVENT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'GRIDVIEWS' and COLUMN_NAME = 'POST_LOAD_EVENT_ID') begin -- then
	print 'alter table GRIDVIEWS add POST_LOAD_EVENT_ID uniqueidentifier null';
	alter table GRIDVIEWS add POST_LOAD_EVENT_ID uniqueidentifier null;
end -- if;
GO

-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'GRIDVIEWS' and COLUMN_NAME = 'SCRIPT') begin -- then
	print 'alter table GRIDVIEWS add SCRIPT nvarchar(max) null';
	alter table GRIDVIEWS add SCRIPT nvarchar(max) null;
end -- if;
GO

-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from sys.indexes where name = 'IDX_GRIDVIEWS_DELETED_VIEW') begin -- then
	print 'create index IDX_GRIDVIEWS_DELETED_VIEW';
	create index IDX_GRIDVIEWS_DELETED_VIEW on dbo.GRIDVIEWS (DELETED, VIEW_NAME)
end -- if;
GO

-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'GRIDVIEWS' and COLUMN_NAME = 'SORT_FIELD') begin -- then
	print 'alter table GRIDVIEWS add SORT_FIELD nvarchar(50) null';
	alter table GRIDVIEWS add SORT_FIELD nvarchar(50) null;
end -- if;
GO

-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'GRIDVIEWS' and COLUMN_NAME = 'SORT_DIRECTION') begin -- then
	print 'alter table GRIDVIEWS add SORT_DIRECTION nvarchar(10) null';
	alter table GRIDVIEWS add SORT_DIRECTION nvarchar(10) null;
end -- if;
GO

