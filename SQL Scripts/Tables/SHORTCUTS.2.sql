
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
-- 01/06/2006 Paul.  Administration shortcuts are large.
-- 04/28/2006 Paul.  Added SHORTCUT_MODULE to help with ACL. 
-- 04/28/2006 Paul.  Added SHORTCUT_ACLTYPE to help with ACL. 
-- 07/24/2006 Paul.  Increase the DISPLAY_NAME to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SHORTCUTS' and COLUMN_NAME = 'RELATIVE_PATH' and CHARACTER_MAXIMUM_LENGTH < 255) begin -- then
	print 'alter table SHORTCUTS alter column RELATIVE_PATH nvarchar(255) not null';
	alter table SHORTCUTS alter column RELATIVE_PATH nvarchar(255) not null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SHORTCUTS' and COLUMN_NAME = 'SHORTCUT_MODULE') begin -- then
	print 'alter table SHORTCUTS add SHORTCUT_MODULE nvarchar(25) null';
	alter table SHORTCUTS add SHORTCUT_MODULE nvarchar(25) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SHORTCUTS' and COLUMN_NAME = 'SHORTCUT_ACLTYPE') begin -- then
	print 'alter table SHORTCUTS add SHORTCUT_ACLTYPE nvarchar(100) null';
	alter table SHORTCUTS add SHORTCUT_ACLTYPE nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SHORTCUTS' and COLUMN_NAME = 'DISPLAY_NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table SHORTCUTS alter column DISPLAY_NAME nvarchar(150) not null';
	alter table SHORTCUTS alter column DISPLAY_NAME nvarchar(150) not null;
end -- if;
GO

