
	set nocount on;

	declare @Command       varchar(2000);
	declare @TABLE_NAME    varchar(80);
	declare @COLUMN_NAME   varchar(40);
	declare @SINGULAR_NAME varchar(80);
	declare @CRLF          char(2);
	declare @TEST          bit;
	declare @PRINT         bit;
	/* -- #if IBM_DB2
	declare in_FETCH_STATUS int;
	-- #endif IBM_DB2 */

/* -- #if Oracle
	StoO_fetchstatus Number Default 0;
	StoO_sqlstatus   Number Default 0;
	StoO_errmsg      varchar2(255);
	cursor TEAM_TABLES_CURSOR is
	select TABLE_NAME
	  from USER_TAB_COLUMNS
	 where COLUMN_NAME = 'TEAM_ID'
	   and TABLE_NAME not like 'vw%'
	   and TABLE_NAME not like '%_TEAMS'
	   and TABLE_NAME not like '%_AUDIT'
	   and TABLE_NAME not in ('DASHBOARDS', 'TEAM_MEMBERSHIPS', 'TEAM_NOTICES')
	 order by TABLE_NAME;
BEGIN
	BEGIN
-- #endif Oracle */

-- #if SQL_Server /*
	print 'TEAMS UpdateDynamic';
	-- 08/20/2009 Paul.  Cursors are global, so we need to use a different name to prevent redefinition
	-- due to cursor in spSqlBuildAllAuditTables. 
	-- 09/30/2012 Paul.  CALL_MARKETING is a new table with a TEAM_ID but not a TEAM_SET_ID. 
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
-- #endif SQL_Server */

	/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
	-- #endif IBM_DB2 */

	set @TEST  = 0;
	set @PRINT = 1;
	set @CRLF = char(13) + char(10);
	open TEAM_TABLES_CURSOR;
	fetch next from TEAM_TABLES_CURSOR into @TABLE_NAME;
/* -- #if Oracle
	IF TEAM_TABLES_CURSOR%NOTFOUND THEN
		StoO_sqlstatus := 2;
		StoO_fetchstatus := -1;
	ELSE
		StoO_sqlstatus := 0;
		StoO_fetchstatus := 0;
	END IF;
-- #endif Oracle */
	while @@FETCH_STATUS = 0 begin -- do
		set @SINGULAR_NAME = dbo.fnModuleSingularName(@TABLE_NAME);
		
		-- 02/18/2010 Paul.  Disable triggers before converting to team sets.
		exec dbo.spSqlTableDisableTriggers @TABLE_NAME;
		
		-- 08/23/2009 Paul.  First correct any invalid team IDs.  
		set @Command = 'update ' + @TABLE_NAME + ' set TEAM_ID = null where DELETED = 0 and TEAM_ID = ''00000000-0000-0000-0000-000000000000''' + ';' + @CRLF;
		if @TEST = 0 begin -- then
			exec (@Command);
		end else begin
			print @Command;
		end -- if;
		
		-- 08/23/2009 Paul.  Create a team set for each existing team. 
		-- 05/13/2012 Paul.  We are getting a conversion error, so lets convert to char(36) instead of to uniqueidentifier. 
		set @Command = '';
		set @Command = @Command + 'insert into TEAM_SETS ( ID, DATE_ENTERED, DATE_MODIFIED, TEAM_SET_LIST, TEAM_SET_NAME )' + @CRLF;
		set @Command = @Command + 'select newid(), getdate(), getdate(), cast(ID as char(36)), NAME' + @CRLF;
		set @Command = @Command + '  from TEAMS' + @CRLF;
		set @Command = @Command + ' where DELETED = 0' + @CRLF;
		set @Command = @Command + '   and cast(ID as char(36)) not in (select TEAM_SET_LIST from TEAM_SETS where len(TEAM_SET_LIST) = 36)' + ';' + @CRLF + @CRLF;
		if @TEST = 0 begin -- then
			exec (@Command);
		end else begin
			print @Command;
		end -- if;

		set @Command = '';
		set @Command = @Command + 'insert into TEAM_SETS_TEAMS ( ID, DATE_ENTERED, DATE_MODIFIED, TEAM_SET_ID, TEAM_ID, PRIMARY_TEAM )' + @CRLF;
		set @Command = @Command + 'select newid(), getdate(), getdate(), ID, cast(TEAM_SET_LIST as uniqueidentifier), 1' + @CRLF;
		set @Command = @Command + '  from TEAM_SETS' + @CRLF;
		set @Command = @Command + ' where len(TEAM_SET_LIST) = 36' + @CRLF;
		set @Command = @Command + '   and ID not in (select TEAM_SET_ID from TEAM_SETS_TEAMS)' + @CRLF;
		-- 07/26/2017 Paul.  Need to make sure that the TEAM_ID is valid. 
		set @Command = @Command + '   and TEAM_SET_LIST in (select cast(ID as char(36)) from TEAMS)' + ';' + @CRLF + @CRLF;
		if @TEST = 0 begin -- then
			exec (@Command);
		end else begin
			print @Command;
		end -- if;

		-- 08/23/2009 Paul.  A team set was created for each team, so now we can update the team set ID in the module table. 
		-- 07/23/2017 Paul.  Make sure that the TEAM_SET_ID field exists. 
		if exists(select * from vwSqlColumns where ObjectName = @TABLE_NAME and ColumnName = 'TEAM_SET_ID') begin -- then
			set @Command = '';
			set @Command = @Command + 'update ' + @TABLE_NAME + @CRLF;
			-- 10/28/2009 Paul.  Although there should not be duplicate entries in the TEAM_SETS table, we did encounter this on a development database. 
			-- 05/13/2012 Paul.  TEAM_ID needs to be converted to char(36). 
			set @Command = @Command + '   set TEAM_SET_ID = (select top 1 ID from TEAM_SETS where TEAM_SET_LIST = cast(' + @TABLE_NAME + '.TEAM_ID as char(36)))' + @CRLF;
			set @Command = @Command + ' where DELETED = 0' + @CRLF;
			set @Command = @Command + '   and TEAM_ID is not null' + @CRLF;
			set @Command = @Command + '   and TEAM_SET_ID is null' + ';' + @CRLF + @CRLF;
			if @TEST = 0 begin -- then
				exec (@Command);
			end else begin
				print @Command;
			end -- if;
		end -- if;

		-- 02/18/2010 Paul.  Restore triggers now that we are done.
		exec dbo.spSqlTableEnableTriggers @TABLE_NAME;

		fetch next from TEAM_TABLES_CURSOR into @TABLE_NAME;
/* -- #if Oracle
		IF TEAM_TABLES_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close TEAM_TABLES_CURSOR;
	deallocate TEAM_TABLES_CURSOR;

	/*
	-- 08/28/2009 Paul.  Instead of converting the records, just use the dynamic teams flag to convert at runtime. 
	if exists(select * from DETAILVIEWS_FIELDS where DATA_LABEL = 'Teams.LBL_TEAM' and DATA_FIELD = 'TEAM_NAME' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS converting to Dynamic Teams.';
		update DETAILVIEWS_FIELDS
		   set DATA_LABEL       = '.LBL_TEAM_SET_NAME'
		     , DATA_FIELD       = 'TEAM_SET_NAME'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where DATA_LABEL       = 'Teams.LBL_TEAM'
		   and DATA_FIELD       = 'TEAM_NAME'
		   and DELETED          = 0;
	end -- if;
	*/

	/*
	-- 08/28/2009 Paul.  Instead of converting the records, just use the dynamic teams flag to convert at runtime. 
	if exists(select * from GRIDVIEWS_COLUMNS where HEADER_TEXT = 'Teams.LBL_LIST_TEAM' and DATA_FIELD = 'TEAM_NAME' and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS converting to Dynamic Teams.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = '.LBL_LIST_TEAM_SET_NAME'
		     , DATA_FIELD       = 'TEAM_SET_NAME'
		     , SORT_EXPRESSION  = 'TEAM_SET_NAME'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where HEADER_TEXT      = 'Teams.LBL_LIST_TEAM'
		   and DATA_FIELD       = 'TEAM_NAME'
		   and DELETED          = 0;
	end -- if;
	*/

	/*
	-- 08/24/2009 Paul.  Convert all team change buttons to the new TeamSelect control. 
	-- 08/28/2009 Paul.  Instead of converting the records, just use the dynamic teams flag to convert at runtime. 
	if exists(select * from EDITVIEWS_FIELDS where (EDIT_NAME like '%.EditView%' or EDIT_NAME like '%.ConvertView') and DATA_FIELD = 'TEAM_ID' and FIELD_TYPE = 'ChangeButton' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS converting to Dynamic Teams.';
		update EDITVIEWS_FIELDS
		   set DATA_LABEL       = '.LBL_TEAM_SET_NAME'
		     , DATA_FIELD       = 'TEAM_SET_NAME'
		     , FIELD_TYPE       = 'TeamSelect'
		     , DISPLAY_FIELD    = null
		     , ONCLICK_SCRIPT   = null
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where (EDIT_NAME like '%.EditView%' or EDIT_NAME like '%.ConvertView')
		   and DATA_FIELD       = 'TEAM_ID'
		   and FIELD_TYPE       = 'ChangeButton'
		   and DELETED          = 0;
	end -- if;
	*/

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTEAMS_UpdateDynamic()
/

call dbo.spSqlDropProcedure('spTEAMS_UpdateDynamic')
/

-- #endif IBM_DB2 */

