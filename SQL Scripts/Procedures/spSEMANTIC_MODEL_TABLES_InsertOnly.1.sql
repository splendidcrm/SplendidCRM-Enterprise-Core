if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSEMANTIC_MODEL_TABLES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSEMANTIC_MODEL_TABLES_InsertOnly;
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
Create Procedure dbo.spSEMANTIC_MODEL_TABLES_InsertOnly
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @NAME                nvarchar(64)
	, @COLLECTION_NAME     nvarchar(64)
	, @INSTANCE_SELECTION  nvarchar(25)
	)
as
  begin
	set nocount on

	if not exists(select * from SEMANTIC_MODEL_TABLES where NAME = @NAME and DELETED = 0) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 or exists(select * from SEMANTIC_MODEL_TABLES where ID = @ID) begin -- then
			set @ID = newid();
		end -- if;
		print N'SEMANTIC_MODEL_TABLES ' + @NAME;
		insert into SEMANTIC_MODEL_TABLES
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, DATE_MODIFIED_UTC  
			, NAME               
			, COLLECTION_NAME    
			, INSTANCE_SELECTION 
			)
		values 	( @ID                 
			, @MODIFIED_USER_ID         
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  getutcdate()       
			, @NAME               
			, @COLLECTION_NAME    
			, @INSTANCE_SELECTION 
			);
	end -- if;
  end
GO

Grant Execute on dbo.spSEMANTIC_MODEL_TABLES_InsertOnly to public;
GO

