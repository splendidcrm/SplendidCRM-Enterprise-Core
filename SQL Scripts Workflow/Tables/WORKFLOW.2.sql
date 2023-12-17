
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
-- 11/16/2008 Paul.  Add support for type-based workflows. 
-- 05/02/2009 Paul.  Add fields to migrate from SugarCRM 4.5.1.
-- 05/24/2009 Paul.  Increase size of SugarCRM fields. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW alter column NAME nvarchar(100) not null';
	exec ('drop index WORKFLOW.IDX_WORKFLOW');
	exec ('alter table WORKFLOW alter column NAME nvarchar(100) not null');
	exec ('create index IDX_WORKFLOW on WORKFLOW (DELETED, STATUS, TYPE, BASE_MODULE)');
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'BASE_MODULE' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW alter column BASE_MODULE nvarchar(100) not null';
	exec ('drop index WORKFLOW.IDX_WORKFLOW');
	exec ('alter table WORKFLOW alter column BASE_MODULE nvarchar(100) not null');
	exec ('create index IDX_WORKFLOW on WORKFLOW (DELETED, STATUS, TYPE, BASE_MODULE)');
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'AUDIT_TABLE') begin -- then
	print 'alter table WORKFLOW add AUDIT_TABLE nvarchar(50) null';
	alter table WORKFLOW add AUDIT_TABLE nvarchar(50) null;
	exec('update WORKFLOW set AUDIT_TABLE = upper(BASE_MODULE) + ''_AUDIT''');
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'CUSTOM_XOML') begin -- then
	print 'alter table WORKFLOW add CUSTOM_XOML bit null default(0)';
	alter table WORKFLOW add CUSTOM_XOML bit null default(0);
	exec('update WORKFLOW set CUSTOM_XOML = 0');
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'FILTER_SQL') begin -- then
	print 'alter table WORKFLOW add FILTER_SQL nvarchar(max) null';
	alter table WORKFLOW add FILTER_SQL nvarchar(max) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'FILTER_XML') begin -- then
	print 'alter table WORKFLOW add FILTER_XML nvarchar(max) null';
	alter table WORKFLOW add FILTER_XML nvarchar(max) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'XOML') begin -- then
	print 'alter table WORKFLOW add XOML nvarchar(max) null';
	alter table WORKFLOW add XOML nvarchar(max) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'JOB_INTERVAL') begin -- then
	print 'alter table WORKFLOW add JOB_INTERVAL nvarchar(100) null';
	alter table WORKFLOW add JOB_INTERVAL nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'LAST_RUN') begin -- then
	print 'alter table WORKFLOW add LAST_RUN datetime null';
	alter table WORKFLOW add LAST_RUN datetime null;
end -- if;
GO

-- 05/24/2009 Paul.  We need to convert the STATUS field from varchar to bit. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW' and COLUMN_NAME = 'STATUS' and DATA_TYPE <> 'bit') begin -- then
	print 'alter table WORKFLOW alter column STATUS bit null';
	exec ('alter table WORKFLOW add STATUS_BIT bit null');
	exec ('update WORKFLOW set STATUS_BIT = (case STATUS when ''on'' then 1 when ''1'' then 1 else 0 end)');
	exec ('drop index WORKFLOW.IDX_WORKFLOW');

	-- 09/30/2009 Paul.  Deprecated feature 'More than two-part column name' is not supported in this version of SQL Server.
	declare @DropConstraint varchar(1000);
	select @DropConstraint = 'alter table ' + objects.name + ' drop constraint ' + default_constraints.name + ';'
	  from      sys.default_constraints  default_constraints
	 inner join sys.objects              objects
	         on objects.object_id      = default_constraints.parent_object_id
	 inner join sys.columns              columns
	         on columns.object_id      = objects.object_id
	        and columns.column_id      = default_constraints.parent_column_id
	 where objects.type = 'U'
	   and default_constraints.type = 'D'
	   and objects.name = 'WORKFLOW'
	   and columns.name = 'STATUS';
	exec (@DropConstraint);

	exec ('alter table WORKFLOW drop column STATUS');
	exec sp_rename 'WORKFLOW.STATUS_BIT', 'STATUS', 'COLUMN';
	exec ('create index IDX_WORKFLOW on WORKFLOW (DELETED, STATUS, TYPE, BASE_MODULE)');
end -- if;
GO


