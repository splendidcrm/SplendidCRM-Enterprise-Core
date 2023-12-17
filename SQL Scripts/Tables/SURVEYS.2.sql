
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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table SURVEYS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table SURVEYS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_SURVEYS_ASSIGNED_SET_ID on dbo.SURVEYS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table SURVEYS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table SURVEYS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

-- 07/28/2018 Paul.  Add Kiosk mode fields. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS' and COLUMN_NAME = 'LOOP_SURVEY') begin -- then
	print 'alter table SURVEYS add LOOP_SURVEY bit null';
	alter table SURVEYS add LOOP_SURVEY bit null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS_AUDIT' and COLUMN_NAME = 'LOOP_SURVEY') begin -- then
		print 'alter table SURVEYS_AUDIT add LOOP_SURVEY bit null';
		alter table SURVEYS_AUDIT add LOOP_SURVEY bit null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS' and COLUMN_NAME = 'EXIT_CODE') begin -- then
	print 'alter table SURVEYS add EXIT_CODE nvarchar(25) null';
	alter table SURVEYS add EXIT_CODE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS_AUDIT' and COLUMN_NAME = 'EXIT_CODE') begin -- then
		print 'alter table SURVEYS_AUDIT add EXIT_CODE nvarchar(25) null';
		alter table SURVEYS_AUDIT add EXIT_CODE nvarchar(25) null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS' and COLUMN_NAME = 'TIMEOUT') begin -- then
	print 'alter table SURVEYS add TIMEOUT int null';
	alter table SURVEYS add TIMEOUT int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS_AUDIT' and COLUMN_NAME = 'TIMEOUT') begin -- then
		print 'alter table SURVEYS_AUDIT add TIMEOUT int null';
		alter table SURVEYS_AUDIT add TIMEOUT int null;
	end -- if;
end -- if;
GO

-- 09/30/2018 Paul.  Add survey record creation to survey. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS' and COLUMN_NAME = 'SURVEY_TARGET_MODULE') begin -- then
	print 'alter table SURVEYS add SURVEY_TARGET_MODULE nvarchar(25) null';
	alter table SURVEYS add SURVEY_TARGET_MODULE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS_AUDIT' and COLUMN_NAME = 'SURVEY_TARGET_MODULE') begin -- then
		print 'alter table SURVEYS_AUDIT add SURVEY_TARGET_MODULE nvarchar(25) null';
		alter table SURVEYS_AUDIT add SURVEY_TARGET_MODULE nvarchar(25) null;
	end -- if;
end -- if;
GO

-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS' and COLUMN_NAME = 'SURVEY_TARGET_ASSIGNMENT') begin -- then
	print 'alter table SURVEYS add SURVEY_TARGET_ASSIGNMENT nvarchar(50) null';
	alter table SURVEYS add SURVEY_TARGET_ASSIGNMENT nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SURVEYS_AUDIT' and COLUMN_NAME = 'SURVEY_TARGET_ASSIGNMENT') begin -- then
		print 'alter table SURVEYS_AUDIT add SURVEY_TARGET_ASSIGNMENT nvarchar(50) null';
		alter table SURVEYS_AUDIT add SURVEY_TARGET_ASSIGNMENT nvarchar(50) null;
	end -- if;
end -- if;
GO

