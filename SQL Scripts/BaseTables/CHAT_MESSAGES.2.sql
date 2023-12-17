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
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- drop table CHAT_MESSAGES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CHAT_MESSAGES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CHAT_MESSAGES';
	Create Table dbo.CHAT_MESSAGES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CHAT_MESSAGES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CHAT_CHANNEL_ID                    uniqueidentifier not null
		, NAME                               nvarchar(400) null
		, PARENT_ID                          uniqueidentifier null
		, PARENT_TYPE                        nvarchar(25) null
		, NOTE_ATTACHMENT_ID                 uniqueidentifier null
		, DESCRIPTION                        nvarchar(max) null
		, IS_PRIVATE                         bit null
		)

	create index IDX_CHAT_MESSAGES_NAME      on dbo.CHAT_MESSAGES (CHAT_CHANNEL_ID, DELETED, NAME)
	create index IDX_CHAT_NOTE_ATTACHMENT_ID on dbo.CHAT_MESSAGES (NOTE_ATTACHMENT_ID, DELETED, ID)
	create index IDX_CHAT_MESSAGES_PARENT_ID on dbo.CHAT_MESSAGES (PARENT_ID, PARENT_TYPE, DELETED, ID)
  end
GO

