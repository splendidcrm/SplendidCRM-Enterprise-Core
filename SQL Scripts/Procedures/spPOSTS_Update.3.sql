if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPOSTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPOSTS_Update;
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
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spPOSTS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @THREAD_ID         uniqueidentifier
	, @TITLE             nvarchar(255)
	, @DESCRIPTION_HTML  nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @TEMP_THREAD_ID uniqueidentifier;
	set @TEMP_THREAD_ID = @THREAD_ID;
	if not exists(select * from POSTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into POSTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, THREAD_ID        
			, TITLE            
			, DESCRIPTION_HTML 
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @TEMP_THREAD_ID        
			, @TITLE            
			, @DESCRIPTION_HTML 
			);
	end else begin
		update POSTS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , THREAD_ID         = @TEMP_THREAD_ID   
		     , TITLE             = @TITLE            
		     , DESCRIPTION_HTML  = @DESCRIPTION_HTML 
		 where ID                = @ID               ;

		select @TEMP_THREAD_ID = THREAD_ID
		  from POSTS
		 where ID         = @ID;
	end -- if;

	if dbo.fnIsEmptyGuid(@TEMP_THREAD_ID) = 0 begin -- then
		exec dbo.spTHREADS_UpdatePostCount @TEMP_THREAD_ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPOSTS_Update to public;
GO
 
