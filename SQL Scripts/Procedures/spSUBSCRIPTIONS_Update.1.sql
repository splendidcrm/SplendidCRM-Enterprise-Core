if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSUBSCRIPTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSUBSCRIPTIONS_Update;
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
Create Procedure dbo.spSUBSCRIPTIONS_Update
	( @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @PARENT_TYPE        nvarchar(25)
	, @PARENT_ID          uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	if not exists(select * from SUBSCRIPTIONS where ASSIGNED_USER_ID = @ASSIGNED_USER_ID and @PARENT_ID = PARENT_ID and DELETED = 0) begin -- then
		set @ID = newid();
		insert into SUBSCRIPTIONS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, ASSIGNED_USER_ID  
			, PARENT_TYPE       
			, PARENT_ID         
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @ASSIGNED_USER_ID  
			, @PARENT_TYPE       
			, @PARENT_ID         
			);
	end -- if;
  end
GO

Grant Execute on dbo.spSUBSCRIPTIONS_Update to public;
GO
