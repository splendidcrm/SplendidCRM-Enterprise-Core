if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_RUN_Failed' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_RUN_Failed;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/29/2023 Paul.  Prevent overwriting of Fault. 
Create Procedure dbo.spWORKFLOW_RUN_Failed
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @STATUS            nvarchar(25)
	, @DESCRIPTION       nvarchar(max)
	)
as
  begin
	set nocount on
	
	-- 10/29/2023 Paul.  Prevent overwriting of Fault. 
	if exists(select * from WORKFLOW_RUN where ID = @ID and STATUS in (N'Faulted', N'Aborted')) begin -- then
		update WORKFLOW_RUN
		   set MODIFIED_USER_ID = @MODIFIED_USER_ID
		     , DATE_MODIFIED    =  getdate()       
		     , DATE_MODIFIED_UTC=  getutcdate()    
		 where ID               = @ID;
	end else begin
		if @DESCRIPTION is not null begin -- then
				update WORKFLOW_RUN
				   set MODIFIED_USER_ID = @MODIFIED_USER_ID
				     , DATE_MODIFIED    =  getdate()       
				     , DATE_MODIFIED_UTC=  getutcdate()    
				     , STATUS           = @STATUS
				     , DESCRIPTION      = @DESCRIPTION
				 where ID               = @ID;
		end else begin
			update WORKFLOW_RUN
			   set MODIFIED_USER_ID = @MODIFIED_USER_ID
			     , DATE_MODIFIED    =  getdate()       
			     , DATE_MODIFIED_UTC=  getutcdate()    
			     , STATUS           = @STATUS
			 where ID               = @ID;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_RUN_Failed to public;
GO
