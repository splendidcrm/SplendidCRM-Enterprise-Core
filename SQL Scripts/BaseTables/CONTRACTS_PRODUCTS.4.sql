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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTRACTS_PRODUCTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CONTRACTS_PRODUCTS';
	Create Table dbo.CONTRACTS_PRODUCTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CONTRACTS_PRODUCTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CONTRACT_ID                        uniqueidentifier not null
		, PRODUCT_ID                         uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_CONTRACTS_PRODUCTS_CONTRACT_ID on dbo.CONTRACTS_PRODUCTS (CONTRACT_ID, DELETED, PRODUCT_ID )
	create index IDX_CONTRACTS_PRODUCTS_PRODUCT_ID  on dbo.CONTRACTS_PRODUCTS (PRODUCT_ID , DELETED, CONTRACT_ID)

	alter table dbo.CONTRACTS_PRODUCTS add constraint FK_CONTRACTS_PRODUCTS_CONTRACT_ID foreign key ( CONTRACT_ID ) references dbo.CONTRACTS ( ID )
	-- 04/19/2010 Paul.  The foreign key should have been dropped long ago. The PRODUCT_ID will point to the ORDERS_LINE_ITEMS table. 
	-- alter table dbo.CONTRACTS_PRODUCTS add constraint FK_CONTRACTS_PRODUCTS_PRODUCT_ID  foreign key ( PRODUCT_ID  ) references dbo.PRODUCTS  ( ID )
  end
GO


