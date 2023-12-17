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
-- 12/09/2015 Paul.  We do not need to specify float(53). 
-- drop table REVENUE_LINE_ITEMS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'REVENUE_LINE_ITEMS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.REVENUE_LINE_ITEMS';
	Create Table dbo.REVENUE_LINE_ITEMS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_REVENUE_LINE_ITEMS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, OPPORTUNITY_ID                     uniqueidentifier null
		, LINE_GROUP_ID                      uniqueidentifier null
		, LINE_ITEM_TYPE                     nvarchar( 25) null
		, POSITION                           int null
		, NAME                               nvarchar(150) null
		, MFT_PART_NUM                       nvarchar( 50) null
		, VENDOR_PART_NUM                    nvarchar( 50) null
		, PRODUCT_TEMPLATE_ID                uniqueidentifier null
		, PARENT_TEMPLATE_ID                 uniqueidentifier null

		, TAX_CLASS                          nvarchar( 25) null
		, QUANTITY                           float null
		, COST_PRICE                         money null
		, COST_USDOLLAR                      money null
		, LIST_PRICE                         money null
		, LIST_USDOLLAR                      money null
		, UNIT_PRICE                         money null
		, UNIT_USDOLLAR                      money null
		, TAXRATE_ID                         uniqueidentifier null
		, TAX                                money null
		, TAX_USDOLLAR                       money null
		, EXTENDED_PRICE                     money null
		, EXTENDED_USDOLLAR                  money null
		, DISCOUNT_ID                        uniqueidentifier null
		, PRICING_FORMULA                    nvarchar( 25) null
		, PRICING_FACTOR                     float null
		, DISCOUNT_PRICE                     money null
		, DISCOUNT_USDOLLAR                  money null
		, DESCRIPTION                        nvarchar(max) null

		-- Opportunity Fields
		, OPPORTUNITY_TYPE                   nvarchar(255) null
		, LEAD_SOURCE                        nvarchar( 50) null
		, DATE_CLOSED                        datetime null
		, NEXT_STEP                          nvarchar(100) null
		, SALES_STAGE                        nvarchar( 25) null
		, PROBABILITY                        float null
		)

	alter table dbo.REVENUE_LINE_ITEMS add constraint FK_REVENUE_LINE_ITEMS_OPPORT foreign key ( OPPORTUNITY_ID ) references dbo.OPPORTUNITIES ( ID )
  end
GO

