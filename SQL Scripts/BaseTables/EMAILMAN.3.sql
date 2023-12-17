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
-- 04/21/2006 Paul.  RELATED_ID was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  RELATED_TYPE was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  EMAILMAN_NUMBER was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  TEMPLATE_ID was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  FROM_EMAIL was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  FROM_NAME was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  MODULE_ID was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  MODULE was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  INVALID_EMAIL was dropped in SugarCRM 4.0.
-- 04/02/2006 Paul.  MySQL requires an index on an identity column. 
-- 01/13/2008 Paul.  Add INBOUND_EMAIL_ID so that the email manager can be used to send out AutoReplies. 
-- INBOUND_EMAIL_ID Should only be set by the AutoReply system. 
-- 07/25/2009 Paul.  EMAILMAN_NUMBER is now a string. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 11/01/2015 Paul.  Include COMPUTED_EMAIL1 in table to increase performance of dup removal. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAILMAN' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EMAILMAN';
	Create Table dbo.EMAILMAN
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EMAILMAN primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, EMAILMAN_NUMBER                    nvarchar( 30) null
		, USER_ID                            uniqueidentifier null
		, CAMPAIGN_ID                        uniqueidentifier null
		, MARKETING_ID                       uniqueidentifier null
		, LIST_ID                            uniqueidentifier null
		, SEND_DATE_TIME                     datetime null
		, IN_QUEUE                           bit null default(0)
		, IN_QUEUE_DATE                      datetime null
		, SEND_ATTEMPTS                      int null default(0)
		, RELATED_ID                         uniqueidentifier null
		, RELATED_TYPE                       nvarchar(100) null
		, INBOUND_EMAIL_ID                   uniqueidentifier null
		, COMPUTED_EMAIL1                    nvarchar(100) null
		)

	create index IDX_EMAILMAN_LIST_ID_USER_ID on dbo.EMAILMAN (LIST_ID, USER_ID, DELETED)
	create index IDX_EMAILMAN_CAMPAIGN_ID     on dbo.EMAILMAN (CAMPAIGN_ID)
	create index IDX_EMAILMAN_NUMBER          on dbo.EMAILMAN (EMAILMAN_NUMBER)
	create index IDX_EMAILMAN_COMPUTED_EMAIL1 on dbo.EMAILMAN (COMPUTED_EMAIL1)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_EMAILMAN_DELETED_CAMPAIGN on dbo.EMAILMAN (DELETED, CAMPAIGN_ID, RELATED_TYPE)
	create index IDX_EMAILMAN_DELETED_RELATED  on dbo.EMAILMAN (DELETED, RELATED_TYPE, CAMPAIGN_ID)

	alter table dbo.EMAILMAN add constraint FK_EMAILMAN_USER_ID      foreign key ( USER_ID      ) references dbo.USERS           ( ID )
	alter table dbo.EMAILMAN add constraint FK_EMAILMAN_CAMPAIGN_ID  foreign key ( CAMPAIGN_ID  ) references dbo.CAMPAIGNS       ( ID )
	alter table dbo.EMAILMAN add constraint FK_EMAILMAN_MARKETING_ID foreign key ( MARKETING_ID ) references dbo.EMAIL_MARKETING ( ID )
  end
GO

