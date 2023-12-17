if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_FIELDS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_FIELDS_Update;
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
-- 06/20/2010 Paul.  Must include the ROLE_ID in the filter. 
Create Procedure dbo.spACL_FIELDS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @ROLE_ID            uniqueidentifier
	, @NAME               nvarchar(150)
	, @CATEGORY           nvarchar(100)
	, @ACLACCESS          int
	)
as
  begin
	set nocount on
	
	-- 06/20/2010 Paul.  Must include the ROLE_ID in the filter. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACL_FIELDS
		 where NAME      = @NAME    
		   and ROLE_ID   = @ROLE_ID           
		   and CATEGORY  = @CATEGORY
		   and DELETED   = 0        ;
	-- END Oracle Exception

	if not exists(select * from ACL_FIELDS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		-- 01/16/2010 Paul.  Don't create if value is NOT_SET. 
		if @ACLACCESS <> 0 begin -- then
			insert into ACL_FIELDS
				( ID                
				, CREATED_BY        
				, DATE_ENTERED      
				, MODIFIED_USER_ID  
				, DATE_MODIFIED     
				, DATE_MODIFIED_UTC 
				, ROLE_ID           
				, NAME              
				, CATEGORY          
				, ACLACCESS         
				)
			values 	( @ID                
				, @MODIFIED_USER_ID  
				,  getdate()         
				, @MODIFIED_USER_ID  
				,  getdate()         
				,  getutcdate()      
				, @ROLE_ID           
				, @NAME              
				, @CATEGORY          
				, @ACLACCESS         
				);
		end -- if;
	end else begin
		if @ACLACCESS = 0 begin -- then
			update ACL_FIELDS
			   set DELETED            = 1                
			     , DATE_MODIFIED      = getdate()        
			     , DATE_MODIFIED_UTC  = getutcdate()     
			     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
			 where ID                 = @ID              ;
		end else begin
			update ACL_FIELDS
			   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
			     , DATE_MODIFIED      =  getdate()         
			     , DATE_MODIFIED_UTC  =  getutcdate()      
			     , ROLE_ID            = @ROLE_ID           
			     , NAME               = @NAME              
			     , CATEGORY           = @CATEGORY          
			     , ACLACCESS          = @ACLACCESS         
			 where ID                 = @ID                ;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spACL_FIELDS_Update to public;
GO

