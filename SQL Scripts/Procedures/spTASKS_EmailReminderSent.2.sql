if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTASKS_EmailReminderSent' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTASKS_EmailReminderSent;
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
Create Procedure dbo.spTASKS_EmailReminderSent
	( @ID                 uniqueidentifier
	, @MODIFIED_USER_ID   uniqueidentifier
	, @INVITEE_TYPE       nvarchar(25)
	, @INVITEE_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	if @INVITEE_TYPE = N'Users' begin -- then
		if exists(select * from TASKS_USERS where TASK_ID = @ID and USER_ID = @INVITEE_ID) begin -- then
			update TASKS_USERS
			   set EMAIL_REMINDER_SENT = 1
			     , MODIFIED_USER_ID    = @MODIFIED_USER_ID
			     , DATE_MODIFIED       = getdate()
			     , DATE_MODIFIED_UTC   = getutcdate()
			 where TASK_ID             = @ID
			   and USER_ID             = @INVITEE_ID
			   and DELETED             = 0;
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
				, EMAIL_REMINDER_SENT
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				,  getutcdate()     
				, @ID               
				, @INVITEE_ID       
				, 1                 
				);
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spTASKS_EmailReminderSent to public;
GO

