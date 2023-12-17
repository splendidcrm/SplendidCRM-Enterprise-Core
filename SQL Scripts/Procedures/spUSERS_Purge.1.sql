if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spUSERS_Purge' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spUSERS_Purge;
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
-- 01/31/2019 Paul.  Remove test code as it complicates Oracle conversion. 
Create Procedure dbo.spUSERS_Purge
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @COMMAND            varchar(max);
	declare @ID_VALUE           char(38);
	declare @PRIVATE_TEAM_ID    uniqueidentifier;
	declare @PRIVATE_TEAM_VALUE char(38);

	-- BEGIN Oracle Exception
		select top 1 @PRIVATE_TEAM_ID = TEAM_MEMBERSHIPS.TEAM_ID
		  from            USERS
		  left outer join TEAM_MEMBERSHIPS
		               on TEAM_MEMBERSHIPS.USER_ID = USERS.ID
		              and TEAM_MEMBERSHIPS.PRIVATE = 1
		              and TEAM_MEMBERSHIPS.DELETED = 0
		  left outer join TEAMS
		               on TEAMS.ID                 = TEAM_MEMBERSHIPS.TEAM_ID
		 where USERS.ID         = @ID;
	-- END Oracle Exception
	-- print 'PRIVATE_TEAM_ID = ' + cast(@PRIVATE_TEAM_ID as char(36));
	set @PRIVATE_TEAM_VALUE = '''' + cast(@PRIVATE_TEAM_ID as char(36)) + '''';
	set @ID_VALUE           = '''' + cast(@ID as char(36)) + '''';

	-- BEGIN Oracle Exception
		delete from PROSPECT_LISTS_PROSPECTS
		 where RELATED_ID       = @ID;
		delete from PROSPECT_LISTS_PROSPECTS_AUDIT
		 where RELATED_ID       = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from CALLS_USERS
		 where USER_ID          = @ID;
		delete from CALLS_USERS_AUDIT
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from CONTACTS_USERS
		 where USER_ID          = @ID;
		delete from CONTACTS_USERS_AUDIT
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from EMAILMAN
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from EMAILMAN_SENT
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from EMAILS_USERS
		 where USER_ID          = @ID;
		delete from EMAILS_USERS_AUDIT
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from MEETINGS_USERS
		 where USER_ID          = @ID;
		delete from MEETINGS_USERS_AUDIT
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from USERS_FEEDS
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from TRACKER
		 where ITEM_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from ACL_ROLES_USERS
		 where USER_ID          = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		if exists(select * from vwSqlTables where TABLE_NAME = 'TEAM_MEMBERSHIPS') begin -- then
			set @COMMAND = 'delete from TEAM_MEMBERSHIPS where TEAM_ID = ' + @PRIVATE_TEAM_VALUE;
			exec(@COMMAND);
		end -- if;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		if exists(select * from vwSqlTables where TABLE_NAME = 'TEAMS_CSTM') begin -- then
			set @COMMAND = 'delete from TEAMS_CSTM
			  from      TEAMS_CSTM
			 inner join TEAM_MEMBERSHIPS
			         on TEAM_MEMBERSHIPS.TEAM_ID = TEAMS_CSTM.ID_C
			 where TEAM_MEMBERSHIPS.USER_ID = ' + @ID_VALUE + '
			   and TEAM_MEMBERSHIPS.TEAM_ID = ' + @PRIVATE_TEAM_VALUE;
			exec(@COMMAND);
		end -- if;
		if exists(select * from vwSqlTables where TABLE_NAME = 'TEAMS_CSTM_AUDIT') begin -- then
			set @COMMAND = 'delete from TEAMS_CSTM_AUDIT
			  from      TEAMS_CSTM_AUDIT
			 inner join TEAM_MEMBERSHIPS
			         on TEAM_MEMBERSHIPS.TEAM_ID = TEAMS_CSTM_AUDIT.ID_C
			 where TEAM_MEMBERSHIPS.USER_ID = ' + @ID_VALUE + '
			   and TEAM_MEMBERSHIPS.TEAM_ID = ' + @PRIVATE_TEAM_VALUE;
			exec(@COMMAND);
		end -- if;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		if exists(select * from vwSqlTables where TABLE_NAME = 'TEAMS') begin -- then
			set @COMMAND = 'delete from TEAMS
			  from      TEAMS
			 inner join TEAM_MEMBERSHIPS
			         on TEAM_MEMBERSHIPS.TEAM_ID = TEAMS.ID
			 where TEAM_MEMBERSHIPS.USER_ID = ' + @ID_VALUE + '
			   and TEAM_MEMBERSHIPS.TEAM_ID = ' + @PRIVATE_TEAM_VALUE;
			exec(@COMMAND);
		end -- if;
		if exists(select * from vwSqlTables where TABLE_NAME = 'TEAMS_AUDIT') begin -- then
			set @COMMAND = 'delete from TEAMS_AUDIT
			  from      TEAMS_AUDIT
			 inner join TEAM_MEMBERSHIPS
			         on TEAM_MEMBERSHIPS.TEAM_ID = TEAMS_AUDIT.ID
			 where TEAM_MEMBERSHIPS.USER_ID = ' + @ID_VALUE + '
			   and TEAM_MEMBERSHIPS.TEAM_ID = ' + @PRIVATE_TEAM_VALUE;
			exec(@COMMAND);
		end -- if;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		if exists(select * from vwSqlTables where TABLE_NAME = 'TEAM_MEMBERSHIPS') begin -- then
			set @COMMAND = 'delete from TEAM_MEMBERSHIPS where USER_ID = ' + @ID_VALUE;
			exec(@COMMAND);
		end -- if;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		if exists(select * from vwSqlTables where TABLE_NAME = 'USERS_CSTM_AUDIT') begin -- then
			set @COMMAND = 'delete from USERS_CSTM_AUDIT where ID_C = ' + @ID_VALUE;
			exec(@COMMAND);
		end -- if;
		delete from USERS_CSTM
		 where ID_C             = @ID;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from USERS_AUDIT
		 where ID               = @ID;
		delete from USERS
		 where ID               = @ID;
	-- END Oracle Exception
  end
GO
 
Grant Execute on dbo.spUSERS_Purge to public;
GO

