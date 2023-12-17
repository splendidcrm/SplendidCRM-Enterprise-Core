
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
-- 05/01/2009 Paul.  Add ACCOUNT_ID to SugarCRM migrated database. 
-- 05/01/2009 Paul.  Change QTY_IN_STOCK in SugarCRM 4.5.1 database to QUANTITY. 
-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table PRODUCT_TEMPLATES add TEAM_ID uniqueidentifier null';
	alter table PRODUCT_TEMPLATES add TEAM_ID uniqueidentifier null;

	create index IDX_PRODUCT_TEMPLATES_TEAM_ID on dbo.PRODUCT_TEMPLATES (TEAM_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'ACCOUNT_ID') begin -- then
	print 'alter table PRODUCT_TEMPLATES add ACCOUNT_ID uniqueidentifier null';
	alter table PRODUCT_TEMPLATES add ACCOUNT_ID uniqueidentifier null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'QTY_IN_STOCK') begin -- then
	print 'sp_rename PRODUCT_TEMPLATES.QTY_IN_STOCK, QUANTITY, COLUMN';
	exec sp_rename 'PRODUCT_TEMPLATES.QTY_IN_STOCK', 'QUANTITY', 'COLUMN';
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table PRODUCT_TEMPLATES add TEAM_SET_ID uniqueidentifier null';
	alter table PRODUCT_TEMPLATES add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PRODUCT_TEMPLATES_TEAM_SET_ID on dbo.PRODUCT_TEMPLATES (TEAM_SET_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table PRODUCT_TEMPLATES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table PRODUCT_TEMPLATES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 07/10/2010 Paul.  Add Options fields. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'MINIMUM_OPTIONS') begin -- then
	print 'alter table PRODUCT_TEMPLATES add MINIMUM_OPTIONS int null';
	alter table PRODUCT_TEMPLATES add MINIMUM_OPTIONS int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'MAXIMUM_OPTIONS') begin -- then
	print 'alter table PRODUCT_TEMPLATES add MAXIMUM_OPTIONS int null';
	alter table PRODUCT_TEMPLATES add MAXIMUM_OPTIONS int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'DISCOUNT_ID') begin -- then
	print 'alter table PRODUCT_TEMPLATES add DISCOUNT_ID uniqueidentifier null';
	alter table PRODUCT_TEMPLATES add DISCOUNT_ID uniqueidentifier null;
end -- if;
GO

-- 08/13/2010 Paul.  PRICING_FACTOR and PRICING_FORMULA were moved to DISCOUNTS table. 
-- 08/17/2010 Paul.  Restore PRICING_FACTOR and PRICING_FORMULA.  Keep DISCOUNTS as a pre-defined discount. 
-- 09/20/2010 Paul.  PRICING_FACTOR is now a float. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'PRICING_FACTOR') begin -- then
	print 'alter table PRODUCT_TEMPLATES add PRICING_FACTOR float null';
	alter table PRODUCT_TEMPLATES add PRICING_FACTOR float null;
end -- if;
GO

-- 09/20/2010 Paul.  PRICING_FACTOR is now a float. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'PRICING_FACTOR' and DATA_TYPE = 'int') begin -- then
	print 'alter table PRODUCT_TEMPLATES alter column PRICING_FACTOR float null';
	alter table PRODUCT_TEMPLATES alter column PRICING_FACTOR float null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'PRICING_FORMULA') begin -- then
	print 'alter table PRODUCT_TEMPLATES add PRICING_FORMULA nvarchar( 25) null';
	alter table PRODUCT_TEMPLATES add PRICING_FORMULA nvarchar( 25) null;
end -- if;
GO

-- 04/11/2012 Paul.  Increase NAME to 100 to match QUOTES_LINE_ITEMS, ORDERS_LINE_ITEMS, INVOICES_LINE_ITEMS. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PRODUCT_TEMPLATES alter column NAME nvarchar(100) not null';
	alter table PRODUCT_TEMPLATES alter column NAME nvarchar(100) not null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PRODUCT_TEMPLATES_AUDIT alter column NAME nvarchar(100) not null';
	alter table PRODUCT_TEMPLATES_AUDIT alter column NAME nvarchar(100) not null;
end -- if;
GO

-- 04/11/2012 Paul.  Increase MFT_PART_NUM and VENDOR_PART_NUM to 100. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'MFT_PART_NUM' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PRODUCT_TEMPLATES alter column MFT_PART_NUM nvarchar(100) not null';
	alter table PRODUCT_TEMPLATES alter column MFT_PART_NUM nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'MFT_PART_NUM' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PRODUCT_TEMPLATES_AUDIT alter column MFT_PART_NUM nvarchar(100) not null';
	alter table PRODUCT_TEMPLATES_AUDIT alter column MFT_PART_NUM nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'VENDOR_PART_NUM' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PRODUCT_TEMPLATES alter column VENDOR_PART_NUM nvarchar(100) not null';
	alter table PRODUCT_TEMPLATES alter column VENDOR_PART_NUM nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'VENDOR_PART_NUM' and CHARACTER_MAXIMUM_LENGTH < 100) begin -- then
	print 'alter table PRODUCT_TEMPLATES_AUDIT alter column VENDOR_PART_NUM nvarchar(100) not null';
	alter table PRODUCT_TEMPLATES_AUDIT alter column VENDOR_PART_NUM nvarchar(100) null;
end -- if;
GO

-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'QUICKBOOKS_ACCOUNT') begin -- then
	print 'alter table PRODUCT_TEMPLATES add QUICKBOOKS_ACCOUNT nvarchar(50) not null';
	alter table PRODUCT_TEMPLATES add QUICKBOOKS_ACCOUNT nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'QUICKBOOKS_ACCOUNT') begin -- then
		print 'alter table PRODUCT_TEMPLATES_AUDIT add QUICKBOOKS_ACCOUNT nvarchar(50) not null';
		alter table PRODUCT_TEMPLATES_AUDIT add QUICKBOOKS_ACCOUNT nvarchar(50) null;
	end -- if;
end -- if;
GO

-- 12/13/2013 Paul.  Allow each product to have a default tax rate. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'TAXRATE_ID') begin -- then
	print 'alter table PRODUCT_TEMPLATES add TAXRATE_ID uniqueidentifier null';
	alter table PRODUCT_TEMPLATES add TAXRATE_ID uniqueidentifier null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'TAXRATE_ID') begin -- then
		print 'alter table PRODUCT_TEMPLATES_AUDIT add TAXRATE_ID uniqueidentifier null';
		alter table PRODUCT_TEMPLATES_AUDIT add TAXRATE_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

-- 10/21/2015 Paul.  Add min and max order fields for published data. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'MINIMUM_QUANTITY') begin -- then
	print 'alter table PRODUCT_TEMPLATES add MINIMUM_QUANTITY int null';
	alter table PRODUCT_TEMPLATES add MINIMUM_QUANTITY int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'MINIMUM_QUANTITY') begin -- then
		print 'alter table PRODUCT_TEMPLATES_AUDIT add MINIMUM_QUANTITY int null';
		alter table PRODUCT_TEMPLATES_AUDIT add MINIMUM_QUANTITY int null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'MAXIMUM_QUANTITY') begin -- then
	print 'alter table PRODUCT_TEMPLATES add MAXIMUM_QUANTITY int null';
	alter table PRODUCT_TEMPLATES add MAXIMUM_QUANTITY int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'MAXIMUM_QUANTITY') begin -- then
		print 'alter table PRODUCT_TEMPLATES_AUDIT add MAXIMUM_QUANTITY int null';
		alter table PRODUCT_TEMPLATES_AUDIT add MAXIMUM_QUANTITY int null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES' and COLUMN_NAME = 'LIST_ORDER') begin -- then
	print 'alter table PRODUCT_TEMPLATES add LIST_ORDER int null';
	alter table PRODUCT_TEMPLATES add LIST_ORDER int null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCT_TEMPLATES_AUDIT' and COLUMN_NAME = 'LIST_ORDER') begin -- then
		print 'alter table PRODUCT_TEMPLATES_AUDIT add LIST_ORDER int null';
		alter table PRODUCT_TEMPLATES_AUDIT add LIST_ORDER int null;
	end -- if;
end -- if;
GO

