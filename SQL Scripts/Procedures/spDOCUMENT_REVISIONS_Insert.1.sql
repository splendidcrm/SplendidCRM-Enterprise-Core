if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDOCUMENT_REVISIONS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDOCUMENT_REVISIONS_Insert;
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
Create Procedure dbo.spDOCUMENT_REVISIONS_Insert
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DOCUMENT_ID       uniqueidentifier
	, @REVISION          nvarchar(25)
	, @CHANGE_LOG        nvarchar(255)
	, @FILENAME          nvarchar(255)
	, @FILE_EXT          nvarchar(25)
	, @FILE_MIME_TYPE    nvarchar(100)
	)
as
  begin
	set nocount on
	
	set @ID = newid();
	insert into DOCUMENT_REVISIONS
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, CHANGE_LOG       
		, DOCUMENT_ID      
		, FILENAME         
		, FILE_EXT         
		, FILE_MIME_TYPE   
		, REVISION         
		)
	values
		( @ID               
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @CHANGE_LOG       
		, @DOCUMENT_ID      
		, @FILENAME         
		, @FILE_EXT         
		, @FILE_MIME_TYPE   
		, @REVISION         
		);
	
	-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
	-- BEGIN Oracle Exception
		update DOCUMENTS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID 
		     , DATE_MODIFIED        =  getdate()        
		     , DATE_MODIFIED_UTC    =  getutcdate()     
		     , DOCUMENT_REVISION_ID = @ID               
		 where ID                   = @DOCUMENT_ID      ;
	-- END Oracle Exception
	
	if not exists(select * from DOCUMENT_REVISIONS_CSTM where ID_C = @ID) begin -- then
		insert into DOCUMENT_REVISIONS_CSTM ( ID_C ) values ( @ID );
	end -- if;

  end
GO

Grant Execute on dbo.spDOCUMENT_REVISIONS_Insert to public;
GO

