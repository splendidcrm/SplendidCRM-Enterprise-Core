if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNOTES_Copy' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNOTES_Copy;
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
-- 12/21/2007 Paul.  The NOTES table is used as a relationship table between emails and attachments. 
-- When applying an Email Template to an Email, we copy the NOTES records. 
-- 10/25/2009 Paul.  Add TEAM_SET_ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spNOTES_Copy
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
		, CONTACT_ID        
		, PORTAL_FLAG       
		, DESCRIPTION       
		, NOTE_ATTACHMENT_ID
		, ASSIGNED_SET_ID   
		)
	select
		  @ID                
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  TEAM_ID           
		,  TEAM_SET_ID       
		,  NAME              
		,  FILENAME          
		,  FILE_MIME_TYPE    
		, @PARENT_TYPE       
		, @PARENT_ID         
		,  CONTACT_ID        
		,  PORTAL_FLAG       
		,  DESCRIPTION       
		,  NOTE_ATTACHMENT_ID
		, ASSIGNED_SET_ID    
	  from NOTES
	 where ID = @COPY_ID;

	if not exists(select * from NOTES_CSTM where ID_C = @ID) begin -- then
		insert into NOTES_CSTM ( ID_C ) values ( @ID );
	end -- if;

  end
GO

Grant Execute on dbo.spNOTES_Copy to public;
GO

