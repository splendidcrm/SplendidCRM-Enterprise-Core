if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_TYPES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_TYPES_InsertOnly;
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
-- 06/28/2008 Paul.  Similar to GetTypeId. 
-- 06/28/2008 Paul.  The name is InsertOnly because it only inserts the record if it does not already exist. 
Create Procedure dbo.spWWF_TYPES_InsertOnly
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @TYPE_FULL_NAME                 nvarchar(128)
	, @ASSEMBLY_FULL_NAME             nvarchar(256)
	, @IS_INSTANCE_TYPE               bit
	)
as
  begin
	set nocount on

	if @TYPE_FULL_NAME is null or @ASSEMBLY_FULL_NAME is null begin -- then
		raiserror(N'@TYPE_FULL_NAME and @ASSEMBLY_FULL_NAME must be non null', 16, 1);
		return;
	end -- if;
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from vwWWF_TYPES
			 where TYPE_FULL_NAME     = @TYPE_FULL_NAME
			   and ASSEMBLY_FULL_NAME = @ASSEMBLY_FULL_NAME;
		-- END Oracle Exception

		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into WWF_TYPES
				( ID                
				, CREATED_BY        
				, DATE_ENTERED      
				, TYPE_FULL_NAME    
				, ASSEMBLY_FULL_NAME
				, IS_INSTANCE_TYPE  
				)
			values
				( @ID                
				, @MODIFIED_USER_ID  
				, getdate()          
				, @TYPE_FULL_NAME    
				, @ASSEMBLY_FULL_NAME
				, @IS_INSTANCE_TYPE  
				);
-- #if SQL_Server /*
			if @@ROWCOUNT = 0 begin -- then
				raiserror(N'Failed inserting Workflow Type ID', 16, 4);
			end -- if;
-- #endif SQL_Server */
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spWWF_TYPES_InsertOnly to public;
GO

