
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
-- 01/04/2009 Paul.  We should be specifying the Module Name and not the Table Name. 
-- 10/07/2018 Paul.  Recompiling all views takes 5 minutes.  Disable recompile and manually refresh views. 
-- This was not a big issue for this custom field as the line-item custom fields are not managed automatically. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS_LINE_ITEMS_CSTM' and COLUMN_NAME = 'BILLING_TYPE_C') begin -- then
	print 'Adding ORDERS_LINE_ITEMS_CSTM.BILLING_TYPE_C'
	exec dbo.spFIELDS_META_DATA_Insert null, null, 'BILLING_TYPE', 'Billing Type', 'BILLING_TYPE', 'OrdersLineItems', 'varchar', 25, 0, 0, null, null, 0, 1;

	-- 10/07/2018 Paul.  Recompiling all views takes 5 minutes.  Disable recompile and manually refresh views. 
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_ORDERS_LINE_ITEMS') begin -- then
		exec sp_refreshview 'vwACCOUNTS_ORDERS_LINE_ITEMS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_PRODUCTS') begin -- then
		exec sp_refreshview 'vwACCOUNTS_PRODUCTS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_PRODUCTS') begin -- then
		exec sp_refreshview 'vwCONTACTS_PRODUCTS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTRACTS_PRODUCTS') begin -- then
		exec sp_refreshview 'vwCONTRACTS_PRODUCTS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_LINE_ITEMS') begin -- then
		exec sp_refreshview 'vwORDERS_LINE_ITEMS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_LINE_ITEMS_Detail') begin -- then
		exec sp_refreshview 'vwORDERS_LINE_ITEMS_Detail';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_LINE_ITEMS_Edit') begin -- then
		exec sp_refreshview 'vwORDERS_LINE_ITEMS_Edit';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_LINE_ITEMS_QuickBooks') begin -- then
		exec sp_refreshview 'vwORDERS_LINE_ITEMS_QuickBooks';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS') begin -- then
		exec sp_refreshview 'vwPRODUCTS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS_List') begin -- then
		exec sp_refreshview 'vwPRODUCTS_List';
	end -- if;
end -- if;
GO


