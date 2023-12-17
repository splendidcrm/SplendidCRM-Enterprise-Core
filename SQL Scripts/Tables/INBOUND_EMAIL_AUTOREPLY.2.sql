
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
-- 01/13/2008 Paul.  Add the reply name so that this lis can be used by the email manager. 
-- 09/15/2009 Paul.  Use new syntax to drop an index. 
-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'INBOUND_EMAIL_AUTOREPLY' and COLUMN_NAME = 'AUTOREPLIED_NAME') begin -- then
	print 'alter table INBOUND_EMAIL_AUTOREPLY add AUTOREPLIED_NAME nvarchar(100) null';
	alter table INBOUND_EMAIL_AUTOREPLY add AUTOREPLIED_NAME nvarchar(100) null;
end -- if;
GO

if exists (select * from sys.indexes where name = 'IDX_INBOUND_EMAIL_AUTOREPLY_TO') begin -- then
	print 'drop index IDX_INBOUND_EMAIL_AUTOREPLY_TO';
	drop index IDX_INBOUND_EMAIL_AUTOREPLY_TO on INBOUND_EMAIL_AUTOREPLY;
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_INBOUND_EMAIL') begin -- then
	-- drop index IDX_INBOUND_EMAIL on dbo.INBOUND_EMAIL_AUTOREPLY;
	print 'create index IDX_INBOUND_EMAIL';
	create index IDX_INBOUND_EMAIL on dbo.INBOUND_EMAIL_AUTOREPLY (AUTOREPLIED_TO, DATE_ENTERED, DELETED, AUTOREPLIED_NAME);
end -- if;
GO

