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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAILMAN_SENT' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EMAILMAN_SENT';
	Create Table dbo.EMAILMAN_SENT
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EMAILMAN_SENT primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, USER_ID                            uniqueidentifier null
		, TEMPLATE_ID                        uniqueidentifier null
		, FROM_EMAIL                         nvarchar(255) null
		, FROM_NAME                          nvarchar(255) null
		, MODULE_ID                          uniqueidentifier null
		, CAMPAIGN_ID                        uniqueidentifier null
		, MARKETING_ID                       uniqueidentifier null
		, LIST_ID                            uniqueidentifier null
		, MODULE                             nvarchar(100) null
		, SEND_DATE_TIME                     datetime null
		, INVALID_EMAIL                      bit null default(0)
		, IN_QUEUE                           bit null default(0)
		, IN_QUEUE_DATE                      datetime null
		, SEND_ATTEMPTS                      int null default(0)
		)

	create index IDX_EMAILMAN_SENT_LIST_ID_USER_ID on dbo.EMAILMAN_SENT (LIST_ID, USER_ID, DELETED)

	alter table dbo.EMAILMAN_SENT add constraint FK_EMAILMAN_SENT_USER_ID      foreign key ( USER_ID      ) references dbo.USERS           ( ID )
	alter table dbo.EMAILMAN_SENT add constraint FK_EMAILMAN_SENT_TEMPLATE_ID  foreign key ( TEMPLATE_ID  ) references dbo.EMAIL_TEMPLATES ( ID )
	alter table dbo.EMAILMAN_SENT add constraint FK_EMAILMAN_SENT_CAMPAIGN_ID  foreign key ( CAMPAIGN_ID  ) references dbo.CAMPAIGNS       ( ID )
	alter table dbo.EMAILMAN_SENT add constraint FK_EMAILMAN_SENT_MARKETING_ID foreign key ( MARKETING_ID ) references dbo.EMAIL_MARKETING ( ID )
  end
GO

