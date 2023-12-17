if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOAUTH_SYNC_TOKENS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOAUTH_SYNC_TOKENS_Update;
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
-- 09/14/2015 Paul.  The Sync Token is used by Google Apps Calendar as a more efficient method than UpdatedMin. 
Create Procedure dbo.spOAUTH_SYNC_TOKENS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(200)
	, @SYNC_TOKEN         nvarchar(200)
	, @TOKEN_EXPIRES_AT   datetime
	)
as
  begin
	set nocount on

	if @TOKEN_EXPIRES_AT is null and @ID is null begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from OAUTH_SYNC_TOKENS
			 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID
			   and NAME             = @NAME
			   and DELETED          = 0;
		-- END Oracle Exception
	end -- if;
		
	if (@ID is null) or not exists(select * from OAUTH_SYNC_TOKENS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into OAUTH_SYNC_TOKENS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, ASSIGNED_USER_ID  
			, NAME              
			, SYNC_TOKEN        
			, TOKEN_EXPIRES_AT  
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @ASSIGNED_USER_ID  
			, @NAME              
			, @SYNC_TOKEN        
			, @TOKEN_EXPIRES_AT  
			);
	end else begin
		-- 09/15/2015 Paul.  The expiration does not change, but the Sync Token does. 
		if @TOKEN_EXPIRES_AT is null begin -- then
			update OAUTH_SYNC_TOKENS
			   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
			     , DATE_MODIFIED      =  getdate()         
			     , DATE_MODIFIED_UTC  =  getutcdate()      
			     , SYNC_TOKEN         = @SYNC_TOKEN        
			 where ID                 = @ID                ;
		end else begin
			if exists(select * from OAUTH_SYNC_TOKENS where ID = @ID and TOKEN_EXPIRES_AT is null) begin -- then
				update OAUTH_SYNC_TOKENS
				   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
				     , DATE_MODIFIED      =  getdate()         
				     , DATE_MODIFIED_UTC  =  getutcdate()      
				     , TOKEN_EXPIRES_AT   = @TOKEN_EXPIRES_AT  
				 where ID                 = @ID                ;
			end -- if;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spOAUTH_SYNC_TOKENS_Update to public;
GO

