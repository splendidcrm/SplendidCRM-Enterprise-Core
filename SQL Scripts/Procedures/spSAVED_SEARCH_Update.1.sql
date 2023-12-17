if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSAVED_SEARCH_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSAVED_SEARCH_Update;
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
-- 12/14/2007 Paul.  When updating, the NAME is only updated if not null.  Module is not updated. 
-- 12/17/2007 Paul.  There can only be one entry for the default of the module. 
-- 07/29/2008 Paul.  Don't updated ASSIGNED_USER_ID.  This will prevent global searches from being over-written. 
-- 12/16/2008 Paul.  When looking for the default view, we need to include the ASSIGNED_USER_ID. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 09/01/2010 Paul.  Store a copy of the DEFAULT_SEARCH_ID in the table so that we don't need to read the XML in order to get the value. 
Create Procedure dbo.spSAVED_SEARCH_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(150)
	, @SEARCH_MODULE     nvarchar(150)
	, @CONTENTS          nvarchar(max)
	, @DESCRIPTION       nvarchar(max)
	, @DEFAULT_SEARCH_ID uniqueidentifier = null
	)
as
  begin
	set nocount on

	if dbo.fnIsEmptyGuid(@ID) = 1 and @NAME is null begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from SAVED_SEARCH
			 where SEARCH_MODULE    = @SEARCH_MODULE
			   and ASSIGNED_USER_ID = @ASSIGNED_USER_ID
			   and NAME             is null
			   and DELETED          = 0;
		-- END Oracle Exception
	end -- if;
	
	if not exists(select * from SAVED_SEARCH where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SAVED_SEARCH
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ASSIGNED_USER_ID 
			, DEFAULT_SEARCH_ID
			, NAME             
			, SEARCH_MODULE    
			, CONTENTS         
			, DESCRIPTION      
			)
		values 	( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ASSIGNED_USER_ID 
			, @DEFAULT_SEARCH_ID
			, @NAME             
			, @SEARCH_MODULE    
			, @CONTENTS         
			, @DESCRIPTION      
			);
	end else begin
		update SAVED_SEARCH
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
-- 07/29/2008 Paul.  Don't updated ASSIGNED_USER_ID.  This will prevent global searches from being over-written. 
--		     , ASSIGNED_USER_ID  = @ASSIGNED_USER_ID 
		     , DEFAULT_SEARCH_ID = @DEFAULT_SEARCH_ID
		     , NAME              = isnull(@NAME, NAME)
		     , CONTENTS          = @CONTENTS         
		     , DESCRIPTION       = @DESCRIPTION      
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spSAVED_SEARCH_Update to public;
GO

