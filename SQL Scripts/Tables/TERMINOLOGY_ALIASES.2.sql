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
-- 07/24/2006 Paul.  Increase the MODULE_NAME to 25 to match the size in the MODULES table.
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TERMINOLOGY_ALIASES' and COLUMN_NAME = 'MODULE_NAME' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table TERMINOLOGY_ALIASES alter column MODULE_NAME nvarchar(25) null';
	alter table TERMINOLOGY_ALIASES alter column MODULE_NAME nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TERMINOLOGY_ALIASES' and COLUMN_NAME = 'ALIAS_MODULE_NAME' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table TERMINOLOGY_ALIASES alter column ALIAS_MODULE_NAME nvarchar(25) null';
	alter table TERMINOLOGY_ALIASES alter column ALIAS_MODULE_NAME nvarchar(25) null;
end -- if;
GO

