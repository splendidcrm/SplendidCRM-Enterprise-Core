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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CHAT_CHANNELS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CHAT_CHANNELS';
	Create Table dbo.CHAT_CHANNELS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CHAT_CHANNELS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, NAME                               nvarchar(150) null
		, PARENT_ID                          uniqueidentifier null
		, PARENT_TYPE                        nvarchar(25) null
		, TEAM_ID                            uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_CHAT_CHANNELS_TEAM_ID         on dbo.CHAT_CHANNELS (TEAM_ID, DELETED, ID)
	create index IDX_CHAT_CHANNELS_TEAM_SET_ID     on dbo.CHAT_CHANNELS (TEAM_SET_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_CHAT_CHANNELS_ASSIGNED_SET_ID on dbo.CHAT_CHANNELS (ASSIGNED_SET_ID, DELETED, ID)
	create index IDX_CHAT_CHANNELS_PARENT_ID       on dbo.CHAT_CHANNELS (PARENT_ID, PARENT_TYPE, DELETED, ID)
  end
GO

-- alter table CHAT_CHANNELS add PARENT_ID uniqueidentifier null;
-- alter table CHAT_CHANNELS add PARENT_TYPE nvarchar(25) null;

