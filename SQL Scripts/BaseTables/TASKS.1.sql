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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 06/07/2017 Paul.  Increase NAME size to 150 to support Asterisk. 
-- 06/07/2017 Paul.  Add REMINDER_TIME, EMAIL_REMINDER_TIME, SMS_REMINDER_TIME. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TASKS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TASKS';
	Create Table dbo.TASKS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TASKS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(150) null
		, STATUS                             nvarchar(25) null
		, DATE_DUE_FLAG                      bit null default(1)
		, DATE_DUE                           datetime null
		, TIME_DUE                           datetime null
		, DATE_START_FLAG                    bit null default(1)
		, DATE_START                         datetime null
		, TIME_START                         datetime null
		, PARENT_TYPE                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, CONTACT_ID                         uniqueidentifier null
		, PRIORITY                           nvarchar(25) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, REMINDER_TIME                      int null
		, EMAIL_REMINDER_TIME                int null
		, SMS_REMINDER_TIME                  int null
		, IS_PRIVATE                         bit null
		)

	create index IDX_TASKS_NAME             on dbo.TASKS (NAME, DELETED, ID)
	create index IDX_TASKS_CONTACT_ID       on dbo.TASKS (CONTACT_ID, DELETED, ID)
	create index IDX_TASKS_PARENT_ID        on dbo.TASKS (PARENT_ID, PARENT_TYPE, DELETED, ID)
	create index IDX_TASKS_ASSIGNED_USER_ID on dbo.TASKS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_TASKS_TEAM_ID          on dbo.TASKS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_TASKS_TEAM_SET_ID      on dbo.TASKS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_TASKS_ASSIGNED_SET_ID  on dbo.TASKS (ASSIGNED_SET_ID, DELETED, ID)
  end
GO


