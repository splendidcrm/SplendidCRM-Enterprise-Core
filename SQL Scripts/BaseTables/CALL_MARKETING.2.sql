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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- drop table CALL_MARKETING_PROSPECT_LISTS;
-- drop table CALL_MARKETING;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALL_MARKETING' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CALL_MARKETING';
	Create Table dbo.CALL_MARKETING
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CALL_MARKETING primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CAMPAIGN_ID                        uniqueidentifier null
		, ASSIGNED_USER_ID                   uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, NAME                               nvarchar(255) null
		, STATUS                             nvarchar(25) null
		, DISTRIBUTION                       nvarchar(25) null
		, ALL_PROSPECT_LISTS                 bit null default(0)

		, SUBJECT                            nvarchar(50) null
		, DURATION_HOURS                     int null
		, DURATION_MINUTES                   int null
		, DATE_START                         datetime null
		, TIME_START                         datetime null
		, DATE_END                           datetime null
		, TIME_END                           datetime null
		, REMINDER_TIME                      int null default(-1)
		, DESCRIPTION                        nvarchar(max) null
		)

	create index IDX_CALL_MARKETING_NAME             on dbo.CALL_MARKETING (NAME   )
	create index IDX_CALL_MARKETING                  on dbo.CALL_MARKETING (DELETED)
	create index IDX_CALL_MARKETING_TEAM_SET_ID      on dbo.CALL_MARKETING (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_CALL_MARKETING_ASSIGNED_SET_ID  on dbo.CALL_MARKETING (ASSIGNED_SET_ID, DELETED, ID)

	alter table dbo.CALL_MARKETING add constraint FK_CALL_MARKETING_CAMPAIGN_ID foreign key ( CAMPAIGN_ID ) references dbo.CAMPAIGNS       ( ID )
  end
GO

