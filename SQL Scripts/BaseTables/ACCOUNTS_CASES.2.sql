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
-- 10/02/2006 Paul.  Fix name of foreign key from FK_ACCOUNTS_CASES_BUG_ID to FK_ACCOUNTS_CASES_CASE_ID. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 12/19/2017 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
/*
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ACCOUNTS_CASES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.ACCOUNTS_CASES';
	Create Table dbo.ACCOUNTS_CASES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_ACCOUNTS_CASES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ACCOUNT_ID                         uniqueidentifier not null
		, CASE_ID                            uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_ACCOUNTS_CASES_ACCOUNT_ID on dbo.ACCOUNTS_CASES (ACCOUNT_ID, DELETED, CASE_ID   )
	create index IDX_ACCOUNTS_CASES_CASE_ID    on dbo.ACCOUNTS_CASES (CASE_ID   , DELETED, ACCOUNT_ID)

	alter table dbo.ACCOUNTS_CASES add constraint FK_ACCOUNTS_CASES_ACCOUNT_ID foreign key ( ACCOUNT_ID ) references dbo.ACCOUNTS ( ID )
	alter table dbo.ACCOUNTS_CASES add constraint FK_ACCOUNTS_CASES_CASE_ID    foreign key ( CASE_ID    ) references dbo.CASES    ( ID )
  end
*/



