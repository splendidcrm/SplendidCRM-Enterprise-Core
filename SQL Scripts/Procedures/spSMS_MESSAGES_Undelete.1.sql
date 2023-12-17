if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSMS_MESSAGES_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSMS_MESSAGES_Undelete;
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
Create Procedure dbo.spSMS_MESSAGES_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- 09/25/2013 Paul.  Email Images also need to be deleted as they are tied directly to the email. 
	-- BEGIN Oracle Exception
		update EMAIL_IMAGES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @ID
		   and DELETED          = 1
		   and ID in (select ID from EMAIL_IMAGES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and PARENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update SMS_MESSAGES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from SMS_MESSAGES
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from SMS_MESSAGES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update SMS_MESSAGES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from SMS_MESSAGES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spSMS_MESSAGES_Undelete to public;
GO

