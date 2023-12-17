if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSEMANTIC_MODEL_ROLES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSEMANTIC_MODEL_ROLES_InsertOnly;
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
Create Procedure dbo.spSEMANTIC_MODEL_ROLES_InsertOnly
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @LHS_TABLE          nvarchar(64)
	, @LHS_KEY            nvarchar(64)
	, @RHS_TABLE          nvarchar(64)
	, @RHS_KEY            nvarchar(64)
	, @CARDINALITY        nvarchar(25)
	, @NAME               nvarchar(64)
	)
as
  begin
	set nocount on
	
	-- 12/12/2009 Paul.  Always ignore the @ID on input. 
	set @ID = null;	
	-- BEGIN Oracle Exception
		select @ID = ID
		  from SEMANTIC_MODEL_ROLES
		 where LHS_TABLE  = @LHS_TABLE 
		   and LHS_KEY    = @LHS_KEY   
		   and RHS_TABLE  = @RHS_TABLE 
		   and RHS_KEY    = @RHS_KEY   
		   and DELETED    = 0;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- print N'SEMANTIC_MODEL_ROLES ' + @LHS_TABLE + N'.' + @LHS_KEY + N' - ' + @RHS_TABLE + N'.' + @RHS_KEY;
		set @ID = newid();
		insert into SEMANTIC_MODEL_ROLES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, LHS_TABLE         
			, LHS_KEY           
			, RHS_TABLE         
			, RHS_KEY           
			, CARDINALITY       
			, NAME              
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @LHS_TABLE         
			, @LHS_KEY           
			, @RHS_TABLE         
			, @RHS_KEY           
			, @CARDINALITY       
			, @NAME              
			);
	end -- if;
  end
GO

Grant Execute on dbo.spSEMANTIC_MODEL_ROLES_InsertOnly to public;
GO

