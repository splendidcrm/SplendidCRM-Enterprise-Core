
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
-- 09/05/2015 Paul.  Google now uses OAuth 2.0. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OAUTH_TOKENS' and COLUMN_NAME = 'TOKEN_EXPIRES_AT') begin -- then
	print 'alter table OAUTH_TOKENS add TOKEN_EXPIRES_AT datetime null';
	alter table OAUTH_TOKENS add TOKEN_EXPIRES_AT datetime null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OAUTH_TOKENS' and COLUMN_NAME = 'REFRESH_TOKEN') begin -- then
	print 'alter table OAUTH_TOKENS add REFRESH_TOKEN nvarchar(2000) null';
	alter table OAUTH_TOKENS add REFRESH_TOKEN nvarchar(2000) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OAUTH_TOKENS' and COLUMN_NAME = 'NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table OAUTH_TOKENS alter column NAME nvarchar(50) null';
	alter table OAUTH_TOKENS alter column NAME nvarchar(50) null;
end -- if;
GO

-- 01/19/2017 Paul.  The Microsoft OAuth token can be large, but less than 2000 bytes. 
-- 12/02/2020 Paul.  The Microsoft OAuth token is now about 2400, so increase to 4000 characters.
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OAUTH_TOKENS' and COLUMN_NAME = 'TOKEN' and CHARACTER_MAXIMUM_LENGTH < 4000) begin -- then
	print 'alter table OAUTH_TOKENS alter column TOKEN nvarchar(4000) null';
	alter table OAUTH_TOKENS alter column TOKEN nvarchar(4000) null;
end -- if;
GO

-- 01/19/2017 Paul.  The Microsoft OAuth token can be large, but less than 2000 bytes. 
-- 12/02/2020 Paul.  The Microsoft OAuth token is now about 2400, so increase to 4000 characters.
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'OAUTH_TOKENS' and COLUMN_NAME = 'REFRESH_TOKEN' and CHARACTER_MAXIMUM_LENGTH < 4000) begin -- then
	print 'alter table OAUTH_TOKENS alter column REFRESH_TOKEN nvarchar(4000) null';
	alter table OAUTH_TOKENS alter column REFRESH_TOKEN nvarchar(4000) null;
end -- if;
GO

