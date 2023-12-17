
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
-- 04/21/2006 Paul.  RELATED_ID was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  RELATED_TYPE was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  PROSPECT_ID was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  CONTACT_ID was dropped in SugarCRM 4.0.
-- 04/21/2006 Paul.  LEAD_ID was dropped in SugarCRM 4.0.
-- 09/15/2009 Paul.  Use new syntax to drop an index. 
-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROSPECT_LISTS_PROSPECTS' and COLUMN_NAME = 'RELATED_ID') begin -- then
	print 'alter table PROSPECT_LISTS_PROSPECTS add RELATED_ID uniqueidentifier null';
	alter table PROSPECT_LISTS_PROSPECTS add RELATED_ID   uniqueidentifier null;
	alter table PROSPECT_LISTS_PROSPECTS add RELATED_TYPE nvarchar(25) null;

	create index IDX_PROSPECT_LISTS_PROSPECTS_RELATED on dbo.PROSPECT_LISTS_PROSPECTS (RELATED_ID, RELATED_TYPE);
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROSPECT_LISTS_PROSPECTS' and COLUMN_NAME = 'PROSPECT_ID') begin -- then
	print 'alter table PROSPECT_LISTS_PROSPECTS drop column PROSPECT_ID';
	execute ('update PROSPECT_LISTS_PROSPECTS set RELATED_ID = PROSPECT_ID, RELATED_TYPE = ''Prospects'' where PROSPECT_ID is not null');

	alter table dbo.PROSPECT_LISTS_PROSPECTS drop constraint FK_PROSPECT_LISTS_PROSPECTS_PROSPECT_ID;
	if exists (select * from sys.indexes where name = 'IDX_PROSPECT_LISTS_PROSPECTS_PROSPECT_ID') begin -- then
		drop index IDX_PROSPECT_LISTS_PROSPECTS_PROSPECT_ID on PROSPECT_LISTS_PROSPECTS;
	end -- if;
	alter table PROSPECT_LISTS_PROSPECTS drop column PROSPECT_ID;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROSPECT_LISTS_PROSPECTS' and COLUMN_NAME = 'CONTACT_ID') begin -- then
	print 'alter table PROSPECT_LISTS_PROSPECTS drop column CONTACT_ID';
	execute ('update PROSPECT_LISTS_PROSPECTS set RELATED_ID = CONTACT_ID , RELATED_TYPE = ''Contacts'' where CONTACT_ID is not null');

	alter table dbo.PROSPECT_LISTS_PROSPECTS drop constraint FK_PROSPECT_LISTS_PROSPECTS_CONTACT_ID ;
	if exists (select * from sys.indexes where name = 'IDX_PROSPECT_LISTS_PROSPECTS_CONTACT_ID') begin -- then
		drop index IDX_PROSPECT_LISTS_PROSPECTS_CONTACT_ID on PROSPECT_LISTS_PROSPECTS;
	end -- if;
	alter table PROSPECT_LISTS_PROSPECTS drop column CONTACT_ID;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'PROSPECT_LISTS_PROSPECTS' and COLUMN_NAME = 'LEAD_ID') begin -- then
	print 'alter table PROSPECT_LISTS_PROSPECTS drop column LEAD_ID';
	execute ('update PROSPECT_LISTS_PROSPECTS set RELATED_ID = LEAD_ID, RELATED_TYPE = ''Leads'' where LEAD_ID is not null');

	alter table dbo.PROSPECT_LISTS_PROSPECTS drop constraint FK_PROSPECT_LISTS_PROSPECTS_LEAD_ID    ;
	if exists (select * from sys.indexes where name = 'IDX_PROSPECT_LISTS_PROSPECTS_LEAD_ID') begin -- then
		drop index IDX_PROSPECT_LISTS_PROSPECTS_LEAD_ID on PROSPECT_LISTS_PROSPECTS;
	end -- if;
	alter table PROSPECT_LISTS_PROSPECTS drop column LEAD_ID;
end -- if;
GO


