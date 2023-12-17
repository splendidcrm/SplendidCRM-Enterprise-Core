
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
-- 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CONTACTS_USERS' and COLUMN_NAME = 'SERVICE_NAME') begin -- then
	print 'alter table CONTACTS_USERS alter column SERVICE_NAME nvarchar(25) null';

	if exists (select * from sys.indexes where name = 'IDX_CONTACTS_USERS_CONTACT_ID') begin -- then
		drop index IDX_CONTACTS_USERS_CONTACT_ID on CONTACTS_USERS;
	end -- if;
	if exists (select * from sys.indexes where name = 'IDX_CONTACTS_USERS_USER_ID') begin -- then
		drop index IDX_CONTACTS_USERS_USER_ID on CONTACTS_USERS;
	end -- if;

	alter table CONTACTS_USERS add SERVICE_NAME nvarchar(25) null;

	create index IDX_CONTACTS_USERS_CONTACT_ID on dbo.CONTACTS_USERS (CONTACT_ID, DELETED, USER_ID   , SERVICE_NAME);
	create index IDX_CONTACTS_USERS_USER_ID    on dbo.CONTACTS_USERS (USER_ID   , DELETED, CONTACT_ID, SERVICE_NAME);

	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'vwEXCHANGE_USERS') begin -- then
		exec('insert into CONTACTS_USERS(CONTACT_ID, USER_ID, SERVICE_NAME)
		select CONTACT_ID, USER_ID, N''Exchange''
		  from CONTACTS_USERS
		 where DELETED = 0
		   and USER_ID in (select ASSIGNED_USER_ID from vwEXCHANGE_USERS where vwEXCHANGE_USERS.ASSIGNED_USER_ID = CONTACTS_USERS.USER_ID)');
	end -- if;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTACTS_USERS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CONTACTS_USERS_AUDIT' and COLUMN_NAME = 'SERVICE_NAME') begin -- then
		print 'alter table CONTACTS_USERS_AUDIT alter column SERVICE_NAME nvarchar(25) null';
		alter table CONTACTS_USERS_AUDIT add SERVICE_NAME nvarchar(25) null;
	end -- if;
end -- if;
GO

