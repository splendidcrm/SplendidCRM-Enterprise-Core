if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROJECTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROJECTS_Update;
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
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 01/13/2010 Paul.  New Project fields in SugarCRM. 
-- 04/07/2010 Paul.  Add EXCHANGE_FOLDER. 
-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPROJECTS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ASSIGNED_USER_ID     uniqueidentifier
	, @NAME                 nvarchar(50)
	, @DESCRIPTION          nvarchar(max)
	, @PARENT_TYPE          nvarchar(25)
	, @PARENT_ID            uniqueidentifier
	, @TEAM_ID              uniqueidentifier = null
	, @TEAM_SET_LIST        varchar(8000) = null
	, @ESTIMATED_START_DATE datetime = null
	, @ESTIMATED_END_DATE   datetime = null
	, @STATUS               nvarchar(25) = null
	, @PRIORITY             nvarchar(25) = null
	, @IS_TEMPLATE          bit = null
	, @EXCHANGE_FOLDER      bit = null
	, @TAG_SET_NAME         nvarchar(4000) = null
	, @ASSIGNED_SET_LIST    varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from PROJECT where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into PROJECT
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, ASSIGNED_USER_ID    
			, NAME                
			, ESTIMATED_START_DATE
			, ESTIMATED_END_DATE  
			, STATUS              
			, PRIORITY            
			, IS_TEMPLATE         
			, DESCRIPTION         
			, TEAM_ID             
			, TEAM_SET_ID         
			, ASSIGNED_SET_ID     
			)
		values
			( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			,  getutcdate()        
			, @ASSIGNED_USER_ID    
			, @NAME                
			, @ESTIMATED_START_DATE
			, @ESTIMATED_END_DATE  
			, @STATUS              
			, @PRIORITY            
			, @IS_TEMPLATE         
			, @DESCRIPTION         
			, @TEAM_ID             
			, @TEAM_SET_ID         
			, @ASSIGNED_SET_ID     
			);
	end else begin
		update PROJECT
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , ASSIGNED_USER_ID     = @ASSIGNED_USER_ID    
		     , NAME                 = @NAME                
		     , ESTIMATED_START_DATE = @ESTIMATED_START_DATE
		     , ESTIMATED_END_DATE   = @ESTIMATED_END_DATE  
		     , STATUS               = @STATUS              
		     , PRIORITY             = @PRIORITY            
		     , IS_TEMPLATE          = @IS_TEMPLATE         
		     , DESCRIPTION          = @DESCRIPTION         
		     , TEAM_ID              = @TEAM_ID             
		     , TEAM_SET_ID          = @TEAM_SET_ID         
		     , ASSIGNED_SET_ID      = @ASSIGNED_SET_ID     
		 where ID                   = @ID                  ;
		
		-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	-- 08/22/2009 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		-- 05/10/2007 Paul.  Always check to ensure that the matching custom record exists. 
		if not exists(select * from PROJECT_CSTM where ID_C = @ID) begin -- then
			insert into PROJECT_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spPROJECT_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
		
		if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
			exec dbo.spPROJECT_RELATION_Update @MODIFIED_USER_ID, @ID, @PARENT_TYPE, @PARENT_ID;
		end -- if;

		-- 04/07/2010 Paul.  If the Exchange Folder value is NULL, then don't do anything. This is to prevent the Exchange from unsyncing after update. 
		if @EXCHANGE_FOLDER = 0 begin -- then
			exec dbo.spPROJECT_USERS_Delete @MODIFIED_USER_ID, @ID, @MODIFIED_USER_ID;
		end else if @EXCHANGE_FOLDER = 1 begin -- then
			exec dbo.spPROJECT_USERS_Update @MODIFIED_USER_ID, @ID, @MODIFIED_USER_ID;
		end -- if;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'Project', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spPROJECTS_Update to public;
GO

