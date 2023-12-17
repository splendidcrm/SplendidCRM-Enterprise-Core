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
-- drop table ORDERS_LINE_ITEMS_SYNC;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ORDERS_LINE_ITEMS_SYNC' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.ORDERS_LINE_ITEMS_SYNC';
	Create Table dbo.ORDERS_LINE_ITEMS_SYNC
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_ORDERS_LINE_ITEMS_SYNC primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier not null
		, LOCAL_ID                           uniqueidentifier not null
		, REMOTE_KEY                         varchar(800) collate SQL_Latin1_General_CP1_CS_AS not null
		, LOCAL_DATE_MODIFIED                datetime null
		, REMOTE_DATE_MODIFIED               datetime null
		, LOCAL_DATE_MODIFIED_UTC            datetime null
		, REMOTE_DATE_MODIFIED_UTC           datetime null
		, SERVICE_NAME                       nvarchar(25) null
		, RAW_CONTENT                        nvarchar(max) null
		)

	create index IDX_ORDERS_LINE_ITEMS_SYNC_REMOTE_KEY on dbo.ORDERS_LINE_ITEMS_SYNC (DELETED, SERVICE_NAME, REMOTE_KEY, LOCAL_ID)
  end
GO

