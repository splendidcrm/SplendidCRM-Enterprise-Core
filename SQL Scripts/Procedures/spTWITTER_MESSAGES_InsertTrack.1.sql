if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTWITTER_MESSAGES_InsertTrack' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTWITTER_MESSAGES_InsertTrack;
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
-- 10/21/2017 Paul.  Twitter increased sized to 280, but we are going to go to 420 so that we don't need to keep increasing. 
-- 11/10/2017 Paul.  Twitter increased display name to 50. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spTWITTER_MESSAGES_InsertTrack
	( @ID                    uniqueidentifier output
	, @MODIFIED_USER_ID      uniqueidentifier
	, @TRACK                 nvarchar(60)
	, @NAME                  nvarchar(420)
	, @DESCRIPTION           nvarchar(max)
	, @DATE_TIME             datetime
	, @TWITTER_ID            bigint
	, @TWITTER_USER_ID       bigint
	, @TWITTER_FULL_NAME     nvarchar(50)
	, @TWITTER_SCREEN_NAME   nvarchar(50)
	, @ORIGINAL_ID           bigint
	, @ORIGINAL_USER_ID      bigint
	, @ORIGINAL_FULL_NAME    nvarchar(50)
	, @ORIGINAL_SCREEN_NAME  nvarchar(50)
	, @ORIGINAL_DATE_TIME    datetime
	, @ORIGINAL_NAME         nvarchar(420)
	, @ORIGINAL_DESCRIPTION  nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @ASSIGNED_USER_ID uniqueidentifier;
	declare @TEAM_ID          uniqueidentifier;
	declare @TEAM_SET_LIST    varchar(8000);
	declare @TEAM_SET_ID      uniqueidentifier;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	declare @ASSIGNED_SET_ID  uniqueidentifier;
	declare @PARENT_TYPE      nvarchar(25);
	declare @PARENT_ID        uniqueidentifier;
	declare @DATE_START       datetime;
	declare @TIME_START       datetime;
	declare @STATUS           nvarchar(25);
	declare @TYPE             nvarchar(25);
	declare @ORIGINAL_EXISTS  bit;
	declare @ARCHIVE_ORIGINAL bit;
	declare @ARCHIVE_ALL      bit;
	set @DATE_START       = dbo.fnStoreDateOnly(@DATE_TIME);
	set @TIME_START       = dbo.fnStoreTimeOnly(@DATE_TIME);
	set @STATUS           = N'received';
	set @TYPE             = N'inbound';
	set @ORIGINAL_EXISTS  = 0;
	set @ARCHIVE_ORIGINAL = 0;
	set @ARCHIVE_ALL      = 0;

	if @TWITTER_ID = 0 begin -- then
		raiserror(N'TWITTER_ID is required', 16, 1);
		return;
	end -- if;
	if @NAME is null begin -- then
		raiserror(N'NAME is required', 16, 1);
		return;
	end -- if;
	if @ORIGINAL_ID > 0 begin -- then
		if exists(select * from TWITTER_MESSAGES where TWITTER_ID = @ORIGINAL_ID and DELETED = 0) begin -- then
			set @ORIGINAL_EXISTS = 1;
		end -- if;
	end -- if;
	if exists(select * from TWITTER_TRACKS where DELETED = 0 and NAME = @TRACK and TYPE = N'Archive Original') begin -- then
		set @ARCHIVE_ORIGINAL = 1;
	end -- if;
	if exists(select * from TWITTER_TRACKS where DELETED = 0 and NAME = @TRACK and TYPE = N'Archive All') begin -- then
		set @ARCHIVE_ALL = 1;
	end -- if;
	-- 10/27/2013 Paul.  Tracking can be picked-up mid stream, so if we want to track the original, but we have not captured the original, then insert an original record. 
	if @ARCHIVE_ORIGINAL = 1 and @ORIGINAL_ID > 0 and @ORIGINAL_EXISTS = 0  begin -- then
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		-- BEGIN Oracle Exception
		select top 1
		       @ASSIGNED_USER_ID = ASSIGNED_USER_ID
		     , @TEAM_ID          = TEAM_ID         
		     , @TEAM_SET_ID      = TEAM_SET_ID     
		     , @ASSIGNED_SET_ID  = ASSIGNED_SET_ID 
		  from TWITTER_TRACKS
		 where DELETED           = 0
		   and NAME              = @TRACK
		   and TYPE              = N'Archive Original'
		 order by DATE_ENTERED;
		-- END Oracle Exception
		if @PARENT_ID is null begin -- then
		-- BEGIN Oracle Exception
			select top 1
			       @PARENT_ID   = ID
			     , @PARENT_TYPE = N'Contacts'
			  from CONTACTS
			 where DELETED      = 0
			   and TWITTER_SCREEN_NAME = @ORIGINAL_SCREEN_NAME;
		-- END Oracle Exception
		end -- if;
		if @PARENT_ID is null begin -- then
		-- BEGIN Oracle Exception
			select top 1
			       @PARENT_ID   = ID
			     , @PARENT_TYPE = N'Leads'
			  from LEADS
			 where DELETED      = 0
			   and TWITTER_SCREEN_NAME = @ORIGINAL_SCREEN_NAME;
		-- END Oracle Exception
		end -- if;
		if @PARENT_ID is null begin -- then
		-- BEGIN Oracle Exception
			select top 1
			       @PARENT_ID   = ID
			     , @PARENT_TYPE = N'Prospects'
			  from PROSPECTS
			 where DELETED      = 0
			   and TWITTER_SCREEN_NAME = @ORIGINAL_SCREEN_NAME;
		-- END Oracle Exception
		end -- if;
		
		-- 10/27/2013 Paul.  Now insert the message using the Original values as the main tweet values. 
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		set @ID = newid();
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
			, ORIGINAL_USER_ID     
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
			, @ORIGINAL_NAME        
			, @ORIGINAL_DESCRIPTION 
			, @ORIGINAL_DATE_TIME   
			, @TIME_START           
			, @PARENT_TYPE          
			, @PARENT_ID            
			, @TYPE                 
			, @STATUS               
			, @ORIGINAL_ID          
			, @ORIGINAL_USER_ID     
			, @ORIGINAL_FULL_NAME   
			, @ORIGINAL_SCREEN_NAME 
			, 0
			, @ASSIGNED_SET_ID      
			);
		
		if @@ERROR = 0 begin -- then
			if not exists(select * from TWITTER_MESSAGES_CSTM where ID_C = @ID) begin -- then
				insert into TWITTER_MESSAGES_CSTM ( ID_C ) values ( @ID );
			end -- if;
		end -- if;
		
		if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
			exec dbo.spPARENT_UpdateLastActivity @MODIFIED_USER_ID, @PARENT_ID, @PARENT_TYPE;
		end -- if;

		-- 10/27/2013 Paul.  There may be more than one tracks that map to this message, so use the set insert operation. 
		insert into TWITTER_TRACK_MESSAGES
			( ID                   
			, CREATED_BY           
			, DATE_ENTERED         
			, MODIFIED_USER_ID     
			, DATE_MODIFIED        
			, DATE_MODIFIED_UTC    
			, TWITTER_TRACK_ID     
			, TWITTER_MESSAGE_ID   
			)
		select	   newid()
			, @MODIFIED_USER_ID     
			,  getdate()            
			, @MODIFIED_USER_ID     
			,  getdate()            
			,  getutcdate()         
			,  ID
			, @ID
		  from TWITTER_TRACKS
		 where DELETED = 0
		   and NAME    = @TRACK
		   and TYPE    = N'Archive Original';

		set @ID               = null;
		set @PARENT_ID        = null;
		set @PARENT_TYPE      = null;
		set @ASSIGNED_USER_ID = null;
		set @TEAM_ID          = null;
		set @TEAM_SET_ID      = null;
		set @ASSIGNED_SET_ID  = null;
	end -- if;

	-- BEGIN Oracle Exception
		select @ID = ID
		  from TWITTER_MESSAGES
		 where TWITTER_ID = @TWITTER_ID 
		   and DELETED = 0;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@ID) = 1 and ((@ARCHIVE_ORIGINAL = 1 and @ORIGINAL_ID = 0) or @ARCHIVE_ALL = 1) begin -- then
		-- 10/27/2013 Paul.  Archive Original and this is an original. 
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		if @ARCHIVE_ORIGINAL = 1 and @ORIGINAL_ID = 0 begin -- then
			-- BEGIN Oracle Exception
			select top 1
			       @ASSIGNED_USER_ID = ASSIGNED_USER_ID
			     , @TEAM_ID          = TEAM_ID         
			     , @TEAM_SET_ID      = TEAM_SET_ID     
			     , @ASSIGNED_SET_ID  = ASSIGNED_SET_ID 
			  from TWITTER_TRACKS
			 where DELETED           = 0
			   and NAME              = @TRACK
			   and TYPE              = N'Archive Original'
			 order by DATE_ENTERED;
			-- END Oracle Exception
		end else if @ARCHIVE_ALL = 1 begin -- then
			-- BEGIN Oracle Exception
			select top 1
			       @ASSIGNED_USER_ID = ASSIGNED_USER_ID
			     , @TEAM_ID          = TEAM_ID         
			     , @TEAM_SET_ID      = TEAM_SET_ID     
			     , @ASSIGNED_SET_ID  = ASSIGNED_SET_ID 
			  from TWITTER_TRACKS
			 where DELETED           = 0
			   and NAME              = @TRACK
			   and TYPE              = N'Archive All'
			 order by DATE_ENTERED;
			-- END Oracle Exception
		end -- if;
		if @PARENT_ID is null begin -- then
		-- BEGIN Oracle Exception
			select top 1
			       @PARENT_ID   = ID
			     , @PARENT_TYPE = N'Contacts'
			  from CONTACTS
			 where DELETED      = 0
			   and TWITTER_SCREEN_NAME = @TWITTER_SCREEN_NAME;
		-- END Oracle Exception
		end -- if;
		if @PARENT_ID is null begin -- then
		-- BEGIN Oracle Exception
			select top 1
			       @PARENT_ID   = ID
			     , @PARENT_TYPE = N'Leads'
			  from LEADS
			 where DELETED      = 0
			   and TWITTER_SCREEN_NAME = @TWITTER_SCREEN_NAME;
		-- END Oracle Exception
		end -- if;
		if @PARENT_ID is null begin -- then
		-- BEGIN Oracle Exception
			select top 1
			       @PARENT_ID   = ID
			     , @PARENT_TYPE = N'Prospects'
			  from PROSPECTS
			 where DELETED      = 0
			   and TWITTER_SCREEN_NAME = @TWITTER_SCREEN_NAME;
		-- END Oracle Exception
		end -- if;
		
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		set @ID = newid();
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
			, @ASSIGNED_SET_ID      
			);
		
		if @@ERROR = 0 begin -- then
			if not exists(select * from TWITTER_MESSAGES_CSTM where ID_C = @ID) begin -- then
				insert into TWITTER_MESSAGES_CSTM ( ID_C ) values ( @ID );
			end -- if;
		end -- if;
		
		if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
			exec dbo.spPARENT_UpdateLastActivity @MODIFIED_USER_ID, @PARENT_ID, @PARENT_TYPE;
		end -- if;

		-- 10/27/2013 Paul.  There may be more than one tracks that map to this message, so use the set insert operation. 
		insert into TWITTER_TRACK_MESSAGES
			( ID                   
			, CREATED_BY           
			, DATE_ENTERED         
			, MODIFIED_USER_ID     
			, DATE_MODIFIED        
			, DATE_MODIFIED_UTC    
			, TWITTER_TRACK_ID     
			, TWITTER_MESSAGE_ID   
			)
		select	   newid()
			, @MODIFIED_USER_ID     
			,  getdate()            
			, @MODIFIED_USER_ID     
			,  getdate()            
			,  getutcdate()         
			,  ID
			, @ID
		  from TWITTER_TRACKS
		 where DELETED = 0
		   and NAME    = @TRACK
		   and (   TYPE = N'Archive Original' and @ARCHIVE_ORIGINAL = 1 and @ORIGINAL_ID = 0
		        or TYPE = N'Archive All'      and @ARCHIVE_ALL = 1
		       );
	end -- if;
  end
GO

Grant Execute on dbo.spTWITTER_MESSAGES_InsertTrack to public;
GO

