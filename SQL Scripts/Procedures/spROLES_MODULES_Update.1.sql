if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spROLES_MODULES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spROLES_MODULES_Update;
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
-- 12/13/2005 Paul.  MODULE name was changed back to original MODULE_ID.
-- No need to change the parameter name. 
Create Procedure dbo.spROLES_MODULES_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ROLE_ID           uniqueidentifier
	, @MODULE            varchar(36)
	, @ALLOW             bit
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ROLES_MODULES
		 where ROLE_ID           = @ROLE_ID
		   and MODULE_ID         = @MODULE   
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into ROLES_MODULES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ROLE_ID          
			, MODULE_ID        
			, ALLOW            
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ROLE_ID          
			, @MODULE           
			, @ALLOW            
			);
	end else begin
		update ROLES_MODULES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , ALLOW             = @ALLOW            
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spROLES_MODULES_Update to public;
GO
 
