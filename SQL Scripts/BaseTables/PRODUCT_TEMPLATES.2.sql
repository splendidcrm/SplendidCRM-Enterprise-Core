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
-- 02/03/2009 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 07/10/2010 Paul.  Add Options fields. 
-- 08/13/2010 Paul.  PRICING_FACTOR and PRICING_FORMULA were moved to DISCOUNTS table. 
-- 08/17/2010 Paul.  Restore PRICING_FACTOR and PRICING_FORMULA.  Keep DISCOUNTS as a pre-defined discount. 
-- 09/20/2010 Paul.  PRICING_FACTOR is now a float. 
-- 04/11/2012 Paul.  Increase NAME to 100 to match QUOTES_LINE_ITEMS, ORDERS_LINE_ITEMS, INVOICES_LINE_ITEMS. 
-- 04/11/2012 Paul.  Increase MFT_PART_NUM and VENDOR_PART_NUM to 100. 
-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
-- 12/13/2013 Paul.  Allow each product to have a default tax rate. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_TEMPLATES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PRODUCT_TEMPLATES';
	Create Table dbo.PRODUCT_TEMPLATES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PRODUCT_TEMPLATES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(100) not null
		, STATUS                             nvarchar( 25) null
		, QUANTITY                           int null
		, DATE_AVAILABLE                     datetime null
		, DATE_COST_PRICE                    datetime null

		, ACCOUNT_ID                         uniqueidentifier null
		, MANUFACTURER_ID                    uniqueidentifier null
		, CATEGORY_ID                        uniqueidentifier null
		, TYPE_ID                            uniqueidentifier null
		, WEBSITE                            nvarchar(255) null
		, MFT_PART_NUM                       nvarchar(100) null
		, VENDOR_PART_NUM                    nvarchar(100) null
		, TAX_CLASS                          nvarchar( 25) null
		, TAXRATE_ID                         uniqueidentifier null
		, WEIGHT                             float null
		, MINIMUM_OPTIONS                    int null
		, MAXIMUM_OPTIONS                    int null
		, MINIMUM_QUANTITY                   int null
		, MAXIMUM_QUANTITY                   int null
		, LIST_ORDER                         int null
		, QUICKBOOKS_ACCOUNT                 nvarchar( 50) null

		, CURRENCY_ID                        uniqueidentifier null
		, COST_PRICE                         money null
		, COST_USDOLLAR                      money null
		, LIST_PRICE                         money null
		, LIST_USDOLLAR                      money null
		, DISCOUNT_PRICE                     money null
		, DISCOUNT_USDOLLAR                  money null
		, PRICING_FACTOR                     float null
		, PRICING_FORMULA                    nvarchar( 25) null
		, DISCOUNT_ID                        uniqueidentifier null

		, SUPPORT_NAME                       nvarchar( 50) null
		, SUPPORT_CONTACT                    nvarchar( 50) null
		, SUPPORT_DESCRIPTION                nvarchar(255) null
		, SUPPORT_TERM                       nvarchar( 25) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		)

	create index IDX_PRODUCT_TEMPLATES_TEAM_ID on dbo.PRODUCT_TEMPLATES (TEAM_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PRODUCT_TEMPLATES_TEAM_SET_ID on dbo.PRODUCT_TEMPLATES (TEAM_SET_ID, DELETED, ID)

	alter table dbo.PRODUCT_TEMPLATES add constraint FK_PRODUCT_TEMPLATES_CATEGORY_ID         foreign key ( CATEGORY_ID     ) references dbo.PRODUCT_CATEGORIES ( ID )
	alter table dbo.PRODUCT_TEMPLATES add constraint FK_PRODUCT_TEMPLATES_TYPE_ID             foreign key ( TYPE_ID         ) references dbo.PRODUCT_TYPES      ( ID )
	alter table dbo.PRODUCT_TEMPLATES add constraint FK_PRODUCT_TEMPLATES_MANUFACTURER_ID     foreign key ( MANUFACTURER_ID ) references dbo.MANUFACTURERS      ( ID )
	alter table dbo.PRODUCT_TEMPLATES add constraint FK_PRODUCT_TEMPLATES_ACCOUNT_ID          foreign key ( ACCOUNT_ID      ) references dbo.ACCOUNTS           ( ID )
  end
GO


