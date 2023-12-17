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
-- 07/26/2008 Paul.  We need the audit table in the BUSINESS_PROCESSES table to speed processing. 
-- Drop Table BUSINESS_PROCESSES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'BUSINESS_PROCESSES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.BUSINESS_PROCESSES';
	Create Table dbo.BUSINESS_PROCESSES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_BUSINESS_PROCESSES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, NAME                               nvarchar(200) not null
		, BASE_MODULE                        nvarchar(50) not null
		, AUDIT_TABLE                        nvarchar(50) not null
		, STATUS                             bit null
		, TYPE                               nvarchar(25) not null
		, RECORD_TYPE                        nvarchar(25) null
		, LIST_ORDER_Y                       int null
		, JOB_INTERVAL                       nvarchar(100) null
		, LAST_RUN                           datetime null
		, LAST_USER_ID                       uniqueidentifier null
		, FILTER_SQL                         nvarchar(max) null
		, DESCRIPTION                        nvarchar(max) null
		, BPMN                               nvarchar(max) null
		, SVG                                nvarchar(max) null
		, XAML                               nvarchar(max) null
		)

	-- drop index BUSINESS_PROCESSES.IDX_BUSINESS_PROCESSES;
	create index IDX_BUSINESS_PROCESSES on BUSINESS_PROCESSES (DELETED, STATUS, TYPE, BASE_MODULE)
  end
GO

