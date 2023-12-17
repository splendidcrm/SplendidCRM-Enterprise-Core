if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_ROLES_USERS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_ROLES_USERS_Delete;
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
-- 05/05/2016 Paul.  The User Primary Role is used with role-based views. 
Create Procedure dbo.spACL_ROLES_USERS_Delete
	( @MODIFIED_USER_ID uniqueidentifier
	, @ROLE_ID          uniqueidentifier
	, @USER_ID          uniqueidentifier
	)
as
  begin
	set nocount on
	
	update ACL_ROLES_USERS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID
	 where ROLE_ID = @ROLE_ID
	   and USER_ID = @USER_ID
	   and DELETED = 0;

	-- 05/05/2016 Paul.  Remove the primary role when unassigned. 
	if exists(select * from USERS where ID = @USER_ID and PRIMARY_ROLE_ID = @ROLE_ID and DELETED = 0) begin -- then
		update USERS
		   set PRIMARY_ROLE_ID   = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where ID                = @USER_ID
		   and DELETED           = 0;
	end -- if;
  end
GO
 
Grant Execute on dbo.spACL_ROLES_USERS_Delete to public;
GO
 
