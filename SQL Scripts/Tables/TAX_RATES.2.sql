
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
-- 06/02/2012 Paul.  Tax Vendor is required to create a QuickBooks tax rate. 
-- 04/07/2016 Paul.  Tax rates per team. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TAX_RATES' and COLUMN_NAME = 'QUICKBOOKS_TAX_VENDOR') begin -- then
	print 'alter table TAX_RATES add QUICKBOOKS_TAX_VENDOR nvarchar(50) null';
	alter table TAX_RATES add QUICKBOOKS_TAX_VENDOR nvarchar(50) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TAX_RATES' and COLUMN_NAME = 'DESCRIPTION') begin -- then
	print 'alter table TAX_RATES add DESCRIPTION nvarchar(max) null';
	alter table TAX_RATES add DESCRIPTION nvarchar(max) null;
end -- if;
GO

-- 02/24/2015 Paul.  Add state for lookup. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TAX_RATES' and COLUMN_NAME = 'ADDRESS_STATE') begin -- then
	print 'alter table TAX_RATES add ADDRESS_STATE nvarchar(100) null';
	alter table TAX_RATES add ADDRESS_STATE nvarchar(100) null;
end -- if;
GO

-- 04/07/2016 Paul.  Tax rates per team. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TAX_RATES' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table TAX_RATES add TEAM_ID uniqueidentifier null';
	alter table TAX_RATES add TEAM_ID uniqueidentifier null;

	create index IDX_TAX_RATES_TEAM_ID on dbo.TAX_RATES (TEAM_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TAX_RATES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table TAX_RATES add TEAM_SET_ID uniqueidentifier null';
	alter table TAX_RATES add TEAM_SET_ID uniqueidentifier null;

	create index IDX_TAX_RATES_TEAM_SET_ID on dbo.TAX_RATES (TEAM_SET_ID, DELETED, ID);
end -- if;
GO

