if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUSINESS_PROCESSES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUSINESS_PROCESSES_Update;
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
Create Procedure dbo.spBUSINESS_PROCESSES_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(200)
	, @BASE_MODULE        nvarchar(50)
	, @AUDIT_TABLE        nvarchar(50)
	, @STATUS             bit
	, @TYPE               nvarchar(25)
	, @RECORD_TYPE        nvarchar(25)
	, @JOB_INTERVAL       nvarchar(100)
	, @DESCRIPTION        nvarchar(max)
	, @FILTER_SQL         nvarchar(max)
	, @BPMN               nvarchar(max)
	, @SVG                nvarchar(max)
	, @XAML               nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @LIST_ORDER_Y int;
	if not exists(select * from BUSINESS_PROCESSES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;

		select @LIST_ORDER_Y =  max(LIST_ORDER_Y) + 1
		  from BUSINESS_PROCESSES
		 where BASE_MODULE = @BASE_MODULE
		   and DELETED     = 0;
		if @LIST_ORDER_Y is null begin -- then
			set @LIST_ORDER_Y = 1;
		end -- if;

		insert into BUSINESS_PROCESSES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, ASSIGNED_USER_ID  
			, NAME              
			, BASE_MODULE       
			, AUDIT_TABLE       
			, STATUS            
			, TYPE              
			, RECORD_TYPE       
			, JOB_INTERVAL      
			, FILTER_SQL        
			, DESCRIPTION       
			, BPMN              
			, SVG               
			, XAML              
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @ASSIGNED_USER_ID  
			, @NAME              
			, @BASE_MODULE       
			, @AUDIT_TABLE       
			, @STATUS            
			, @TYPE              
			, @RECORD_TYPE       
			, @JOB_INTERVAL      
			, @FILTER_SQL        
			, @DESCRIPTION       
			, @BPMN              
			, @SVG               
			, @XAML              
			);
	end else begin
		update BUSINESS_PROCESSES
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , NAME               = @NAME              
		     , ASSIGNED_USER_ID   = @ASSIGNED_USER_ID  
		     , BASE_MODULE        = @BASE_MODULE       
		     , AUDIT_TABLE        = @AUDIT_TABLE       
		     , STATUS             = @STATUS            
		     , TYPE               = @TYPE              
		     , RECORD_TYPE        = @RECORD_TYPE       
		     , JOB_INTERVAL       = @JOB_INTERVAL      
		     , FILTER_SQL         = @FILTER_SQL        
		     , DESCRIPTION        = @DESCRIPTION       
		     , BPMN               = @BPMN              
		     , SVG                = @SVG               
		     , XAML               = @XAML              
		 where ID                 = @ID                ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spBUSINESS_PROCESSES_Update to public;
GO

