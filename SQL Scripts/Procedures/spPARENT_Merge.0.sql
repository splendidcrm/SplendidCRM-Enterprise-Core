if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPARENT_Merge' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPARENT_Merge;
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
-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
Create Procedure dbo.spPARENT_Merge
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @MERGE_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update ACCOUNTS_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from ACCOUNTS
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update ACCOUNTS
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CALLS_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from CALLS
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update CALLS
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update EMAILS_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from EMAILS
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update EMAILS
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 09/25/2013 Paul.  SMS messages act like emails. 
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update SMS_MESSAGES_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from SMS_MESSAGES
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update SMS_MESSAGES
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update MEETINGS_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from MEETINGS
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update MEETINGS
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update NOTES_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from NOTES
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update NOTES
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update PROJECT_TASK_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from PROJECT_TASK
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update PROJECT_TASK
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update PROJECT_RELATION
		   set RELATION_ID      = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where RELATION_ID      = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update TASKS_CSTM
		   set ID_C              = ID_C
		 where ID_C in
			(select ID
			   from TASKS
			  where PARENT_ID        = @MERGE_ID
			    and DELETED           = 0
			);
		update TASKS
		   set PARENT_ID        = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where PARENT_ID        = @MERGE_ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spPARENT_Merge to public;
GO

