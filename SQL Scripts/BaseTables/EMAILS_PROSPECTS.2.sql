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
-- 04/21/2006 Paul.  Added in SugarCRM 4.2.
-- 12/25/2007 Paul.  CAMPAIGN_DATA was added in SugarCRM 4.5.1
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAILS_PROSPECTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EMAILS_PROSPECTS';
	Create Table dbo.EMAILS_PROSPECTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EMAILS_PROSPECTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, EMAIL_ID                           uniqueidentifier not null
		, PROSPECT_ID                        uniqueidentifier not null
		, CAMPAIGN_DATA                      nvarchar(max) null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_EMAILS_PROSPECTS_EMAIL_ID    on dbo.EMAILS_PROSPECTS (EMAIL_ID   , DELETED, PROSPECT_ID)
	create index IDX_EMAILS_PROSPECTS_PROSPECT_ID on dbo.EMAILS_PROSPECTS (PROSPECT_ID, DELETED, EMAIL_ID   )

	alter table dbo.EMAILS_PROSPECTS add constraint FK_EMAILS_PROSPECTS_EMAIL_ID    foreign key ( EMAIL_ID    ) references dbo.EMAILS    ( ID )
	alter table dbo.EMAILS_PROSPECTS add constraint FK_EMAILS_PROSPECTS_PROSPECT_ID foreign key ( PROSPECT_ID ) references dbo.PROSPECTS ( ID )
  end
GO


