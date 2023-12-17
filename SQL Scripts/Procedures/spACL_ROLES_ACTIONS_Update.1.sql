if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_ROLES_ACTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_ROLES_ACTIONS_Update;
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
-- 12/17/2017 Paul.  Add helpful message. 
Create Procedure dbo.spACL_ROLES_ACTIONS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ROLE_ID           uniqueidentifier
	, @ACTION_NAME       nvarchar(25)
	, @MODULE_NAME       nvarchar(25)
	, @ACCESS_OVERRIDE   int
	)
as
  begin
	set nocount on

	declare @ACTION_ID uniqueidentifier;

	-- BEGIN Oracle Exception
		select @ACTION_ID = ID
		  from ACL_ACTIONS
		 where NAME     = @ACTION_NAME
		   and CATEGORY = @MODULE_NAME
		   and DELETED  = 0           ;
	-- END Oracle Exception
	-- 12/17/2017 Paul.  Add helpful message. 
	if @ACTION_ID is null begin -- then
		raiserror(N'spACL_ROLES_ACTIONS_Update: Could not find action "%s" for module "%s".', 16, 1, @ACTION_NAME, @MODULE_NAME);
		return;
	end -- if;
	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACL_ROLES_ACTIONS
		 where ROLE_ID   = @ROLE_ID  
		   and ACTION_ID = @ACTION_ID
		   and DELETED   = 0         ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into ACL_ROLES_ACTIONS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ROLE_ID          
			, ACTION_ID        
			, ACCESS_OVERRIDE  
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ROLE_ID          
			, @ACTION_ID        
			, @ACCESS_OVERRIDE  
			);
	end else begin
		update ACL_ROLES_ACTIONS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , ACCESS_OVERRIDE   = @ACCESS_OVERRIDE  
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spACL_ROLES_ACTIONS_Update to public;
GO

