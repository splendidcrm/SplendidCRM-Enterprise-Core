if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_MEMBERSHIPS_RefreshUser' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_MEMBERSHIPS_RefreshUser;
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
Create Procedure dbo.spTEAM_MEMBERSHIPS_RefreshUser
	( @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	)
as
  begin
	set nocount on

	declare @TEAM_ID uniqueidentifier;

	declare team_cursor cursor for
	select TEAM_ID
	  from TEAM_MEMBERSHIPS
	 where USER_ID = @USER_ID
	   and DELETED = 0;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	open team_cursor;
	fetch next from team_cursor into @TEAM_ID;
	-- 11/18/2006 Paul.  Refresh all implicit members of teams that this user is part of. 
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		exec dbo.spTEAM_MEMBERSHIPS_UpdateImplicit @MODIFIED_USER_ID, @TEAM_ID;
		fetch next from team_cursor into @TEAM_ID;
	end -- while;
	close team_cursor;

	deallocate team_cursor;
  end
GO
 
Grant Execute on dbo.spTEAM_MEMBERSHIPS_RefreshUser to public;
GO
 

