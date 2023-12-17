if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALLS_Import' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALLS_Import;
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
-- 12/29/2007 Paul.  Add TEAM_ID so that it is not updated separately. 
-- 01/26/2009 Paul.  The current user is accepted by default. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 02/04/2010 Paul.  Special import procedure to allow date from ACT! import. 
-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
-- 09/01/2012 Paul.  Add LAST_ACTIVITY_DATE. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 12/07/2018 Paul.  Allow Team Name to be specified during import. 
Create Procedure dbo.spCALLS_Import
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DATE_MODIFIED     datetime
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(50)
	, @DURATION_HOURS    int
	, @DURATION_MINUTES  int
	, @DATE_TIME         datetime
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	, @STATUS            nvarchar(25)
	, @DIRECTION         nvarchar(25)
	, @REMINDER_TIME     int
	, @DESCRIPTION       nvarchar(max)
	, @INVITEE_LIST      varchar(8000)
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_LIST     varchar(8000) = null
	, @ASSIGNED_SET_LIST varchar(8000) = null
	, @TEAM_NAME         nvarchar(128) = null
	)
as
  begin
	set nocount on
	
	declare @TEMP_DATE_MODIFIED  datetime;
	declare @DATE_START          datetime;
	declare @TIME_START          datetime;
	declare @DATE_END            datetime;
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;

	-- 12/15/2005 Paul.  Oracle uses fractions to add hours and minutes to date.  24 hours, 1440 minutes, 86400 seconds in a day. 
	-- 04/02/2006 Paul.  Use date functions so that the conversions will be simplified. 
	set @DATE_END   = dbo.fnDateAdd_Minutes(@DURATION_MINUTES, dbo.fnDateAdd_Hours(@DURATION_HOURS, @DATE_TIME));
	set @DATE_START = dbo.fnStoreDateOnly(@DATE_TIME);
	set @TIME_START = dbo.fnStoreTimeOnly(@DATE_TIME);
	-- 02/04/2010 Paul.  DATE_ENTERED cannot be NULL. 
	set @TEMP_DATE_MODIFIED = @DATE_MODIFIED;
	if @TEMP_DATE_MODIFIED is null begin -- then
		set @TEMP_DATE_MODIFIED = getdate();
	end -- if;

	-- 12/07/2018 Paul.  Allow Team Name to be specified during import. 
	if @TEAM_ID is null and @TEAM_NAME is not null begin -- then
		select @TEAM_ID = ID
		  from TEAMS
		 where NAME     = @TEAM_NAME
		   and DELETED  = 0;
	end -- if;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from CALLS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into CALLS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, DATE_MODIFIED_UTC
			, ASSIGNED_USER_ID 
			, NAME             
			, DURATION_HOURS   
			, DURATION_MINUTES 
			, DATE_START       
			, TIME_START       
			, DATE_END         
			, PARENT_TYPE      
			, PARENT_ID        
			, STATUS           
			, DIRECTION        
			, REMINDER_TIME    
			, DESCRIPTION      
			, TEAM_ID          
			, TEAM_SET_ID      
			, ASSIGNED_SET_ID  
			)
		values
			( @ID                
			, @MODIFIED_USER_ID  
			, @TEMP_DATE_MODIFIED
			, @MODIFIED_USER_ID  
			, @TEMP_DATE_MODIFIED
			,  getutcdate()      
			, @ASSIGNED_USER_ID  
			, @NAME              
			, @DURATION_HOURS    
			, @DURATION_MINUTES  
			, @DATE_START        
			, @TIME_START        
			, @DATE_END          
			, @PARENT_TYPE       
			, @PARENT_ID         
			, @STATUS            
			, @DIRECTION         
			, @REMINDER_TIME     
			, @DESCRIPTION       
			, @TEAM_ID           
			, @TEAM_SET_ID       
			, @ASSIGNED_SET_ID   
			);
	end else begin
		-- 07/24/2012 Paul.  Import is used by Outlook Plug-in soap call, so we need to allow update. 
		update CALLS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID  
		     , DATE_MODIFIED     =  getdate()         
		     , DATE_MODIFIED_UTC =  getutcdate()      
		     , ASSIGNED_USER_ID  = @ASSIGNED_USER_ID  
		     , NAME              = @NAME              
		     , DURATION_HOURS    = @DURATION_HOURS    
		     , DURATION_MINUTES  = @DURATION_MINUTES  
		     , DATE_START        = @DATE_START        
		     , TIME_START        = @TIME_START        
		     , DATE_END          = @DATE_END          
		     , PARENT_TYPE       = @PARENT_TYPE       
		     , PARENT_ID         = @PARENT_ID         
		     , STATUS            = @STATUS            
		     , DIRECTION         = @DIRECTION         
		     , DESCRIPTION       = @DESCRIPTION       
		     , REMINDER_TIME     = @REMINDER_TIME     
		     , TEAM_ID           = @TEAM_ID           
		     , TEAM_SET_ID       = @TEAM_SET_ID       
		     , ASSIGNED_SET_ID   = @ASSIGNED_SET_ID   
		 where ID                = @ID                ;
		
		-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	-- 03/06/2006 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from CALLS_CSTM where ID_C = @ID) begin -- then
			insert into CALLS_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spCALLS_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
		
		-- 07/15/2012 Paul.  If the invitee list is null, then don't change the relationships. 
		-- This should prevent the Outlook Plug-in from resetting the relationships. 
		if @INVITEE_LIST is not null begin -- then
			-- BEGIN Oracle Exception
				update CALLS_USERS
				   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
				     , DATE_MODIFIED     =  getdate()        
				     , DATE_MODIFIED_UTC =  getutcdate()     
				     , DELETED           = 1                 
				 where CALL_ID           = @ID               ;
			-- END Oracle Exception
			
			-- BEGIN Oracle Exception
				update CALLS_CONTACTS
				   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
				     , DATE_MODIFIED     =  getdate()        
				     , DATE_MODIFIED_UTC =  getutcdate()     
				     , DELETED           = 1                 
				 where CALL_ID           = @ID               ;
			-- END Oracle Exception
			
			-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
			-- BEGIN Oracle Exception
				update CALLS_LEADS
				   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
				     , DATE_MODIFIED     =  getdate()        
				     , DATE_MODIFIED_UTC =  getutcdate()     
				     , DELETED           = 1                 
				 where CALL_ID           = @ID               ;
			-- END Oracle Exception
			
			exec dbo.spCALLS_InviteeMassUpdate @MODIFIED_USER_ID, @ID, @INVITEE_LIST, 1;
		end -- if;
		-- 03/06/2006 Paul.  Assigned user is optional, so only try to assign if provided. 
		if dbo.fnIsEmptyGuid(@ASSIGNED_USER_ID) = 0 begin -- then
			-- 01/26/2009 Paul.  The current user is accepted by default. 
			if @MODIFIED_USER_ID = @ASSIGNED_USER_ID begin -- then
				-- 01/26/2009 Paul.  Avoid updating the record if it is already correct. 
				if not exists(select * from CALLS_USERS where CALL_ID = @ID and USER_ID = @MODIFIED_USER_ID and ACCEPT_STATUS = N'accept' and DELETED = 0) begin -- then
					exec dbo.spCALLS_USERS_Update @MODIFIED_USER_ID, @ID, @ASSIGNED_USER_ID, 1, N'accept';
				end -- if;
			end else begin
				exec dbo.spCALLS_USERS_Update @MODIFIED_USER_ID, @ID, @ASSIGNED_USER_ID, 1, null;
			end -- if;
		end -- if;
		
		if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
			-- 09/01/2012 Paul.  Add LAST_ACTIVITY_DATE. 
			exec dbo.spPARENT_UpdateLastActivity @MODIFIED_USER_ID, @PARENT_ID, @PARENT_TYPE;
		end -- if;
	end -- if;

  end
GO

Grant Execute on dbo.spCALLS_Import to public;
GO

