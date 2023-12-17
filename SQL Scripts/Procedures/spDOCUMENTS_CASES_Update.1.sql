if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDOCUMENTS_CASES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDOCUMENTS_CASES_Update;
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
Create Procedure dbo.spDOCUMENTS_CASES_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @CASE_ID           uniqueidentifier
	, @DOCUMENT_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID                   uniqueidentifier;
	declare @DOCUMENT_REVISION_ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from DOCUMENTS_CASES
		 where CASE_ID     = @CASE_ID
		   and DOCUMENT_ID = @DOCUMENT_ID
		   and DELETED     = 0;
	-- END Oracle Exception
	-- BEGIN Oracle Exception
		select @DOCUMENT_REVISION_ID = DOCUMENT_REVISION_ID
		  from DOCUMENTS
		 where ID      = @DOCUMENT_ID
		   and DELETED = 0;
	-- END Oracle Exception

	
	if @ID is null begin -- then
		set @ID = newid();
		insert into DOCUMENTS_CASES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, CASE_ID          
			, DOCUMENT_ID      
			, DOCUMENT_REVISION_ID
			)
		values 	( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @CASE_ID          
			, @DOCUMENT_ID      
			, @DOCUMENT_REVISION_ID
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spDOCUMENTS_CASES_Update to public;
GO
 
