if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_TRIGGER_SHELLS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_TRIGGER_SHELLS_Update;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spWORKFLOW_TRIGGER_SHELLS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_ID         uniqueidentifier
	, @FIELD             nvarchar(100)
	, @TYPE              nvarchar(25)
	, @FRAME_TYPE        nvarchar(25)
	, @EVAL              nvarchar(max)
	, @SHOW_PAST         bit
	, @REL_MODULE        nvarchar(100)
	, @REL_MODULE_TYPE   nvarchar(25)
	, @PARAMETERS        nvarchar(100)
	)
as
  begin
	set nocount on
	
	if not exists(select * from WORKFLOW_TRIGGER_SHELLS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into WORKFLOW_TRIGGER_SHELLS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, PARENT_ID        
			, FIELD            
			, TYPE             
			, FRAME_TYPE       
			, EVAL             
			, SHOW_PAST        
			, REL_MODULE       
			, REL_MODULE_TYPE  
			, PARAMETERS       
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @PARENT_ID        
			, @FIELD            
			, @TYPE             
			, @FRAME_TYPE       
			, @EVAL             
			, @SHOW_PAST        
			, @REL_MODULE       
			, @REL_MODULE_TYPE  
			, @PARAMETERS       
			);
	end else begin
		update WORKFLOW_TRIGGER_SHELLS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , PARENT_ID         = @PARENT_ID        
		     , FIELD             = @FIELD            
		     , TYPE              = @TYPE             
		     , FRAME_TYPE        = @FRAME_TYPE       
		     , EVAL              = @EVAL             
		     , SHOW_PAST         = @SHOW_PAST        
		     , REL_MODULE        = @REL_MODULE       
		     , REL_MODULE_TYPE   = @REL_MODULE_TYPE  
		     , PARAMETERS        = @PARAMETERS       
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_TRIGGER_SHELLS_Update to public;
GO

