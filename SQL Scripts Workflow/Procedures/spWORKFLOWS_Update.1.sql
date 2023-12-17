if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOWS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOWS_Update;
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
-- 07/26/2008 Paul.  We need the audit table in the workflow table to speed processing. 
-- 11/16/2008 Paul.  Add support for type-based workflows. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 06/26/2010 Paul.  Use the PARENT_ID with scheduled reports. 
-- 07/19/2010 Paul.  PARENT_ID should allow nulls.
-- 06/21/2021 Paul.  Create spWORKFLOW_Update procedure as procedure must match the table name. 
Create Procedure dbo.spWORKFLOWS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(100)
	, @BASE_MODULE       nvarchar(100)
	, @AUDIT_TABLE       nvarchar(50)
	, @STATUS            bit
	, @TYPE              nvarchar(25)
	, @FIRE_ORDER        nvarchar(25)
	, @RECORD_TYPE       nvarchar(25)
	, @DESCRIPTION       nvarchar(max)
	, @FILTER_SQL        nvarchar(max)
	, @FILTER_XML        nvarchar(max)
	, @JOB_INTERVAL      nvarchar(100) = null
	, @PARENT_ID         uniqueidentifier = null
	)
as
  begin
	set nocount on
	
	declare @LIST_ORDER_Y int;
	if not exists(select * from WORKFLOW where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;

		select @LIST_ORDER_Y =  max(LIST_ORDER_Y) + 1
		  from vwWORKFLOWS
		 where BASE_MODULE = @BASE_MODULE;
		if @LIST_ORDER_Y is null begin -- then
			set @LIST_ORDER_Y = 1;
		end -- if;

		insert into WORKFLOW
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, BASE_MODULE      
			, AUDIT_TABLE      
			, STATUS           
			, TYPE             
			, FIRE_ORDER       
			, PARENT_ID        
			, RECORD_TYPE      
			, LIST_ORDER_Y     
			, DESCRIPTION      
			, FILTER_SQL       
			, FILTER_XML       
			, JOB_INTERVAL     
			)
		values 	( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @BASE_MODULE      
			, @AUDIT_TABLE      
			, @STATUS           
			, @TYPE             
			, @FIRE_ORDER       
			, @PARENT_ID        
			, @RECORD_TYPE      
			, @LIST_ORDER_Y     
			, @DESCRIPTION      
			, @FILTER_SQL       
			, @FILTER_XML       
			, @JOB_INTERVAL     
			);
	end else begin
		update WORKFLOW
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , NAME              = @NAME             
		     , BASE_MODULE       = @BASE_MODULE      
		     , AUDIT_TABLE       = @AUDIT_TABLE      
		     , STATUS            = @STATUS           
		     , TYPE              = @TYPE             
		     , FIRE_ORDER        = @FIRE_ORDER       
		     , PARENT_ID         = @PARENT_ID        
		     , RECORD_TYPE       = @RECORD_TYPE      
		     , DESCRIPTION       = @DESCRIPTION      
		     , FILTER_SQL        = @FILTER_SQL       
		     , FILTER_XML        = @FILTER_XML       
		     , JOB_INTERVAL      = @JOB_INTERVAL     
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOWS_Update to public;
GO

