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
-- 07/24/2006 Paul.  Increase the MODULE_NAME to 25 to match the size in the MODULES table.
-- 02/11/2017 Paul.  New index based on missing indexes query. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TERMINOLOGY' and COLUMN_NAME = 'MODULE_NAME' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table TERMINOLOGY alter column MODULE_NAME nvarchar(25) null';
	alter table TERMINOLOGY alter column MODULE_NAME nvarchar(25) null;
end -- if;
GO

-- 03/06/2012 Paul.  Increase size of the NAME field so that it can include a date formula. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TERMINOLOGY' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table TERMINOLOGY alter column NAME nvarchar(150) null';
	alter table TERMINOLOGY alter column NAME nvarchar(150) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TERMINOLOGY' and COLUMN_NAME = 'DISPLAY_NAME' and CHARACTER_MAXIMUM_LENGTH <> -1) begin -- then
	print 'alter table TERMINOLOGY alter column DISPLAY_NAME nvarchar(max) null';
	alter table TERMINOLOGY alter column DISPLAY_NAME nvarchar(max) null;
end -- if;
GO

-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from sys.indexes where name = 'IX_TERMINOLOGY_LIST_NAME') begin -- then
	print 'create index IX_TERMINOLOGY_LIST_NAME';
	create index IX_TERMINOLOGY_LIST_NAME on dbo.TERMINOLOGY(DELETED, LANG, LIST_NAME)
end -- if;
GO

-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from sys.indexes where name = 'IDX_TERMINOLOGY_DELETED_LIST') begin -- then
	print 'create index IDX_TERMINOLOGY_DELETED_LIST';
	create index IDX_TERMINOLOGY_DELETED_LIST on dbo.TERMINOLOGY (DELETED, LIST_NAME)
end -- if;
GO

