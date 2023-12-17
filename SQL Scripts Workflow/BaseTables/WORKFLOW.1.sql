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
-- 07/26/2008 Paul.  We need the audit table in the workflow table to speed processing. 
-- Drop Table WORKFLOW;
-- 11/16/2008 Paul.  Add support for type-based workflows. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW';
	Create Table dbo.WORKFLOW
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(100) not null
		, BASE_MODULE                        nvarchar(100) not null
		, AUDIT_TABLE                        nvarchar(50) not null
		, STATUS                             bit null
		, TYPE                               nvarchar(25) not null
		, FIRE_ORDER                         nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, RECORD_TYPE                        nvarchar(25) null
		, LIST_ORDER_Y                       int null
		, CUSTOM_XOML                        bit null default(0)
		, DESCRIPTION                        nvarchar(max) null
		, FILTER_SQL                         nvarchar(max) null
		, FILTER_XML                         nvarchar(max) null
		, XOML                               nvarchar(max) null
		, JOB_INTERVAL                       nvarchar(100) null
		, LAST_RUN                           datetime null
		)

	-- drop index WORKFLOW.IDX_WORKFLOW;
	create index IDX_WORKFLOW on WORKFLOW (DELETED, STATUS, TYPE, BASE_MODULE)
  end
GO



