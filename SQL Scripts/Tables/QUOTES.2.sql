
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
-- 03/27/2007 Paul.  Add DISCOUNT fields.
-- 03/31/2007 Paul.  Add EXCHANGE_RATE. 
-- 09/15/2009 Paul.  Use new syntax to drop an index. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table QUOTES add TEAM_ID uniqueidentifier null';
	alter table QUOTES add TEAM_ID uniqueidentifier null;

	create index IDX_QUOTES_TEAM_ID on dbo.QUOTES (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'DISCOUNT') begin -- then
	print 'alter table QUOTES add DISCOUNT money null';
	alter table QUOTES add DISCOUNT money null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'DISCOUNT_USDOLLAR') begin -- then
	print 'alter table QUOTES add DISCOUNT_USDOLLAR money null';
	alter table QUOTES add DISCOUNT_USDOLLAR money null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'EXCHANGE_RATE') begin -- then
	print 'alter table QUOTES add EXCHANGE_RATE float null default(0.0)';
	alter table QUOTES add EXCHANGE_RATE float null default(0.0);
end -- if;
GO

-- 07/25/2009 Paul.  QUOTE_NUM is now a string. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'QUOTE_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change QUOTES.QUOTE_NUM to nvarchar.';
	if exists (select * from sys.indexes where name = 'IDX_QUOTES_QUOTE_NUM') begin -- then
		drop index IDX_QUOTES_QUOTE_NUM on QUOTES;
	end -- if;

	declare @CURRENT_VALUE int;
	select @CURRENT_VALUE = max(QUOTE_NUM)
	  from QUOTES;
	-- 08/06/2009 Paul.  @CURRENT_VALUE cannot be null, so only insert if it has a value. 
	if @CURRENT_VALUE is not null begin -- then
		if exists (select * from NUMBER_SEQUENCES where NAME = 'QUOTES.QUOTE_NUM') begin -- then
			update NUMBER_SEQUENCES
			   set CURRENT_VALUE = @CURRENT_VALUE
			 where NAME = 'QUOTES.QUOTE_NUM';
		end else begin
			insert into NUMBER_SEQUENCES (ID, NAME, CURRENT_VALUE)
			values (newid(), 'QUOTES.QUOTE_NUM', @CURRENT_VALUE);
		end -- if;
	end -- if;

	-- 02/18/2010 Paul.  Disable triggers before converting.
	exec dbo.spSqlTableDisableTriggers 'QUOTES';
	
	exec sp_rename 'QUOTES.QUOTE_NUM', 'QUOTE_NUM_INT', 'COLUMN';
	exec ('alter table QUOTES add QUOTE_NUM nvarchar(30) null');
	exec ('update QUOTES set QUOTE_NUM = cast(QUOTE_NUM_INT as nvarchar(30))');
	exec ('alter table QUOTES drop column QUOTE_NUM_INT');
	
	-- 02/18/2010 Paul.  Enable triggers after converting.
	exec dbo.spSqlTableEnableTriggers 'QUOTES';
	
	exec ('create index IDX_QUOTES_QUOTE_NUM        on dbo.QUOTES (QUOTE_NUM, DELETED, ID)');

end -- if;
GO

-- 08/08/2009 Paul.  We also need to change the field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_AUDIT' and COLUMN_NAME = 'QUOTE_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change QUOTES_AUDIT.QUOTE_NUM to nvarchar.';
	exec sp_rename 'QUOTES_AUDIT.QUOTE_NUM', 'QUOTE_NUM_INT', 'COLUMN';
	exec ('alter table QUOTES_AUDIT add QUOTE_NUM nvarchar(30) null');
	exec ('update QUOTES_AUDIT set QUOTE_NUM = cast(QUOTE_NUM_INT as nvarchar(30))');
	exec ('alter table QUOTES_AUDIT drop column QUOTE_NUM_INT');
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table QUOTES add TEAM_SET_ID uniqueidentifier null';
	alter table QUOTES add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_QUOTES_TEAM_SET_ID on dbo.QUOTES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table QUOTES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table QUOTES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 10/05/2010 Paul.  Increase the size of the NAME field. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table QUOTES alter column NAME nvarchar(150) null';
	alter table QUOTES alter column NAME nvarchar(150) null;
end -- if;
GO

-- 10/20/2010 Paul.  Increase the size of the NAME field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_AUDIT') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
		print 'alter table QUOTES_AUDIT alter column NAME nvarchar(150) null';
		alter table QUOTES_AUDIT alter column NAME nvarchar(150) null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table QUOTES add ASSIGNED_SET_ID uniqueidentifier null';
	alter table QUOTES add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_QUOTES_ASSIGNED_SET_ID on dbo.QUOTES (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'QUOTES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'QUOTES_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table QUOTES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table QUOTES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

