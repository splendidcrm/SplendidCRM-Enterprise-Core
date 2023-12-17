if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTWITTER_TRACKS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTWITTER_TRACKS_Update;
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
-- 05/17/2017 Paul.  Add Tags module. 
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spTWITTER_TRACKS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ASSIGNED_USER_ID     uniqueidentifier
	, @TEAM_ID              uniqueidentifier
	, @TEAM_SET_LIST        varchar(8000)
	, @NAME                 nvarchar(60)
	, @LOCATION             nvarchar(60)
	, @TWITTER_USER_ID      bigint
	, @TWITTER_SCREEN_NAME  nvarchar(50)
	, @STATUS               nvarchar(25)
	, @TYPE                 nvarchar(25)
	, @DESCRIPTION          nvarchar(max)
	, @TAG_SET_NAME         nvarchar(4000) = null
	, @ASSIGNED_SET_LIST    varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;
	
	if not exists(select * from TWITTER_TRACKS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into TWITTER_TRACKS
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, ASSIGNED_USER_ID    
			, TEAM_ID             
			, TEAM_SET_ID         
			, NAME                
			, LOCATION            
			, TWITTER_USER_ID     
			, TWITTER_SCREEN_NAME 
			, STATUS              
			, TYPE                
			, DESCRIPTION         
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
			, @TEAM_ID             
			, @TEAM_SET_ID         
			, @NAME                
			, @LOCATION            
			, @TWITTER_USER_ID     
			, @TWITTER_SCREEN_NAME 
			, @STATUS              
			, @TYPE                
			, @DESCRIPTION         
			, @ASSIGNED_SET_ID     
			);
	end else begin
		update TWITTER_TRACKS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , ASSIGNED_USER_ID     = @ASSIGNED_USER_ID    
		     , TEAM_ID              = @TEAM_ID             
		     , TEAM_SET_ID          = @TEAM_SET_ID         
		     , NAME                 = @NAME                
		     , LOCATION             = @LOCATION            
		     , TWITTER_USER_ID      = @TWITTER_USER_ID     
		     , TWITTER_SCREEN_NAME  = @TWITTER_SCREEN_NAME 
		     , STATUS               = @STATUS              
		     , TYPE                 = @TYPE                
		     , DESCRIPTION          = @DESCRIPTION         
		     , ASSIGNED_SET_ID      = @ASSIGNED_SET_ID     
		 where ID                   = @ID                  ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;
	-- 05/17/2017 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'TwitterTracks', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spTWITTER_TRACKS_Update to public;
GO

