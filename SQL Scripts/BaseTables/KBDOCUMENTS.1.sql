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
-- drop table KBDOCUMENT_ATTACHMENTS;
-- drop table KBDOCUMENT_IMAGES;
-- drop table KBDOCUMENT_KBTAGS;
-- drop table KBDOCUMENTS;
-- 10/21/2009 Paul.  KBTAG_SET_LIST so that we can generate workflow events on tag changes. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 01/11/2010 Paul.  Stop using sysobjects table. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'KBDOCUMENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.KBDOCUMENTS';
	Create Table dbo.KBDOCUMENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_KBDOCUMENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(255) not null
		, KBDOC_APPROVER_ID                  uniqueidentifier null
		, IS_EXTERNAL_ARTICLE                bit null
		, ACTIVE_DATE                        datetime null
		, EXP_DATE                           datetime null
		, STATUS                             nvarchar(25) null
		, REVISION                           nvarchar(25) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, KBTAG_SET_LIST                     nvarchar(max) null
		)

	create index IDX_KBDOCUMENTS_TEAM_ID         on dbo.KBDOCUMENTS (TEAM_ID, DELETED, ID)
	create index IDX_KBDOCUMENTS_TEAM_SET_ID     on dbo.KBDOCUMENTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_KBDOCUMENTS_ASSIGNED_SET_ID on dbo.KBDOCUMENTS (ASSIGNED_SET_ID, DELETED, ID)
  end
GO

