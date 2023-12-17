if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spKBDOCUMENTS_ATTACHMENTS_CreateNote' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spKBDOCUMENTS_ATTACHMENTS_CreateNote;
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
-- 10/26/2009 Paul.  Knowledge Base attachments will be stored in the Note Attachments table. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spKBDOCUMENTS_ATTACHMENTS_CreateNote
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @COPY_ID           uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	set @ID = newid();
	insert into NOTES
		( ID                
		, CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, TEAM_ID           
		, TEAM_SET_ID       
		, NAME              
		, FILENAME          
		, FILE_MIME_TYPE    
		, PARENT_TYPE       
		, PARENT_ID         
		, DESCRIPTION       
		, NOTE_ATTACHMENT_ID
		, ASSIGNED_SET_ID   
		)
	select
		   vwKBDOCUMENTS_ATTACHMENTS.ID
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  vwKBDOCUMENTS.TEAM_ID
		,  vwKBDOCUMENTS.TEAM_SET_ID
		,  vwKBDOCUMENTS.NAME + N': ' + vwKBDOCUMENTS_ATTACHMENTS.FILENAME
		,  vwKBDOCUMENTS_ATTACHMENTS.FILENAME
		,  vwKBDOCUMENTS_ATTACHMENTS.FILE_MIME_TYPE
		, @PARENT_TYPE       
		, @PARENT_ID         
		,  null              
		,  vwKBDOCUMENTS_ATTACHMENTS.ID
		, ASSIGNED_SET_ID
	  from      vwKBDOCUMENTS_ATTACHMENTS
	 inner join vwKBDOCUMENTS
	         on vwKBDOCUMENTS.ID = vwKBDOCUMENTS_ATTACHMENTS.KBDOCUMENT_ID
	 where vwKBDOCUMENTS_ATTACHMENTS.ID = @COPY_ID;

	if not exists(select * from NOTES_CSTM where ID_C = @ID) begin -- then
		insert into NOTES_CSTM ( ID_C ) values ( @ID );
	end -- if;
  end
GO

Grant Execute on dbo.spKBDOCUMENTS_ATTACHMENTS_CreateNote to public;
GO

