if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAILMAN_SendSuccessful' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAILMAN_SendSuccessful;
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
-- 01/13/2008 Paul.  The email manager is also being used for AutoReplies, so the campaign might not exist. 
Create Procedure dbo.spEMAILMAN_SendSuccessful
	( @ID                  uniqueidentifier
	, @MODIFIED_USER_ID    uniqueidentifier
	, @TARGET_TRACKER_KEY  uniqueidentifier
	, @EMAIL_ID            uniqueidentifier
	)
as
  begin
	set nocount on
	
	if exists(select * from vwEMAILMAN_List where ID = @ID) begin -- then
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
			, MARKETING_ID       
			, LIST_ID            
			, MORE_INFORMATION   
			)
		select	   newid()            
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  CAMPAIGN_ID        
			, @TARGET_TRACKER_KEY 
			,  RELATED_ID         
			,  RELATED_TYPE       
			,  N'targeted'        
			,  getdate()          
			, @EMAIL_ID           
			,  N'Emails'          
			,  MARKETING_ID       
			,  LIST_ID            
			,  RECIPIENT_EMAIL    
		  from vwEMAILMAN_List
		 where ID = @ID
		   and CAMPAIGN_ID is not null;
		
		exec dbo.spEMAILMAN_Delete @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spEMAILMAN_SendSuccessful to public;
GO

