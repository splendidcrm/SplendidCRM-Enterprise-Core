if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spGRIDVIEWS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spGRIDVIEWS_Update;
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
-- 11/22/2010 Paul.  Add support for Business Rules Framework. 
-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
Create Procedure dbo.spGRIDVIEWS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @NAME                nvarchar(50)
	, @MODULE_NAME         nvarchar(25)
	, @VIEW_NAME           nvarchar(50)
	, @PRE_LOAD_EVENT_ID   uniqueidentifier = null
	, @POST_LOAD_EVENT_ID  uniqueidentifier = null
	, @SCRIPT              nvarchar(max) = null
	, @SORT_FIELD          nvarchar(50) = null
	, @SORT_DIRECTION      nvarchar(10) = null
	)
as
  begin
	if not exists(select * from GRIDVIEWS where NAME = @NAME and DELETED = 0) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into GRIDVIEWS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, NAME               
			, MODULE_NAME        
			, VIEW_NAME          
			, PRE_LOAD_EVENT_ID  
			, POST_LOAD_EVENT_ID 
			, SCRIPT             
			, SORT_FIELD         
			, SORT_DIRECTION     
			)
		values 
			( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @NAME               
			, @MODULE_NAME        
			, @VIEW_NAME          
			, @PRE_LOAD_EVENT_ID  
			, @POST_LOAD_EVENT_ID 
			, @SCRIPT             
			, @SORT_FIELD         
			, @SORT_DIRECTION     
			);
	end else begin
		update GRIDVIEWS
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , NAME                = @NAME               
		     , MODULE_NAME         = @MODULE_NAME        
		     , VIEW_NAME           = @VIEW_NAME          
		     , PRE_LOAD_EVENT_ID   = @PRE_LOAD_EVENT_ID  
		     , POST_LOAD_EVENT_ID  = @POST_LOAD_EVENT_ID 
		     , SCRIPT              = @SCRIPT             
		     , SORT_FIELD          = @SORT_FIELD         
		     , SORT_DIRECTION      = @SORT_DIRECTION     
		 where NAME                = @NAME               
		   and DELETED = 0                              ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spGRIDVIEWS_Update to public;
GO
 
