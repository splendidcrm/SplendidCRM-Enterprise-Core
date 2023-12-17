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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTACTS_USERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CONTACTS_USERS';
	Create Table dbo.CONTACTS_USERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CONTACTS_USERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CONTACT_ID                         uniqueidentifier not null
		, USER_ID                            uniqueidentifier not null
		, SERVICE_NAME                       nvarchar(25) null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	-- 09/18/2015 Paul.  Add service name. 
	create index IDX_CONTACTS_USERS_CONTACT_ID on dbo.CONTACTS_USERS (CONTACT_ID, DELETED, USER_ID   , SERVICE_NAME)
	create index IDX_CONTACTS_USERS_USER_ID    on dbo.CONTACTS_USERS (USER_ID   , DELETED, CONTACT_ID, SERVICE_NAME)

	alter table dbo.CONTACTS_USERS add constraint FK_CONTACTS_USERS_CONTACT_ID foreign key ( CONTACT_ID ) references dbo.CONTACTS ( ID )
	alter table dbo.CONTACTS_USERS add constraint FK_CONTACTS_USERS_USER_ID    foreign key ( USER_ID    ) references dbo.USERS    ( ID )
  end
GO

