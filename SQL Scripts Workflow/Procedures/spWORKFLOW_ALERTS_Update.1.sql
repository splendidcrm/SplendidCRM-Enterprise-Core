if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_ALERTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_ALERTS_Update;
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
Create Procedure dbo.spWORKFLOW_ALERTS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @FIELD_VALUE        nvarchar(100)
	, @REL_EMAIL_VALUE    nvarchar(100)
	, @REL_MODULE1        nvarchar(100)
	, @REL_MODULE2        nvarchar(100)
	, @REL_MODULE1_TYPE   nvarchar(25)
	, @REL_MODULE2_TYPE   nvarchar(25)
	, @WHERE_FILTER       bit
	, @USER_TYPE          nvarchar(25)
	, @ARRAY_TYPE         nvarchar(25)
	, @RELATE_TYPE        nvarchar(25)
	, @ADDRESS_TYPE       nvarchar(25)
	, @PARENT_ID          uniqueidentifier
	, @USER_DISPLAY_TYPE  nvarchar(25)
	)
as
  begin
	set nocount on
	
	if not exists(select * from WORKFLOW_ALERTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into WORKFLOW_ALERTS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, FIELD_VALUE       
			, REL_EMAIL_VALUE   
			, REL_MODULE1       
			, REL_MODULE2       
			, REL_MODULE1_TYPE  
			, REL_MODULE2_TYPE  
			, WHERE_FILTER      
			, USER_TYPE         
			, ARRAY_TYPE        
			, RELATE_TYPE       
			, ADDRESS_TYPE      
			, PARENT_ID         
			, USER_DISPLAY_TYPE 
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @FIELD_VALUE       
			, @REL_EMAIL_VALUE   
			, @REL_MODULE1       
			, @REL_MODULE2       
			, @REL_MODULE1_TYPE  
			, @REL_MODULE2_TYPE  
			, @WHERE_FILTER      
			, @USER_TYPE         
			, @ARRAY_TYPE        
			, @RELATE_TYPE       
			, @ADDRESS_TYPE      
			, @PARENT_ID         
			, @USER_DISPLAY_TYPE 
			);
	end else begin
		update WORKFLOW_ALERTS
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , FIELD_VALUE        = @FIELD_VALUE       
		     , REL_EMAIL_VALUE    = @REL_EMAIL_VALUE   
		     , REL_MODULE1        = @REL_MODULE1       
		     , REL_MODULE2        = @REL_MODULE2       
		     , REL_MODULE1_TYPE   = @REL_MODULE1_TYPE  
		     , REL_MODULE2_TYPE   = @REL_MODULE2_TYPE  
		     , WHERE_FILTER       = @WHERE_FILTER      
		     , USER_TYPE          = @USER_TYPE         
		     , ARRAY_TYPE         = @ARRAY_TYPE        
		     , RELATE_TYPE        = @RELATE_TYPE       
		     , ADDRESS_TYPE       = @ADDRESS_TYPE      
		     , PARENT_ID          = @PARENT_ID         
		     , USER_DISPLAY_TYPE  = @USER_DISPLAY_TYPE 
		 where ID                 = @ID                ;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_ALERTS_Update to public;
GO

