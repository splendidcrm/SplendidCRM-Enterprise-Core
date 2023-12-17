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
-- 03/06/2008 Paul.  All tables should have MODIFIED_USER_ID and DATE_MODIFIED.
-- Drop Table WORKFLOW_RUN;
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW_RUN' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW_RUN';
	Create Table dbo.WORKFLOW_RUN
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_RUN primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, WORKFLOW_VERSION                   rowversion not null
		, WORKFLOW_ID                        uniqueidentifier not null
		, AUDIT_ID                           uniqueidentifier not null
		, AUDIT_TABLE                        nvarchar(50) not null
		, STATUS                             nvarchar(25) null
		, START_DATE                         datetime null
		, END_DATE                           datetime null
		, WORKFLOW_INSTANCE_ID               uniqueidentifier null
		, DESCRIPTION                        nvarchar(max) null
		)

	create index IDX_WORKFLOW_RUN                      on WORKFLOW_RUN (STATUS, WORKFLOW_VERSION)
	-- drop index WORKFLOW_RUN.IDX_WORKFLOW_RUN_WORKFLOW_ID;
	create index IDX_WORKFLOW_RUN_WORKFLOW_ID          on WORKFLOW_RUN (WORKFLOW_ID, START_DATE, END_DATE, WORKFLOW_INSTANCE_ID)
	create index IDX_WORKFLOW_RUN_WORKFLOW_INSTANCE_ID on WORKFLOW_RUN (WORKFLOW_INSTANCE_ID)
	-- 11/16/2008 Paul.  Timed-workflows may lookup last event. 
	create index IDX_WORKFLOW_RUN_AUDIT_ID             on WORKFLOW_RUN (WORKFLOW_ID, AUDIT_ID, DATE_ENTERED)
  end
GO

