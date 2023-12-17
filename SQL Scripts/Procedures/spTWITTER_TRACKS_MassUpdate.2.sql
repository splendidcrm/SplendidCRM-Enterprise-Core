if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTWITTER_TRACKS_MassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTWITTER_TRACKS_MassUpdate;
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
-- 05/31/2018 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spTWITTER_TRACKS_MassUpdate
	( @ID_LIST           varchar(8000)
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @TEAM_ID           uniqueidentifier
	, @TEAM_SET_LIST     varchar(8000)
	, @TEAM_SET_ADD      bit = null
	, @STATUS            nvarchar(25)
	, @TYPE              nvarchar(25)
	, @ASSIGNED_SET_LIST varchar(8000) = null
	, @ASSIGNED_SET_ADD  bit = null
	)
as
  begin
	set nocount on
	
	declare @ID           uniqueidentifier;
	declare @CurrentPosR  int;
	declare @NextPosR     int;
	declare @TEAM_SET_ID  uniqueidentifier;
	declare @OLD_SET_ID   uniqueidentifier;

	-- 05/31/2018 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	declare @ASSIGNED_OLD_SET_ID uniqueidentifier;
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		if @TEAM_SET_ADD = 1 and @TEAM_SET_ID is not null begin -- then
			-- BEGIN Oracle Exception
				select @OLD_SET_ID = TEAM_SET_ID
				     , @TEAM_ID    = isnull(@TEAM_ID, TEAM_ID)
				  from TWITTER_TRACKS
				 where ID                = @ID
				   and DELETED           = 0;
			-- END Oracle Exception
			if @OLD_SET_ID is not null begin -- then
				exec dbo.spTEAM_SETS_AddSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @OLD_SET_ID, @TEAM_ID, @TEAM_SET_ID;
			end -- if;
		end -- if;

		-- 05/31/2018 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		-- 05/31/2018 Paul.  When adding a set, we need to start with the existing set of the current record. 
		if @ASSIGNED_SET_ADD = 1 and @ASSIGNED_SET_ID is not null begin -- then
			-- BEGIN Oracle Exception
				-- 05/31/2018 Paul.  If a primary team was not provided, then load the old primary team. 
				select @ASSIGNED_OLD_SET_ID = ASSIGNED_SET_ID
				     , @ASSIGNED_USER_ID    = isnull(@ASSIGNED_USER_ID, ASSIGNED_USER_ID)
				  from TWITTER_TRACKS
				 where ID                = @ID
				   and DELETED           = 0;
			-- END Oracle Exception
			if @ASSIGNED_OLD_SET_ID is not null begin -- then
				exec dbo.spASSIGNED_SETS_AddSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_OLD_SET_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_ID;
			end -- if;
		end -- if;

		-- 05/31/2018 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		-- BEGIN Oracle Exception
			update TWITTER_TRACKS
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , ASSIGNED_USER_ID  = isnull(@ASSIGNED_USER_ID, ASSIGNED_USER_ID)
			     , ASSIGNED_SET_ID   = isnull(@ASSIGNED_SET_ID , ASSIGNED_SET_ID )
			     , TEAM_ID           = isnull(@TEAM_ID         , TEAM_ID         )
			     , TEAM_SET_ID       = isnull(@TEAM_SET_ID     , TEAM_SET_ID     )
			     , STATUS            = isnull(@STATUS          , STATUS          )
			     , TYPE              = isnull(@TYPE            , TYPE            )
			 where ID                = @ID
			   and DELETED           = 0;
		-- END Oracle Exception
	end -- while;
  end
GO
 
Grant Execute on dbo.spTWITTER_TRACKS_MassUpdate to public;
GO
 
 
