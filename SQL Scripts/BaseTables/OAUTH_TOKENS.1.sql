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
-- 04/13/2012 Paul.  Facebook has a 111 character access token. 
-- 09/05/2015 Paul.  Google now uses OAuth 2.0. 
-- 01/19/2017 Paul.  The Microsoft OAuth token can be large, but less than 2000 bytes. 
-- 12/02/2020 Paul.  The Microsoft OAuth token is now about 2400, so increase to 4000 characters.
-- drop table dbo.OAUTH_TOKENS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OAUTH_TOKENS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.OAUTH_TOKENS';
	Create Table dbo.OAUTH_TOKENS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_OAUTH_TOKENS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, NAME                               nvarchar(50) null
		, TOKEN                              nvarchar(4000) null
		, SECRET                             nvarchar(50) null
		, TOKEN_EXPIRES_AT                   datetime null
		, REFRESH_TOKEN                      nvarchar(4000) null
		)

	create index IDX_OAUTH_TOKENS on dbo.OAUTH_TOKENS (ASSIGNED_USER_ID, NAME, DELETED)
  end
GO


