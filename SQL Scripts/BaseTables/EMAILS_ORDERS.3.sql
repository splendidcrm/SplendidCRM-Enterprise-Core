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
-- 05/18/2014 Paul.  Customer wants to be able to archive to an order. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAILS_ORDERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EMAILS_ORDERS';
	Create Table dbo.EMAILS_ORDERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EMAILS_ORDERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, EMAIL_ID                           uniqueidentifier not null
		, ORDER_ID                           uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_EMAILS_ORDERS_EMAIL_ID on dbo.EMAILS_ORDERS (EMAIL_ID, DELETED, ORDER_ID)
	create index IDX_EMAILS_ORDERS_ORDER_ID on dbo.EMAILS_ORDERS (ORDER_ID, DELETED, EMAIL_ID)

	alter table dbo.EMAILS_ORDERS add constraint FK_EMAILS_ORDERS_EMAIL_ID foreign key ( EMAIL_ID ) references dbo.EMAILS ( ID )
	alter table dbo.EMAILS_ORDERS add constraint FK_EMAILS_ORDERS_ORDER_ID foreign key ( ORDER_ID ) references dbo.ORDERS ( ID )
  end
GO


