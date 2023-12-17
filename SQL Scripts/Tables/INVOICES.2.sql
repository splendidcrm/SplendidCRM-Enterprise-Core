
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
-- 09/15/2009 Paul.  Use new syntax to drop an index. 
-- 12/04/2009 Paul.  Move fix invoces to the data folder as spNUMBER_SEQUENCES_Formatted may not exist until now. 
-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES' and COLUMN_NAME = 'INVOICE_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change INVOICES.INVOICE_NUM to nvarchar.';
	if exists (select * from sys.indexes where name = 'IDX_INVOICES_INVOICE_NUM') begin -- then
		drop index IDX_INVOICES_INVOICE_NUM on INVOICES;
	end -- if;

	declare @CURRENT_VALUE int;
	select @CURRENT_VALUE = max(INVOICE_NUM)
	  from INVOICES;
	-- 08/06/2009 Paul.  @CURRENT_VALUE cannot be null, so only insert if it has a value. 
	if @CURRENT_VALUE is not null begin -- then
		if exists (select * from NUMBER_SEQUENCES where NAME = 'INVOICES.INVOICE_NUM') begin -- then
			update NUMBER_SEQUENCES
			   set CURRENT_VALUE = @CURRENT_VALUE
			 where NAME = 'INVOICES.INVOICE_NUM';
		end else begin
			insert into NUMBER_SEQUENCES (ID, NAME, CURRENT_VALUE)
			values (newid(), 'INVOICES.INVOICE_NUM', @CURRENT_VALUE);
		end -- if;
	end -- if;

	-- 02/18/2010 Paul.  Disable triggers before converting.
	exec dbo.spSqlTableDisableTriggers 'INVOICES';
	
	exec sp_rename 'INVOICES.INVOICE_NUM', 'INVOICE_NUM_INT', 'COLUMN';
	exec ('alter table INVOICES add INVOICE_NUM nvarchar(30) null');
	exec ('update INVOICES set INVOICE_NUM = cast(INVOICE_NUM_INT as nvarchar(30))');
	exec ('alter table INVOICES drop column INVOICE_NUM_INT');
	
	-- 02/18/2010 Paul.  Enable triggers after converting.
	exec dbo.spSqlTableEnableTriggers 'INVOICES';
	
	exec ('create index IDX_INVOICES_INVOICE_NUM      on dbo.INVOICES (INVOICE_NUM, DELETED, ID)');
end -- if;
GO

-- 08/08/2009 Paul.  We also need to change the field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES_AUDIT' and COLUMN_NAME = 'INVOICE_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change INVOICES_AUDIT.INVOICE_NUM to nvarchar.';
	exec sp_rename 'INVOICES_AUDIT.INVOICE_NUM', 'INVOICE_NUM_INT', 'COLUMN';
	exec ('alter table INVOICES_AUDIT add INVOICE_NUM nvarchar(30) null');
	exec ('update INVOICES_AUDIT set INVOICE_NUM = cast(INVOICE_NUM_INT as nvarchar(30))');
	exec ('alter table INVOICES_AUDIT drop column INVOICE_NUM_INT');
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table INVOICES add TEAM_SET_ID uniqueidentifier null';
	alter table INVOICES add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_INVOICES_TEAM_SET_ID      on dbo.INVOICES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table INVOICES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table INVOICES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO


-- 10/05/2010 Paul.  Increase the size of the NAME field. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table INVOICES alter column NAME nvarchar(150) null';
	alter table INVOICES alter column NAME nvarchar(150) null;
end -- if;
GO

-- 10/20/2010 Paul.  Increase the size of the NAME field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES_AUDIT') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
		print 'alter table INVOICES_AUDIT alter column NAME nvarchar(150) null';
		alter table INVOICES_AUDIT alter column NAME nvarchar(150) null;
	end -- if;
end -- if;
GO

-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES' and COLUMN_NAME = 'SHIP_DATE') begin -- then
	print 'alter table INVOICES add SHIP_DATE datetime null';
	alter table INVOICES add SHIP_DATE datetime null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES_AUDIT' and COLUMN_NAME = 'SHIP_DATE') begin -- then
		print 'alter table INVOICES_AUDIT add SHIP_DATE datetime null';
		alter table INVOICES_AUDIT add SHIP_DATE datetime null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table INVOICES add ASSIGNED_SET_ID uniqueidentifier null';
	alter table INVOICES add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_INVOICES_ASSIGNED_SET_ID on dbo.INVOICES (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'INVOICES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INVOICES_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table INVOICES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table INVOICES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

