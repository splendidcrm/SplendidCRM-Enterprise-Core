
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
-- 05/24/2009 Paul.  Increase size of SugarCRM fields. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'FIELD_VALUE' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ALERTS alter column FIELD_VALUE nvarchar(100) null';
	alter table WORKFLOW_ALERTS alter column FIELD_VALUE nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'REL_EMAIL_VALUE' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ALERTS alter column REL_EMAIL_VALUE nvarchar(100) null';
	alter table WORKFLOW_ALERTS alter column REL_EMAIL_VALUE nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'REL_MODULE1' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ALERTS alter column REL_MODULE1 nvarchar(100) null';
	alter table WORKFLOW_ALERTS alter column REL_MODULE1 nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'REL_MODULE2' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ALERTS alter column REL_MODULE2 nvarchar(100) null';
	alter table WORKFLOW_ALERTS alter column REL_MODULE2 nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'REL_MODULE1_TYPE' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table WORKFLOW_ALERTS alter column REL_MODULE1_TYPE nvarchar(25) null';
	alter table WORKFLOW_ALERTS alter column REL_MODULE1_TYPE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'REL_MODULE2_TYPE' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table WORKFLOW_ALERTS alter column REL_MODULE2_TYPE nvarchar(25) null';
	alter table WORKFLOW_ALERTS alter column REL_MODULE2_TYPE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERTS' and COLUMN_NAME = 'WHERE_FILTER' and DATA_TYPE <> 'bit') begin -- then
	print 'alter table WORKFLOW_ALERTS alter column WHERE_FILTER bit null';
	exec ('alter table WORKFLOW_ALERTS add WHERE_FILTER_BIT bit null');
	exec ('update WORKFLOW_ALERTS set WHERE_FILTER_BIT = (case WHERE_FILTER when ''on'' then 1 when ''1'' then 1 else 0 end)');

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
	   and objects.name = 'WORKFLOW_ALERTS'
	   and columns.name = 'WHERE_FILTER';
	exec (@DropConstraint);

	exec ('alter table WORKFLOW_ALERTS drop column WHERE_FILTER');
	exec sp_rename 'WORKFLOW_ALERTS.WHERE_FILTER_BIT', 'WHERE_FILTER', 'COLUMN';
end -- if;
GO


