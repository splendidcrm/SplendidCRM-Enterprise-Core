
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
-- 10/07/2010 Paul.  Add Contact field. 
-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS' and COLUMN_NAME = 'CONTACT_ID') begin -- then
	print 'alter table CREDIT_CARDS add CONTACT_ID uniqueidentifier null';
	alter table CREDIT_CARDS add CONTACT_ID uniqueidentifier null;
end -- if;
GO

-- 08/16/2015 Paul.  We also need to change the field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT' and COLUMN_NAME = 'CONTACT_ID') begin -- then
		print 'alter table CREDIT_CARDS_AUDIT add CONTACT_ID uniqueidentifier null';
		alter table CREDIT_CARDS_AUDIT add CONTACT_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

-- 04/16/2013 Paul.  ACCOUNT_ID should be nullable so that CRM can be used for B2C. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS' and COLUMN_NAME = 'ACCOUNT_ID' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table CREDIT_CARDS alter column ACCOUNT_ID uniqueidentifier null';
	alter table CREDIT_CARDS alter column ACCOUNT_ID uniqueidentifier null;
end -- if;
GO

-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS' and COLUMN_NAME = 'CARD_TOKEN') begin -- then
	print 'alter table CREDIT_CARDS add CARD_TOKEN nvarchar(50) null';
	alter table CREDIT_CARDS add CARD_TOKEN nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT' and COLUMN_NAME = 'CARD_TOKEN') begin -- then
		print 'alter table CREDIT_CARDS_AUDIT add CARD_TOKEN nvarchar(50) null';
		alter table CREDIT_CARDS_AUDIT add CARD_TOKEN nvarchar(50) null;
	end -- if;

end -- if;
GO

-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS' and COLUMN_NAME = 'EMAIL') begin -- then
	print 'alter table CREDIT_CARDS add EMAIL nvarchar(100) null';
	alter table CREDIT_CARDS add EMAIL nvarchar(100) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT' and COLUMN_NAME = 'EMAIL') begin -- then
		print 'alter table CREDIT_CARDS_AUDIT add EMAIL nvarchar(100) null';
		alter table CREDIT_CARDS_AUDIT add EMAIL nvarchar(100) null;
	end -- if;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS' and COLUMN_NAME = 'PHONE') begin -- then
	print 'alter table CREDIT_CARDS add PHONE nvarchar(25) null';
	alter table CREDIT_CARDS add PHONE nvarchar(25) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'CREDIT_CARDS_AUDIT' and COLUMN_NAME = 'PHONE') begin -- then
		print 'alter table CREDIT_CARDS_AUDIT add PHONE nvarchar(25) null';
		alter table CREDIT_CARDS_AUDIT add PHONE nvarchar(25) null;
	end -- if;
end -- if;
GO

