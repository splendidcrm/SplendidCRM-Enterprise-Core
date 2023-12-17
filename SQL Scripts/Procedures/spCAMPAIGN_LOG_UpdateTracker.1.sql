if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGN_LOG_UpdateTracker' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGN_LOG_UpdateTracker;
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
Create Procedure dbo.spCAMPAIGN_LOG_UpdateTracker
	( @MODIFIED_USER_ID    uniqueidentifier
	, @TARGET_TRACKER_KEY  uniqueidentifier
	, @ACTIVITY_TYPE       nvarchar(25)
	, @CAMPAIGN_TRKRS_ID   uniqueidentifier
	, @TARGET_ID           uniqueidentifier output
	, @TARGET_TYPE         nvarchar(25) output
	)
as
  begin
	set nocount on
	
	declare @ID               uniqueidentifier;
	declare @CAMPAIGN_ID      uniqueidentifier;
	declare @RELATED_ID       uniqueidentifier;
	declare @RELATED_TYPE     nvarchar(25);
	declare @LIST_ID          uniqueidentifier;
	declare @MARKETING_ID     uniqueidentifier;
	declare @MORE_INFORMATION nvarchar(100);
	-- BEGIN Oracle Exception
		select @ID                = ID
		     , @TARGET_ID         = TARGET_ID
		     , @TARGET_TYPE       = TARGET_TYPE
		  from CAMPAIGN_LOG
		 where TARGET_TRACKER_KEY = @TARGET_TRACKER_KEY
		   and ACTIVITY_TYPE      = @ACTIVITY_TYPE
		   and (@CAMPAIGN_TRKRS_ID is null or RELATED_ID = @CAMPAIGN_TRKRS_ID);
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @RELATED_ID   = null;
		set @RELATED_TYPE = null;
		-- BEGIN Oracle Exception
			select @ID                = ID
			     , @CAMPAIGN_ID       = CAMPAIGN_ID
			     , @TARGET_ID         = TARGET_ID
			     , @TARGET_TYPE       = TARGET_TYPE
			     , @RELATED_ID        = RELATED_ID
			     , @RELATED_TYPE      = RELATED_TYPE
			     , @LIST_ID           = LIST_ID
			     , @MARKETING_ID      = MARKETING_ID
			     , @MORE_INFORMATION  = MORE_INFORMATION
			  from CAMPAIGN_LOG
			 where TARGET_TRACKER_KEY = @TARGET_TRACKER_KEY
			   and ACTIVITY_TYPE      = N'targeted';
		-- END Oracle Exception
		
		-- 09/10/2007 Paul.  Users cannot remove themselves because the Users table does not have an opt out column. 
		if dbo.fnIsEmptyGuid(@ID) = 0 and (@TARGET_TYPE <> N'users' or @ACTIVITY_TYPE <> 'removed') begin -- then
			if @CAMPAIGN_TRKRS_ID is not null begin -- then
				set @RELATED_ID   = @CAMPAIGN_TRKRS_ID;
				set @RELATED_TYPE = N'CampaignTrackers';
			end -- if;
			set @ID = newid();
			insert into CAMPAIGN_LOG
				( ID                 
				, CREATED_BY         
				, DATE_ENTERED       
				, MODIFIED_USER_ID   
				, DATE_MODIFIED      
				, CAMPAIGN_ID        
				, TARGET_TRACKER_KEY 
				, TARGET_ID          
				, TARGET_TYPE        
				, ACTIVITY_TYPE      
				, ACTIVITY_DATE      
				, RELATED_ID         
				, RELATED_TYPE       
				, HITS               
				, LIST_ID            
				, MARKETING_ID       
				, MORE_INFORMATION   
				)
			values 	( @ID                 
				, @MODIFIED_USER_ID         
				,  getdate()          
				, @MODIFIED_USER_ID   
				,  getdate()          
				, @CAMPAIGN_ID        
				, @TARGET_TRACKER_KEY 
				, @TARGET_ID          
				, @TARGET_TYPE        
				, @ACTIVITY_TYPE      
				,  getdate()          
				, @RELATED_ID         
				, @RELATED_TYPE       
				, 1               
				, @LIST_ID            
				, @MARKETING_ID       
				, @MORE_INFORMATION   
				);
		end -- if;
		-- 01/21/2008 Paul.  If we get an email bounce, then go back and mark the email as an error. 
		if dbo.fnIsEmptyGuid(@RELATED_ID) = 0 and @RELATED_TYPE = N'Emails' and (@ACTIVITY_TYPE = N'invalid email' or @ACTIVITY_TYPE = N'send error') begin -- then
			-- 01/21/2008 Paul.  Lets not update MODIFIED_USER_ID as it will almost always be null. 
			update EMAILS
			   set STATUS           = @ACTIVITY_TYPE
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			 where ID               = @RELATED_ID
			   and STATUS           = N'sent'
			   and DELETED          = 0;
		end -- if;

		-- 06/12/2009 Paul.  We want to allow workflow emails to have an opt-out. 
		-- Workflow events will use the ID of the record. 
		if dbo.fnIsEmptyGuid(@TARGET_ID) = 1 begin -- then
			select @TARGET_ID         = PARENT_ID
			     , @TARGET_TYPE       = PARENT_TYPE
			  from vwPARENTS_EMAIL_ADDRESS
			 where PARENT_ID          = @TARGET_TRACKER_KEY;
		end -- if;
	end else begin
		update CAMPAIGN_LOG
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID 
		     , DATE_MODIFIED       =  getdate()        
		     , DATE_MODIFIED_UTC   =  getutcdate()     
		     , HITS                = HITS + 1          
		 where ID                  = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spCAMPAIGN_LOG_UpdateTracker to public;
GO
 
