if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_ROLES_USERS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_ROLES_USERS_Update;
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
-- 11/13/2009 Paul.  Remove the unnecessary update as it will reduce offline client conflicts. 
-- 05/05/2016 Paul.  The User Primary Role is used with role-based views. 
-- 03/22/2017 Paul.  Update the custom field table so that the audit view will have matching custom field values. 
Create Procedure dbo.spACL_ROLES_USERS_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @ROLE_ID           uniqueidentifier
	, @USER_ID           uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- 04/26/2006 Paul.  @ACCESS_OVERRIDE is not used yet. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACL_ROLES_USERS
		 where ROLE_ID           = @ROLE_ID
		   and USER_ID           = @USER_ID
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into ACL_ROLES_USERS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ROLE_ID          
			, USER_ID          
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ROLE_ID          
			, @USER_ID          
			);

		-- 05/05/2016 Paul.  Add the primary role if unassigned. 
		if exists(select * from USERS where ID = @USER_ID and PRIMARY_ROLE_ID is null and DELETED = 0) begin -- then
			-- BEGIN Oracle Exception
				update USERS
				   set PRIMARY_ROLE_ID   = @ROLE_ID
				     , DATE_MODIFIED     = getdate()
				     , DATE_MODIFIED_UTC = getutcdate()
				     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
				 where ID                = @USER_ID
				   and DELETED           = 0;
			-- END Oracle Exception
			-- 03/22/2017 Paul.  Update the custom field table so that the audit view will have matching custom field values. 
			-- BEGIN Oracle Exception
				update USERS_CSTM
				   set ID_C              = ID_C
				 where ID_C              = @USER_ID;
			-- END Oracle Exception
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spACL_ROLES_USERS_Update to public;
GO
 
