if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDETAILVIEWS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDETAILVIEWS_Update;
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
-- 12/02/2007 Paul.  Add field for data columns. 
-- 10/30/2010 Paul.  Add support for Business Rules Framework. 
-- 11/11/2010 Paul.  Change to Pre Load and Post Load. 
-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
Create Procedure dbo.spDETAILVIEWS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @NAME                nvarchar(50)
	, @MODULE_NAME         nvarchar(25)
	, @VIEW_NAME           nvarchar(50)
	, @LABEL_WIDTH         nvarchar(10)
	, @FIELD_WIDTH         nvarchar(10)
	, @DATA_COLUMNS        int
	, @PRE_LOAD_EVENT_ID   uniqueidentifier = null
	, @POST_LOAD_EVENT_ID  uniqueidentifier = null
	, @SCRIPT              nvarchar(max) = null
	)
as
  begin
	if not exists(select * from DETAILVIEWS where NAME = @NAME and DELETED = 0) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into DETAILVIEWS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, NAME               
			, MODULE_NAME        
			, VIEW_NAME          
			, LABEL_WIDTH        
			, FIELD_WIDTH        
			, DATA_COLUMNS       
			, PRE_LOAD_EVENT_ID  
			, POST_LOAD_EVENT_ID 
			, SCRIPT             
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
			, @LABEL_WIDTH        
			, @FIELD_WIDTH        
			, @DATA_COLUMNS       
			, @PRE_LOAD_EVENT_ID  
			, @POST_LOAD_EVENT_ID 
			, @SCRIPT             
			);
	end else begin
		update DETAILVIEWS
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , NAME                = @NAME               
		     , MODULE_NAME         = @MODULE_NAME        
		     , VIEW_NAME           = @VIEW_NAME          
		     , LABEL_WIDTH         = @LABEL_WIDTH        
		     , FIELD_WIDTH         = @FIELD_WIDTH        
		     , DATA_COLUMNS        = @DATA_COLUMNS       
		     , PRE_LOAD_EVENT_ID   = @PRE_LOAD_EVENT_ID  
		     , POST_LOAD_EVENT_ID  = @POST_LOAD_EVENT_ID 
		     , SCRIPT              = @SCRIPT             
		 where NAME                = @NAME               
		   and DELETED             = 0                   ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spDETAILVIEWS_Update to public;
GO
 
