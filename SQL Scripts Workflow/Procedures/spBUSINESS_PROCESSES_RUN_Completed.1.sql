if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUSINESS_PROCESSES_RUN_Completed' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUSINESS_PROCESSES_RUN_Completed;
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
Create Procedure dbo.spBUSINESS_PROCESSES_RUN_Completed
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	)
as
  begin
	set nocount on
	
	if exists(select * from BUSINESS_PROCESSES_RUN where ID = @ID and STATUS <> N'Completed') begin -- then
		update BUSINESS_PROCESSES_RUN
		   set DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = N'Completed'
		     , END_DATE          = getdate()
		 where BUSINESS_PROCESS_INSTANCE_ID = @ID;
		-- 09/05/2016 Paul.  We need to clear the process for those that have been skipped. 
		update PROCESSES
		   set DATE_MODIFIED                =  getdate()       
		     , DATE_MODIFIED_UTC            =  getutcdate()    
		     , STATUS                       = N'Skipped'
		 where BUSINESS_PROCESS_INSTANCE_ID = @ID
		   and DELETED                      = 0
		   and STATUS                       in (N'In Progress', N'Unclaimed')
		   and APPROVAL_USER_ID             is null;
	end -- if;
  end
GO

Grant Execute on dbo.spBUSINESS_PROCESSES_RUN_Completed to public;
GO

