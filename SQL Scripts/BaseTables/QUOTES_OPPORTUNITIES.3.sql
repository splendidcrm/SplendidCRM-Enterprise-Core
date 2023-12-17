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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'QUOTES_OPPORTUNITIES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.QUOTES_OPPORTUNITIES';
	Create Table dbo.QUOTES_OPPORTUNITIES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_QUOTES_OPPORTUNITIES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, QUOTE_ID                           uniqueidentifier not null
		, OPPORTUNITY_ID                     uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_QUOTES_OPPORTUNITIES_QUOTE_ID       on dbo.QUOTES_OPPORTUNITIES (QUOTE_ID      , DELETED, OPPORTUNITY_ID)
	create index IDX_QUOTES_OPPORTUNITIES_OPPORTUNITY_ID on dbo.QUOTES_OPPORTUNITIES (OPPORTUNITY_ID, DELETED, QUOTE_ID      )

	alter table dbo.QUOTES_OPPORTUNITIES add constraint FK_QUOTES_OPPORTUNITIES_QUOTE_ID       foreign key ( QUOTE_ID       ) references dbo.QUOTES        ( ID )
	alter table dbo.QUOTES_OPPORTUNITIES add constraint FK_QUOTES_OPPORTUNITIES_OPPORTUNITY_ID foreign key ( OPPORTUNITY_ID ) references dbo.OPPORTUNITIES ( ID )
  end
GO


