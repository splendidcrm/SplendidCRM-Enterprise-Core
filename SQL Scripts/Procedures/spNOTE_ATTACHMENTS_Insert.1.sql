if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNOTE_ATTACHMENTS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNOTE_ATTACHMENTS_Insert;
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
Create Procedure dbo.spNOTE_ATTACHMENTS_Insert
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NOTE_ID           uniqueidentifier
	, @DESCRIPTION       nvarchar(255)
	, @FILENAME          nvarchar(255)
	, @FILE_EXT          nvarchar(25)
	, @FILE_MIME_TYPE    nvarchar(100)
	)
as
  begin
	set nocount on
	
	set @ID = newid();
	insert into NOTE_ATTACHMENTS
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, DESCRIPTION      
		, NOTE_ID          
		, FILENAME         
		, FILE_EXT         
		, FILE_MIME_TYPE   
		)
	values
		( @ID               
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @DESCRIPTION      
		, @NOTE_ID          
		, @FILENAME         
		, @FILE_EXT         
		, @FILE_MIME_TYPE   
		);
	
	-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
	-- 10/26/2009 Paul.  Now that we are using the NOTE_ATTACHMENTS table for Knowledge Base attachments, 
	-- we can no longer always update the NOTES record. 
	if exists(select * from NOTES where ID = @NOTE_ID) begin -- then
		-- BEGIN Oracle Exception
			update NOTES
			   set MODIFIED_USER_ID     = @MODIFIED_USER_ID 
			     , DATE_MODIFIED        =  getdate()        
			     , DATE_MODIFIED_UTC    =  getutcdate()     
			     , FILENAME             = @FILENAME         
			     , FILE_MIME_TYPE       = @FILE_MIME_TYPE   
			     , NOTE_ATTACHMENT_ID   = @ID               
			 where ID                   = @NOTE_ID          ;
		-- END Oracle Exception
	end -- if;
  end
GO

Grant Execute on dbo.spNOTE_ATTACHMENTS_Insert to public;
GO

