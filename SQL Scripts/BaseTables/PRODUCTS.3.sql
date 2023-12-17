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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 09/20/2010 Paul.  PRICING_FACTOR is now a float. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PRODUCTS';
	Create Table dbo.PRODUCTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PRODUCTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TEAM_ID                            uniqueidentifier null
		, PRODUCT_TEMPLATE_ID                uniqueidentifier null
		, NAME                               nvarchar( 50) null
		, STATUS                             nvarchar( 25) null
		, QUOTE_ID                           uniqueidentifier null
		, ACCOUNT_ID                         uniqueidentifier null
		, CONTACT_ID                         uniqueidentifier null
		, QUANTITY                           int null
		, DATE_PURCHASED                     datetime null
		, DATE_SUPPORT_EXPIRES               datetime null
		, DATE_SUPPORT_STARTS                datetime null

		, MANUFACTURER_ID                    uniqueidentifier null
		, CATEGORY_ID                        uniqueidentifier null
		, TYPE_ID                            uniqueidentifier null
		, WEBSITE                            nvarchar(255) null
		, MFT_PART_NUM                       nvarchar( 50) null
		, VENDOR_PART_NUM                    nvarchar( 50) null
		, SERIAL_NUMBER                      nvarchar( 50) null
		, ASSET_NUMBER                       nvarchar( 50) null
		, TAX_CLASS                          nvarchar( 25) null
		, WEIGHT                             float null

		, CURRENCY_ID                        uniqueidentifier null
		, COST_PRICE                         money null
		, COST_USDOLLAR                      money null
		, LIST_PRICE                         money null
		, LIST_USDOLLAR                      money null
		, BOOK_VALUE                         money null
		, BOOK_VALUE_DATE                    datetime null
		, DISCOUNT_PRICE                     money null
		, DISCOUNT_USDOLLAR                  money null
		, PRICING_FACTOR                     float null
		, PRICING_FORMULA                    nvarchar( 25) null

		, SUPPORT_NAME                       nvarchar( 50) null
		, SUPPORT_CONTACT                    nvarchar( 50) null
		, SUPPORT_DESCRIPTION                nvarchar(255) null
		, SUPPORT_TERM                       nvarchar( 25) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		)

	create index IDX_PRODUCTS_NAME    on dbo.PRODUCTS (NAME, DELETED, ID)
	create index IDX_PRODUCTS_TEAM_ID on dbo.PRODUCTS (TEAM_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PRODUCTS_TEAM_SET_ID on dbo.PRODUCTS (TEAM_SET_ID, DELETED, ID)

	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_PRODUCT_TEMPLATE_ID foreign key ( PRODUCT_TEMPLATE_ID ) references dbo.PRODUCT_TEMPLATES  ( ID )
	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_QUOTE_ID            foreign key ( QUOTE_ID            ) references dbo.QUOTES             ( ID )
	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_ACCOUNT_ID          foreign key ( ACCOUNT_ID          ) references dbo.ACCOUNTS           ( ID )
	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_CONTACT_ID          foreign key ( CONTACT_ID          ) references dbo.CONTACTS           ( ID )
	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_CATEGORY_ID         foreign key ( CATEGORY_ID         ) references dbo.PRODUCT_CATEGORIES ( ID )
	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_TYPE_ID             foreign key ( TYPE_ID             ) references dbo.PRODUCT_TYPES      ( ID )
	alter table dbo.PRODUCTS add constraint FK_PRODUCTS_MANUFACTURER_ID     foreign key ( MANUFACTURER_ID     ) references dbo.MANUFACTURERS      ( ID )
  end
GO

