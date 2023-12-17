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
-- https://dev.twitter.com/docs/platform-objects/tweets
-- 05/24/2016 Paul.  Twitter is increasing the size of their tweets. They are going to 177, but we are going to 255. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 10/21/2017 Paul.  Twitter increased sized to 280, but we are going to go to 420 so that we don't need to keep increasing. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- drop table TWITTER_MESSAGES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TWITTER_MESSAGES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TWITTER_MESSAGES';
	Create Table dbo.TWITTER_MESSAGES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TWITTER_MESSAGES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, NAME                               nvarchar(420) null
		, DESCRIPTION                        nvarchar(max) null
		, DATE_START                         datetime null
		, TIME_START                         datetime null
		, PARENT_TYPE                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, TYPE                               nvarchar(25) null
		, STATUS                             nvarchar(25) null
		, TWITTER_ID                         bigint null
		, TWITTER_USER_ID                    bigint null
		, TWITTER_FULL_NAME                  nvarchar(50) null
		, TWITTER_SCREEN_NAME                nvarchar(50) null
		, ORIGINAL_ID                        bigint null
		, ORIGINAL_USER_ID                   bigint null
		, ORIGINAL_FULL_NAME                 nvarchar(50) null
		, ORIGINAL_SCREEN_NAME               nvarchar(50) null
		, IS_PRIVATE                         bit null
		)

	create index IDX_TWITTER_MSG_NAME            on dbo.TWITTER_MESSAGES (NAME, DELETED, ID)
	create index IDX_TWITTER_MSG_PARENT_ID       on dbo.TWITTER_MESSAGES (PARENT_ID, ID, DELETED)
	create index IDX_TWITTER_MSG_ASSIGNED_ID     on dbo.TWITTER_MESSAGES (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_TWITTER_MSG_TEAM_ID         on dbo.TWITTER_MESSAGES (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_TWITTER_MSG_TEAM_SET_ID     on dbo.TWITTER_MESSAGES (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_TWITTER_MSG_ASSIGNED_SET_ID on dbo.TWITTER_MESSAGES (ASSIGNED_SET_ID, ID, DELETED)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_TWITTER_MESSAGES_TWITTER_ID on dbo.TWITTER_MESSAGES (DELETED, TWITTER_ID)
  end
GO

