if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTAGS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTAGS_Update;
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
Create Procedure dbo.spTAGS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(255)
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @SOURCE_ID          uniqueidentifier
	, @SOURCE_TYPE        nvarchar(50)
	, @SOURCE_META        nvarchar(max)
	, @DESCRIPTION        nvarchar(max)
	)
as
  begin
	set nocount on
	
	if not exists(select * from TAGS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into TAGS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, ASSIGNED_USER_ID  
			, SOURCE_ID         
			, SOURCE_TYPE       
			, SOURCE_META       
			, DESCRIPTION       
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @ASSIGNED_USER_ID  
			, @SOURCE_ID         
			, @SOURCE_TYPE       
			, @SOURCE_META       
			, @DESCRIPTION       
			);
	end else begin
		update TAGS
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , NAME               = @NAME              
		     , ASSIGNED_USER_ID   = @ASSIGNED_USER_ID  
		     , SOURCE_ID          = @SOURCE_ID         
		     , SOURCE_TYPE        = @SOURCE_TYPE       
		     , SOURCE_META        = @SOURCE_META       
		     , DESCRIPTION        = @DESCRIPTION       
		 where ID                 = @ID                ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spTAGS_Update to public;
GO

