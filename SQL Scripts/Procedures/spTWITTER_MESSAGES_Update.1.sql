if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTWITTER_MESSAGES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTWITTER_MESSAGES_Update;
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
-- 05/24/2016 Paul.  Twitter is increasing the size of their tweets. They are going to 177, but we are going to 255. 
-- 05/17/2017 Paul.  Add Tags module. 
-- 10/21/2017 Paul.  Twitter increased sized to 280, but we are going to go to 420 so that we don't need to keep increasing. 
-- 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spTWITTER_MESSAGES_Update
	( @ID                    uniqueidentifier output
	, @MODIFIED_USER_ID      uniqueidentifier
	, @ASSIGNED_USER_ID      uniqueidentifier
	, @TEAM_ID               uniqueidentifier
	, @TEAM_SET_LIST         varchar(8000)
	, @NAME                  nvarchar(420)
	, @DESCRIPTION           nvarchar(max)
	, @DATE_TIME             datetime
	, @PARENT_TYPE           nvarchar(25)
	, @PARENT_ID             uniqueidentifier
	, @TYPE                  nvarchar(25)
	, @TWITTER_ID            bigint
	, @TWITTER_USER_ID       bigint
	, @TWITTER_FULL_NAME     nvarchar(50)
	, @TWITTER_SCREEN_NAME   nvarchar(50)
	, @ORIGINAL_ID           bigint
	, @ORIGINAL_USER_ID      bigint
	, @ORIGINAL_FULL_NAME    nvarchar(50)
	, @ORIGINAL_SCREEN_NAME  nvarchar(50)
	, @TAG_SET_NAME          nvarchar(4000) = null
	, @IS_PRIVATE            bit = null
	, @ASSIGNED_SET_LIST     varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	declare @STATUS      nvarchar(25);
	declare @DATE_START  datetime;
	declare @TIME_START  datetime;
	set @DATE_START = dbo.fnStoreDateOnly(@DATE_TIME);
	set @TIME_START = dbo.fnStoreTimeOnly(@DATE_TIME);

	-- 10/22/2013 Paul.  Just in case the tweet is imported in bulk. 
	if @ID is null and @TWITTER_ID is not null begin -- then
	-- BEGIN Oracle Exception
		select @ID = ID
		  from TWITTER_MESSAGES
		 where TWITTER_ID = @TWITTER_ID 
		   and DELETED = 0;
	-- END Oracle Exception
	end -- if;
	
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;
	
	if not exists(select * from TWITTER_MESSAGES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		if @TYPE is null or @TYPE = N'' begin -- then
			set @TYPE = N'draft';
		end -- if;
		if @TYPE = N'archived' begin -- then
			set @STATUS = N'sent';
		end else if @TYPE = N'inbound' begin -- then
			set @STATUS = N'received';
		end else begin
			set @STATUS = N'draft';
		end -- if;
		insert into TWITTER_MESSAGES
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
			, DESCRIPTION          
			, DATE_START           
			, TIME_START           
			, PARENT_TYPE          
			, PARENT_ID            
			, TYPE                 
			, STATUS               
			, TWITTER_ID           
			, TWITTER_USER_ID      
			, TWITTER_FULL_NAME    
			, TWITTER_SCREEN_NAME  
			, ORIGINAL_ID          
			, ORIGINAL_USER_ID     
			, ORIGINAL_FULL_NAME   
			, ORIGINAL_SCREEN_NAME 
			, IS_PRIVATE           
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
			, @DESCRIPTION          
			, @DATE_START           
			, @TIME_START           
			, @PARENT_TYPE          
			, @PARENT_ID            
			, @TYPE                 
			, @STATUS               
			, @TWITTER_ID           
			, @TWITTER_USER_ID      
			, @TWITTER_FULL_NAME    
			, @TWITTER_SCREEN_NAME  
			, @ORIGINAL_ID          
			, @ORIGINAL_USER_ID     
			, @ORIGINAL_FULL_NAME   
			, @ORIGINAL_SCREEN_NAME 
			, @IS_PRIVATE           
			, @ASSIGNED_SET_ID      
			);
	end else begin
		update TWITTER_MESSAGES
		   set MODIFIED_USER_ID      = @MODIFIED_USER_ID     
		     , DATE_MODIFIED         =  getdate()            
		     , DATE_MODIFIED_UTC     =  getutcdate()         
		     , ASSIGNED_USER_ID      = @ASSIGNED_USER_ID     
		     , TEAM_ID               = @TEAM_ID              
		     , TEAM_SET_ID           = @TEAM_SET_ID          
		     , NAME                  = @NAME                 
		     , DESCRIPTION           = @DESCRIPTION          
		     , DATE_START            = @DATE_START           
		     , TIME_START            = @TIME_START           
		     , PARENT_TYPE           = @PARENT_TYPE          
		     , PARENT_ID             = @PARENT_ID            
		     , TYPE                  = @TYPE                 
		     , STATUS                = @STATUS               
		     , TWITTER_ID            = @TWITTER_ID           
		     , TWITTER_USER_ID       = @TWITTER_USER_ID      
		     , TWITTER_FULL_NAME     = @TWITTER_FULL_NAME    
		     , TWITTER_SCREEN_NAME   = @TWITTER_SCREEN_NAME  
		     , ORIGINAL_ID           = @ORIGINAL_ID          
		     , ORIGINAL_USER_ID      = @ORIGINAL_USER_ID     
		     , ORIGINAL_FULL_NAME    = @ORIGINAL_FULL_NAME   
		     , ORIGINAL_SCREEN_NAME  = @ORIGINAL_SCREEN_NAME 
		     , IS_PRIVATE            = @IS_PRIVATE           
		     , ASSIGNED_SET_ID       = @ASSIGNED_SET_ID      
		 where ID                    = @ID                   ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	if @@ERROR = 0 begin -- then
		if not exists(select * from TWITTER_MESSAGES_CSTM where ID_C = @ID) begin -- then
			insert into TWITTER_MESSAGES_CSTM ( ID_C ) values ( @ID );
		end -- if;
	end -- if;

	if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
		exec dbo.spPARENT_UpdateLastActivity @MODIFIED_USER_ID, @PARENT_ID, @PARENT_TYPE;
	end -- if;
	-- 05/17/2017 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'TwitterMessages', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spTWITTER_MESSAGES_Update to public;
GO

