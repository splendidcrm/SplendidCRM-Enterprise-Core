if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDYNAMIC_BUTTONS_CopyDefault' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDYNAMIC_BUTTONS_CopyDefault;
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
-- 04/13/2008 Paul.  Manually insert the ID to ease migration to Oracle. 
-- 03/14/2014 Paul.  Allow hidden buttons to be created. 
Create Procedure dbo.spDYNAMIC_BUTTONS_CopyDefault
	( @SOURCE_VIEW_NAME    nvarchar(50)
	, @NEW_VIEW_NAME       nvarchar(50)
	, @MODULE_NAME         nvarchar(25)
	)
as
  begin
	set nocount on
	
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = @NEW_VIEW_NAME and DELETED = 0) begin -- then
		insert into DYNAMIC_BUTTONS
			( ID
			, DATE_ENTERED      
			, DATE_MODIFIED     
			, VIEW_NAME         
			, CONTROL_INDEX     
			, CONTROL_TYPE      
			, DEFAULT_VIEW      
			, MODULE_NAME       
			, MODULE_ACCESS_TYPE
			, TARGET_NAME       
			, TARGET_ACCESS_TYPE
			, MOBILE_ONLY       
			, ADMIN_ONLY        
			, EXCLUDE_MOBILE    
			, HIDDEN            
			, CONTROL_TEXT      
			, CONTROL_TOOLTIP   
			, CONTROL_ACCESSKEY 
			, CONTROL_CSSCLASS  
			, TEXT_FIELD        
			, ARGUMENT_FIELD    
			, COMMAND_NAME      
			, URL_FORMAT        
			, URL_TARGET        
			, ONCLICK_SCRIPT    
			)
		select	   newid()
			,  getdate()
			,  getdate()
			, @NEW_VIEW_NAME
			,  CONTROL_INDEX     
			,  CONTROL_TYPE      
			,  DEFAULT_VIEW      
			, @MODULE_NAME       
			,  MODULE_ACCESS_TYPE
			,  TARGET_NAME       
			,  TARGET_ACCESS_TYPE
			,  MOBILE_ONLY       
			,  ADMIN_ONLY        
			,  EXCLUDE_MOBILE    
			,  HIDDEN            
			,  CONTROL_TEXT      
			,  CONTROL_TOOLTIP   
			,  CONTROL_ACCESSKEY 
			,  CONTROL_CSSCLASS  
			,  TEXT_FIELD        
			,  ARGUMENT_FIELD    
			,  COMMAND_NAME      
			,  URL_FORMAT        
			,  URL_TARGET        
			,  ONCLICK_SCRIPT    
		  from DYNAMIC_BUTTONS
		 where VIEW_NAME = @SOURCE_VIEW_NAME
		   and DELETED   = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spDYNAMIC_BUTTONS_CopyDefault to public;
GO

