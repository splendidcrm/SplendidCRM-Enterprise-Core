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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROSPECT_LISTS_PROSPECTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PROSPECT_LISTS_PROSPECTS';
	Create Table dbo.PROSPECT_LISTS_PROSPECTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PROSPECT_LISTS_PROSPECTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PROSPECT_LIST_ID                   uniqueidentifier not null
		, RELATED_ID                         uniqueidentifier null
		, RELATED_TYPE                       nvarchar(25) null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_PROSPECT_LISTS_PROSPECTS_PROSPECT_LIST_ID on dbo.PROSPECT_LISTS_PROSPECTS (PROSPECT_LIST_ID, RELATED_TYPE, DELETED, RELATED_ID      )
	create index IDX_PROSPECT_LISTS_PROSPECTS_RELATED_ID       on dbo.PROSPECT_LISTS_PROSPECTS (RELATED_ID      , RELATED_TYPE, DELETED, PROSPECT_LIST_ID)
	-- create index IDX_PROSPECT_LISTS_PROSPECTS_RELATED          on dbo.PROSPECT_LISTS_PROSPECTS (RELATED_ID, DELETED, , RELATED_TYPE)

	alter table dbo.PROSPECT_LISTS_PROSPECTS add constraint FK_PROSPECT_LISTS_PROSPECTS_PROSPECT_LIST_ID foreign key ( PROSPECT_LIST_ID ) references dbo.PROSPECT_LISTS( ID )
  end
GO


