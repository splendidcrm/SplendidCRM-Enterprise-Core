if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTERMINOLOGY_ALIASES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTERMINOLOGY_ALIASES_InsertOnly;
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
-- 07/24/2006 Paul.  Increase the MODULE_NAME to 25 to match the size in the MODULES table.
Create Procedure dbo.spTERMINOLOGY_ALIASES_InsertOnly
	( @MODIFIED_USER_ID   uniqueidentifier
	, @ALIAS_NAME         nvarchar(50)
	, @ALIAS_MODULE_NAME  nvarchar(25)
	, @ALIAS_LIST_NAME    nvarchar(50)
	, @NAME               nvarchar(50)
	, @MODULE_NAME        nvarchar(25)
	, @LIST_NAME          nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from TERMINOLOGY_ALIASES
		 where  ALIAS_NAME        = @ALIAS_NAME
		   and (ALIAS_MODULE_NAME = @ALIAS_MODULE_NAME or ALIAS_MODULE_NAME is null and @ALIAS_MODULE_NAME is null)
		   and (ALIAS_LIST_NAME   = @ALIAS_LIST_NAME   or ALIAS_LIST_NAME   is null and @ALIAS_LIST_NAME   is null)
		   and  DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into TERMINOLOGY_ALIASES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, ALIAS_NAME        
			, ALIAS_MODULE_NAME 
			, ALIAS_LIST_NAME   
			, NAME              
			, MODULE_NAME       
			, LIST_NAME         
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @ALIAS_NAME        
			, @ALIAS_MODULE_NAME 
			, @ALIAS_LIST_NAME   
			, @NAME              
			, @MODULE_NAME       
			, @LIST_NAME         
			);
	end -- if;
  end
GO

Grant Execute on dbo.spTERMINOLOGY_ALIASES_InsertOnly to public;
GO

