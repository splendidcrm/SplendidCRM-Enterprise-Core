
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
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCTS' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table PRODUCTS add TEAM_ID uniqueidentifier null';
	alter table PRODUCTS add TEAM_ID uniqueidentifier null;

	create index IDX_PRODUCTS_TEAM_ID on dbo.PRODUCTS (TEAM_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCTS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table PRODUCTS add TEAM_SET_ID uniqueidentifier null';
	alter table PRODUCTS add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PRODUCTS_TEAM_SET_ID on dbo.PRODUCTS (TEAM_SET_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCTS' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table PRODUCTS add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table PRODUCTS add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 09/20/2010 Paul.  PRICING_FACTOR is now a float. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PRODUCTS' and COLUMN_NAME = 'PRICING_FACTOR' and DATA_TYPE = 'int') begin -- then
	print 'alter table PRODUCTS alter column PRICING_FACTOR float null';
	alter table PRODUCTS alter column PRICING_FACTOR float null;
end -- if;
GO

