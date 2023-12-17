if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSMS_MESSAGES_UpdateStatus' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSMS_MESSAGES_UpdateStatus;
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
Create Procedure dbo.spSMS_MESSAGES_UpdateStatus
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @STATUS            nvarchar(25)
	, @MESSAGE_SID       nvarchar(100)
	)
as
  begin
	set nocount on

	declare @DATE_SENT datetime;
	set @DATE_SENT = getdate();
	if @STATUS = N'sent' begin -- then
		update SMS_MESSAGES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , TYPE              = N'sent'
		     , STATUS            = @STATUS           
		     , MESSAGE_SID       = isnull(@MESSAGE_SID, MESSAGE_SID)
		     , DATE_START        = dbo.fnStoreDateOnly(@DATE_SENT)
		     , TIME_START        = dbo.fnStoreTimeOnly(@DATE_SENT)
		 where ID                = @ID               
		   and DELETED           = 0;
	end else begin
		update SMS_MESSAGES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , STATUS            = @STATUS           
		     , MESSAGE_SID       = isnull(@MESSAGE_SID, MESSAGE_SID)
		 where ID                = @ID               
		   and DELETED           = 0;
	end -- if;
	
  end
GO
 
Grant Execute on dbo.spSMS_MESSAGES_UpdateStatus to public;
GO
 
