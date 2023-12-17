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
-- 09/06/2005 Paul.  Version 3.5.0 added the BODY_HTML field. 
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/19/2006 Paul.  Add READ_ONLY flag. 
-- 12/25/2007 Paul.  TEXT_ONLY was added in SugarCRM 4.5.1
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAIL_TEMPLATES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EMAIL_TEMPLATES';
	Create Table dbo.EMAIL_TEMPLATES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EMAIL_TEMPLATES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, PUBLISHED                          bit null
		, READ_ONLY                          bit null default(0)
		, TEXT_ONLY                          bit null default(0)
		, NAME                               nvarchar(255) null
		, DESCRIPTION                        nvarchar(max) null
		, SUBJECT                            nvarchar(255) null
		, BODY                               nvarchar(max) null
		, BODY_HTML                          nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_EMAIL_TEMPLATES_NAME             on dbo.EMAIL_TEMPLATES (NAME, DELETED, ID)
	create index IDX_EMAIL_TEMPLATES_TEAM_ID          on dbo.EMAIL_TEMPLATES (TEAM_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_EMAIL_TEMPLATES_TEAM_SET_ID      on dbo.EMAIL_TEMPLATES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_EMAIL_TEMPLATES_ASSIGNED_SET_ID  on dbo.EMAIL_TEMPLATES (ASSIGNED_SET_ID, DELETED, ID)
	create index IDX_EMAIL_TEMPLATES_ASSIGNED_USER_ID on dbo.EMAIL_TEMPLATES (ASSIGNED_USER_ID, DELETED, ID)
  end
GO


