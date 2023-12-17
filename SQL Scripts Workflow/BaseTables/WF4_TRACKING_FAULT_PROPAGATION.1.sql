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
-- Drop Table dbo.WF4_TRACKING_FAULT_PROPAGATION;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WF4_TRACKING_FAULT_PROPAGATION' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WF4_TRACKING_FAULT_PROPAGATION';
	Create Table dbo.WF4_TRACKING_FAULT_PROPAGATION
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WF4_TRACKING_FAULT_PROPAGATION primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		-- TrackingRecord fields 
		, INSTANCE_ID                        uniqueidentifier not null
		, EVENT_TIME                         datetime not null
		, RECORD_NUMBER                      bigint null
		, ANNOTATIONS                        nvarchar(max) null

		, FAULT                              nvarchar(max) not null
		, STACK_TRACE                        nvarchar(max) not null
		, IS_FAULT_SOURCE                    bit null
		, FAULT_HANDLER                      nvarchar(100) null
		, FAULT_HANDLER_INSTANCE             nvarchar(100) null
		, FAULT_HANDLER_NAME                 nvarchar(256) null
		, FAULT_HANDLER_TYPE_NAME            nvarchar(256) null
		, FAULT_SOURCE                       nvarchar(100) null
		, FAULT_SOURCE_INSTANCE              nvarchar(100) null
		, FAULT_SOURCE_NAME                  nvarchar(256) null
		, FAULT_SOURCE_TYPE_NAME             nvarchar(256) null
		)

	create index IDX_WF4_TRACKING_FAULT_PROPAGATION on dbo.WF4_TRACKING_FAULT_PROPAGATION (INSTANCE_ID)
  end
GO

