if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDYNAMIC_BUTTONS_InsPersonalInfo' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDYNAMIC_BUTTONS_InsPersonalInfo;
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
Create Procedure dbo.spDYNAMIC_BUTTONS_InsPersonalInfo
	( @VIEW_NAME           nvarchar(50)
	, @CONTROL_INDEX       int
	, @MODULE_NAME         nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from DYNAMIC_BUTTONS
		 where VIEW_NAME     = @VIEW_NAME    
		   and COMMAND_NAME  = N'PersonalInfo'    
		   and DELETED       = 0             
		   and DEFAULT_VIEW  = 0             ;
	-- END Oracle Exception
	if not exists(select * from DYNAMIC_BUTTONS where ID = @ID) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_Update
			  @ID out
			, null                    -- MODIFIED_USER_ID    
			, @VIEW_NAME           
			, @CONTROL_INDEX       
			, N'Button'               -- CONTROL_TYPE
			, @MODULE_NAME         
			, N'view'                 -- MODULE_ACCESS_TYPE  
			, null                    -- TARGET_NAME         
			, null                    -- TARGET_ACCESS_TYPE  
			, N'.LNK_PERSONAL_INFO'   -- CONTROL_TEXT        
			, N'.LNK_PERSONAL_INFO'   -- CONTROL_TOOLTIP     
			, null                    -- CONTROL_ACCESSKEY   
			, N'button'               -- CONTROL_CSSCLASS
			, null                    -- TEXT_FIELD          
			, null                    -- ARGUMENT_FIELD      
			, N'PersonalInfo'         -- COMMAND_NAME        
			, null                    -- URL_FORMAT
			, null                    -- URL_TARGET
			, N'return PopupPersonalInfo();' -- ONCLICK_SCRIPT      
			, 0                       -- MOBILE_ONLY         
			, 0                       -- ADMIN_ONLY          
			, 1                       -- EXCLUDE_MOBILE
			, null                    -- HIDDEN              
			;
	end -- if;
  end
GO

Grant Execute on dbo.spDYNAMIC_BUTTONS_InsPersonalInfo to public;
GO

