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
-- Drop Table BUSINESS_PROCESSES_RUN;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'BUSINESS_PROCESSES_RUN' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.BUSINESS_PROCESSES_RUN';
	Create Table dbo.BUSINESS_PROCESSES_RUN
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_BUSINESS_PROCESSES_RUN primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, BUSINESS_PROCESS_VERSION           rowversion not null
		, BUSINESS_PROCESS_ID                uniqueidentifier not null
		, AUDIT_ID                           uniqueidentifier not null
		, AUDIT_TABLE                        nvarchar(50) not null
		, STATUS                             nvarchar(25) null
		, START_DATE                         datetime null
		, END_DATE                           datetime null
		, BUSINESS_PROCESS_INSTANCE_ID       uniqueidentifier null
		, DESCRIPTION                        nvarchar(max) null
		)

	create index IDX_BUSINESS_PROCESSES_RUN             on BUSINESS_PROCESSES_RUN (STATUS, BUSINESS_PROCESS_VERSION)
	-- drop index BUSINESS_PROCESSES_RUN.IDX_BUSINESS_PROCESSES_RUN_BUSINESS_PROCESSES_ID;
	create index IDX_BUSINESS_PROCESSES_RUN_ID          on BUSINESS_PROCESSES_RUN (BUSINESS_PROCESS_ID, START_DATE, END_DATE, BUSINESS_PROCESS_INSTANCE_ID)
	create index IDX_BUSINESS_PROCESSES_RUN_INSTANCE_ID on BUSINESS_PROCESSES_RUN (BUSINESS_PROCESS_INSTANCE_ID)
	create index IDX_BUSINESS_PROCESSES_RUN_AUDIT_ID    on BUSINESS_PROCESSES_RUN (BUSINESS_PROCESS_ID, AUDIT_ID, DATE_ENTERED)
  end
GO

