if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGN_LOG_BannerTracker' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGN_LOG_BannerTracker;
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
Create Procedure dbo.spCAMPAIGN_LOG_BannerTracker
	( @MODIFIED_USER_ID    uniqueidentifier
	, @ACTIVITY_TYPE       nvarchar(25)
	, @CAMPAIGN_TRKRS_ID   uniqueidentifier
	, @MORE_INFORMATION    nvarchar(100)
	)
as
  begin
	set nocount on
	
	declare @ID                 uniqueidentifier;
	declare @TARGET_TRACKER_KEY uniqueidentifier;
	declare @CAMPAIGN_ID        uniqueidentifier;
	declare @RELATED_ID         uniqueidentifier;
	declare @RELATED_TYPE       nvarchar(25);
	declare @TARGET_ID          uniqueidentifier;
	declare @TARGET_TYPE        nvarchar(25);
	declare @LIST_ID            uniqueidentifier;
	declare @MARKETING_ID       uniqueidentifier;

	-- 09/10/2007 Paul.  For banners, attempt to count hits by storing the REMOTE_ADDR. 
	-- BEGIN Oracle Exception
		select @ID              = ID
		  from CAMPAIGN_LOG
		 where RELATED_ID       = @CAMPAIGN_TRKRS_ID
		   and RELATED_TYPE     = N'CampaignTrackers'
		   and ACTIVITY_TYPE    = @ACTIVITY_TYPE
		   and MORE_INFORMATION = @MORE_INFORMATION;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select @CAMPAIGN_ID = CAMPAIGN_ID
			  from CAMPAIGN_TRKRS
			 where ID = @CAMPAIGN_TRKRS_ID;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@CAMPAIGN_ID) = 0 begin -- then
			set @ID                 = newid();
			set @TARGET_TRACKER_KEY = newid();
			set @RELATED_ID         = @CAMPAIGN_TRKRS_ID;
			set @RELATED_TYPE       = N'CampaignTrackers';
			set @TARGET_ID          = newid();
			set @TARGET_TYPE        = N'Prospects';
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
				, @CAMPAIGN_TRKRS_ID  -- @RELATED_ID         
				, @RELATED_TYPE       
				, 1                   
				, @MORE_INFORMATION   
				);
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
 
Grant Execute on dbo.spCAMPAIGN_LOG_BannerTracker to public;
GO
 
