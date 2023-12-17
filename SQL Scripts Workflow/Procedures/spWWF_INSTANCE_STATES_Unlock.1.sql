if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_INSTANCE_STATES_Unlock' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_INSTANCE_STATES_Unlock;
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
-- 07/16/2008 Paul.  Similar to UnlockInstanceState. 
Create Procedure dbo.spWWF_INSTANCE_STATES_Unlock
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @OWNER_ID          uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- 07/16/2008 Paul.  OWNED_UNTIL is null when owned forever. 
	-- 07/16/2008 Paul.  Microsoft's UnlockInstanceState does not set UNLOCKED = 1, but it seems to make sense. 
	-- 07/16/2008 Paul.  A timer does not resume operation after a workflow is reloaded in Microsoft Windows Workflow Foundation
	-- http://support.microsoft.com/default.aspx?scid=kb;en-us;932394
	-- http://forums.microsoft.com/msdn/ShowPost.aspx?PostID=1848286&SiteID=1
	update WWF_INSTANCE_STATES
	   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
	     , DATE_MODIFIED     =  getdate()        
	     , DATE_MODIFIED_UTC =  getutcdate()     
	     , OWNER_ID          = null              
	     , OWNED_UNTIL       = null              
	     , UNLOCKED          = 1                 
	 where ID                = @ID               
	   and ((OWNER_ID = @OWNER_ID and (OWNED_UNTIL > getdate() or OWNED_UNTIL is null)) or (OWNER_ID is null and @OWNER_ID is null));
  end
GO

Grant Execute on dbo.spWWF_INSTANCE_STATES_Unlock to public;
GO

