if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAILMAN_SendFailed' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAILMAN_SendFailed;
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
-- 09/13/2008 Paul.  DB2 does not like the use of NULL in the insert into statement. 
Create Procedure dbo.spEMAILMAN_SendFailed
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ACTIVITY_TYPE     nvarchar(25)
	, @ABORT             bit
	)
as
  begin
	set nocount on
	
	declare @RELATED_ID       uniqueidentifier;
	declare @RELATED_TYPE     nvarchar(25);

	update EMAILMAN
	   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , IN_QUEUE          = 1
	     , IN_QUEUE_DATE     = getdate()
	     , SEND_ATTEMPTS     = SEND_ATTEMPTS + 1
	 where ID                = @ID               
	   and DELETED           = 0;
	-- 04/13/2008 Paul.  Change the order of the condition to simplify migration to Oracle. 
	if exists(select * from vwEMAILMAN_List where ID = @ID and SEND_ATTEMPTS >= 5 or @ABORT = 1) begin -- then
		-- BEGIN Oracle Exception
			select @RELATED_ID   = RELATED_ID
			     , @RELATED_TYPE = RELATED_TYPE
			  from vwEMAILMAN_List
			 where ID            = @ID;
		-- END Oracle Exception
		-- 01/21/2008 Paul.  If we get an send error, then update the email status. 
		if dbo.fnIsEmptyGuid(@RELATED_ID) = 0 and @RELATED_TYPE = N'Emails' begin -- then
			-- 01/21/2008 Paul.  Lets not update MODIFIED_USER_ID as it will almost always be null. 
			update EMAILS
			   set STATUS           = N'send error'
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			 where ID               = @RELATED_ID
			   and DELETED          = 0;
		end -- if;

		insert into CAMPAIGN_LOG
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, CAMPAIGN_ID        
--			, TARGET_TRACKER_KEY 
			, TARGET_ID          
			, TARGET_TYPE        
			, ACTIVITY_TYPE      
			, ACTIVITY_DATE      
--			, RELATED_ID         
--			, RELATED_TYPE       
			, MARKETING_ID       
			, LIST_ID            
			, MORE_INFORMATION   
			)
		select	  newid()             
			, @MODIFIED_USER_ID         
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  CAMPAIGN_ID        
--			,  null
			,  RELATED_ID         
			,  RELATED_TYPE       
			, @ACTIVITY_TYPE     
			,  getdate()          
--			,  null               
--			,  null               
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

Grant Execute on dbo.spEMAILMAN_SendFailed to public;
GO

