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
-- 12/25/2007 Paul.  EMBED_FLAG was added in SugarCRM 4.5.1
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'NOTES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.NOTES';
	Create Table dbo.NOTES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_NOTES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(255) null
		, FILENAME                           nvarchar(255) null
		, FILE_MIME_TYPE                     nvarchar(100) null
		, PARENT_TYPE                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, CONTACT_ID                         uniqueidentifier null
		, PORTAL_FLAG                        bit not null default(0)
		, EMBED_FLAG                         bit null default(0)
		, DESCRIPTION                        nvarchar(max) null
		, NOTE_ATTACHMENT_ID                 uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, IS_PRIVATE                         bit null
		)

	create index IDX_NOTES_NAME               on dbo.NOTES (NAME, DELETED, ID)
	create index IDX_NOTES_NAME_PARENT        on dbo.NOTES (PARENT_ID, PARENT_TYPE, DELETED, ID)
	create index IDX_NOTES_CONTACT_ID         on dbo.NOTES (CONTACT_ID, DELETED, ID)
	create index IDX_NOTES_NOTE_ATTACHMENT_ID on dbo.NOTES (NOTE_ATTACHMENT_ID, DELETED, ID)
	create index IDX_NOTES_TEAM_ID            on dbo.NOTES (TEAM_ID, DELETED, ID)
	create index IDX_NOTES_ASSIGNED_USER_ID   on dbo.NOTES (ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_NOTES_TEAM_SET_ID        on dbo.NOTES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_NOTES_ASSIGNED_SET_ID    on dbo.NOTES (ASSIGNED_SET_ID, DELETED, ID)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_NOTES_DELETED_PARENT     on dbo.NOTES (DELETED, PARENT_TYPE, PARENT_ID, NOTE_ATTACHMENT_ID)
  end
GO


