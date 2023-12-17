if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spASSIGNED_SETS_UpdateNames' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spASSIGNED_SETS_UpdateNames;
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
Create Procedure dbo.spASSIGNED_SETS_UpdateNames
	( @MODIFIED_USER_ID     uniqueidentifier
	, @USER_ID              uniqueidentifier
	)
as
  begin
	set nocount on

	declare @ASSIGNED_SET_ID          uniqueidentifier;
	declare @NORMAL_ASSIGNED_SET_LIST varchar(851);
	declare @NORMAL_ASSIGNED_SET_NAME nvarchar(200);
-- #if SQL_Server /*
	declare @TEMP_USERS table
		( ID               uniqueidentifier not null primary key
		, PRIMARY_USER     bit not null default(0)
		, NAME             nvarchar(128) not null
		);
-- #endif SQL_Server */

	declare ASSIGNED_set_cursor cursor for
	select ASSIGNED_SET_ID
	  from ASSIGNED_SETS_USERS
	 where DELETED = 0
	   and USER_ID = @USER_ID;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	open ASSIGNED_set_cursor;
	fetch next from ASSIGNED_set_cursor into @ASSIGNED_SET_ID;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		insert into @TEMP_USERS ( ID, PRIMARY_USER, NAME)
		select ASSIGNED_SETS_USERS.USER_ID
		     , ASSIGNED_SETS_USERS.PRIMARY_USER
		     , USERS.USER_NAME
		  from      ASSIGNED_SETS_USERS
		 inner join USERS
		         on USERS.ID      = ASSIGNED_SETS_USERS.USER_ID
		        and USERS.DELETED = 0
		 where ASSIGNED_SETS_USERS.ASSIGNED_SET_ID = @ASSIGNED_SET_ID
		   and ASSIGNED_SETS_USERS.DELETED     = 0;
		
		set @NORMAL_ASSIGNED_SET_LIST =  '';
		set @NORMAL_ASSIGNED_SET_NAME = N'';
		-- 11/30/2017 Paul.  Order the ID list by the IDs of the USERS, with the primary going first.
		-- 11/30/2017 Paul.  There is no space separator after the comma as we want to be efficient with space. 
		select @NORMAL_ASSIGNED_SET_LIST = substring(@NORMAL_ASSIGNED_SET_LIST + (case when len(@NORMAL_ASSIGNED_SET_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36)), 1, 851)
		  from @TEMP_USERS
		 order by PRIMARY_USER desc, ID asc;
		
		-- 11/30/2017 Paul.  Order the set name by the names of the USERS, with the primary going first. 
		-- 11/30/2017 Paul.  Use a space after the comma so that the ASSIGNED names are readable in the GridView or DetailView. 
		select @NORMAL_ASSIGNED_SET_NAME = substring(@NORMAL_ASSIGNED_SET_NAME + (case when len(@NORMAL_ASSIGNED_SET_NAME) > 0 then N', ' else N'' end) + NAME, 1, 200)
		  from @TEMP_USERS
		 order by PRIMARY_USER desc, NAME asc;
		
		update ASSIGNED_SETS
		   set ASSIGNED_SET_LIST = @NORMAL_ASSIGNED_SET_LIST
		     , ASSIGNED_SET_NAME = @NORMAL_ASSIGNED_SET_NAME
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where ID                = @ASSIGNED_SET_ID;
		
		delete from @TEMP_USERS;
		
		fetch next from ASSIGNED_set_cursor into @ASSIGNED_SET_ID;
	end -- while;
	close ASSIGNED_set_cursor;

	deallocate ASSIGNED_set_cursor;
  end
GO
 
Grant Execute on dbo.spASSIGNED_SETS_UpdateNames to public;
GO
 
 
