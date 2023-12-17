
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
-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES' and COLUMN_NAME = 'CUSTOM_STYLES') begin -- then
	print 'alter table SURVEY_THEMES add CUSTOM_STYLES nvarchar(max) null';
	alter table SURVEY_THEMES add CUSTOM_STYLES nvarchar(max) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_THEMES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES_AUDIT' and COLUMN_NAME = 'CUSTOM_STYLES') begin -- then
		print 'alter table SURVEY_THEMES_AUDIT add CUSTOM_STYLES nvarchar(max) null';
		alter table SURVEY_THEMES_AUDIT add CUSTOM_STYLES nvarchar(max) null;
	end -- if;
end -- if;
GO

-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES' and COLUMN_NAME = 'PAGE_BACKGROUND_IMAGE') begin -- then
	print 'alter table SURVEY_THEMES add PAGE_BACKGROUND_IMAGE nvarchar(255) null';
	alter table SURVEY_THEMES add PAGE_BACKGROUND_IMAGE nvarchar(255) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_THEMES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES_AUDIT' and COLUMN_NAME = 'PAGE_BACKGROUND_IMAGE') begin -- then
		print 'alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_IMAGE nvarchar(255) null';
		alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_IMAGE nvarchar(255) null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES' and COLUMN_NAME = 'PAGE_BACKGROUND_POSITION') begin -- then
	print 'alter table SURVEY_THEMES add PAGE_BACKGROUND_POSITION nvarchar(25) null';
	alter table SURVEY_THEMES add PAGE_BACKGROUND_POSITION nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_THEMES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES_AUDIT' and COLUMN_NAME = 'PAGE_BACKGROUND_POSITION') begin -- then
		print 'alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_POSITION nvarchar(25) null';
		alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_POSITION nvarchar(25) null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES' and COLUMN_NAME = 'PAGE_BACKGROUND_REPEAT') begin -- then
	print 'alter table SURVEY_THEMES add PAGE_BACKGROUND_REPEAT nvarchar(25) null';
	alter table SURVEY_THEMES add PAGE_BACKGROUND_REPEAT nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_THEMES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES_AUDIT' and COLUMN_NAME = 'PAGE_BACKGROUND_REPEAT') begin -- then
		print 'alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_REPEAT nvarchar(25) null';
		alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_REPEAT nvarchar(25) null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES' and COLUMN_NAME = 'PAGE_BACKGROUND_SIZE') begin -- then
	print 'alter table SURVEY_THEMES add PAGE_BACKGROUND_SIZE nvarchar(25) null';
	alter table SURVEY_THEMES add PAGE_BACKGROUND_SIZE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_THEMES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEY_THEMES_AUDIT' and COLUMN_NAME = 'PAGE_BACKGROUND_SIZE') begin -- then
		print 'alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_SIZE nvarchar(25) null';
		alter table SURVEY_THEMES_AUDIT add PAGE_BACKGROUND_SIZE nvarchar(25) null;
	end -- if;
end -- if;
GO

