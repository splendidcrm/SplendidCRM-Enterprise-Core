if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_GROUPS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_GROUPS_Update;
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
-- 02/24/2010 Paul.  We need to specify an order to the modules for the tab menu. 
Create Procedure dbo.spMODULES_GROUPS_Update
	( @MODIFIED_USER_ID   uniqueidentifier
	, @GROUP_NAME         nvarchar(25)
	, @MODULE_NAME        nvarchar(50)
	, @MODULE_ORDER       int
	, @MODULE_MENU        bit
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from MODULES_GROUPS
		 where GROUP_NAME        = @GROUP_NAME
		   and MODULE_NAME       = @MODULE_NAME
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into MODULES_GROUPS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, GROUP_NAME        
			, MODULE_NAME       
			, MODULE_ORDER      
			, MODULE_MENU       
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @GROUP_NAME        
			, @MODULE_NAME       
			, @MODULE_ORDER      
			, @MODULE_MENU       
			);
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_GROUPS_Update to public;
GO

