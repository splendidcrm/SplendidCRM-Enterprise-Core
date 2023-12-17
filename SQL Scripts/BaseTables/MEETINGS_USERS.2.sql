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
-- 12/24/2012 Paul.  Add REMINDER_DISMISSED flag. 
-- 12/25/2012 Paul.  EMAIL_REMINDER_SENT was moved to relationship table so that it can be applied per recipient. 
-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MEETINGS_USERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.MEETINGS_USERS';
	Create Table dbo.MEETINGS_USERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_MEETINGS_USERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, MEETING_ID                         uniqueidentifier not null
		, USER_ID                            uniqueidentifier not null
		, REQUIRED                           bit null default(1)
		, ACCEPT_STATUS                      nvarchar(25) null default('none')
		, REMINDER_DISMISSED                 bit null default(0)
		, EMAIL_REMINDER_SENT                bit null default(0)
		, SMS_REMINDER_SENT                  bit null default(0)
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_MEETINGS_USERS_MEETING_ID on dbo.MEETINGS_USERS (MEETING_ID, DELETED, USER_ID   , ACCEPT_STATUS, REMINDER_DISMISSED, EMAIL_REMINDER_SENT, SMS_REMINDER_SENT)
	create index IDX_MEETINGS_USERS_USER_ID    on dbo.MEETINGS_USERS (USER_ID   , DELETED, MEETING_ID, ACCEPT_STATUS, REMINDER_DISMISSED, EMAIL_REMINDER_SENT, SMS_REMINDER_SENT)
	-- 09/18/2016 Paul.  Azure recommended index for vwACTIVITIES_EmailReminders. 
	create index IDX_MEETINGS_USERS_REMINDER   on dbo.MEETINGS_USERS (DELETED, EMAIL_REMINDER_SENT, MEETING_ID)

	alter table dbo.MEETINGS_USERS add constraint FK_MEETINGS_USERS_MEETING_ID foreign key ( MEETING_ID ) references dbo.MEETINGS ( ID )
	alter table dbo.MEETINGS_USERS add constraint FK_MEETINGS_USERS_USER_ID    foreign key ( USER_ID    ) references dbo.USERS    ( ID )
  end
GO


