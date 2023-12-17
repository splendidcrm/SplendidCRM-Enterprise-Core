
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
-- 07/24/2006 Paul.  Increase the DATA_LABEL to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
-- 06/12/2009 Paul.  Add TOOL_TIP for help hover.
-- 06/16/2010 Paul.  Increase the size of the URL_FIELD and URL_FORMAT so that we can create an IFrame to a Google map. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'DEFAULT_VIEW') begin -- then
	print 'alter table DETAILVIEWS_FIELDS add DEFAULT_VIEW bit null default(0)';
	alter table DETAILVIEWS_FIELDS add DEFAULT_VIEW bit null default(0);
end -- if;
GO


if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'DATA_LABEL' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table DETAILVIEWS_FIELDS alter column DATA_LABEL nvarchar(150) null';
	alter table DETAILVIEWS_FIELDS alter column DATA_LABEL nvarchar(150) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'TOOL_TIP') begin -- then
	print 'alter table DETAILVIEWS_FIELDS add TOOL_TIP nvarchar(150) null';
	alter table DETAILVIEWS_FIELDS add TOOL_TIP nvarchar(150) null;
end -- if;
GO

-- 02/16/2010 Paul.  Add MODULE_TYPE so that we can lookup custom field IDs. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'MODULE_TYPE') begin -- then
	print 'alter table DETAILVIEWS_FIELDS add MODULE_TYPE nvarchar(25) null';
	alter table DETAILVIEWS_FIELDS add MODULE_TYPE nvarchar(25) null;
end -- if;
GO

-- 06/16/2010 Paul.  Increase the size of the URL_FIELD and URL_FORMAT so that we can create an IFrame to a Google map. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'URL_FIELD' and CHARACTER_MAXIMUM_LENGTH <> -1) begin -- then
	print 'alter table DETAILVIEWS_FIELDS alter column URL_FIELD nvarchar(max) null';
	alter table DETAILVIEWS_FIELDS alter column URL_FIELD nvarchar(max) null;
end -- if;
GO

-- 08/02/2010 Paul.  Increase the size of the URL_FIELD and URL_FORMAT so that we can add a javascript info column. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'URL_FORMAT' and CHARACTER_MAXIMUM_LENGTH <> -1) begin -- then
	print 'alter table DETAILVIEWS_FIELDS alter column URL_FORMAT nvarchar(max) null';
	alter table DETAILVIEWS_FIELDS alter column URL_FORMAT nvarchar(max) null;
end -- if;
GO

-- 10/09/2010 Paul.  Add PARENT_FIELD so that we can establish dependent listboxes. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'PARENT_FIELD') begin -- then
	print 'alter table DETAILVIEWS_FIELDS add PARENT_FIELD nvarchar(30) null';
	alter table DETAILVIEWS_FIELDS add PARENT_FIELD nvarchar(30) null
end -- if;
GO

-- 10/30/2013 Paul.  Increase size of URL_TARGET. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'URL_TARGET' and CHARACTER_MAXIMUM_LENGTH < 60) begin -- then
	print 'alter table DETAILVIEWS_FIELDS alter column URL_TARGET nvarchar(60) null';
	alter table DETAILVIEWS_FIELDS alter column URL_TARGET nvarchar(60) null;
end -- if;
GO

-- 02/25/2015 Paul.  Increase size of DATA_FIELD and DATA_FORMAT for OfficeAddin. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'DATA_FIELD' and CHARACTER_MAXIMUM_LENGTH < 1000) begin -- then
	print 'alter table DETAILVIEWS_FIELDS alter column DATA_FIELD nvarchar(1000) null';
	alter table DETAILVIEWS_FIELDS alter column DATA_FIELD nvarchar(1000) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DETAILVIEWS_FIELDS' and COLUMN_NAME = 'DATA_FORMAT' and CHARACTER_MAXIMUM_LENGTH <> -1) begin -- then
	print 'alter table DETAILVIEWS_FIELDS alter column DATA_FORMAT nvarchar(max) null';
	alter table DETAILVIEWS_FIELDS alter column DATA_FORMAT nvarchar(max) null;
end -- if;
GO
