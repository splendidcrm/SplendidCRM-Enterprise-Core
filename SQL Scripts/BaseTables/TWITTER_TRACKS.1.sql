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
-- https://dev.twitter.com/docs/api/1.1/post/statuses/filter
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- drop table TWITTER_TRACKS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TWITTER_TRACKS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TWITTER_TRACKS';
	Create Table dbo.TWITTER_TRACKS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TWITTER_TRACKS primary key
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
		, NAME                               nvarchar(60) null
		, LOCATION                           nvarchar(60) null
		, TWITTER_USER_ID                    bigint null
		, TWITTER_SCREEN_NAME                nvarchar(50) null
		, STATUS                             nvarchar(25) null
		, TYPE                               nvarchar(25) null
		, DESCRIPTION                        nvarchar(max) null
		)

	create index IDX_TWITTER_TRACKS_NAME            on dbo.TWITTER_TRACKS (NAME, DELETED, ID)
	create index IDX_TWITTER_TRACKS_ASSIGNED_ID     on dbo.TWITTER_TRACKS (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_TWITTER_TRACKS_TEAM_ID         on dbo.TWITTER_TRACKS (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_TWITTER_TRACKS_TEAM_SET_ID     on dbo.TWITTER_TRACKS (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_TWITTER_TRACKS_ASSIGNED_SET_ID on dbo.TWITTER_TRACKS (ASSIGNED_SET_ID, ID, DELETED)
  end
GO

