if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_InsertOnly;
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
Create Procedure dbo.spPROCESSES_InsertOnly
	( @BUSINESS_PROCESS_INSTANCE_ID  uniqueidentifier
	, @ACTIVITY_INSTANCE             nvarchar(100)
	, @ACTIVITY_NAME                 nvarchar(100)
	, @BUSINESS_PROCESS_ID           uniqueidentifier
	, @PROCESS_USER_ID               uniqueidentifier
	, @BOOKMARK_NAME                 nvarchar(100)
	, @PARENT_TYPE                   nvarchar(50)
	, @PARENT_ID                     uniqueidentifier
	, @USER_TASK_TYPE                nvarchar(50)
	, @CHANGE_ASSIGNED_USER          bit
	, @CHANGE_ASSIGNED_TEAM_ID       uniqueidentifier
	, @CHANGE_PROCESS_USER           bit
	, @CHANGE_PROCESS_TEAM_ID        uniqueidentifier
	, @USER_ASSIGNMENT_METHOD        nvarchar(50)
	, @STATIC_ASSIGNED_USER_ID       uniqueidentifier
	, @DYNAMIC_PROCESS_TEAM_ID       uniqueidentifier
	, @DYNAMIC_PROCESS_ROLE_ID       uniqueidentifier
	, @READ_ONLY_FIELDS              nvarchar(max)
	, @REQUIRED_FIELDS               nvarchar(max)
	, @DURATION_UNITS                nvarchar(50)
	, @DURATION_VALUE                int
	)
as
  begin
	set nocount on
	
	declare @ID               uniqueidentifier;
	declare @MODIFIED_USER_ID uniqueidentifier;
	declare @PROCESS_NUMBER   int;
	declare @STATUS           nvarchar(25);
	-- raiserror(N'spPROCESSES_InsertOnly test error', 16, 4);
	
	set @STATUS = N'In Progress';
	if @PROCESS_USER_ID is null begin -- then
		set @STATUS = N'Unclaimed';
	end -- if;
	
	if not exists(select * from PROCESSES where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID and ACTIVITY_INSTANCE = @ACTIVITY_INSTANCE) begin -- then
		exec dbo.spNUMBER_SEQUENCES_Unformatted N'PROCESSES.PROCESS_NUMBER', 1, @PROCESS_NUMBER out;
		set @ID = newid();
		insert into PROCESSES
			( ID                           
			, CREATED_BY                   
			, DATE_ENTERED                 
			, MODIFIED_USER_ID             
			, DATE_MODIFIED                
			, DATE_MODIFIED_UTC            
			, PROCESS_NUMBER               
			, BUSINESS_PROCESS_INSTANCE_ID 
			, ACTIVITY_INSTANCE            
			, ACTIVITY_NAME                
			, BUSINESS_PROCESS_ID          
			, PROCESS_USER_ID              
			, BOOKMARK_NAME                
			, PARENT_TYPE                  
			, PARENT_ID                    
			, USER_TASK_TYPE               
			, CHANGE_ASSIGNED_USER         
			, CHANGE_ASSIGNED_TEAM_ID      
			, CHANGE_PROCESS_USER          
			, CHANGE_PROCESS_TEAM_ID       
			, USER_ASSIGNMENT_METHOD       
			, STATIC_ASSIGNED_USER_ID      
			, DYNAMIC_PROCESS_TEAM_ID      
			, DYNAMIC_PROCESS_ROLE_ID      
			, READ_ONLY_FIELDS             
			, REQUIRED_FIELDS              
			, DURATION_UNITS               
			, DURATION_VALUE               
			, STATUS                       
			)
		values 	( @ID                           
			, @MODIFIED_USER_ID             
			,  getdate()                    
			, @MODIFIED_USER_ID             
			,  getdate()                    
			,  getutcdate()                 
			, @PROCESS_NUMBER               
			, @BUSINESS_PROCESS_INSTANCE_ID 
			, @ACTIVITY_INSTANCE            
			, @ACTIVITY_NAME                
			, @BUSINESS_PROCESS_ID          
			, @PROCESS_USER_ID              
			, @BOOKMARK_NAME                
			, @PARENT_TYPE                  
			, @PARENT_ID                    
			, @USER_TASK_TYPE               
			, @CHANGE_ASSIGNED_USER         
			, @CHANGE_ASSIGNED_TEAM_ID      
			, @CHANGE_PROCESS_USER          
			, @CHANGE_PROCESS_TEAM_ID       
			, @USER_ASSIGNMENT_METHOD       
			, @STATIC_ASSIGNED_USER_ID      
			, @DYNAMIC_PROCESS_TEAM_ID      
			, @DYNAMIC_PROCESS_ROLE_ID      
			, @READ_ONLY_FIELDS             
			, @REQUIRED_FIELDS              
			, @DURATION_UNITS               
			, @DURATION_VALUE               
			, @STATUS                       
			);

		if @PROCESS_USER_ID is not null begin -- then
			exec dbo. spPROCESSES_HISTORY_InsertOnly null, @ID, @BUSINESS_PROCESS_INSTANCE_ID, N'Assign', @PROCESS_USER_ID, null, null, @STATUS;
		end -- if;
	end else begin
		-- 07/31/2016 Paul.  We should not reach this code, but just in case, reset the approval state. 
		update PROCESSES
		   set MODIFIED_USER_ID             = null
		     , DATE_MODIFIED                = getdate()
		     , DATE_MODIFIED_UTC            = getutcdate()
		     , PROCESS_USER_ID              = @PROCESS_USER_ID
		     , BOOKMARK_NAME                = @BOOKMARK_NAME
		     , PARENT_TYPE                  = @PARENT_TYPE
		     , PARENT_ID                    = @PARENT_ID
		     , APPROVAL_USER_ID             = null
		     , APPROVAL_RESPONSE            = null
		 where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID
		   and ACTIVITY_INSTANCE            = @ACTIVITY_INSTANCE;
	end -- if;
  end
GO

Grant Execute on dbo.spPROCESSES_InsertOnly to public;
GO

