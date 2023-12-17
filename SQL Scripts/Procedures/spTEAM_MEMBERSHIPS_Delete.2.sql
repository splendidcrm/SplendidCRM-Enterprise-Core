if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_MEMBERSHIPS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_MEMBERSHIPS_Delete;
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
-- 08/07/2013 Paul.  Add Oracle Exception. 
-- 02/22/2015 Paul.  When removing a user from a team, also remove default team for that user if it is the same team. 
Create Procedure dbo.spTEAM_MEMBERSHIPS_Delete
	( @MODIFIED_USER_ID uniqueidentifier
	, @TEAM_ID          uniqueidentifier
	, @USER_ID          uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update TEAM_MEMBERSHIPS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where TEAM_ID          = @TEAM_ID
		   and USER_ID          = @USER_ID
		   and DELETED          = 0;
	-- END Oracle Exception

	-- 11/18/2006 Paul.  Refresh all the implicit assignments any time a member is removed. 
	-- Just make sure not to use spTEAM_MEMBERSHIPS_Delete inside spTEAM_MEMBERSHIPS_UpdateImplicit. 
	exec dbo.spTEAM_MEMBERSHIPS_UpdateImplicit @MODIFIED_USER_ID, @TEAM_ID;

	-- 02/22/2015 Paul.  When removing a user from a team, also remove default team for that user if it is the same team. 
	-- This will prevent records created by this user from being accessed by this same user. 
	if exists(select * from USERS where ID = @USER_ID and DELETED = 0 and DEFAULT_TEAM = @TEAM_ID) begin -- then
		update USERS
		   set DEFAULT_TEAM      = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where ID                = @USER_ID
		   and DEFAULT_TEAM      = @TEAM_ID
		   and DELETED           = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spTEAM_MEMBERSHIPS_Delete to public;
GO

