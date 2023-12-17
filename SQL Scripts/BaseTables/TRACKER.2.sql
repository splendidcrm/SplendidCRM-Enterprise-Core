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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 03/08/2012 Paul.  Add ACTION to the tracker table so that we can create quick user activity reports. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TRACKER' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TRACKER';
	Create Table dbo.TRACKER
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TRACKER primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, USER_ID                            uniqueidentifier not null
		, ACTION                             nvarchar(25) null default('detailview')
		, MODULE_NAME                        nvarchar(25) null
		, ITEM_ID                            uniqueidentifier not null
		, ITEM_SUMMARY                       nvarchar(255) null
		)

	-- 03/08/2012 Paul.  Add ACTION to the tracker table so that we can create quick user activity reports. 
	create index IDX_TRACKER_USER_ID     on dbo.TRACKER (USER_ID, ACTION, DELETED)
	create index IDX_TRACKER_ITEM_ID     on dbo.TRACKER (ITEM_ID, ACTION, DELETED)
	-- 08/26/2010 Paul.  Add IDX_TRACKER_USER_MODULE to speed spTRACKER_Update. 
	create index IDX_TRACKER_USER_MODULE on dbo.TRACKER (USER_ID, ACTION, DELETED, MODULE_NAME, ID)

	-- 11/03/2009 Paul.  This foreign key will give us trouble on the offline client. 
	-- alter table dbo.TRACKER add constraint FK_TRACKER_USER_ID foreign key ( USER_ID ) references dbo.USERS ( ID )
  end
GO


