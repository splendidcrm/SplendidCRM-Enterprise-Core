if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_ACTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_ACTIONS_Update;
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
Create Procedure dbo.spWORKFLOW_ACTIONS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @FIELD             nvarchar(100)
	, @VALUE             nvarchar(max)
	, @SET_TYPE          nvarchar(25)
	, @ADV_TYPE          nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	, @EXT1              nvarchar(100)
	, @EXT2              nvarchar(100)
	, @EXT3              nvarchar(100)
	)
as
  begin
	set nocount on
	
	if not exists(select * from WORKFLOW_ACTIONS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into WORKFLOW_ACTIONS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, FIELD            
			, VALUE            
			, SET_TYPE         
			, ADV_TYPE         
			, PARENT_ID        
			, EXT1             
			, EXT2             
			, EXT3             
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @FIELD            
			, @VALUE            
			, @SET_TYPE         
			, @ADV_TYPE         
			, @PARENT_ID        
			, @EXT1             
			, @EXT2             
			, @EXT3             
			);
	end else begin
		update WORKFLOW_ACTIONS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , FIELD             = @FIELD            
		     , VALUE             = @VALUE            
		     , SET_TYPE          = @SET_TYPE         
		     , ADV_TYPE          = @ADV_TYPE         
		     , PARENT_ID         = @PARENT_ID        
		     , EXT1              = @EXT1             
		     , EXT2              = @EXT2             
		     , EXT3              = @EXT3             
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_ACTIONS_Update to public;
GO

