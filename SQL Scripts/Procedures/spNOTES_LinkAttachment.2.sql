if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNOTES_LinkAttachment' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNOTES_LinkAttachment;
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
-- 03/30/2013 Paul.  Link attachments to campaign emails. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spNOTES_LinkAttachment
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(255)
	, @PARENT_TYPE        nvarchar(25)
	, @PARENT_ID          uniqueidentifier
	, @DESCRIPTION        nvarchar(max)
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @TEAM_ID            uniqueidentifier
	, @TEAM_SET_ID        uniqueidentifier
	, @NOTE_ATTACHMENT_ID uniqueidentifier
	, @ASSIGNED_SET_ID    uniqueidentifier
	)
as
  begin
	set nocount on
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	insert into NOTES
		( ID                
		, CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, DATE_MODIFIED_UTC 
		, NAME              
		, PARENT_TYPE       
		, PARENT_ID         
		, DESCRIPTION       
		, TEAM_ID           
		, TEAM_SET_ID       
		, ASSIGNED_USER_ID  
		, NOTE_ATTACHMENT_ID
		, ASSIGNED_SET_ID   
		)
	values
		( @ID                
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  getutcdate()      
		, @NAME              
		, @PARENT_TYPE       
		, @PARENT_ID         
		, @DESCRIPTION       
		, @TEAM_ID           
		, @TEAM_SET_ID       
		, @ASSIGNED_USER_ID  
		, @NOTE_ATTACHMENT_ID
		, @ASSIGNED_SET_ID   
		);
	if @@ERROR = 0 begin -- then
		if not exists(select * from NOTES_CSTM where ID_C = @ID) begin -- then
			insert into NOTES_CSTM ( ID_C ) values ( @ID );
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spNOTES_LinkAttachment to public;
GO

