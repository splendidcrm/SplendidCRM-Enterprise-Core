if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spREACT_CUSTOM_VIEWS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spREACT_CUSTOM_VIEWS_Update;
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
-- 12/06/2021 Paul.  spSUGARFAVORITES_UpdateName does not apply to REACT_CUSTOM_VIEWS. 
Create Procedure dbo.spREACT_CUSTOM_VIEWS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(100)
	, @MODULE_NAME        nvarchar(50)
	, @CATEGORY           nvarchar(25)
	, @CONTENT            nvarchar(max)
	)
as
  begin
	set nocount on
	
	if exists(select * from REACT_CUSTOM_VIEWS where NAME = @NAME and MODULE_NAME = @MODULE_NAME and CATEGORY = @CATEGORY and (ID <> @ID or @ID is null)) begin -- then
		raiserror(N'spREACT_CUSTOM_VIEWS_Update: A custom view for module %s and category %s', 16, 1, @MODULE_NAME, @CATEGORY);
		return;
	end -- if;
	if not exists(select * from REACT_CUSTOM_VIEWS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into REACT_CUSTOM_VIEWS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, MODULE_NAME       
			, CATEGORY          
			, CONTENT           
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @MODULE_NAME       
			, @CATEGORY          
			, @CONTENT           
			);
	end else begin
		update REACT_CUSTOM_VIEWS
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , NAME               = @NAME              
		     , MODULE_NAME        = @MODULE_NAME       
		     , CATEGORY           = @CATEGORY          
		     , CONTENT            = @CONTENT           
		 where ID                 = @ID                ;
		
		-- 12/06/2021 Paul.  spSUGARFAVORITES_UpdateName does not apply to REACT_CUSTOM_VIEWS. 
	end -- if;
  end
GO

Grant Execute on dbo.spREACT_CUSTOM_VIEWS_Update to public;
GO

