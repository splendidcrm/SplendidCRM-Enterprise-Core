
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
-- 03/06/2008 Paul.  The USERS_LOGINS fields should match SYSTEM_LOG fields to simplify joins. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USERS_LOGINS' and COLUMN_NAME = 'SERVER_HOST') begin -- then
	print 'alter table USERS_LOGINS add SERVER_HOST nvarchar(100) null';
	alter table USERS_LOGINS add SERVER_HOST nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USERS_LOGINS' and COLUMN_NAME = 'RELATIVE_PATH') begin -- then
	print 'alter table USERS_LOGINS add RELATIVE_PATH nvarchar(255) null';
	alter table USERS_LOGINS add RELATIVE_PATH nvarchar(255) null;
end -- if;
GO

-- 08/07/2010 Paul.  Create an index to speed the cleanup of the logins table. 
if not exists (select * from sys.indexes where name = 'IDX_USERS_LOGINS_LOGIN_DATE') begin -- then
	print 'create index IDX_USERS_LOGINS_LOGIN_DATE';
	create index IDX_USERS_LOGINS_LOGIN_DATE on dbo.USERS_LOGINS (LOGIN_DATE)
end -- if;
GO

