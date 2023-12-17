if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUSINESS_PROCESSES_RUN_Failed' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUSINESS_PROCESSES_RUN_Failed;
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
Create Procedure dbo.spBUSINESS_PROCESSES_RUN_Failed
	( @ID                            uniqueidentifier
	, @BUSINESS_PROCESS_INSTANCE_ID  uniqueidentifier
	, @MODIFIED_USER_ID              uniqueidentifier
	, @STATUS                        nvarchar(25)
	, @DESCRIPTION                   nvarchar(max)
	)
as
  begin
	set nocount on
	
	if @BUSINESS_PROCESS_INSTANCE_ID is not null begin -- then
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		     , DESCRIPTION       = isnull(@DESCRIPTION, DESCRIPTION)
		 where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID
		   and STATUS in (N'Ready', N'Started', N'Resumed', N'Resuming');
	end else begin
		update BUSINESS_PROCESSES_RUN
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATUS
		     , DESCRIPTION       = isnull(@DESCRIPTION, DESCRIPTION)
		 where ID                = @ID;
	end -- if;
  end
GO

Grant Execute on dbo.spBUSINESS_PROCESSES_RUN_Failed to public;
GO

