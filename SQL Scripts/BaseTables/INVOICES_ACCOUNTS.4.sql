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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'INVOICES_ACCOUNTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.INVOICES_ACCOUNTS';
	Create Table dbo.INVOICES_ACCOUNTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_INVOICES_ACCOUNTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, INVOICE_ID                         uniqueidentifier not null
		, ACCOUNT_ID                         uniqueidentifier not null
		, ACCOUNT_ROLE                       nvarchar(25) not null
		)
	-- 06/04/2006 Paul.  ACCOUNT_ROLE can be 'Bill To', 'Ship To'

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_INVOICES_ACCOUNTS_INVOICE_ID on dbo.INVOICES_ACCOUNTS (INVOICE_ID, ACCOUNT_ROLE, DELETED, ACCOUNT_ID)
	create index IDX_INVOICES_ACCOUNTS_ACCOUNT_ID on dbo.INVOICES_ACCOUNTS (ACCOUNT_ID, ACCOUNT_ROLE, DELETED, INVOICE_ID)

	alter table dbo.INVOICES_ACCOUNTS add constraint FK_INVOICES_ACCOUNTS_INVOICE_ID foreign key ( INVOICE_ID ) references dbo.INVOICES ( ID )
	alter table dbo.INVOICES_ACCOUNTS add constraint FK_INVOICES_ACCOUNTS_ACCOUNT_ID foreign key ( ACCOUNT_ID ) references dbo.ACCOUNTS ( ID )
  end
GO

