if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spLINKED_DOCUMENTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spLINKED_DOCUMENTS_Update;
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
Create Procedure dbo.spLINKED_DOCUMENTS_Update
	( @ID                    uniqueidentifier output
	, @MODIFIED_USER_ID      uniqueidentifier
	, @PARENT_ID             uniqueidentifier
	, @PARENT_TYPE           nvarchar(25)
	, @DOCUMENT_ID           uniqueidentifier
	, @DOCUMENT_REVISION_ID  uniqueidentifier
	)
as
  begin
	set nocount on
	
	if not exists(select * from LINKED_DOCUMENTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into LINKED_DOCUMENTS
			( ID                   
			, CREATED_BY           
			, DATE_ENTERED         
			, MODIFIED_USER_ID     
			, DATE_MODIFIED        
			, PARENT_ID            
			, PARENT_TYPE          
			, DOCUMENT_ID          
			, DOCUMENT_REVISION_ID 
			)
		values 	( @ID                   
			, @MODIFIED_USER_ID           
			,  getdate()            
			, @MODIFIED_USER_ID     
			,  getdate()            
			, @PARENT_ID            
			, @PARENT_TYPE          
			, @DOCUMENT_ID          
			, @DOCUMENT_REVISION_ID 
			);
	end else begin
		update LINKED_DOCUMENTS
		   set MODIFIED_USER_ID      = @MODIFIED_USER_ID     
		     , DATE_MODIFIED         =  getdate()            
		     , DATE_MODIFIED_UTC     =  getutcdate()         
		     , PARENT_ID             = @PARENT_ID            
		     , PARENT_TYPE           = @PARENT_TYPE          
		     , DOCUMENT_ID           = @DOCUMENT_ID          
		     , DOCUMENT_REVISION_ID  = @DOCUMENT_REVISION_ID 
		 where ID                    = @ID                   ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spLINKED_DOCUMENTS_Update to public;
GO

