if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_RUN_UpdateStatus' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_RUN_UpdateStatus;
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
-- 10/28/2023 Paul.  WF3 to WF4 will use WORKFLOW_INSTANCE_ID instead of @WORKFLOW_INSTANCE_INTERNAL_ID. 
Create Procedure dbo.spWORKFLOW_RUN_UpdateStatus
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @STATUS            nvarchar(25)
	)
as
  begin
	set nocount on
	
	-- 10/29/2023 Paul.  WF3 to WF4 will use WORKFLOW_INSTANCE_ID instead of @WORKFLOW_INSTANCE_INTERNAL_ID. 
	if exists(select * from WORKFLOW_RUN where WORKFLOW_INSTANCE_ID = @ID) begin -- then
		select @ID = ID
		  from WORKFLOW_RUN
		 where WORKFLOW_INSTANCE_ID = @ID;
	end -- if;

	if @STATUS = N'Started' begin -- then
		update WORKFLOW_RUN
		   set MODIFIED_USER_ID = @MODIFIED_USER_ID
		     , DATE_MODIFIED    =  getdate()       
		     , DATE_MODIFIED_UTC=  getutcdate()    
		     , STATUS           = @STATUS
		     , START_DATE       = isnull(START_DATE, getdate())
		 where ID               = @ID;
	end else if @STATUS = N'Completed' begin -- then
		-- 10/29/2023 Paul.  Don't overwrite Faulted or Aborted. 
		if exists(select * from WORKFLOW_RUN where ID = @ID and STATUS in (N'Faulted', N'Aborted')) begin -- then
			update WORKFLOW_RUN
			   set MODIFIED_USER_ID = @MODIFIED_USER_ID
			     , DATE_MODIFIED    =  getdate()       
			     , DATE_MODIFIED_UTC=  getutcdate()    
			     , END_DATE         = isnull(END_DATE, getdate())
			 where ID               = @ID;
		end else begin
			update WORKFLOW_RUN
			   set MODIFIED_USER_ID = @MODIFIED_USER_ID
			     , DATE_MODIFIED    =  getdate()       
			     , DATE_MODIFIED_UTC=  getutcdate()    
--			     , STATUS           = @STATUS
			     , END_DATE         = isnull(END_DATE, getdate())
			 where ID               = @ID;
		end -- if;
	end else if @STATUS = N'Unloaded' begin -- then
		-- 10/29/2023 Paul.  WF3 to WF4.  Don't overwrite Faulted or Aborted, or Completed. 
		-- 11/08/2023 Paul.  WF3 to WF4.  Started should be changed to Completed. 
		select @STATUS = (case STATUS
		                  when N'Faulted'   then STATUS
		                  when N'Aborted'   then STATUS
		                  when N'Completed' then STATUS
		                  when N'Started'   then N'Completed'
		                  else @STATUS
		                  end)
		  from WORKFLOW_RUN
		 where ID = @ID;
		update WORKFLOW_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		 where ID                = @ID;
	end else begin
		update WORKFLOW_RUN
		   set MODIFIED_USER_ID = @MODIFIED_USER_ID
		     , DATE_MODIFIED    =  getdate()       
		     , DATE_MODIFIED_UTC=  getutcdate()    
		     , STATUS           = @STATUS
		 where ID               = @ID;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_RUN_UpdateStatus to public;
GO

