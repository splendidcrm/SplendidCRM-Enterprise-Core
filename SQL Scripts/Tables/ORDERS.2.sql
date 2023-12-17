
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
-- 09/15/2009 Paul.  Use new syntax to drop an index. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS' and COLUMN_NAME = 'QUOTE_ID') begin -- then
	print 'alter table ORDERS add QUOTE_ID uniqueidentifier null';
	alter table ORDERS add QUOTE_ID uniqueidentifier null;
end -- if;
GO

-- 07/25/2009 Paul.  ORDER_NUM is now a string. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS' and COLUMN_NAME = 'ORDER_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change ORDERS.ORDER_NUM to nvarchar.';
	if exists (select * from sys.indexes where name = 'IDX_ORDERS_ORDER_NUM') begin -- then
		drop index IDX_ORDERS_ORDER_NUM on ORDERS;
	end -- if;

	declare @CURRENT_VALUE int;
	select @CURRENT_VALUE = max(ORDER_NUM)
	  from ORDERS;
	-- 08/06/2009 Paul.  @CURRENT_VALUE cannot be null, so only insert if it has a value. 
	if @CURRENT_VALUE is not null begin -- then
		if exists (select * from NUMBER_SEQUENCES where NAME = 'ORDERS.ORDER_NUM') begin -- then
			update NUMBER_SEQUENCES
			   set CURRENT_VALUE = @CURRENT_VALUE
			 where NAME = 'ORDERS.ORDER_NUM';
		end else begin
			insert into NUMBER_SEQUENCES (ID, NAME, CURRENT_VALUE)
			values (newid(), 'ORDERS.ORDER_NUM', @CURRENT_VALUE);
		end -- if;
	end -- if;

	-- 02/18/2010 Paul.  Disable triggers before converting.
	exec dbo.spSqlTableDisableTriggers 'ORDERS';
	
	exec sp_rename 'ORDERS.ORDER_NUM', 'ORDER_NUM_INT', 'COLUMN';
	exec ('alter table ORDERS add ORDER_NUM nvarchar(30) null');
	exec ('update ORDERS set ORDER_NUM = cast(ORDER_NUM_INT as nvarchar(30))');
	exec ('alter table ORDERS drop column ORDER_NUM_INT');
	
	-- 02/18/2010 Paul.  Enable triggers after converting.
	exec dbo.spSqlTableEnableTriggers 'ORDERS';
	
	exec ('create index IDX_ORDERS_ORDER_NUM        on dbo.ORDERS (ORDER_NUM, DELETED, ID)');
end -- if;
GO

-- 08/08/2009 Paul.  We also need to change the field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS_AUDIT' and COLUMN_NAME = 'ORDER_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change ORDERS_AUDIT.ORDER_NUM to nvarchar.';
	exec sp_rename 'ORDERS_AUDIT.ORDER_NUM', 'ORDER_NUM_INT', 'COLUMN';
	exec ('alter table ORDERS_AUDIT add ORDER_NUM nvarchar(30) null');
	exec ('update ORDERS_AUDIT set ORDER_NUM = cast(ORDER_NUM_INT as nvarchar(30))');
	exec ('alter table ORDERS_AUDIT drop column ORDER_NUM_INT');
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table ORDERS add TEAM_SET_ID uniqueidentifier null';
	alter table ORDERS add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_ORDERS_TEAM_SET_ID      on dbo.ORDERS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table ORDERS add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table ORDERS add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 10/05/2010 Paul.  Increase the size of the NAME field. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table ORDERS alter column NAME nvarchar(150) null';
	alter table ORDERS alter column NAME nvarchar(150) null;
end -- if;
GO

-- 10/20/2010 Paul.  Increase the size of the NAME field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS_AUDIT') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
		print 'alter table ORDERS_AUDIT alter column NAME nvarchar(150) null';
		alter table ORDERS_AUDIT alter column NAME nvarchar(150) null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table ORDERS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table ORDERS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_ORDERS_ASSIGNED_SET_ID on dbo.ORDERS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ORDERS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'ORDERS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table ORDERS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table ORDERS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

