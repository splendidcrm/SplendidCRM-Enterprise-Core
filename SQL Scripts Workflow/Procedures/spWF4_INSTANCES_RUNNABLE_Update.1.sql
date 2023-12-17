if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_INSTANCES_RUNNABLE_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_INSTANCES_RUNNABLE_Update;
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
Create Procedure dbo.spWF4_INSTANCES_RUNNABLE_Update
	( @ID                       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @DELETED                  bit;
	declare @CREATED_BY               uniqueidentifier;
	declare @SURROGATE_INSTANCE_ID    uniqueidentifier
	declare @SURROGATE_LOCK_OWNER_ID  uniqueidentifier;
	declare @WORKFLOW_HOST_TYPE       uniqueidentifier;
	declare @SURROGATE_IDENTITY_ID    uniqueidentifier;
	declare @DEFINITION_IDENTITY_ID   uniqueidentifier;
	declare @RUNNABLE_TIMER           datetime;
	declare @IS_SUSPENDED             bit;
	declare @IS_READY_TO_RUN          bit;
	declare @BLOCKING_BOOKMARKS       nvarchar(max);
	declare @EXECUTION_STATUS         nvarchar(450);

	select @DELETED                 = DELETED                 
	     , @CREATED_BY              = CREATED_BY              
	     , @SURROGATE_INSTANCE_ID   = SURROGATE_INSTANCE_ID   
	     , @SURROGATE_LOCK_OWNER_ID = SURROGATE_LOCK_OWNER_ID 
	     , @WORKFLOW_HOST_TYPE      = WORKFLOW_HOST_TYPE      
	     , @SURROGATE_IDENTITY_ID   = SURROGATE_IDENTITY_ID   
	     , @DEFINITION_IDENTITY_ID  = DEFINITION_IDENTITY_ID  
	     , @RUNNABLE_TIMER          = PENDING_TIMER           
	     , @IS_SUSPENDED            = IS_SUSPENDED            
	     , @IS_READY_TO_RUN         = IS_READY_TO_RUN         
	     , @BLOCKING_BOOKMARKS      = BLOCKING_BOOKMARKS      
	     , @EXECUTION_STATUS        = @EXECUTION_STATUS       
	  from WF4_INSTANCES
	 where ID                       = @ID;
	
	if @EXECUTION_STATUS = N'Closed' or @EXECUTION_STATUS = N'Canceled' or @EXECUTION_STATUS = N'Faulted' begin -- then
		set @DELETED = 1;
	end -- if;
	
	if not exists(select * from WF4_INSTANCES_RUNNABLE where ID = @ID) begin -- then
		insert into WF4_INSTANCES_RUNNABLE
			( ID                     
			, DELETED                
			, CREATED_BY             
			, DATE_ENTERED           
			, DATE_MODIFIED_UTC      
			, SURROGATE_INSTANCE_ID  
			, SURROGATE_LOCK_OWNER_ID
			, WORKFLOW_HOST_TYPE     
			, SURROGATE_IDENTITY_ID  
			, DEFINITION_IDENTITY_ID 
			, RUNNABLE_TIMER         
			, IS_SUSPENDED           
			, IS_READY_TO_RUN        
			, BLOCKING_BOOKMARKS     
			)
		values 	( @ID                     
			, @DELETED                
			, @CREATED_BY             
			,  getdate()              
			,  getutcdate()           
			, @SURROGATE_INSTANCE_ID  
			, @SURROGATE_LOCK_OWNER_ID
			, @WORKFLOW_HOST_TYPE     
			, @SURROGATE_IDENTITY_ID  
			, @DEFINITION_IDENTITY_ID 
			, @RUNNABLE_TIMER         
			, @IS_SUSPENDED           
			, @IS_READY_TO_RUN        
			, @BLOCKING_BOOKMARKS     
			);
	end else begin
		update WF4_INSTANCES_RUNNABLE
		   set DATE_MODIFIED_UTC       =  getutcdate()           
		     , DELETED                 = @DELETED                
		     , SURROGATE_INSTANCE_ID   = @SURROGATE_INSTANCE_ID  
		     , SURROGATE_LOCK_OWNER_ID = @SURROGATE_LOCK_OWNER_ID
		     , WORKFLOW_HOST_TYPE      = @WORKFLOW_HOST_TYPE     
		     , SURROGATE_IDENTITY_ID   = @SURROGATE_IDENTITY_ID  
		     , DEFINITION_IDENTITY_ID  = @DEFINITION_IDENTITY_ID 
		     , RUNNABLE_TIMER          = @RUNNABLE_TIMER         
		     , IS_SUSPENDED            = @IS_SUSPENDED           
		     , IS_READY_TO_RUN         = @IS_READY_TO_RUN        
		     , BLOCKING_BOOKMARKS      = @BLOCKING_BOOKMARKS     
		 where ID                      = @ID                     ;
	end -- if;
  end
GO

Grant Execute on dbo.spWF4_INSTANCES_RUNNABLE_Update to public;
GO

