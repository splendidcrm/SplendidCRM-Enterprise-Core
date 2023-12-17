if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_INSTANCES_RUNNABLE_Failed' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_INSTANCES_RUNNABLE_Failed;
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
Create Procedure dbo.spWF4_INSTANCES_RUNNABLE_Failed
	( @ID                           uniqueidentifier
	, @MODIFIED_USER_ID             uniqueidentifier
	, @STATUS                       nvarchar(25)
	, @DESCRIPTION                  nvarchar(max)
	)
as
  begin
	set nocount on
	
 	-- 07/31/2016 Paul.  WF4_INSTANCES_RUNNABLE should be updated by the storage instance. 

	if @DESCRIPTION is not null begin -- then
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		     , DESCRIPTION       = @DESCRIPTION
		 where BUSINESS_PROCESS_INSTANCE_ID = @ID;
	end else begin
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		 where BUSINESS_PROCESS_INSTANCE_ID = @ID;
	end -- if;
  end
GO

Grant Execute on dbo.spWF4_INSTANCES_RUNNABLE_Failed to public;
GO

