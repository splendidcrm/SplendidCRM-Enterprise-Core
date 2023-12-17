if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGN_LOG_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGN_LOG_Update;
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
Create Procedure dbo.spCAMPAIGN_LOG_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @CAMPAIGN_ID         uniqueidentifier
	, @TARGET_TRACKER_KEY  uniqueidentifier
	, @TARGET_ID           uniqueidentifier
	, @TARGET_TYPE         nvarchar(25)
	, @ACTIVITY_TYPE       nvarchar(25)
	, @ACTIVITY_DATE       datetime
	, @RELATED_ID          uniqueidentifier
	, @RELATED_TYPE        nvarchar(25)
	, @ARCHIVED            bit
	, @HITS                int
	, @LIST_ID             uniqueidentifier
	, @MORE_INFORMATION    nvarchar(100)
	)
as
  begin
	set nocount on
	
	if not exists(select * from CAMPAIGN_LOG where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
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
			, ARCHIVED           
			, HITS               
			, LIST_ID            
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
			, @ACTIVITY_DATE      
			, @RELATED_ID         
			, @RELATED_TYPE       
			, @ARCHIVED           
			, @HITS               
			, @LIST_ID            
			, @MORE_INFORMATION   
			);
	end else begin
		update CAMPAIGN_LOG
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , CAMPAIGN_ID         = @CAMPAIGN_ID        
		     , TARGET_TRACKER_KEY  = @TARGET_TRACKER_KEY 
		     , TARGET_ID           = @TARGET_ID          
		     , TARGET_TYPE         = @TARGET_TYPE        
		     , ACTIVITY_TYPE       = @ACTIVITY_TYPE      
		     , ACTIVITY_DATE       = @ACTIVITY_DATE      
		     , RELATED_ID          = @RELATED_ID         
		     , RELATED_TYPE        = @RELATED_TYPE       
		     , ARCHIVED            = @ARCHIVED           
		     , HITS                = @HITS               
		     , LIST_ID             = @LIST_ID            
		     , MORE_INFORMATION    = @MORE_INFORMATION   
		 where ID                  = @ID                 ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spCAMPAIGN_LOG_Update to public;
GO
 
