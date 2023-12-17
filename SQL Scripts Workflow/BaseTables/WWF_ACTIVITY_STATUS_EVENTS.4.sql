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
-- 06/13/2016 Paul.  Add schema. 
-- 06/21/2017 Paul.  Index DATE_ENTERED for Cleanup. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WWF_ACTIVITY_STATUS_EVENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WWF_ACTIVITY_STATUS_EVENTS';
	Create Table dbo.WWF_ACTIVITY_STATUS_EVENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WWF_ACTIVITY_STATUS_EVENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		, WORKFLOW_INSTANCE_INTERNAL_ID      uniqueidentifier not null
		, ACTIVITY_INSTANCE_ID               uniqueidentifier not null
		, EVENT_ORDER                        int not null
		, EXECUTION_STATUS                   nvarchar(25) not null
		, EVENT_DATE_TIME                    datetime not null
		, DB_EVENT_DATE_TIME                 datetime not null default(getdate())
		)

	create index IDX_WWF_ACTIVITY_STATUS_EVENTS on dbo.WWF_ACTIVITY_STATUS_EVENTS (WORKFLOW_INSTANCE_INTERNAL_ID)
	create index IDX_WWF_ACTIVITY_STATUS_DATE   on dbo.WWF_ACTIVITY_STATUS_EVENTS (DATE_ENTERED)
  end
GO

