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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALL_MARKETING_PROSPECT_LISTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CALL_MARKETING_PROSPECT_LISTS';
	Create Table dbo.CALL_MARKETING_PROSPECT_LISTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CALL_MARKETING_PROSPECT_LISTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PROSPECT_LIST_ID                   uniqueidentifier null
		, CALL_MARKETING_ID                  uniqueidentifier null
		)

	create index IDX_CALL_MARKETING_PROSPECT_LISTS_CALL_MARKETING_ID on dbo.CALL_MARKETING_PROSPECT_LISTS (CALL_MARKETING_ID, DELETED, PROSPECT_LIST_ID )
	create index IDX_CALL_MARKETING_PROSPECT_LISTS_PROSPECT_LIST_ID  on dbo.CALL_MARKETING_PROSPECT_LISTS (PROSPECT_LIST_ID , DELETED, CALL_MARKETING_ID)

	alter table dbo.CALL_MARKETING_PROSPECT_LISTS add constraint FK_CALL_MARKETING_PROSPECT_LISTS_PROSPECT_LIST_ID  foreign key ( PROSPECT_LIST_ID  ) references dbo.PROSPECT_LISTS ( ID )
	alter table dbo.CALL_MARKETING_PROSPECT_LISTS add constraint FK_CALL_MARKETING_PROSPECT_LISTS_CALL_MARKETING_ID foreign key ( CALL_MARKETING_ID ) references dbo.CALL_MARKETING ( ID )
  end
GO

