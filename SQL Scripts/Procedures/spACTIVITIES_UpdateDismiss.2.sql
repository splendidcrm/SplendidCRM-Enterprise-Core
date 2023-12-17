if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACTIVITIES_UpdateDismiss' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACTIVITIES_UpdateDismiss;
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
-- 06/09/2017 Paul.  Add support for Tasks reminders. 
Create Procedure dbo.spACTIVITIES_UpdateDismiss
	( @ID                 uniqueidentifier
	, @MODIFIED_USER_ID   uniqueidentifier
	, @USER_ID            uniqueidentifier
	, @REMINDER_DISMISSED bit
	)
as
  begin
	set nocount on
	
	declare @ACTIVITY_TYPE nvarchar(25);
	-- BEGIN Oracle Exception
		select @ACTIVITY_TYPE = min(ACTIVITY_TYPE)
		  from vwACTIVITIES_MyList
		 where ID               = @ID
		   and ASSIGNED_USER_ID = @USER_ID
		 group by ACTIVITY_TYPE;
	-- END Oracle Exception

	if @ACTIVITY_TYPE = N'Meetings' begin -- then
		update MEETINGS_USERS
		   set REMINDER_DISMISSED = @REMINDER_DISMISSED
		     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where MEETING_ID         = @ID
		   and USER_ID            = @USER_ID
		   and DELETED            = 0;
	end else if @ACTIVITY_TYPE = N'Calls' begin -- then
		update CALLS_USERS
		   set REMINDER_DISMISSED = @REMINDER_DISMISSED
		     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where CALL_ID            = @ID
		   and USER_ID            = @USER_ID
		   and DELETED            = 0;
	-- 06/09/2017 Paul.  Add support for Tasks reminders. 
	end else if @ACTIVITY_TYPE = N'Tasks' begin -- then
		if exists(select * from TASKS_USERS where TASK_ID = @ID and USER_ID = @USER_ID) begin -- then
			update TASKS_USERS
			   set REMINDER_DISMISSED = @REMINDER_DISMISSED
			     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
			     , DATE_MODIFIED      = getdate()
			     , DATE_MODIFIED_UTC  = getutcdate()
			 where TASK_ID            = @ID
			   and USER_ID            = @USER_ID
			   and DELETED            = 0;
		end else begin
			insert into TASKS_USERS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, DATE_MODIFIED_UTC
				, TASK_ID          
				, USER_ID          
				, REMINDER_DISMISSED
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				,  getutcdate()     
				, @ID               
				, @USER_ID          
				, @REMINDER_DISMISSED
				);
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spACTIVITIES_UpdateDismiss to public;
GO

