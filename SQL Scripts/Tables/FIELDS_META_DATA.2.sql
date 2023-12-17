
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
-- 04/21/2006 Paul.  MASS_UPDATE was added in SugarCRM 4.0.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'AUDITED') begin -- then
	print 'alter table FIELDS_META_DATA add AUDITED bit null default(0)';
	alter table FIELDS_META_DATA add AUDITED bit null default(0);
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'MASS_UPDATE') begin -- then
	print 'alter table FIELDS_META_DATA add MASS_UPDATE bit null default(0)';
	alter table FIELDS_META_DATA add MASS_UPDATE bit null default(0);
end -- if;
GO

-- 04/21/2008 Paul.  We changed some of the original SugarCRM field names. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'LABEL') begin -- then
	print 'alter table FIELDS_META_DATA add LABEL nvarchar(255) null';
	alter table FIELDS_META_DATA add LABEL nvarchar(255) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'DATA_TYPE') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'TYPE') begin -- then
		print 'alter table FIELDS_META_DATA rename TYPE to DATA_TYPE';
		exec sp_rename 'FIELDS_META_DATA.TYPE', 'DATA_TYPE', 'COLUMN';
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'MAX_SIZE') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'LEN') begin -- then
		print 'alter table FIELDS_META_DATA rename LEN to MAX_SIZE';
		exec sp_rename 'FIELDS_META_DATA.LEN', 'MAX_SIZE', 'COLUMN';
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'REQUIRED_OPTION') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'REQUIRED') begin -- then
		print 'alter table FIELDS_META_DATA rename REQUIRED to REQUIRED_OPTION';
		exec sp_rename 'FIELDS_META_DATA.REQUIRED', 'REQUIRED_OPTION', 'COLUMN';
	end -- if;
end -- if;
GO

-- 11/17/2009 Paul.  We have added DATE_MODIFIED_UTC to tables that are sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FIELDS_META_DATA' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table FIELDS_META_DATA add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table FIELDS_META_DATA add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

