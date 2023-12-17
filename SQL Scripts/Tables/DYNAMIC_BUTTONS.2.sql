
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
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DYNAMIC_BUTTONS' and COLUMN_NAME = 'EXCLUDE_MOBILE') begin -- then
	print 'alter table DYNAMIC_BUTTONS add EXCLUDE_MOBILE bit null default(0)';
	alter table DYNAMIC_BUTTONS add EXCLUDE_MOBILE bit null default(0);
end -- if;
GO

-- 03/14/2014 Paul.  Allow hidden buttons to be created. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DYNAMIC_BUTTONS' and COLUMN_NAME = 'HIDDEN') begin -- then
	print 'alter table DYNAMIC_BUTTONS add HIDDEN bit null default(0)';
	alter table DYNAMIC_BUTTONS add HIDDEN bit null default(0);
end -- if;
GO

-- 08/16/2017 Paul.  Increase the size of the ONCLICK_SCRIPT so that we can add a javascript info column. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DYNAMIC_BUTTONS' and COLUMN_NAME = 'ONCLICK_SCRIPT' and CHARACTER_MAXIMUM_LENGTH <> -1) begin -- then
	print 'alter table DYNAMIC_BUTTONS alter column ONCLICK_SCRIPT nvarchar(max) null';
	alter table DYNAMIC_BUTTONS alter column ONCLICK_SCRIPT nvarchar(max) null;
end -- if;
GO

-- 08/16/2017 Paul.  Add ability to apply a business rule to a button. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DYNAMIC_BUTTONS' and COLUMN_NAME = 'BUSINESS_RULE') begin -- then
	print 'alter table DYNAMIC_BUTTONS add BUSINESS_RULE nvarchar(max) null';
	alter table DYNAMIC_BUTTONS add BUSINESS_RULE nvarchar(max) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DYNAMIC_BUTTONS' and COLUMN_NAME = 'BUSINESS_SCRIPT') begin -- then
	print 'alter table DYNAMIC_BUTTONS add BUSINESS_SCRIPT nvarchar(max) null';
	alter table DYNAMIC_BUTTONS add BUSINESS_SCRIPT nvarchar(max) null;
end -- if;
GO

