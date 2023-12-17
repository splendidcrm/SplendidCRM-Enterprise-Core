
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
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'CREDIT_CARD_ID') begin -- then
	print 'alter table PAYMENTS add CREDIT_CARD_ID uniqueidentifier null';
	alter table PAYMENTS add CREDIT_CARD_ID uniqueidentifier null;
end -- if;
GO

-- 07/25/2009 Paul.  PAYMENT_NUM is now a string. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'PAYMENT_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change PAYMENTS.PAYMENT_NUM to nvarchar.';
	if exists (select * from sys.indexes where name = 'IDX_PAYMENTS_PAYMENT_NUM') begin -- then
		drop index IDX_PAYMENTS_PAYMENT_NUM on PAYMENTS;
	end -- if;

	declare @CURRENT_VALUE int;
	select @CURRENT_VALUE = max(PAYMENT_NUM)
	  from PAYMENTS;
	-- 08/06/2009 Paul.  @CURRENT_VALUE cannot be null, so only insert if it has a value. 
	if @CURRENT_VALUE is not null begin -- then
		if exists (select * from NUMBER_SEQUENCES where NAME = 'PAYMENTS.PAYMENT_NUM') begin -- then
			update NUMBER_SEQUENCES
			   set CURRENT_VALUE = @CURRENT_VALUE
			 where NAME = 'PAYMENTS.PAYMENT_NUM';
		end else begin
			insert into NUMBER_SEQUENCES (ID, NAME, CURRENT_VALUE)
			values (newid(), 'PAYMENTS.PAYMENT_NUM', @CURRENT_VALUE);
		end -- if;
	end -- if;

	exec sp_rename 'PAYMENTS.PAYMENT_NUM', 'PAYMENT_NUM_INT', 'COLUMN';
	exec ('alter table PAYMENTS add PAYMENT_NUM nvarchar(30) null');
	exec ('update PAYMENTS set PAYMENT_NUM = cast(PAYMENT_NUM_INT as nvarchar(30))');
	exec ('alter table PAYMENTS drop column PAYMENT_NUM_INT');
	
	exec ('create index IDX_PAYMENTS_PAYMENT_NUM      on dbo.PAYMENTS (PAYMENT_NUM, DELETED, ID)');
end -- if;
GO

-- 08/08/2009 Paul.  We also need to change the field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_AUDIT' and COLUMN_NAME = 'PAYMENT_NUM' and DATA_TYPE <> 'nvarchar') begin -- then
	print 'Change PAYMENTS_AUDIT.PAYMENT_NUM to nvarchar.';
	exec sp_rename 'PAYMENTS_AUDIT.PAYMENT_NUM', 'PAYMENT_NUM_INT', 'COLUMN';
	exec ('alter table PAYMENTS_AUDIT add PAYMENT_NUM nvarchar(30) null');
	exec ('update PAYMENTS_AUDIT set PAYMENT_NUM = cast(PAYMENT_NUM_INT as nvarchar(30))');
	exec ('alter table PAYMENTS_AUDIT drop column PAYMENT_NUM_INT');
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table PAYMENTS add TEAM_SET_ID uniqueidentifier null';
	alter table PAYMENTS add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PAYMENTS_TEAM_SET_ID      on dbo.PAYMENTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table PAYMENTS add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table PAYMENTS add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'BANK_FEE') begin -- then
	print 'alter table PAYMENTS add BANK_FEE money null';
	alter table PAYMENTS add BANK_FEE money null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'BANK_FEE_USDOLLAR') begin -- then
	print 'alter table PAYMENTS add BANK_FEE_USDOLLAR money null';
	alter table PAYMENTS add BANK_FEE_USDOLLAR money null;
end -- if;
GO

-- 09/07/2010 Paul.  Make sure that the PAYMENTS_AUDIT table exists before trying to add the field. 
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PAYMENTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_AUDIT' and COLUMN_NAME = 'BANK_FEE') begin -- then
		print 'alter table PAYMENTS_AUDIT add BANK_FEE money null';
		alter table PAYMENTS_AUDIT add BANK_FEE money null;
	end -- if;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PAYMENTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_AUDIT' and COLUMN_NAME = 'BANK_FEE_USDOLLAR') begin -- then
		print 'alter table PAYMENTS_AUDIT add BANK_FEE_USDOLLAR money null';
		alter table PAYMENTS_AUDIT add BANK_FEE_USDOLLAR money null;
	end -- if;
end -- if;
GO

-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'B2C_CONTACT_ID') begin -- then
	print 'alter table PAYMENTS add B2C_CONTACT_ID uniqueidentifier null';
	alter table PAYMENTS add B2C_CONTACT_ID uniqueidentifier null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PAYMENTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_AUDIT' and COLUMN_NAME = 'B2C_CONTACT_ID') begin -- then
		print 'alter table PAYMENTS_AUDIT add B2C_CONTACT_ID uniqueidentifier null';
		alter table PAYMENTS_AUDIT add B2C_CONTACT_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table PAYMENTS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table PAYMENTS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_PAYMENTS_ASSIGNED_SET_ID on dbo.PAYMENTS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PAYMENTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PAYMENTS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table PAYMENTS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table PAYMENTS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

