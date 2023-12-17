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
-- 09/06/2005 Paul.  Version 3.5.0 added the DESCRIPTION_HTML field. 
-- 04/16/2006 Paul.  The NAME is not required.  An email can be sent without an email. 
-- 04/21/2006 Paul.  MESSAGE_ID was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  REPLY_TO_NAME was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  REPLY_TO_ADDR was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  INTENT was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  MAILBOX_ID was added in SugarCRM 4.0.
-- 05/30/2006 Paul.  MESSAGE_ID is a nvarchar(100) in SugarCRM 4.2
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 01/13/2008 Paul.  Add RAW_SOURCE was added in SugarCRM 4.5.0.
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 11/01/2010 Paul.  Increase length of MESSAGE_ID to varchar(851) to allow for IMAP value + login + server. 
-- 11/04/2010 Paul.  It looks like the MESSAGE_ID could be case-significant.  Lets set the collation just to be safe. 
-- 02/09/2017 Paul.  Add index for use by vwEMAILS_ReadyToSend. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAILS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EMAILS';
	Create Table dbo.EMAILS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EMAILS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(255) null
		, DATE_START                         datetime null
		, TIME_START                         datetime null
		, PARENT_TYPE                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, DESCRIPTION                        nvarchar(max) null
		, DESCRIPTION_HTML                   nvarchar(max) null
		, FROM_ADDR                          nvarchar(100) null
		, FROM_NAME                          nvarchar(100) null
		, TO_ADDRS                           nvarchar(max) null
		, CC_ADDRS                           nvarchar(max) null
		, BCC_ADDRS                          nvarchar(max) null
		, TO_ADDRS_IDS                       nvarchar(max) null
		, TO_ADDRS_NAMES                     nvarchar(max) null
		, TO_ADDRS_EMAILS                    nvarchar(max) null
		, CC_ADDRS_IDS                       nvarchar(max) null
		, CC_ADDRS_NAMES                     nvarchar(max) null
		, CC_ADDRS_EMAILS                    nvarchar(max) null
		, BCC_ADDRS_IDS                      nvarchar(max) null
		, BCC_ADDRS_NAMES                    nvarchar(max) null
		, BCC_ADDRS_EMAILS                   nvarchar(max) null
		, TYPE                               nvarchar(25) null
		, STATUS                             nvarchar(25) null
		, MESSAGE_ID                         varchar(851) collate SQL_Latin1_General_CP1_CS_AS null
		, REPLY_TO_NAME                      nvarchar(100) null
		, REPLY_TO_ADDR                      nvarchar(100) null
		, INTENT                             nvarchar(25) null default('pick')
		, MAILBOX_ID                         uniqueidentifier null
		, RAW_SOURCE                         nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, IS_PRIVATE                         bit null
		)

	create index IDX_EMAILS_NAME                 on dbo.EMAILS (NAME, ID, DELETED)
	-- 11/01/2010 Paul.  Change order of fields in index. 
	create index IDX_EMAILS_MESSAGE_ID           on dbo.EMAILS (MESSAGE_ID, DELETED, ID)
	create index IDX_EMAILS_PARENT_ID            on dbo.EMAILS (PARENT_ID, ID, DELETED)
	create index IDX_EMAILS_ASSIGNED_TYPE_STATUS on dbo.EMAILS (ASSIGNED_USER_ID, TYPE, STATUS, ID, DELETED)
	create index IDX_EMAILS_ASSIGNED_USER_ID     on dbo.EMAILS (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_EMAILS_TEAM_ID              on dbo.EMAILS (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_EMAILS_TEAM_SET_ID          on dbo.EMAILS (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_EMAILS_ASSIGNED_SET_ID      on dbo.EMAILS (ASSIGNED_SET_ID, ID, DELETED)
	-- 02/09/2017 Paul.  Add index for use by vwEMAILS_ReadyToSend and vwEMAILS_ScheduledSend. 
	create index IDX_EMAILS_READYTOSEND          on dbo.EMAILS (DELETED, TYPE, STATUS, DATE_MODIFIED)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_EMAILS_DELETED_PARENT       on dbo.EMAILS (DELETED, PARENT_TYPE, PARENT_ID)
	-- 07/09/2018 Paul.  New index for archival based on date. 
	create index IDX_EMAILS_DATE_START           on dbo.EMAILS (DELETED, DATE_START, TIME_START, PARENT_ID, ID)

  end
GO


