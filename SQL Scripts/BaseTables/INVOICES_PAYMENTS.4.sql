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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'INVOICES_PAYMENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.INVOICES_PAYMENTS';
	Create Table dbo.INVOICES_PAYMENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_INVOICES_PAYMENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, INVOICE_ID                         uniqueidentifier not null
		, PAYMENT_ID                         uniqueidentifier not null
		, AMOUNT                             money null
		, AMOUNT_USDOLLAR                    money null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_INVOICES_PAYMENTS_INVOICE_ID on dbo.INVOICES_PAYMENTS (INVOICE_ID, DELETED, PAYMENT_ID)
	create index IDX_INVOICES_PAYMENTS_PAYMENT_ID on dbo.INVOICES_PAYMENTS (PAYMENT_ID, DELETED, INVOICE_ID)

	alter table dbo.INVOICES_PAYMENTS add constraint FK_INVOICES_PAYMENTS_INVOICE_ID foreign key ( INVOICE_ID ) references dbo.INVOICES ( ID )
	alter table dbo.INVOICES_PAYMENTS add constraint FK_INVOICES_PAYMENTS_PAYMENT_ID foreign key ( PAYMENT_ID ) references dbo.PAYMENTS ( ID )
  end
GO

