if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAMS_NormalizeSet' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAMS_NormalizeSet;
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
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 08/30/2009 Paul.  This procedure is not used.  Instead, we use spTEAM_SETS_NormalizeSet. 
Create Procedure dbo.spTEAMS_NormalizeSet
	( @MODIFIED_USER_ID     uniqueidentifier
	, @PRIMARY_TEAM_ID      uniqueidentifier
	, @TEAM_SET_LIST        varchar(8000)
	, @NORMAL_TEAM_SET_LIST varchar(851) output
	, @NORMAL_TEAM_SET_NAME nvarchar(200) output
	)
as
  begin
	set nocount on
	
	declare @ID           uniqueidentifier;
	declare @TEAM_ID      uniqueidentifier;
	declare @TEAM_NAME    nvarchar(128);
	declare @CurrentPosR  int;
	declare @NextPosR     int;
-- #if SQL_Server /*
	declare @TEMP_TEAMS table
		( ID           uniqueidentifier not null primary key
		, PRIMARY_TEAM bit not null default(0)
		, NAME         nvarchar(128) not null
		);
-- #endif SQL_Server */

	if @PRIMARY_TEAM_ID is not null begin -- then
		-- BEGIN Oracle Exception
			select @TEAM_NAME = NAME
			  from TEAMS
			 where ID         = @PRIMARY_TEAM_ID
			   and DELETED    = 0;
		-- END Oracle Exception
		if @TEAM_NAME is not null begin -- then
			insert into @TEMP_TEAMS ( ID              , PRIMARY_TEAM, NAME      )
			                 values ( @PRIMARY_TEAM_ID, 1           , @TEAM_NAME);
		end -- if;
	end -- if;

	if @TEAM_SET_LIST is not null and len(@TEAM_SET_LIST) > 0 begin -- then
		set @CurrentPosR = 1;
		-- 08/21/2009 Paul.  Add any new teams to the relationship table. 
		while @CurrentPosR <= len(@TEAM_SET_LIST) begin -- do
			set @NextPosR = charindex(',', @TEAM_SET_LIST,  @CurrentPosR);
			if @NextPosR = 0 or @NextPosR is null begin -- then
				set @NextPosR = len(@TEAM_SET_LIST) + 1;
			end -- if;
			set @TEAM_ID = cast(rtrim(ltrim(substring(@TEAM_SET_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
			set @CurrentPosR = @NextPosR+1;
			
			-- 08/22/2009 Paul.  Prevent duplicates by inserting unique teams into the temp table. 
			if not exists(select * from @TEMP_TEAMS where ID = @TEAM_ID) begin -- then
				-- BEGIN Oracle Exception
					select @TEAM_NAME = NAME
					  from TEAMS
					 where ID         = @TEAM_ID
					   and DELETED    = 0;
				-- END Oracle Exception
				if @TEAM_NAME is not null begin -- then
					insert into @TEMP_TEAMS ( ID      , PRIMARY_TEAM, NAME      )
					                 values ( @TEAM_ID, 0           , @TEAM_NAME);
				end -- if;
			end -- if;
		end -- while;
	end -- if;

	if exists(select * from @TEMP_TEAMS) begin -- then
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
	end -- if;

  end
GO
 
Grant Execute on dbo.spTEAMS_NormalizeSet to public;
GO
 
 
