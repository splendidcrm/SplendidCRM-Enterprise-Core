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
-- Drop Table PROCESSES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROCESSES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PROCESSES';
	Create Table dbo.PROCESSES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PROCESSES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PROCESS_NUMBER                     int null
		, BUSINESS_PROCESS_INSTANCE_ID       uniqueidentifier not null
		, ACTIVITY_INSTANCE                  nvarchar(100) not null
		, ACTIVITY_NAME                      nvarchar(200) null
		, BUSINESS_PROCESS_ID                uniqueidentifier null
		, PROCESS_USER_ID                    uniqueidentifier null
		, BOOKMARK_NAME                      nvarchar(100) null
		, PARENT_TYPE                        nvarchar(50) null
		, PARENT_ID                          uniqueidentifier null
		, USER_TASK_TYPE                     nvarchar(50) null
		, CHANGE_ASSIGNED_USER               bit null
		, CHANGE_ASSIGNED_TEAM_ID            uniqueidentifier null
		, CHANGE_PROCESS_USER                bit null
		, CHANGE_PROCESS_TEAM_ID             uniqueidentifier null
		, USER_ASSIGNMENT_METHOD             nvarchar(50) null
		, STATIC_ASSIGNED_USER_ID            uniqueidentifier null
		, DYNAMIC_PROCESS_TEAM_ID            uniqueidentifier null
		, DYNAMIC_PROCESS_ROLE_ID            uniqueidentifier null
		, READ_ONLY_FIELDS                   nvarchar(max) null
		, REQUIRED_FIELDS                    nvarchar(max) null
		, DURATION_UNITS                     nvarchar(50) null
		, DURATION_VALUE                     int null
		, STATUS                             nvarchar(50) null
		, APPROVAL_USER_ID                   uniqueidentifier null
		, APPROVAL_DATE                      datetime null
		, APPROVAL_RESPONSE                  nvarchar(100) null
		)

	-- drop index IDX_BPM_APPROVALS_PARENT_ID on PROCESSES
	create index IDX_BPM_APPROVALS_DATE        on PROCESSES (DATE_MODIFIED, PARENT_ID, PROCESS_USER_ID, DELETED)
	create index IDX_BPM_APPROVALS_PARENT_ID   on PROCESSES (PARENT_ID, DELETED, APPROVAL_USER_ID, STATUS)
	create index IDX_BPM_APPROVALS_INSTANCE_ID on PROCESSES (BUSINESS_PROCESS_INSTANCE_ID, ACTIVITY_INSTANCE)
	create index IDX_BPM_APPROVALS_MY_LIST     on PROCESSES (PROCESS_USER_ID, DELETED, STATUS, APPROVAL_USER_ID, USER_ASSIGNMENT_METHOD)
  end
GO

