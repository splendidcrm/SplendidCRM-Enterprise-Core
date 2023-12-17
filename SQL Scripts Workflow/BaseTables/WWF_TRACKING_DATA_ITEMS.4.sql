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
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
-- 06/13/2016 Paul.  Add schema. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WWF_TRACKING_DATA_ITEMS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WWF_TRACKING_DATA_ITEMS';
	Create Table dbo.WWF_TRACKING_DATA_ITEMS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WWF_TRACKING_DATA_ITEMS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		, WORKFLOW_INSTANCE_INTERNAL_ID      uniqueidentifier not null
		, EVENT_ID                           uniqueidentifier not null
		, EVENT_TYPE                         nvarchar(25) not null
		, FIELD_NAME                         nvarchar(256) not null
		, FIELD_TYPE_ID                      uniqueidentifier null
		, DATA_STR                           nvarchar(512) null
		, DATA_BLOB                          varbinary(max) null
		, DATA_NON_SERIALIZABLE              bit not null
		)

	create index IDX_WWF_TRACKING_DATA_ITEMS on dbo.WWF_TRACKING_DATA_ITEMS (WORKFLOW_INSTANCE_INTERNAL_ID, EVENT_ID, EVENT_TYPE)
  end
GO

