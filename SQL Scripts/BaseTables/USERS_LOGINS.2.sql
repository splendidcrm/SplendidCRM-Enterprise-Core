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
-- drop table USERS_LOGINS;
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/07/2010 Paul.  Create an index to speed the cleanup of the logins table. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'USERS_LOGINS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.USERS_LOGINS';
	Create Table dbo.USERS_LOGINS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_USERS_LOGINS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, USER_ID                            uniqueidentifier null
		, USER_NAME                          nvarchar(60) null
		, LOGIN_TYPE                         nvarchar(25) null
		, LOGIN_DATE                         datetime null
		, LOGOUT_DATE                        datetime null
		, LOGIN_STATUS                       nvarchar(25) null
		, ASPNET_SESSIONID                   nvarchar(50) null
		, REMOTE_HOST                        nvarchar(100) null
		, SERVER_HOST                        nvarchar(100) null
		, TARGET                             nvarchar(255) null
		, RELATIVE_PATH                      nvarchar(255) null
		, USER_AGENT                         nvarchar(255) null
		)

	create index IDX_USERS_LOGINS_USER_ID    on dbo.USERS_LOGINS (USER_ID)
	create index IDX_USERS_LOGINS_LOGIN_DATE on dbo.USERS_LOGINS (LOGIN_DATE)
  end
GO

