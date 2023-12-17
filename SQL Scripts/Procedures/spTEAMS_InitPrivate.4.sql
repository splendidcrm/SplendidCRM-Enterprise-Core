if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAMS_InitPrivate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAMS_InitPrivate;
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
-- 10/21/2008 Paul.  Increase USER_NAME to 60 to match table. 
-- 04/07/2016 Paul.  Provide a way to disable private teams.  
Create Procedure dbo.spTEAMS_InitPrivate
as
  begin
	set nocount on
	
	declare @USER_ID      uniqueidentifier;
	declare @USER_NAME    nvarchar(  60);
	declare @FULL_NAME    nvarchar( 100);
	declare @PROGRESS_MSG nvarchar(1000);

	-- 11/25/2006 Paul.  Get all the users that do not have a private team. 
	-- 12/14/2006 Paul.  Exclude employees that are not users. USER_NAME cannot be null. 
	declare user_cursor cursor for
	select USERS.ID
	     , USERS.USER_NAME
	     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME)
	  from            USERS
	  left outer join TEAM_MEMBERSHIPS
	               on TEAM_MEMBERSHIPS.USER_ID = USERS.ID
	              and TEAM_MEMBERSHIPS.PRIVATE = 1
	              and TEAM_MEMBERSHIPS.DELETED = 0
	  left outer join TEAMS
	               on TEAMS.ID                 = TEAM_MEMBERSHIPS.TEAM_ID
	              and TEAMS.PRIVATE            = 1
	              and TEAMS.DELETED            = 0
	 where USERS.DELETED = 0
	   and USERS.USER_NAME is not null
	   and TEAMS.ID is null
	 order by USERS.USER_NAME;

/* -- #if IBM_DB2
	declare continue handler for not found
		set @FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	-- 04/07/2016 Paul.  Provide a way to disable private teams.  
	if dbo.fnCONFIG_Boolean(N'disable_private_teams') = 0 begin -- then
		open user_cursor;
		fetch next from user_cursor into @USER_ID, @USER_NAME, @FULL_NAME;
		while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
			set @PROGRESS_MSG = N'Creating private team for ' + @USER_NAME;
			print @PROGRESS_MSG;
			exec dbo.spTEAMS_InsertPrivate null, @USER_ID, @USER_NAME, @FULL_NAME;
			fetch next from user_cursor into @USER_ID, @USER_NAME, @FULL_NAME;
		end -- while;
		close user_cursor;
	end -- if;
	deallocate user_cursor;
  end
GO


Grant Execute on dbo.spTEAMS_InitPrivate to public;
GO



