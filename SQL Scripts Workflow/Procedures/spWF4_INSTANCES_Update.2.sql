if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_INSTANCES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_INSTANCES_Update;
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
Create Procedure dbo.spWF4_INSTANCES_Update
	( @ID                              uniqueidentifier
	, @SURROGATE_IDENTITY_ID           uniqueidentifier
	, @DEFINITION_IDENTITY_HASH        uniqueidentifier
	, @SURROGATE_LOCK_OWNER_ID         uniqueidentifier
	, @PRIMITIVE_DATA_PROPERTIES       varbinary(max)
	, @COMPLEX_DATA_PROPERTIES         varbinary(max)
	, @WRITE_ONLY_PRIMITIVE_DATA_PROP  varbinary(max)
	, @WRITE_ONLY_COMPLEX_DATA_PROP    varbinary(max)
	, @METADATA_PROPERTIES             varbinary(max)
	, @METADATA_CONSISTENCY            bit
	, @ENCODING_OPTION                 tinyint
	, @VERSION                         bigint
	, @TIMER_DURATION_MILLISECONDS     bigint
	, @PENDING_TIMER                   datetime
	, @WORKFLOW_HOST_TYPE              uniqueidentifier
	, @SERVICE_DEPLOYMENT_ID           uniqueidentifier
	, @SUSPENSION_EXCEPTION_NAME       nvarchar(450)
	, @SUSPENSION_REASON               nvarchar(max)
	, @BLOCKING_BOOKMARKS              nvarchar(max)
	, @LAST_MACHINE_RUN_ON             nvarchar(450)
	, @EXECUTION_STATUS                nvarchar(450)
	, @IS_INITIALIZED                  bit
	, @SUSPENSION_STATE_CHANGE         tinyint
	, @IS_READY_TO_RUN                 bit
	, @IS_COMPLETED                    bit
	)
as
  begin
	set nocount on
	
	declare @CREATED_BY             uniqueidentifier;
	declare @SURROGATE_INSTANCE_ID  uniqueidentifier;
	declare @DEFINITION_IDENTITY_ID uniqueidentifier;
	declare @IS_SUSPENDED           bit;
	declare @METADATA_UPDATE_ONLY   bit;

	-- 06/20/2016 Paul.  We could use @PENDING_TIMER, but use the timer duration just in case Web and SQL servers are slightly off. 
	if @PENDING_TIMER is not null begin -- then
		set @PENDING_TIMER = dbo.fnWF4GetExpirationTime(@TIMER_DURATION_MILLISECONDS);
	end -- if;
	set @IS_SUSPENDED = @SUSPENSION_STATE_CHANGE;
	set @METADATA_UPDATE_ONLY = 0;
	if @PRIMITIVE_DATA_PROPERTIES is null and @COMPLEX_DATA_PROPERTIES is null and @WRITE_ONLY_PRIMITIVE_DATA_PROP is null and @WRITE_ONLY_COMPLEX_DATA_PROP is null begin -- then
		set @METADATA_UPDATE_ONLY = 1;
	end -- if;

	if not exists(select * from WF4_INSTANCES where ID = @ID) begin -- then
		select @DEFINITION_IDENTITY_ID  = ID
		  from WF4_DEFINITION_IDENTITY
		 where SURROGATE_IDENTITY_ID    = @SURROGATE_IDENTITY_ID
		   and DEFINITION_IDENTITY_HASH = @DEFINITION_IDENTITY_HASH;

		insert into WF4_INSTANCES
			( ID                             
			, CREATED_BY                     
			, DATE_ENTERED                   
			, DATE_MODIFIED_UTC              
			, SURROGATE_INSTANCE_ID          
			, SURROGATE_LOCK_OWNER_ID        
			, SURROGATE_IDENTITY_ID          
			, DEFINITION_IDENTITY_ID         
			, PRIMITIVE_DATA_PROPERTIES      
			, COMPLEX_DATA_PROPERTIES        
			, WRITE_ONLY_PRIMITIVE_DATA_PROP 
			, WRITE_ONLY_COMPLEX_DATA_PROP   
			, METADATA_PROPERTIES            
			, DATA_ENCODING_OPTION           
			, METADATA_ENCODING_OPTION       
			, VERSION                        
			, PENDING_TIMER                  
			, WORKFLOW_HOST_TYPE             
			, SERVICE_DEPLOYMENT_ID          
			, SUSPENSION_EXCEPTION_NAME      
			, SUSPENSION_REASON              
			, BLOCKING_BOOKMARKS             
			, LAST_MACHINE_RUN_ON            
			, EXECUTION_STATUS               
			, IS_INITIALIZED                 
			, IS_SUSPENDED                   
			, IS_READY_TO_RUN                
			, IS_COMPLETED                   
			)
		values 	( @ID                             
			, @CREATED_BY                     
			,  getdate()                      
			,  getutcdate()                   
			, @SURROGATE_INSTANCE_ID          
			, @SURROGATE_LOCK_OWNER_ID        
			, @SURROGATE_IDENTITY_ID          
			, @DEFINITION_IDENTITY_ID         
			, @PRIMITIVE_DATA_PROPERTIES      
			, @COMPLEX_DATA_PROPERTIES        
			, @WRITE_ONLY_PRIMITIVE_DATA_PROP 
			, @WRITE_ONLY_COMPLEX_DATA_PROP   
			, @METADATA_PROPERTIES            
			, @ENCODING_OPTION                
			, @ENCODING_OPTION                
			, @VERSION                        
			, @PENDING_TIMER                  
			, @WORKFLOW_HOST_TYPE             
			, @SERVICE_DEPLOYMENT_ID          
			, @SUSPENSION_EXCEPTION_NAME      
			, @SUSPENSION_REASON              
			, @BLOCKING_BOOKMARKS             
			, @LAST_MACHINE_RUN_ON            
			, @EXECUTION_STATUS               
			, @IS_INITIALIZED                 
			, @IS_SUSPENDED                   
			, @IS_READY_TO_RUN                
			, @IS_COMPLETED                   
			);
	end else begin
		select @IS_SUSPENDED           = (case when @SUSPENSION_STATE_CHANGE = 0 then IS_SUSPENDED when @SUSPENSION_STATE_CHANGE = 1 then 1 else 0 end)
		     , @DEFINITION_IDENTITY_ID = DEFINITION_IDENTITY_ID
		     , @SURROGATE_IDENTITY_ID  = SURROGATE_IDENTITY_ID
		  from WF4_INSTANCES
		 where ID = @ID;

		update WF4_INSTANCES
		   set DATE_MODIFIED_UTC               =  getutcdate()                   
		     , SURROGATE_INSTANCE_ID           = @SURROGATE_INSTANCE_ID          
		     , SURROGATE_LOCK_OWNER_ID         = @SURROGATE_LOCK_OWNER_ID        
		     , PRIMITIVE_DATA_PROPERTIES       = (case when @METADATA_UPDATE_ONLY = 1 then PRIMITIVE_DATA_PROPERTIES      else @PRIMITIVE_DATA_PROPERTIES      end)
		     , COMPLEX_DATA_PROPERTIES         = (case when @METADATA_UPDATE_ONLY = 1 then COMPLEX_DATA_PROPERTIES        else @COMPLEX_DATA_PROPERTIES        end)
		     , WRITE_ONLY_PRIMITIVE_DATA_PROP  = (case when @METADATA_UPDATE_ONLY = 1 then WRITE_ONLY_PRIMITIVE_DATA_PROP else @WRITE_ONLY_PRIMITIVE_DATA_PROP end)
		     , WRITE_ONLY_COMPLEX_DATA_PROP    = (case when @METADATA_UPDATE_ONLY = 1 then WRITE_ONLY_COMPLEX_DATA_PROP   else @WRITE_ONLY_COMPLEX_DATA_PROP   end)
		     , METADATA_PROPERTIES             = (case when @METADATA_CONSISTENCY = 0 then METADATA_PROPERTIES            else @METADATA_PROPERTIES            end)
		     , DATA_ENCODING_OPTION            = (case when @METADATA_UPDATE_ONLY = 1 then DATA_ENCODING_OPTION           else @ENCODING_OPTION                end)
		     , METADATA_ENCODING_OPTION        = (case when @METADATA_CONSISTENCY = 0 then METADATA_ENCODING_OPTION       else @ENCODING_OPTION                end)
		     , VERSION                         = @VERSION                        
		     , PENDING_TIMER                   = (case when @METADATA_UPDATE_ONLY = 1 then PENDING_TIMER                  else @PENDING_TIMER                  end)
		     , WORKFLOW_HOST_TYPE              = @WORKFLOW_HOST_TYPE             
		     , SERVICE_DEPLOYMENT_ID           = @SERVICE_DEPLOYMENT_ID          
		     , SUSPENSION_EXCEPTION_NAME       = @SUSPENSION_EXCEPTION_NAME      
		     , SUSPENSION_REASON               = @SUSPENSION_REASON              
		     , BLOCKING_BOOKMARKS              = @BLOCKING_BOOKMARKS             
		     , LAST_MACHINE_RUN_ON             = (case when @METADATA_UPDATE_ONLY = 1 then LAST_MACHINE_RUN_ON            else @LAST_MACHINE_RUN_ON            end)
		     , EXECUTION_STATUS                = (case when @METADATA_UPDATE_ONLY = 1 then EXECUTION_STATUS               else @EXECUTION_STATUS               end)
		     , IS_INITIALIZED                  = (case when @METADATA_UPDATE_ONLY = 1 then IS_INITIALIZED                 else 1                               end)
		     , IS_SUSPENDED                    = @IS_SUSPENDED                   
		     , IS_READY_TO_RUN                 = (case when @METADATA_UPDATE_ONLY = 1 then IS_READY_TO_RUN                else @IS_READY_TO_RUN                end)
		     , IS_COMPLETED                    = @IS_COMPLETED                   
		 where ID                              = @ID                             ;
	end -- if;

	-- 06/22/2016 Paul.  Use WF4_INSTANCES_RUNNABLE to determine runnable so that we query a smaller table. 
	if @METADATA_UPDATE_ONLY = 0 begin -- then
		if not exists(select * from WF4_INSTANCES where ID = @ID and IS_COMPLETED = 0 and (IS_READY_TO_RUN = 1 or PENDING_TIMER is not null or BLOCKING_BOOKMARKS is not null)) begin -- then
			update WF4_INSTANCES
			   set DELETED           = 1
			     , DATE_MODIFIED_UTC = getutcdate()
			 where ID = @ID;
			update WF4_INSTANCES_RUNNABLE
			   set DELETED           = 1
			     , DATE_MODIFIED_UTC = getutcdate()
			 where ID = @ID;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spWF4_INSTANCES_Update to public;
GO

