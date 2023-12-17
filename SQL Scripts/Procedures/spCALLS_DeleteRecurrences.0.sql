if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALLS_DeleteRecurrences' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALLS_DeleteRecurrences;
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
-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
Create Procedure dbo.spCALLS_DeleteRecurrences
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @DELETE_ALL       bit
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update CALLS_USERS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , DELETED           = 1                 
		 where CALL_ID in (select ID from CALLS where REPEAT_PARENT_ID = @ID and (@DELETE_ALL = 1 or DATE_START > getdate()) and DELETED = 0);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CALLS_CONTACTS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , DELETED           = 1                 
		 where CALL_ID in (select ID from CALLS where REPEAT_PARENT_ID = @ID and (@DELETE_ALL = 1 or DATE_START > getdate()) and DELETED = 0);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CALLS_LEADS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , DELETED           = 1                 
		 where CALL_ID in (select ID from CALLS where REPEAT_PARENT_ID = @ID and (@DELETE_ALL = 1 or DATE_START > getdate()) and DELETED = 0);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update NOTES_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from NOTES
			 where PARENT_ID in (select ID from CALLS where REPEAT_PARENT_ID = @ID and (@DELETE_ALL = 1 or DATE_START > getdate()) and DELETED = 0)
			   and DELETED          = 0
			);

		update NOTES
		   set PARENT_ID        = null
		     , PARENT_TYPE      = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID in (select ID from CALLS where REPEAT_PARENT_ID = @ID and (@DELETE_ALL = 1 or DATE_START > getdate()) and DELETED = 0)
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update CALLS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			  from CALLS
			  where REPEAT_PARENT_ID  = @ID
			   and (@DELETE_ALL = 1 or DATE_START > getdate())
			   and DELETED           = 0
			);
		update CALLS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID   
		     , DATE_MODIFIED     =  getdate()          
		     , DATE_MODIFIED_UTC =  getutcdate()       
		     , DELETED           =  1                  
		 where REPEAT_PARENT_ID  = @ID
		   and (@DELETE_ALL = 1 or DATE_START > getdate())
		   and DELETED           = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from TRACKER
		 where ITEM_ID in (select ID from CALLS where REPEAT_PARENT_ID = @ID and (@DELETE_ALL = 1 or DATE_START > getdate()) and DELETED = 0);
	-- END Oracle Exception
  end
GO

Grant Execute on dbo.spCALLS_DeleteRecurrences to public;
GO

