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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- drop table SMS_MESSAGES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SMS_MESSAGES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SMS_MESSAGES';
	Create Table dbo.SMS_MESSAGES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SMS_MESSAGES primary key
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
		, MAILBOX_ID                         uniqueidentifier null
		, NAME                               nvarchar(1600) null
		, DATE_START                         datetime null
		, TIME_START                         datetime null
		, PARENT_TYPE                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, FROM_NUMBER                        nvarchar(20) null
		, TO_NUMBER                          nvarchar(20) null
		, TO_ID                              uniqueidentifier null
		, TYPE                               nvarchar(25) null
		, STATUS                             nvarchar(25) null
		, MESSAGE_SID                        nvarchar(100) null
		, FROM_LOCATION                      nvarchar(100) null
		, TO_LOCATION                        nvarchar(100) null
		, IS_PRIVATE                         bit null
		)

	-- 09/19/2013 Paul.  We are not going to index the NAME field as the index will exceed the maximum key length of 900 bytes. 
	create index IDX_SMS_MESSAGES_MESSAGE_SID          on dbo.SMS_MESSAGES (MESSAGE_SID, DELETED, ID)
	create index IDX_SMS_MESSAGES_PARENT_ID            on dbo.SMS_MESSAGES (PARENT_ID, ID, DELETED)
	create index IDX_SMS_MESSAGES_ASSIGNED_USER        on dbo.SMS_MESSAGES (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_SMS_MESSAGES_TEAM_ID              on dbo.SMS_MESSAGES (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_SMS_MESSAGES_TEAM_SET_ID          on dbo.SMS_MESSAGES (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_SMS_MESSAGES_ASSIGNED_SET_ID      on dbo.SMS_MESSAGES (ASSIGNED_SET_ID, ID, DELETED)
  end
GO

