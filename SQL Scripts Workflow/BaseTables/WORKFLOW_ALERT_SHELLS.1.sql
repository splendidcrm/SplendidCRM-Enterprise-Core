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
-- Drop Table dbo.WORKFLOW_ALERT_SHELLS;
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
/*
1. Select User Type (user_type)
	current_user    ' A user associated with the target module
	rel_user        ' A user associated with a related module
	rel_user_custom ' Recipient associated with a related module
	trig_user_custom' Recipient associated with the target module
	specific_user   ' A specified user
	specific_team   ' All users in a specified team
	specific_role   ' All users in a specified role
	login_user      ' Logged in user at time of execution

2. Select Source Field (user_display_type)
	user1' User who created the record
	user2' User who last modified the record
	user3' User who is assigned the record
	user4' User who was assigned the record

3. Select Address Type (wflow_relate_type_dom)
	to
	cc
	bcc

*/

-- 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW_ALERT_SHELLS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW_ALERT_SHELLS';
	Create Table dbo.WORKFLOW_ALERT_SHELLS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_ALERT_SHELLS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PARENT_ID                          uniqueidentifier not null
		, NAME                               nvarchar(100) not null
		, ALERT_TYPE                         nvarchar(25) not null
		, SOURCE_TYPE                        nvarchar(25) null
		, CUSTOM_TEMPLATE_ID                 uniqueidentifier null
		, CUSTOM_XOML                        bit null default(0)
		, ALERT_TEXT                         nvarchar(max) null
		, RDL                                nvarchar(max) null
		, XOML                               nvarchar(max) null
		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		)

	create index IDX_WORKFLOW_ALERT_SHELLS_PARENT_ID on dbo.WORKFLOW_ALERT_SHELLS (PARENT_ID, DELETED, ID)
  end
GO

