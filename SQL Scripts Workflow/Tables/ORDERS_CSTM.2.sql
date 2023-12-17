
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
-- This was technically not an issue since the module name matches the table name, but the comment is still useful. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS_CSTM' and COLUMN_NAME = 'BILLING_FREQUENCY_C') begin -- then
	print 'Adding ORDERS_CSTM.BILLING_FREQUENCY_C'
	exec dbo.spFIELDS_META_DATA_Insert null, null, 'BILLING_FREQUENCY', 'Billing Frequency', 'BILLING_FREQUENCY', 'Orders', 'varchar', 25, 0, 0, null, null, 0, 1;

	-- 10/07/2018 Paul.  Recompiling all views takes 5 minutes.  Disable recompile and manually refresh views. 
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_ORDERS') begin -- then
		exec sp_refreshview 'vwACCOUNTS_ORDERS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_ORDERS') begin -- then
		exec sp_refreshview 'vwCONTACTS_ORDERS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_ORDERS') begin -- then
		exec sp_refreshview 'vwEMAILS_ORDERS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS') begin -- then
		exec sp_refreshview 'vwORDERS';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_ConvertToInvoice') begin -- then
		exec sp_refreshview 'vwORDERS_ConvertToInvoice';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_Edit') begin -- then
		exec sp_refreshview 'vwORDERS_Edit';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_List') begin -- then
		exec sp_refreshview 'vwORDERS_List';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_MyList') begin -- then
		exec sp_refreshview 'vwORDERS_MyList';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_QuickBooks') begin -- then
		exec sp_refreshview 'vwORDERS_QuickBooks';
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_ORDERS') begin -- then
		exec sp_refreshview 'vwQUOTES_ORDERS';
	end -- if;
end -- if;
GO


