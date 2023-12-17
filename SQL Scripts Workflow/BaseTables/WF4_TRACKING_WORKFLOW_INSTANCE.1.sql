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
-- 06/21/2017 Paul.  Index DATE_ENTERED for Cleanup. 
-- Drop Table dbo.WF4_TRACKING_WORKFLOW_INSTANCE;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WF4_TRACKING_WORKFLOW_INSTANCE' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WF4_TRACKING_WORKFLOW_INSTANCE';
	Create Table dbo.WF4_TRACKING_WORKFLOW_INSTANCE
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WF4_TRACKING_WORKFLOW_INSTANCE primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		-- TrackingRecord fields 
		, INSTANCE_ID                        uniqueidentifier not null
		, EVENT_TIME                         datetime not null
		, RECORD_NUMBER                      bigint null
		, ANNOTATIONS                        nvarchar(max) null

		, ACTIVITY_DEFINITION                nvarchar(256) null
		, STATE                              nvarchar(25) null
		, IDENTITY_NAME                      nvarchar(256) null
		, IDENTITY_PACKAGE                   nvarchar(256) null
		, IDENTITY_VERSION                   nvarchar(25) null
		)

	create index IDX_WF4_TRACKING_WORKFLOW_INSTANCE on dbo.WF4_TRACKING_WORKFLOW_INSTANCE (INSTANCE_ID)
	create index IDX_WF4_TRACKING_WORKFLOW_DATE     on dbo.WF4_TRACKING_WORKFLOW_INSTANCE (DATE_ENTERED)
  end
GO

