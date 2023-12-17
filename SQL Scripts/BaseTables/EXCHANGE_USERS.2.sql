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
-- 04/04/2010 Paul.  EXCHANGE_WATERMARK for push and pull subscriptions. 
-- 04/04/2010 Paul.  The Watermark seems to be 40 characters. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EXCHANGE_USERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EXCHANGE_USERS';
	Create Table dbo.EXCHANGE_USERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EXCHANGE_USERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier not null
		, EXCHANGE_ALIAS                     nvarchar( 60) null
		, EXCHANGE_EMAIL                     nvarchar(100) null
		, EXCHANGE_WATERMARK                 varchar(100) null
		)

	create index IDX_EXCHANGE_USERS_ASSIGNED_USER_ID on dbo.EXCHANGE_USERS (ASSIGNED_USER_ID, DELETED, EXCHANGE_ALIAS, EXCHANGE_EMAIL)
  end
GO

