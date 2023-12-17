if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONFIG_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONFIG_Update;
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
-- 09/28/2008 Paul.  max_users is a protected config value that cannot be edited by an admin. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spCONFIG_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @CATEGORY          nvarchar(32)
	, @NAME              nvarchar(60)
	, @VALUE             nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from CONFIG
		 where NAME = @NAME 
		   and DELETED = 0;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into CONFIG
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, CATEGORY         
			, NAME             
			, VALUE            
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @CATEGORY         
			, @NAME             
			, @VALUE            
			);
	end else begin
		-- 09/28/2008 Paul.  max_users can be inserted, but it cannot be updated. 
		if lower(@NAME) <> N'max_users' begin -- then
			update CONFIG
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , CATEGORY          = @CATEGORY         
			     , NAME              = @NAME             
			     , VALUE             = @VALUE            
			 where ID                = @ID               ;
		end -- if;
	end -- if;

	-- 09/20/2007 Paul.  Create private teams when enabling team management. 
	if @NAME = N'enable_team_management' begin -- then
		if dbo.fnCONFIG_Boolean(@NAME) = 1 begin -- then
			-- 09/14/2008 Paul.  A single space after the procedure simplifies the migration to DB2. 
			exec dbo.spTEAMS_InitPrivate ;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spCONFIG_Update to public;
GO

