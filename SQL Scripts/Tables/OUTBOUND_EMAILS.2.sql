
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
-- 07/16/2013 Paul.  USER_ID should be nullable so that table can contain system email accounts. 
-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OUTBOUND_EMAILS' and COLUMN_NAME = 'USER_ID' and IS_NULLABLE = 'NO') begin -- then
	print 'alter table OUTBOUND_EMAILS alter column USER_ID uniqueidentifier null';
	alter table OUTBOUND_EMAILS alter column USER_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OUTBOUND_EMAILS' and COLUMN_NAME = 'FROM_NAME') begin -- then
	print 'alter table OUTBOUND_EMAILS add FROM_NAME nvarchar(100) null';
	alter table OUTBOUND_EMAILS add FROM_NAME nvarchar(100) null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OUTBOUND_EMAILS' and COLUMN_NAME = 'FROM_ADDR') begin -- then
	print 'alter table OUTBOUND_EMAILS add FROM_ADDR nvarchar(100) null';
	alter table OUTBOUND_EMAILS add FROM_ADDR nvarchar(100) null;
end -- if;
GO

-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OUTBOUND_EMAILS' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table OUTBOUND_EMAILS add TEAM_ID uniqueidentifier null';
	alter table OUTBOUND_EMAILS add TEAM_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OUTBOUND_EMAILS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table OUTBOUND_EMAILS add TEAM_SET_ID uniqueidentifier null';
	alter table OUTBOUND_EMAILS add TEAM_SET_ID uniqueidentifier null;
end -- if;
GO

-- 01/17/2017 Paul.  Increase size of @MAIL_SENDTYPE to fit office365. 
-- 11/07/2017 Paul.  Correct max test. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OUTBOUND_EMAILS' and COLUMN_NAME = 'MAIL_SENDTYPE' and CHARACTER_MAXIMUM_LENGTH < 25) begin -- then
	print 'alter table OUTBOUND_EMAILS alter column MAIL_SENDTYPE nvarchar(25) null';
	alter table OUTBOUND_EMAILS alter column MAIL_SENDTYPE nvarchar(25) null;
end -- if;
GO

