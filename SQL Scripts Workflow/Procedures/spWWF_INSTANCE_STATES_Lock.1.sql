if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_INSTANCE_STATES_Lock' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_INSTANCE_STATES_Lock;
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
-- 07/16/2008 Paul.  Similar to RetrieveInstanceState. 
Create Procedure dbo.spWWF_INSTANCE_STATES_Lock
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @OWNER_ID          uniqueidentifier
	, @OWNED_UNTIL       datetime
	, @LOCK_SUCCESSFUL   bit out
	)
as
  begin
	set nocount on
	
	if exists(select * from WWF_INSTANCE_STATES where ID = @ID and (OWNER_ID = @OWNER_ID or OWNER_ID is null or OWNED_UNTIL < getdate())) begin -- then
		-- 07/16/2008 Paul.  Microsoft's RetrieveInstanceState does not set UNLOCKED = 0, but it seems to make sense. 
		update WWF_INSTANCE_STATES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , OWNER_ID          = @OWNER_ID         
		     , OWNED_UNTIL       = @OWNED_UNTIL      
		 where ID                = @ID               ;
		set @LOCK_SUCCESSFUL = 1;
	end else begin
		set @LOCK_SUCCESSFUL = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spWWF_INSTANCE_STATES_Lock to public;
GO

