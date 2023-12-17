
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'FIELD' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column FIELD nvarchar(100) null';
	alter table WORKFLOW_ACTIONS alter column FIELD nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'SET_TYPE' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column SET_TYPE nvarchar(25) null';
	alter table WORKFLOW_ACTIONS alter column SET_TYPE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'ADV_TYPE' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column ADV_TYPE nvarchar(25) null';
	alter table WORKFLOW_ACTIONS alter column ADV_TYPE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'EXT1' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column EXT1 nvarchar(100) null';
	alter table WORKFLOW_ACTIONS alter column EXT1 nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'EXT2' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column EXT2 nvarchar(100) null';
	alter table WORKFLOW_ACTIONS alter column EXT2 nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'EXT3' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column EXT3 nvarchar(100) null';
	alter table WORKFLOW_ACTIONS alter column EXT3 nvarchar(100) null;
end -- if;
GO

-- 09/15/2009 Paul.  CHARACTER_MAXIMUM_LENGTH will be -1 if already nvarchar(max). 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ACTIONS' and COLUMN_NAME = 'VALUE' and (CHARACTER_MAXIMUM_LENGTH > 0 and CHARACTER_MAXIMUM_LENGTH < 10000)) begin -- then
	print 'alter table WORKFLOW_ACTIONS alter column VALUE nvarchar(max) null';
	alter table WORKFLOW_ACTIONS alter column VALUE nvarchar(max) null;
end -- if;
GO

