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
-- 06/13/2016 Paul.  Similar to InstancesTable.
-- drop table WF4_INSTANCES_RUNNABLE;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WF4_INSTANCES_RUNNABLE' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WF4_INSTANCES_RUNNABLE';
	Create Table dbo.WF4_INSTANCES_RUNNABLE
		( ID                                 uniqueidentifier not null constraint PK_WF4_INSTANCES_RUNNABLE primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())     -- CreationTime
		, DATE_MODIFIED_UTC                  datetime not null default(getutcdate())  -- LastUpdated

		, SURROGATE_INSTANCE_ID              uniqueidentifier null      -- SurrogateInstanceId 
		, SURROGATE_LOCK_OWNER_ID            uniqueidentifier null      -- SurrogateLockOwnerId
		, WORKFLOW_HOST_TYPE                 uniqueidentifier null      -- WorkflowHostType    
		, SURROGATE_IDENTITY_ID              uniqueidentifier null      -- SurrogateIdentityId 
		, DEFINITION_IDENTITY_ID             uniqueidentifier null
		, RUNNABLE_TIMER                     datetime null              -- RunnableTime        
		, IS_SUSPENDED                       bit null                   -- IsSuspended         
		, IS_READY_TO_RUN                    bit null                   -- IsReadyToRun        
		, BLOCKING_BOOKMARKS                 nvarchar(max) null         -- BlockingBookmarks, will be updated with bookmark values. 
		)

	create index IDX_WF4_INSTANCES_RUNNABLE_RUNNABLE on dbo.WF4_INSTANCES_RUNNABLE (IS_READY_TO_RUN, IS_SUSPENDED, RUNNABLE_TIMER)
  end
GO

