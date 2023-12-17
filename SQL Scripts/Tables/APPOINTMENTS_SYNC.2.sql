
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
-- 07/24/2010 Paul.  Instead of managing collation in code, it is better to change the collation on the field in the database. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'APPOINTMENTS_SYNC' and COLUMN_NAME = 'REMOTE_KEY' and COLLATION_NAME = 'SQL_Latin1_General_CP1_CI_AS') begin -- then
	print 'alter table APPOINTMENTS_SYNC alter column REMOTE_KEY varchar(800) collate SQL_Latin1_General_CP1_CS_AS not null';

	if exists (select * from sys.indexes where name = 'IDX_APPOINTMENTS_SYNC_REMOTE_KEY') begin -- then
		drop index IDX_APPOINTMENTS_SYNC_REMOTE_KEY on APPOINTMENTS_SYNC;
	end -- if;

	alter table APPOINTMENTS_SYNC alter column REMOTE_KEY varchar(800) collate SQL_Latin1_General_CP1_CS_AS not null;

	create index IDX_APPOINTMENTS_SYNC_REMOTE_KEY on dbo.APPOINTMENTS_SYNC (ASSIGNED_USER_ID, DELETED, REMOTE_KEY, LOCAL_ID);
end -- if;
GO

-- 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'APPOINTMENTS_SYNC' and COLUMN_NAME = 'SERVICE_NAME') begin -- then
	print 'alter table APPOINTMENTS_SYNC alter column SERVICE_NAME nvarchar(25) null';

	if exists (select * from sys.indexes where name = 'IDX_APPOINTMENTS_SYNC_REMOTE_KEY') begin -- then
		drop index IDX_APPOINTMENTS_SYNC_REMOTE_KEY on APPOINTMENTS_SYNC;
	end -- if;

	alter table APPOINTMENTS_SYNC add SERVICE_NAME nvarchar(25) null;

	create index IDX_APPOINTMENTS_SYNC_REMOTE_KEY on dbo.APPOINTMENTS_SYNC (ASSIGNED_USER_ID, DELETED, SERVICE_NAME, REMOTE_KEY, LOCAL_ID);

	exec('update APPOINTMENTS_SYNC
	   set SERVICE_NAME      = (case when REMOTE_KEY like ''http://www.google.com/%'' then ''Google'' else ''Exchange'' end)
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where SERVICE_NAME is null
	   and DELETED = 0');
end -- if;
GO

-- 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'APPOINTMENTS_SYNC' and COLUMN_NAME = 'RAW_CONTENT') begin -- then
	print 'alter table APPOINTMENTS_SYNC alter column RAW_CONTENT nvarchar(max) null';
	alter table APPOINTMENTS_SYNC add RAW_CONTENT nvarchar(max) null;
end -- if;
GO

