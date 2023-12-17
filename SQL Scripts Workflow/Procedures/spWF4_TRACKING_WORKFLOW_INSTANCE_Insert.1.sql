if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_TRACKING_WORKFLOW_INSTANCE_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_TRACKING_WORKFLOW_INSTANCE_Insert;
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
Create Procedure dbo.spWF4_TRACKING_WORKFLOW_INSTANCE_Insert
	( @INSTANCE_ID          uniqueidentifier
	, @EVENT_TIME           datetime
	, @RECORD_NUMBER        bigint
	, @ANNOTATIONS          nvarchar(max)
	, @ACTIVITY_DEFINITION  nvarchar(256)
	, @STATE                nvarchar(25)
	, @IDENTITY_NAME        nvarchar(256)
	, @IDENTITY_PACKAGE     nvarchar(256)
	, @IDENTITY_VERSION     nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID         uniqueidentifier;
	declare @CREATED_BY uniqueidentifier;
	set @ID = newid();
	insert into WF4_TRACKING_WORKFLOW_INSTANCE
		( ID                  
		, CREATED_BY          
		, DATE_ENTERED        
		, INSTANCE_ID         
		, EVENT_TIME          
		, RECORD_NUMBER       
		, ANNOTATIONS         
		, ACTIVITY_DEFINITION 
		, STATE               
		, IDENTITY_NAME       
		, IDENTITY_PACKAGE    
		, IDENTITY_VERSION    
		)
	values 	( @ID                  
		, @CREATED_BY          
		,  getdate()           
		, @INSTANCE_ID         
		, @EVENT_TIME          
		, @RECORD_NUMBER       
		, @ANNOTATIONS         
		, @ACTIVITY_DEFINITION 
		, @STATE               
		, @IDENTITY_NAME       
		, @IDENTITY_PACKAGE    
		, @IDENTITY_VERSION    
		);
	if @STATE = N'Completed' or @STATE = N'Terminated' begin -- then
		update BUSINESS_PROCESSES_RUN
		   set DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , STATUS            = @STATE
		     , END_DATE          = isnull(END_DATE, getdate())
		 where BUSINESS_PROCESS_INSTANCE_ID = @INSTANCE_ID
		  and STATUS             <> N'Completed';
		-- 08/26/2016 Paul.  We need to clear the process for those that have been skipped. 
		update PROCESSES
		   set DATE_MODIFIED                =  getdate()       
		     , DATE_MODIFIED_UTC            =  getutcdate()    
		     , STATUS                       = N'Skipped'
		 where BUSINESS_PROCESS_INSTANCE_ID = @INSTANCE_ID
		   and DELETED                      = 0
		   and STATUS                       in (N'In Progress', N'Unclaimed')
		   and APPROVAL_USER_ID             is null;
	end -- if;
  end
GO

Grant Execute on dbo.spWF4_TRACKING_WORKFLOW_INSTANCE_Insert to public;
GO

