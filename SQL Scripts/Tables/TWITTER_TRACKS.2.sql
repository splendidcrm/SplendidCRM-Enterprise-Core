
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
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

-- 11/10/2017 Paul.  Twitter increased display name to 50. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_TRACKS' and COLUMN_NAME = 'TWITTER_SCREEN_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_TRACKS alter column TWITTER_SCREEN_NAME nvarchar(50) null';
	alter table TWITTER_TRACKS alter column TWITTER_SCREEN_NAME nvarchar(50) null;
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_TRACKS_AUDIT' and COLUMN_NAME = 'TWITTER_SCREEN_NAME' and CHARACTER_MAXIMUM_LENGTH < 50) begin -- then
	print 'alter table TWITTER_TRACKS_AUDIT alter column TWITTER_SCREEN_NAME nvarchar(50) null';
	alter table TWITTER_TRACKS_AUDIT alter column TWITTER_SCREEN_NAME nvarchar(50) null;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_TRACKS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table TWITTER_TRACKS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table TWITTER_TRACKS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_TWITTER_TRACKS_ASSIGNED_SET_ID on dbo.TWITTER_TRACKS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TWITTER_TRACKS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TWITTER_TRACKS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table TWITTER_TRACKS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table TWITTER_TRACKS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

