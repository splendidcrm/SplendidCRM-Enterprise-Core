
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
-- 09/14/2011 Paul.  We don't need to audit the EXCHANGE_USERS table.  It is getting very big with all the watermarks. 
if exists (select * from sys.objects where name = 'trEXCHANGE_USERS_Ins_AUDIT' and type = 'TR') begin -- then
	print 'Drop Trigger dbo.trEXCHANGE_USERS_Ins_AUDIT';
	Drop Trigger dbo.trEXCHANGE_USERS_Ins_AUDIT;
end -- if;

if exists (select * from sys.objects where name = 'trEXCHANGE_USERS_Upd_AUDIT' and type = 'TR') begin -- then
	print 'Drop Trigger dbo.trEXCHANGE_USERS_Upd_AUDIT';
	Drop Trigger dbo.trEXCHANGE_USERS_Upd_AUDIT;
end -- if;

if exists (select * from sys.objects where name = 'trEXCHANGE_USERS_Del_AUDIT' and type = 'TR') begin -- then
	print 'Drop Trigger dbo.trEXCHANGE_USERS_Del_AUDIT';
	Drop Trigger dbo.trEXCHANGE_USERS_Del_AUDIT;
end -- if;

if exists (select * from sys.objects where name = 'trEXCHANGE_USERS_AUDIT_Ins_WORK' and type = 'TR') begin -- then
	print 'Drop Trigger dbo.trEXCHANGE_USERS_AUDIT_Ins_WORK';
	Drop Trigger dbo.trEXCHANGE_USERS_AUDIT_Ins_WORK;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EXCHANGE_USERS_AUDIT') begin -- then
	print 'Drop Table dbo.EXCHANGE_USERS_AUDIT';
	Drop Table dbo.EXCHANGE_USERS_AUDIT;
end -- if;
GO

