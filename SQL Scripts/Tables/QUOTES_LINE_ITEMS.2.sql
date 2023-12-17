
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
-- 07/11/2010 Paul.  Add PARENT_TEMPLATE_ID. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'PARENT_TEMPLATE_ID') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add PARENT_TEMPLATE_ID uniqueidentifier null';
	alter table QUOTES_LINE_ITEMS add PARENT_TEMPLATE_ID uniqueidentifier null;
end -- if;
GO

-- 07/15/2010 Paul.  Add GROUP_ID for options management. 
-- 08/13/2010 Paul.  Use LINE_GROUP_ID instead of GROUP_ID. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'GROUP_ID') begin -- then
	print 'alter table QUOTES_LINE_ITEMS drop column GROUP_ID';
	alter table QUOTES_LINE_ITEMS drop column GROUP_ID;
end -- if;
GO

-- 08/12/2010 Paul.  Add Discount fields to better match Sugar. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'DISCOUNT_ID') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add DISCOUNT_ID uniqueidentifier null';
	alter table QUOTES_LINE_ITEMS add DISCOUNT_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'DISCOUNT_PRICE') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add DISCOUNT_PRICE money null';
	alter table QUOTES_LINE_ITEMS add DISCOUNT_PRICE money null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'DISCOUNT_USDOLLAR') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add DISCOUNT_USDOLLAR money null';
	alter table QUOTES_LINE_ITEMS add DISCOUNT_USDOLLAR money null;
end -- if;
GO

-- 08/17/2010 Paul.  Add PRICING fields so that they can be customized per line item. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'PRICING_FORMULA') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add PRICING_FORMULA nvarchar( 25) null';
	alter table QUOTES_LINE_ITEMS add PRICING_FORMULA nvarchar( 25) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'PRICING_FACTOR') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add PRICING_FACTOR float null';
	alter table QUOTES_LINE_ITEMS add PRICING_FACTOR float null;
end -- if;
GO

-- 10/08/2010 Paul.  Change QUANTITY to float. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'QUANTITY' and DATA_TYPE = 'int') begin -- then
	print 'alter table QUOTES_LINE_ITEMS alter column QUANTITY float null';
	alter table QUOTES_LINE_ITEMS alter column QUANTITY float null;
end -- if;
GO

-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'TAXRATE_ID') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add TAXRATE_ID uniqueidentifier null';
	alter table QUOTES_LINE_ITEMS add TAXRATE_ID uniqueidentifier null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'QUOTES_LINE_ITEMS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS_AUDIT' and COLUMN_NAME = 'TAXRATE_ID') begin -- then
		print 'alter table QUOTES_LINE_ITEMS_AUDIT add TAXRATE_ID uniqueidentifier null';
		alter table QUOTES_LINE_ITEMS_AUDIT add TAXRATE_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'TAX') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add TAX money null';
	alter table QUOTES_LINE_ITEMS add TAX money null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'QUOTES_LINE_ITEMS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS_AUDIT' and COLUMN_NAME = 'TAX') begin -- then
		print 'alter table QUOTES_LINE_ITEMS_AUDIT add TAX money null';
		alter table QUOTES_LINE_ITEMS_AUDIT add TAX money null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS' and COLUMN_NAME = 'TAX_USDOLLAR') begin -- then
	print 'alter table QUOTES_LINE_ITEMS add TAX_USDOLLAR money null';
	alter table QUOTES_LINE_ITEMS add TAX_USDOLLAR money null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'QUOTES_LINE_ITEMS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_LINE_ITEMS_AUDIT' and COLUMN_NAME = 'TAX_USDOLLAR') begin -- then
		print 'alter table QUOTES_LINE_ITEMS_AUDIT add TAX_USDOLLAR money null';
		alter table QUOTES_LINE_ITEMS_AUDIT add TAX_USDOLLAR money null;
	end -- if;
end -- if;
GO

