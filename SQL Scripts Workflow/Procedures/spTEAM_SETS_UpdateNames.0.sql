if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_SETS_UpdateNames' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_SETS_UpdateNames;
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
Create Procedure dbo.spTEAM_SETS_UpdateNames
	( @MODIFIED_USER_ID     uniqueidentifier
	, @TEAM_ID              uniqueidentifier
	)
as
  begin
	set nocount on

	declare @TEAM_SET_ID          uniqueidentifier;
	declare @NORMAL_TEAM_SET_LIST varchar(851);
	declare @NORMAL_TEAM_SET_NAME nvarchar(200);
-- #if SQL_Server /*
	declare @TEMP_TEAMS table
		( ID           uniqueidentifier not null primary key
		, PRIMARY_TEAM bit not null default(0)
		, NAME         nvarchar(128) not null
		);
-- #endif SQL_Server */

	declare team_set_cursor cursor for
	select TEAM_SET_ID
	  from TEAM_SETS_TEAMS
	 where DELETED = 0
	   and TEAM_ID = @TEAM_ID;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	open team_set_cursor;
	fetch next from team_set_cursor into @TEAM_SET_ID;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		insert into @TEMP_TEAMS ( ID, PRIMARY_TEAM, NAME)
		select TEAM_SETS_TEAMS.TEAM_ID
		     , TEAM_SETS_TEAMS.PRIMARY_TEAM
		     , TEAMS.NAME
		  from      TEAM_SETS_TEAMS
		 inner join TEAMS
		         on TEAMS.ID      = TEAM_SETS_TEAMS.TEAM_ID
		        and TEAMS.DELETED = 0
		 where TEAM_SETS_TEAMS.TEAM_SET_ID = @TEAM_SET_ID
		   and TEAM_SETS_TEAMS.DELETED     = 0;
		
		set @NORMAL_TEAM_SET_LIST =  '';
		set @NORMAL_TEAM_SET_NAME = N'';
		-- 08/22/2009 Paul.  Order the ID list by the IDs of the teams, with the primary going first.
		-- 08/23/2009 Paul.  There is no space separator after the comma as we want to be efficient with space. 
		select @NORMAL_TEAM_SET_LIST = substring(@NORMAL_TEAM_SET_LIST + (case when len(@NORMAL_TEAM_SET_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36)), 1, 851)
		  from @TEMP_TEAMS
		 order by PRIMARY_TEAM desc, ID asc;
		
		-- 08/22/2009 Paul.  Order the set name by the names of the teams, with the primary going first. 
		-- 08/23/2009 Paul.  Use a space after the comma so that the team names are readable in the GridView or DetailView. 
		select @NORMAL_TEAM_SET_NAME = substring(@NORMAL_TEAM_SET_NAME + (case when len(@NORMAL_TEAM_SET_NAME) > 0 then N', ' else N'' end) + NAME, 1, 200)
		  from @TEMP_TEAMS
		 order by PRIMARY_TEAM desc, NAME asc;
		
		update TEAM_SETS
		   set TEAM_SET_LIST     = @NORMAL_TEAM_SET_LIST
		     , TEAM_SET_NAME     = @NORMAL_TEAM_SET_NAME
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where ID                = @TEAM_SET_ID;
		
		delete from @TEMP_TEAMS;
		
		fetch next from team_set_cursor into @TEAM_SET_ID;
	end -- while;
	close team_set_cursor;

	deallocate team_set_cursor;
  end
GO
 
Grant Execute on dbo.spTEAM_SETS_UpdateNames to public;
GO
 
 
