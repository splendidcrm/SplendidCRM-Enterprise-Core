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
-- drop table TWITTER_TRACK_MESSAGES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TWITTER_TRACK_MESSAGES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TWITTER_TRACK_MESSAGES';
	Create Table dbo.TWITTER_TRACK_MESSAGES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TWITTER_TRACK_MESSAGES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TWITTER_TRACK_ID                   uniqueidentifier not null
		, TWITTER_MESSAGE_ID                 uniqueidentifier not null
		)

	create index IDX_TWITTER_TRK_MSG_MESSAGE_ID on dbo.TWITTER_TRACK_MESSAGES (TWITTER_MESSAGE_ID, DELETED, TWITTER_TRACK_ID)
	create index IDX_TWITTER_TRK_MSG_TRACK_ID   on dbo.TWITTER_TRACK_MESSAGES (TWITTER_TRACK_ID, DELETED, TWITTER_MESSAGE_ID)

	alter table dbo.TWITTER_TRACK_MESSAGES add constraint FK_TWITTER_TRK_MSG_MESSAGE_ID foreign key ( TWITTER_MESSAGE_ID ) references dbo.TWITTER_MESSAGES ( ID )
	alter table dbo.TWITTER_TRACK_MESSAGES add constraint FK_TWITTER_TRK_MSG_TRACK_ID   foreign key ( TWITTER_TRACK_ID   ) references dbo.TWITTER_TRACKS   ( ID )
  end
GO


