if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_INSTANCES_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_INSTANCES_Insert;
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
-- 06/30/2008 Paul.  Similar to InsertWorkflowInstance. 
-- 06/30/2008 Paul.  The name ends in Insert because a record is always inserted. 
-- 06/30/2008 Paul.  The @D is the @WORKFLOW_INSTANCE_INTERNAL_ID. 
Create Procedure dbo.spWWF_INSTANCES_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_ID           uniqueidentifier
	, @TYPE_FULL_NAME                 nvarchar(128)
	, @ASSEMBLY_FULL_NAME             nvarchar(256)
	, @CONTEXT_ID                     uniqueidentifier
	, @CALLER_INSTANCE_ID             uniqueidentifier
	, @CALL_PATH                      nvarchar(400)
	, @CALLER_CONTEXT_ID              uniqueidentifier
	, @CALLER_PARENT_CONTEXT_ID       uniqueidentifier
	)
as
  begin
	set nocount on

	declare @WORKFLOW_TYPE_ID      uniqueidentifier;

	set @TYPE_FULL_NAME     = nullif(ltrim(rtrim(@TYPE_FULL_NAME    )), N'');
	set @ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@ASSEMBLY_FULL_NAME)), N'');
	if @TYPE_FULL_NAME is not null or @ASSEMBLY_FULL_NAME is not null begin -- then
		exec dbo.spWWF_TYPES_InsertOnly @WORKFLOW_TYPE_ID out, @MODIFIED_USER_ID, @TYPE_FULL_NAME, @ASSEMBLY_FULL_NAME, 0;

		if dbo.fnIsEmptyGuid(@WORKFLOW_TYPE_ID) = 1 begin -- then
			raiserror(N'spWWF_INSTANCES_Insert failed calling procedure spWWF_TYPES_InsertOnly', 16, 1);
			return;
		end -- if;
	end -- if;

	-- 11/13/2008 Paul.  We are having a problem with Send() being called before SendWorkflowDefinition(). 
	-- So define the internal ID in the constructor. 
	-- C:/Web.net/SplendidCRM6/_code/Workflow/SplendidTrackingChannel.cs Line141, Void Send(System.Workflow.Runtime.Tracking.TrackingRecord). 
	-- Cannot insert the value NULL into column 'WORKFLOW_INSTANCE_INTERNAL_ID', table 'WWF_INSTANCE_EVENTS'; column does not allow nulls. INSERT fails.
	if not exists(select * from WWF_INSTANCES where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_ID and CONTEXT_ID = @CONTEXT_ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end else begin
			-- 11/14/2008 Paul.  If the internal ID exists, but the context does not, then we need to generate a new ID. 
			if exists(select * from WWF_INSTANCES where ID= @ID) begin -- then
				set @ID = newid();
			end -- if;
		end -- if;
		insert into WWF_INSTANCES
			( ID                            
			, CREATED_BY                    
			, DATE_ENTERED                  
			, WORKFLOW_INSTANCE_ID          
			, WORKFLOW_TYPE_ID              
			, CONTEXT_ID                    
			, CALLER_INSTANCE_ID            
			, CALL_PATH                     
			, CALLER_CONTEXT_ID             
			, CALLER_PARENT_CONTEXT_ID      
			, INITIALIZED_DATE_TIME         
			)
		values
		 	( @ID                            
			, @MODIFIED_USER_ID              
			,  getdate()                     
			, @WORKFLOW_INSTANCE_ID          
			, @WORKFLOW_TYPE_ID              
			, @CONTEXT_ID                    
			, @CALLER_INSTANCE_ID            
			, @CALL_PATH                     
			, @CALLER_CONTEXT_ID             
			, @CALLER_PARENT_CONTEXT_ID      
			,  getdate()                     
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spWWF_INSTANCES_Insert to public;
GO

