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
-- 07/18/2008 Paul.  Similar to WorkflowInstance.
-- 06/13/2016 Paul.  Add schema. 
-- drop table WWF_INSTANCES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WWF_INSTANCES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WWF_INSTANCES';
	Create Table dbo.WWF_INSTANCES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WWF_INSTANCES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		, WORKFLOW_INSTANCE_ID               uniqueidentifier not null
		, WORKFLOW_TYPE_ID                   uniqueidentifier not null
		, CONTEXT_ID                         uniqueidentifier not null
		, CALLER_INSTANCE_ID                 uniqueidentifier null
		, CALL_PATH                          nvarchar(400) null
		, CALLER_CONTEXT_ID                  uniqueidentifier null
		, CALLER_PARENT_CONTEXT_ID           uniqueidentifier null
		, INITIALIZED_DATE_TIME              datetime not null
		, END_DATE_TIME                      datetime null
		, DB_INITIALIZED_DATE_TIME           datetime not null default(getdate())
		, DB_END_DATE_TIME                   datetime null
		)

	create index IDX_WWF_INSTANCES_CONTEXT_ID on dbo.WWF_INSTANCES (WORKFLOW_INSTANCE_ID, CONTEXT_ID)
	create index IDX_WWF_INSTANCES_ID         on dbo.WWF_INSTANCES (WORKFLOW_INSTANCE_ID, ID)
  end
GO

