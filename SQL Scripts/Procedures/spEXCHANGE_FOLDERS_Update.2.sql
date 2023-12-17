if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEXCHANGE_FOLDERS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEXCHANGE_FOLDERS_Update;
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
-- 04/05/2010 Paul.  We need the WELL_KNOWN_PARENT flag to detect the difference between well known Contacts and SplendidCRM Contacts. 
-- 04/05/2010 Paul.  We need to keep the PARENT_ID and the PARENT_NAME so that we can detect a name change. 
Create Procedure dbo.spEXCHANGE_FOLDERS_Update
	( @MODIFIED_USER_ID         uniqueidentifier
	, @ASSIGNED_USER_ID         uniqueidentifier
	, @REMOTE_KEY               varchar(800)
	, @MODULE_NAME              nvarchar(25)
	, @PARENT_ID                uniqueidentifier
	, @PARENT_NAME              nvarchar(255)
	, @WELL_KNOWN_FOLDER        bit
	)
as
  begin
	set nocount on

	declare @ID uniqueidentifier;

	-- BEGIN Oracle Exception
		select @ID = ID
		  from EXCHANGE_FOLDERS
		 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
		   and REMOTE_KEY       = @REMOTE_KEY 
		   and DELETED          = 0;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- 04/07/2010 Paul.  There can only be one parent record per user. 
		-- If we are creating a new folder, then we must remove the previous folder. 
		update EXCHANGE_FOLDERS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where ASSIGNED_USER_ID  = @ASSIGNED_USER_ID 
		   and (MODULE_NAME = @MODULE_NAME or (MODULE_NAME is null and @MODULE_NAME is null))
		   and (PARENT_ID   = @PARENT_ID   or (PARENT_ID   is null and @PARENT_ID   is null))
		   and WELL_KNOWN_FOLDER = @WELL_KNOWN_FOLDER
		   and DELETED           = 0;

		set @ID = newid();
		insert into EXCHANGE_FOLDERS
			( ID                      
			, CREATED_BY              
			, DATE_ENTERED            
			, MODIFIED_USER_ID        
			, DATE_MODIFIED           
			, DATE_MODIFIED_UTC       
			, ASSIGNED_USER_ID        
			, REMOTE_KEY              
			, MODULE_NAME             
			, PARENT_ID               
			, PARENT_NAME             
			, WELL_KNOWN_FOLDER       
			)
		values
			( @ID                      
			, @MODIFIED_USER_ID        
			,  getdate()               
			, @MODIFIED_USER_ID        
			,  getdate()               
			,  getutcdate()            
			, @ASSIGNED_USER_ID        
			, @REMOTE_KEY              
			, @MODULE_NAME             
			, @PARENT_ID               
			, @PARENT_NAME             
			, @WELL_KNOWN_FOLDER       
			);
	end else begin
		if exists(select * from EXCHANGE_FOLDERS where ID = @ID and PARENT_NAME is not null and PARENT_NAME <> @PARENT_NAME) begin -- then
			-- 05/14/2010 Paul.  We also need to update the module name, just in case the folder moved. 
			update EXCHANGE_FOLDERS
			   set MODULE_NAME       = @MODULE_NAME
			     , PARENT_ID         = @PARENT_ID
			     , PARENT_NAME       = @PARENT_NAME
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			 where ID                = @ID;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spEXCHANGE_FOLDERS_Update to public;
GO


