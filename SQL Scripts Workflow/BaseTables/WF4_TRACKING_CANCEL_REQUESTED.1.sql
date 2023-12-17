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
-- Drop Table dbo.WF4_TRACKING_CANCEL_REQUESTED;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WF4_TRACKING_CANCEL_REQUESTED' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WF4_TRACKING_CANCEL_REQUESTED';
	Create Table dbo.WF4_TRACKING_CANCEL_REQUESTED
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WF4_TRACKING_CANCEL_REQUESTED primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		-- TrackingRecord fields 
		, INSTANCE_ID                        uniqueidentifier not null
		, EVENT_TIME                         datetime not null
		, RECORD_NUMBER                      bigint null
		, ANNOTATIONS                        nvarchar(max) null

		, ACTIVITY                           nvarchar(100) null
		, ACTIVITY_INSTANCE                  nvarchar(100) null
		, ACTIVITY_NAME                      nvarchar(256) null
		, ACTIVITY_TYPE_NAME                 nvarchar(256) null
		, CHILD_ACTIVITY                     nvarchar(100) null
		, CHILD_ACTIVITY_INSTANCE            nvarchar(100) null
		, CHILD_ACTIVITY_NAME                nvarchar(256) null
		, CHILD_ACTIVITY_TYPE_NAME           nvarchar(256) null
		)

	create index IDX_WF4_TRACKING_CANCEL_REQUESTED on dbo.WF4_TRACKING_CANCEL_REQUESTED (INSTANCE_ID)
  end
GO

