if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_FIELDS_ALIASES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_FIELDS_ALIASES_InsertOnly;
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
Create Procedure dbo.spACL_FIELDS_ALIASES_InsertOnly
	( @MODIFIED_USER_ID   uniqueidentifier
	, @ALIAS_NAME         nvarchar(50)
	, @ALIAS_MODULE_NAME  nvarchar(25)
	, @NAME               nvarchar(50)
	, @MODULE_NAME        nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACL_FIELDS_ALIASES
		 where  ALIAS_NAME        = @ALIAS_NAME
		   and (ALIAS_MODULE_NAME = @ALIAS_MODULE_NAME or (ALIAS_MODULE_NAME is null and @ALIAS_MODULE_NAME is null))
		   and  DELETED           = 0;
	-- END Oracle Exception
	
	if not exists(select * from ACL_FIELDS_ALIASES where ID = @ID) begin -- then
		set @ID = newid();
		insert into ACL_FIELDS_ALIASES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, ALIAS_NAME        
			, ALIAS_MODULE_NAME 
			, NAME              
			, MODULE_NAME       
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @ALIAS_NAME        
			, @ALIAS_MODULE_NAME 
			, @NAME              
			, @MODULE_NAME       
			);
	end -- if;
  end
GO

Grant Execute on dbo.spACL_FIELDS_ALIASES_InsertOnly to public;
GO

