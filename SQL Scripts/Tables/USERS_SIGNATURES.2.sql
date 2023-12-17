
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
-- 09/10/2012 Paul.  Add PRIMARY_SIGNATURE. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USERS_SIGNATURES' and COLUMN_NAME = 'PRIMARY_SIGNATURE') begin -- then
	print 'alter table USERS_SIGNATURES add PRIMARY_SIGNATURE bit null';
	alter table USERS_SIGNATURES add PRIMARY_SIGNATURE bit null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'USERS_SIGNATURES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USERS_SIGNATURES_AUDIT' and COLUMN_NAME = 'PRIMARY_SIGNATURE') begin -- then
		print 'alter table USERS_SIGNATURES_AUDIT add PRIMARY_SIGNATURE bit null';
		alter table USERS_SIGNATURES_AUDIT add PRIMARY_SIGNATURE bit null;
	end -- if;
end -- if;
GO

