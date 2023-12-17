if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSHORTCUTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSHORTCUTS_Update;
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
-- 04/28/2006 Paul.  Added SHORTCUT_MODULE to help with ACL. 
-- 04/28/2006 Paul.  Added SHORTCUT_ACLTYPE to help with ACL. 
-- 07/24/2006 Paul.  Increase the DISPLAY_NAME to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
Create Procedure dbo.spSHORTCUTS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @MODULE_NAME       nvarchar( 25)
	, @DISPLAY_NAME      nvarchar(150)
	, @RELATIVE_PATH     nvarchar(255)
	, @IMAGE_NAME        nvarchar( 50)
	, @SHORTCUT_ENABLED  bit
	, @SHORTCUT_ORDER    int
	, @SHORTCUT_MODULE   nvarchar( 25)
	, @SHORTCUT_ACLTYPE  nvarchar(100)
	)
as
  begin
	if not exists(select * from SHORTCUTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SHORTCUTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, MODULE_NAME      
			, DISPLAY_NAME     
			, RELATIVE_PATH    
			, IMAGE_NAME       
			, SHORTCUT_ENABLED 
			, SHORTCUT_ORDER   
			, SHORTCUT_MODULE  
			, SHORTCUT_ACLTYPE 
			)
		values 
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODULE_NAME      
			, @DISPLAY_NAME     
			, @RELATIVE_PATH    
			, @IMAGE_NAME       
			, @SHORTCUT_ENABLED 
			, @SHORTCUT_ORDER   
			, @SHORTCUT_MODULE  
			, @SHORTCUT_ACLTYPE 
			);
	end else begin
		update SHORTCUTS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , MODULE_NAME       = @MODULE_NAME      
		     , DISPLAY_NAME      = @DISPLAY_NAME     
		     , RELATIVE_PATH     = @RELATIVE_PATH    
		     , IMAGE_NAME        = @IMAGE_NAME       
		     , SHORTCUT_ENABLED  = @SHORTCUT_ENABLED 
		     , SHORTCUT_ORDER    = @SHORTCUT_ORDER   
		     , SHORTCUT_MODULE   = @SHORTCUT_MODULE  
		     , SHORTCUT_ACLTYPE  = @SHORTCUT_ACLTYPE 
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spSHORTCUTS_Update to public;
GO
 
