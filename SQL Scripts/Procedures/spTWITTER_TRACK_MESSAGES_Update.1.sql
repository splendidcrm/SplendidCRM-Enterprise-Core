if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTWITTER_TRACK_MESSAGES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTWITTER_TRACK_MESSAGES_Update;
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
Create Procedure dbo.spTWITTER_TRACK_MESSAGES_Update
	( @MODIFIED_USER_ID   uniqueidentifier
	, @TWITTER_TRACK_ID   uniqueidentifier
	, @TWITTER_MESSAGE_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from TWITTER_TRACK_MESSAGES
		 where TWITTER_MESSAGE_ID = @TWITTER_MESSAGE_ID
		   and TWITTER_TRACK_ID   = @TWITTER_TRACK_ID
		   and DELETED            = 0;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into TWITTER_TRACK_MESSAGES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, TWITTER_MESSAGE_ID       
			, TWITTER_TRACK_ID       
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @TWITTER_MESSAGE_ID       
			, @TWITTER_TRACK_ID       
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spTWITTER_TRACK_MESSAGES_Update to public;
GO
 
