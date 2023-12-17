if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_SETS_RemoveTeam' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_SETS_RemoveTeam;
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
Create Procedure dbo.spTEAM_SETS_RemoveTeam
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @OLD_SET_ID           uniqueidentifier
	, @REMOVE_TEAM_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @NORMAL_TEAM_SET_LIST varchar(851);
	declare @NORMAL_TEAM_SET_NAME nvarchar(200);
	declare @TEAM_SET_ID          uniqueidentifier;
	declare @PRIMARY_TEAM_ID      uniqueidentifier;
-- #if SQL_Server /*
	declare @TEMP_TEAMS table
		( ID           uniqueidentifier not null primary key
		, PRIMARY_TEAM bit not null default(0)
		, NAME         nvarchar(128) not null
		);
-- #endif SQL_Server */

	set @ID = @OLD_SET_ID;
	if @OLD_SET_ID is not null begin -- then
		-- 01/28/2014 Paul.  Make sure that the team exists in the list before processing the removal. 
		-- If not exists, then exit with old Team Set ID. 
		if exists(select * from TEAM_SETS_TEAMS where TEAM_SET_ID = @OLD_SET_ID and TEAM_ID = @REMOVE_TEAM_ID and DELETED = 0) begin -- then
			insert into @TEMP_TEAMS ( ID, PRIMARY_TEAM, NAME)
			select TEAM_SETS_TEAMS.TEAM_ID
			     , TEAM_SETS_TEAMS.PRIMARY_TEAM
			     , TEAMS.NAME
			  from      TEAM_SETS_TEAMS
			 inner join TEAMS
			         on TEAMS.ID      = TEAM_SETS_TEAMS.TEAM_ID
			        and TEAMS.DELETED = 0
			 where TEAM_SETS_TEAMS.TEAM_SET_ID = @OLD_SET_ID;
			-- 01/28/2014 Paul.  Remove after insert instead of filter clause above for performance. 
			delete from @TEMP_TEAMS where ID = @REMOVE_TEAM_ID;
			
			set @ID = null;
			-- 01/28/2014 Paul.  If temp table is empty, then clear the resulting Team Set ID and exit. 
			if exists(select * from @TEMP_TEAMS) begin -- then
				-- 01/28/2014 Paul.  If no primary is specified, then pick one based on team name sort. 
				if not exists(select * from @TEMP_TEAMS where PRIMARY_TEAM = 1) begin -- then
					select top 1 @PRIMARY_TEAM_ID = ID
					  from @TEMP_TEAMS
					 order by NAME;
					update @TEMP_TEAMS
					   set PRIMARY_TEAM = 1
					 where ID = @PRIMARY_TEAM_ID;
				end -- if;
				
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
		
				-- 08/23/2009 Paul.  If a team set already exists with the same normalized list, then return it.
				-- The team set does not need to be identical, it just needs to have the same display list, so we use the id list as the key. 
				-- BEGIN Oracle Exception
					select top 1 @ID = ID
					  from TEAM_SETS
					 where TEAM_SET_LIST = @NORMAL_TEAM_SET_LIST
					   and DELETED       = 0;
				-- END Oracle Exception
				if @ID is null begin -- then
					set @ID = newid();
					-- 08/24/2009 Paul.  Use a duplicate variable for clarity. 
					set @TEAM_SET_ID = @ID;
					insert into TEAM_SETS
						( ID               
						, CREATED_BY       
						, DATE_ENTERED     
						, MODIFIED_USER_ID 
						, DATE_MODIFIED    
						, TEAM_SET_LIST    
						, TEAM_SET_NAME    
						)
					values
						( @ID                  
						, @MODIFIED_USER_ID    
						,  getdate()           
						, @MODIFIED_USER_ID    
						,  getdate()           
						, @NORMAL_TEAM_SET_LIST
						, @NORMAL_TEAM_SET_NAME
						);
					
					-- 08/23/2009 Paul.  We would normally use a cursor to be common across platforms. 
					-- Instead, lets use insert into so that we are fast. 
					insert into TEAM_SETS_TEAMS
						( ID               
						, CREATED_BY       
						, DATE_ENTERED     
						, MODIFIED_USER_ID 
						, DATE_MODIFIED    
						, TEAM_SET_ID      
						, TEAM_ID          
						, PRIMARY_TEAM     
						)
					select  newid()             
					     , @MODIFIED_USER_ID    
					     ,  getdate()           
					     , @MODIFIED_USER_ID    
					     ,  getdate()           
					     , @TEAM_SET_ID         
					     ,  ID                  
					     ,  PRIMARY_TEAM        
					  from @TEMP_TEAMS;
				end -- if;
			end -- if;
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spTEAM_SETS_RemoveTeam to public;
GO
 
 
