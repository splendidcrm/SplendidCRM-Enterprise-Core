
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
-- 10/08/2006 Paul.  Recreate IMPORT_MAPS with NAME, SOURCE and MODULE as nvarchar fields. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'IMPORT_MAPS' and COLUMN_NAME = 'NAME' and DATA_TYPE = 'varbinary') begin -- then
	print 'Drop Table IMPORT_MAPS';
	Drop Table dbo.IMPORT_MAPS;
	
	print 'Create Table dbo.IMPORT_MAPS';
	Create Table dbo.IMPORT_MAPS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_IMPORT_MAPS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, NAME                               nvarchar(150) null
		, SOURCE                             nvarchar(25) null
		, MODULE                             nvarchar(25) not null
		, HAS_HEADER                         bit not null default(1)
		, IS_PUBLISHED                       bit not null default(0)
		, CONTENT                            nvarchar(max) null
		, RULES_XML                          nvarchar(max) null
		)

	create index IDX_IMPORT_MAPS_ASSIGNED_USER_ID_MODULE_NAME on dbo.IMPORT_MAPS (ASSIGNED_USER_ID, MODULE, NAME, DELETED)
end -- if;
GO

-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'IMPORT_MAPS' and COLUMN_NAME = 'CONTENT' and DATA_TYPE not in ('ntext', 'nvarchar')) begin -- then
	print 'alter table IMPORT_MAPS drop column CONTENT';
	alter table IMPORT_MAPS drop column CONTENT;
	print 'alter table IMPORT_MAPS add CONTENT nvarchar(max) null';
	alter table IMPORT_MAPS add CONTENT nvarchar(max) null;
end -- if;
GO

-- 09/17/2013 Paul.  Add Business Rules to import. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'IMPORT_MAPS' and COLUMN_NAME = 'RULES_XML') begin -- then
	print 'alter table IMPORT_MAPS add RULES_XML nvarchar(max) null';
	alter table IMPORT_MAPS add RULES_XML nvarchar(max) null;
end -- if;
GO

