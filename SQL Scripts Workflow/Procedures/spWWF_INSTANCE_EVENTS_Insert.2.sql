if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_INSTANCE_EVENTS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_INSTANCE_EVENTS_Insert;
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
-- 06/28/2008 Paul.  Similar to InsertWorkflowInstanceEvent.
-- 06/28/2008 Paul.  The name ends in Insert because a record is always inserted. 
-- 06/29/2008 Paul.  This procedure returns @WORKFLOW_INSTANCE_EVENT_ID. 
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2023 Paul.  WF3 to WF4 will use WORKFLOW_INSTANCE_ID instead of @WORKFLOW_INSTANCE_INTERNAL_ID. 
Create Procedure dbo.spWWF_INSTANCE_EVENTS_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @TRACKING_WORKFLOW_EVENT        nvarchar(25)
	, @EVENT_ORDER                    int
	, @EVENT_DATE_TIME                datetime
	, @EVENT_ARG_TYPE_FULL_NAME       nvarchar(128)
	, @EVENT_ARG_ASSEMBLY_FULL_NAME   nvarchar(256)
	, @EVENT_ARG                      varbinary(max)
	, @DESCRIPTION                    nvarchar(max)
	)
as
  begin
	set nocount on

	declare @EVENT_ARG_TYPE_ID    uniqueidentifier;
	declare @WORKFLOW_RUN_ID      uniqueidentifier;
	declare @WORKFLOW_INSTANCE_ID uniqueidentifier;

	-- 10/28/2023 Paul.  WF3 to WF4 will use WORKFLOW_INSTANCE_ID instead of @WORKFLOW_INSTANCE_INTERNAL_ID. 
	if exists(select * from WWF_INSTANCES where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_INTERNAL_ID) begin -- then
		select @WORKFLOW_INSTANCE_INTERNAL_ID = ID
		  from WWF_INSTANCES
		 where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_INTERNAL_ID;
	end -- if;

	if @EVENT_ARG is not null begin -- then
		set @EVENT_ARG_TYPE_FULL_NAME     = nullif(ltrim(rtrim(@EVENT_ARG_TYPE_FULL_NAME    )), N'');
		set @EVENT_ARG_ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@EVENT_ARG_ASSEMBLY_FULL_NAME)), N'');
		if @EVENT_ARG_TYPE_FULL_NAME is null or @EVENT_ARG_ASSEMBLY_FULL_NAME is null begin -- then
			raiserror(N'@EVENT_ARG_TYPE_FULL_NAME and @EVENT_ARG_ASSEMBLY_FULL_NAME must be non null if @EVENT_ARG is non null', 16, 1);
			return;
		end else begin
			exec dbo.spWWF_TYPES_InsertOnly @EVENT_ARG_TYPE_ID out, @MODIFIED_USER_ID, @EVENT_ARG_TYPE_FULL_NAME, @EVENT_ARG_ASSEMBLY_FULL_NAME, 0;
		end -- if;
	end -- if;

	-- 10/29/2023 Paul.  WF3 to WF4 does not have a good EVENT_ORDER, so fake it out using max count. 
	if @EVENT_ORDER = 0 begin -- then
		select @EVENT_ORDER = isnull(max(EVENT_ORDER), 0) + 1
		  from WWF_INSTANCE_EVENTS
		 where WORKFLOW_INSTANCE_INTERNAL_ID = @WORKFLOW_INSTANCE_INTERNAL_ID;
	end -- if;
	set @ID = newid();
	insert into WWF_INSTANCE_EVENTS
		( ID                            
		, CREATED_BY                    
		, DATE_ENTERED                  
		, WORKFLOW_INSTANCE_INTERNAL_ID 
		, TRACKING_WORKFLOW_EVENT       
		, EVENT_ORDER                   
		, EVENT_DATE_TIME               
		, EVENT_ARG_TYPE_ID             
		, EVENT_ARG                     
		, DESCRIPTION                   
		)
	values
	 	( @ID                            
		, @MODIFIED_USER_ID              
		,  getdate()                     
		, @WORKFLOW_INSTANCE_INTERNAL_ID 
		, @TRACKING_WORKFLOW_EVENT       
		, @EVENT_ORDER                   
		, @EVENT_DATE_TIME               
		, @EVENT_ARG_TYPE_ID             
		, @EVENT_ARG                     
		, @DESCRIPTION                   
		);

	-- 10/11/2008 Paul.  Update status with more events from TrackingWorkflowEvent. 
	-- Created = 0,
	-- Completed = 1,
	-- Idle = 2,
	-- Suspended = 3,
	-- Resumed = 4,
	-- Persisted = 5,
	-- Unloaded = 6,
	-- Loaded = 7,
	-- Exception = 8,
	-- Terminated = 9,
	-- Aborted = 10,
	-- Changed = 11,
	-- Started = 12,
	if @TRACKING_WORKFLOW_EVENT = N'Started' or @TRACKING_WORKFLOW_EVENT = N'Completed' begin -- then
		-- BEGIN Oracle Exception
			select @WORKFLOW_RUN_ID = WORKFLOW_RUN.ID
			  from      WWF_INSTANCES
			 inner join WORKFLOW_RUN
			         on WORKFLOW_RUN.WORKFLOW_INSTANCE_ID = WWF_INSTANCES.WORKFLOW_INSTANCE_ID
			 where WWF_INSTANCES.ID = @WORKFLOW_INSTANCE_INTERNAL_ID;
		-- END Oracle Exception
		exec dbo.spWORKFLOW_RUN_UpdateStatus @WORKFLOW_RUN_ID, @MODIFIED_USER_ID, @TRACKING_WORKFLOW_EVENT;
	end else if @TRACKING_WORKFLOW_EVENT = N'Exception' or @TRACKING_WORKFLOW_EVENT = N'Terminated' or @TRACKING_WORKFLOW_EVENT = N'Aborted' begin -- then
		-- BEGIN Oracle Exception
			select @WORKFLOW_RUN_ID = WORKFLOW_RUN.ID
			  from      WWF_INSTANCES
			 inner join WORKFLOW_RUN
			         on WORKFLOW_RUN.WORKFLOW_INSTANCE_ID = WWF_INSTANCES.WORKFLOW_INSTANCE_ID
			 where WWF_INSTANCES.ID = @WORKFLOW_INSTANCE_INTERNAL_ID;
		-- END Oracle Exception
		exec dbo.spWORKFLOW_RUN_Failed @WORKFLOW_RUN_ID, @MODIFIED_USER_ID, @TRACKING_WORKFLOW_EVENT, @DESCRIPTION;
	end -- if;
  end
GO
 
Grant Execute on dbo.spWWF_INSTANCE_EVENTS_Insert to public;
GO

