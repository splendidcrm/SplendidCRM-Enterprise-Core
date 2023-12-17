
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
-- 04/21/2006 Paul.  INBOUND_EMAIL_ID was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  STATUS was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  ALL_PROSPECT_LISTS was added in SugarCRM 4.0.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_MARKETING' and COLUMN_NAME = 'INBOUND_EMAIL_ID') begin -- then
	print 'alter table EMAIL_MARKETING add INBOUND_EMAIL_ID uniqueidentifier null';
	alter table EMAIL_MARKETING add INBOUND_EMAIL_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_MARKETING' and COLUMN_NAME = 'STATUS') begin -- then
	print 'alter table EMAIL_MARKETING add STATUS nvarchar(25) null';
	alter table EMAIL_MARKETING add STATUS nvarchar(25) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_MARKETING' and COLUMN_NAME = 'ALL_PROSPECT_LISTS') begin -- then
	print 'alter table EMAIL_MARKETING add ALL_PROSPECT_LISTS bit null default(0)';
	alter table EMAIL_MARKETING add ALL_PROSPECT_LISTS bit null default(0);
end -- if;
GO

-- 04/21/2008 Paul.  SugarCRM 5.0 has dropped TIME_START and combined it with DATE_START. 
-- We did this long ago, but we kept the use of TIME_START for compatibility with MySQL. 
-- We will eventually duplicate this behavior, but not now.  Add the fields if missing. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_MARKETING' and COLUMN_NAME = 'TIME_START') begin -- then
	print 'alter table EMAIL_MARKETING add TIME_START datetime null';
	alter table EMAIL_MARKETING add TIME_START datetime null;
end -- if;
GO

-- 01/23/2013 Paul.  Add REPLY_TO_NAME and REPLY_TO_ADDR. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_MARKETING' and COLUMN_NAME = 'REPLY_TO_NAME') begin -- then
	print 'alter table EMAIL_MARKETING add REPLY_TO_NAME nvarchar(100) null';
	alter table EMAIL_MARKETING add REPLY_TO_NAME nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_MARKETING' and COLUMN_NAME = 'REPLY_TO_ADDR') begin -- then
	print 'alter table EMAIL_MARKETING add REPLY_TO_ADDR nvarchar(100) null';
	alter table EMAIL_MARKETING add REPLY_TO_ADDR nvarchar(100) null;
end -- if;
GO

