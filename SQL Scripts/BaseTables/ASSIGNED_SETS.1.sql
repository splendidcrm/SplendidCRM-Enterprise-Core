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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ASSIGNED_SETS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.ASSIGNED_SETS';
	Create Table dbo.ASSIGNED_SETS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_ASSIGNED_SETS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_SET_LIST                  varchar(851) not null
		, ASSIGNED_SET_NAME                  nvarchar(200) not null
		)

	create index IDX_ASSIGNED_SETS_ID       on dbo.ASSIGNED_SETS (ID, DELETED, ASSIGNED_SET_NAME)
	create index IDX_ASSIGNED_SETS_SET_LIST on dbo.ASSIGNED_SETS (ASSIGNED_SET_LIST, DELETED, ID)
  end
GO

