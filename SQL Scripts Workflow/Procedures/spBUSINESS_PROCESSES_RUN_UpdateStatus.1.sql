if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUSINESS_PROCESSES_RUN_UpdateStatus' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUSINESS_PROCESSES_RUN_UpdateStatus;
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
Create Procedure dbo.spBUSINESS_PROCESSES_RUN_UpdateStatus
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @STATUS            nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @EXISTING_STATUS nvarchar(25);
	select @EXISTING_STATUS = STATUS
	  from BUSINESS_PROCESSES_RUN
	 where ID = @ID;

	if @STATUS = N'Started' begin -- then
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		     , START_DATE        = isnull(START_DATE, getdate())
		 where ID                = @ID;
	end else if @STATUS = N'Completed' begin -- then
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		     , END_DATE          = isnull(END_DATE, getdate())
		 where ID                = @ID;
	-- 06/24/2016 Paul.  Make sure that the Resumed status does not overwrite a valid status.  It can only change Resuming to Resumed. 
	-- 09/05/2016 Paul.  END_DATE should not be set during resume. 
	end else if @STATUS = N'Resumed' and @EXISTING_STATUS = N'Resuming' begin -- then
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		 where ID                = @ID
		   and STATUS            <> N'Completed';
	end else if @EXISTING_STATUS <> N'Faulted' and @EXISTING_STATUS = N'Completed' begin -- then
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		 where ID                = @ID
		   and STATUS            <> N'Completed';
	end -- if;
  end
GO

Grant Execute on dbo.spBUSINESS_PROCESSES_RUN_UpdateStatus to public;
GO

