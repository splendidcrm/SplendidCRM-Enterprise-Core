
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
-- 07/16/2005 Paul.  Version 3.0.1 increased the size of the NEXT_STEP field. 
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/25/2007 Paul.  CAMPAIGN_ID was added in SugarCRM 4.5.1
-- 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'NEXT_STEP' and CHARACTER_MAXIMUM_LENGTH <> 100) begin -- then
	print 'alter table OPPORTUNITIES alter column NEXT_STEP nvarchar(100) null';
	alter table OPPORTUNITIES alter column NEXT_STEP nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table OPPORTUNITIES add TEAM_ID uniqueidentifier null';
	alter table OPPORTUNITIES add TEAM_ID uniqueidentifier null;

	create index IDX_OPPORTUNITIES_TEAM_ID on dbo.OPPORTUNITIES (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'CAMPAIGN_ID') begin -- then
	print 'alter table OPPORTUNITIES add CAMPAIGN_ID uniqueidentifier null';
	alter table OPPORTUNITIES add CAMPAIGN_ID uniqueidentifier null;

	create index IDX_OPPORTUNITIES_CAMPAIGN_ID on dbo.OPPORTUNITIES (CAMPAIGN_ID, SALES_STAGE, DELETED, AMOUNT)
end -- if;
GO

-- 04/21/2008 Paul.  SugarCRM 5.0 dropped AMOUNT_BACKUP.  We will eventually do the same. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'AMOUNT_BACKUP') begin -- then
	print 'alter table OPPORTUNITIES add AMOUNT_BACKUP nvarchar(25) null';
	alter table OPPORTUNITIES add AMOUNT_BACKUP nvarchar(25) null;
end -- if;
GO

-- 08/21/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table OPPORTUNITIES add TEAM_SET_ID uniqueidentifier null';
	alter table OPPORTUNITIES add TEAM_SET_ID uniqueidentifier null;

	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_OPPORTUNITIES_TEAM_SET_ID on dbo.OPPORTUNITIES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
end -- if;
GO

-- 08/21/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table OPPORTUNITIES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table OPPORTUNITIES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

-- 10/05/2010 Paul.  Increase the size of the NAME field. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
	print 'alter table OPPORTUNITIES alter column NAME nvarchar(150) null';
	alter table OPPORTUNITIES alter column NAME nvarchar(150) null;
end -- if;
GO

-- 10/20/2010 Paul.  Increase the size of the NAME field in the audit table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES_AUDIT') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES_AUDIT' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 150) begin -- then
		print 'alter table OPPORTUNITIES_AUDIT alter column NAME nvarchar(150) null';
		alter table OPPORTUNITIES_AUDIT alter column NAME nvarchar(150) null;
	end -- if;
end -- if;
GO

-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'B2C_CONTACT_ID') begin -- then
	print 'alter table OPPORTUNITIES add B2C_CONTACT_ID uniqueidentifier null';
	alter table OPPORTUNITIES add B2C_CONTACT_ID uniqueidentifier null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OPPORTUNITIES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES_AUDIT' and COLUMN_NAME = 'B2C_CONTACT_ID') begin -- then
		print 'alter table OPPORTUNITIES_AUDIT add B2C_CONTACT_ID uniqueidentifier null';
		alter table OPPORTUNITIES_AUDIT add B2C_CONTACT_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

-- 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'OPPORTUNITY_NUMBER') begin -- then
	print 'alter table OPPORTUNITIES add OPPORTUNITY_NUMBER nvarchar(30) null';
	alter table OPPORTUNITIES add OPPORTUNITY_NUMBER nvarchar(30) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OPPORTUNITIES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES_AUDIT' and COLUMN_NAME = 'OPPORTUNITY_NUMBER') begin -- then
		print 'alter table OPPORTUNITIES_AUDIT add OPPORTUNITY_NUMBER nvarchar(30) null';
		alter table OPPORTUNITIES_AUDIT add OPPORTUNITY_NUMBER nvarchar(30) null;
	end -- if;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table OPPORTUNITIES add ASSIGNED_SET_ID uniqueidentifier null';
	alter table OPPORTUNITIES add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_OPPORTUNITIES_ASSIGNED_SET_ID on dbo.OPPORTUNITIES (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OPPORTUNITIES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OPPORTUNITIES_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table OPPORTUNITIES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table OPPORTUNITIES_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

