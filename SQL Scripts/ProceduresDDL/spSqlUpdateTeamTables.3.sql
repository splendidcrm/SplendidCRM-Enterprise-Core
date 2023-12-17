if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlUpdateTeamTables' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlUpdateTeamTables;
GO


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
Create Procedure dbo.spSqlUpdateTeamTables
as
  begin
	set nocount on
	print N'spSqlUpdateTeamTables';

	declare @Command    varchar(2000);
	declare @TABLE_NAME varchar(80);
	declare @TEST       bit;

	-- 08/20/2009 Paul.  Cursors are global, so we need to use a different name to prevent redefinition
	-- due to cursor in spSqlBuildAllAuditTables. 
	-- 09/08/2012 Paul.  Exclude CALL_MARKETING because the TEAM_ID field is used for something else. 
	-- 02/04/2013 Paul.  Some customers have views that don't start with vw, so make sure that it is a table. 
	-- 09/30/2015 Paul.  Stream tables should not be included. 
	declare TEAM_TABLES_CURSOR cursor for
	select COLUMNS.TABLE_NAME
	  from      INFORMATION_SCHEMA.COLUMNS  COLUMNS
	 inner join INFORMATION_SCHEMA.TABLES   TABLES
	         on TABLES.TABLE_NAME         = COLUMNS.TABLE_NAME
	 where TABLES.TABLE_TYPE   = 'BASE TABLE'
	   and COLUMNS.COLUMN_NAME = 'TEAM_ID'
	   and COLUMNS.TABLE_NAME not like 'vw%'
	   and COLUMNS.TABLE_NAME not like '%_TEAMS'
	   and COLUMNS.TABLE_NAME not like '%_AUDIT'
	   and COLUMNS.TABLE_NAME not like '%_STREAM'
	   and COLUMNS.TABLE_NAME not in ('CALL_MARKETING', 'DASHBOARDS', 'TEAM_MEMBERSHIPS', 'TEAM_NOTICES')
	 order by COLUMNS.TABLE_NAME;

	set @TEST = 0;
	open TEAM_TABLES_CURSOR;
	fetch next from TEAM_TABLES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TABLE_NAME and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
			set @Command = 'alter table ' + @TABLE_NAME + ' add TEAM_SET_ID uniqueidentifier null';
			print @Command + ';';
			if @TEST = 0 begin -- then
				exec (@Command);
			end -- if;
			-- 08/31/2009 Paul.  Also create the index on the team set. 
			if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TABLE_NAME and COLUMN_NAME = 'ASSIGNED_USER_ID') begin -- then
				set @Command = 'create index IDX_' + @TABLE_NAME + '_TEAM_SET_ID on dbo.' + @TABLE_NAME + ' (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)';
				print @Command + ';';
				if @TEST = 0 begin -- then
					exec (@Command);
				end -- if;
			end else begin
				set @Command = 'create index IDX_' + @TABLE_NAME + '_TEAM_SET_ID on dbo.' + @TABLE_NAME + ' (TEAM_SET_ID, DELETED, ID)';
				print @Command + ';';
				if @TEST = 0 begin -- then
					exec (@Command);
				end -- if;
			end -- if;
		end -- if;
		fetch next from TEAM_TABLES_CURSOR into @TABLE_NAME;
	end -- while;
	close TEAM_TABLES_CURSOR;
	deallocate TEAM_TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlUpdateTeamTables to public;
GO

-- exec dbo.spSqlUpdateTeamTables;



