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
-- 07/16/2005 Paul.  Version 3.0.1 added the OUTLOOK_ID field. 
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 09/04/2012 Paul.  Version 6.5.4 added REPEAT fields. 
-- 12/25/2012 Paul.  EMAIL_REMINDER_SENT was moved to relationship table so that it can be applied per recipient. 
-- 03/04/2013 Paul.  REPEAT_DOW is a character string of Days of Week. 0 = sunday, 1 = monday, 2 = tuesday, etc. 
-- 03/07/2013 Paul.  Add ALL_DAY_EVENT. 
-- 09/06/2013 Paul.  Increase NAME size to 150 to support Asterisk. 
-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
-- 06/07/2017 Paul.  REMINDER_TIME, EMAIL_REMINDER_TIME, SMS_REMINDER_TIME should default to null, not -1.  
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALLS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CALLS';
	Create Table dbo.CALLS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CALLS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(150) null
		, DURATION_HOURS                     int null
		, DURATION_MINUTES                   int null
		, DATE_START                         datetime null
		, TIME_START                         datetime null
		, DATE_END                           datetime null
		, PARENT_TYPE                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, STATUS                             nvarchar(25) null
		, DIRECTION                          nvarchar(25) null
		, REMINDER_TIME                      int null
		, DESCRIPTION                        nvarchar(max) null
		, OUTLOOK_ID                         nvarchar(255) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, EMAIL_REMINDER_TIME                int null
		, SMS_REMINDER_TIME                  int null
		, REPEAT_TYPE                        nvarchar(25) null
		, REPEAT_INTERVAL                    int null default(1)
		, REPEAT_DOW                         nvarchar(7) null
		, REPEAT_UNTIL                       datetime null
		, REPEAT_COUNT                       int null
		, REPEAT_PARENT_ID                   uniqueidentifier null
		, RECURRING_SOURCE                   nvarchar(25) null
		, ALL_DAY_EVENT                      bit null
		, IS_PRIVATE                         bit null
		)

	create index IDX_CALLS_NAME             on dbo.CALLS (NAME, ID, DELETED)
	create index IDX_CALLS_ASSIGNED_USER_ID on dbo.CALLS (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_CALLS_TEAM_ID          on dbo.CALLS (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_CALLS_TEAM_SET_ID      on dbo.CALLS (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_CALLS_ASSIGNED_SET_ID  on dbo.CALLS (ASSIGNED_SET_ID, ID, DELETED)
	-- 03/22/2013 Paul.  Index for updating recurring events. 
	create index IDX_CALLS_REPEAT_PARENT_ID on dbo.CALLS (REPEAT_PARENT_ID, DELETED, DATE_START, DATE_MODIFIED_UTC, ID)
  end
GO


