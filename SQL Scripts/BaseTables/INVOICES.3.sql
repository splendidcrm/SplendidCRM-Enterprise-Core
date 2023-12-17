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
-- 07/25/2009 Paul.  INVOICE_NUM is now a string. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 10/05/2010 Paul.  Increase the size of the NAME field. 
-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'INVOICES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.INVOICES';
	Create Table dbo.INVOICES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_INVOICES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, QUOTE_ID                           uniqueidentifier null
		, ORDER_ID                           uniqueidentifier null
		, OPPORTUNITY_ID                     uniqueidentifier null
		, INVOICE_NUM                        nvarchar( 30) null
		, NAME                               nvarchar(150) null
		, PAYMENT_TERMS                      nvarchar( 25) null
		, INVOICE_STAGE                      nvarchar( 25) null
		, PURCHASE_ORDER_NUM                 nvarchar( 50) null
		, DUE_DATE                           datetime null
		, SHIP_DATE                          datetime null
		, EXCHANGE_RATE                      float null default(0.0)
		, CURRENCY_ID                        uniqueidentifier null
		, TAXRATE_ID                         uniqueidentifier null
		, SHIPPER_ID                         uniqueidentifier null
		, SUBTOTAL                           money null
		, SUBTOTAL_USDOLLAR                  money null
		, DISCOUNT                           money null
		, DISCOUNT_USDOLLAR                  money null
		, SHIPPING                           money null
		, SHIPPING_USDOLLAR                  money null
		, TAX                                money null
		, TAX_USDOLLAR                       money null
		, TOTAL                              money null
		, TOTAL_USDOLLAR                     money null
		, AMOUNT_DUE                         money null
		, AMOUNT_DUE_USDOLLAR                money null
		, BILLING_ADDRESS_STREET             nvarchar(150) null
		, BILLING_ADDRESS_CITY               nvarchar(100) null
		, BILLING_ADDRESS_STATE              nvarchar(100) null
		, BILLING_ADDRESS_POSTALCODE         nvarchar( 20) null
		, BILLING_ADDRESS_COUNTRY            nvarchar(100) null
		, SHIPPING_ADDRESS_STREET            nvarchar(150) null
		, SHIPPING_ADDRESS_CITY              nvarchar(100) null
		, SHIPPING_ADDRESS_STATE             nvarchar(100) null
		, SHIPPING_ADDRESS_POSTALCODE        nvarchar( 20) null
		, SHIPPING_ADDRESS_COUNTRY           nvarchar(100) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	-- 07/18/2006 Paul.  MySQL requires an index on auto_increment.
	-- #42000 Incorrect table definition; there can be only one auto column and it must be defined as a key
	create index IDX_INVOICES_INVOICE_NUM      on dbo.INVOICES (INVOICE_NUM, DELETED, ID)
	create index IDX_INVOICES_ASSIGNED_USER_ID on dbo.INVOICES (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_INVOICES_TEAM_ID          on dbo.INVOICES (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_INVOICES_TEAM_SET_ID      on dbo.INVOICES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_INVOICES_ASSIGNED_SET_ID  on dbo.INVOICES (ASSIGNED_SET_ID, DELETED, ID)

	alter table dbo.INVOICES add constraint FK_INVOICES_TAXRATE_ID foreign key ( TAXRATE_ID ) references dbo.TAX_RATES ( ID )
	alter table dbo.INVOICES add constraint FK_INVOICES_SHIPPER_ID foreign key ( SHIPPER_ID ) references dbo.SHIPPERS  ( ID )
  end
GO

