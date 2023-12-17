if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_ACTIVITY_STATUS_EVENTS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_ACTIVITY_STATUS_EVENTS_Insert;
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
-- 06/28/2008 Paul.  Similar to InsertActivityExecutionStatusEventMultiple. 
-- 06/28/2008 Paul.  The name ends in Insert because a record is always inserted. 
Create Procedure dbo.spWWF_ACTIVITY_STATUS_EVENTS_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @ACTIVITY_INSTANCE_ID           uniqueidentifier output
	, @QUALIFIED_NAME                 nvarchar(128)
	, @CONTEXT_ID                     uniqueidentifier
	, @PARENT_CONTEXT_ID              uniqueidentifier
	, @EVENT_ORDER                    int
	, @EVENT_DATE_TIME                datetime
	, @EXECUTION_STATUS               nvarchar(25)
	)
as
  begin
	set nocount on

	declare @WORKFLOW_INSTANCE_EVENT_ID uniqueidentifier;

	exec dbo.spWWF_ACTIVITY_INSTANCES_InsertOnly @ACTIVITY_INSTANCE_ID out, @MODIFIED_USER_ID, @WORKFLOW_INSTANCE_INTERNAL_ID, @QUALIFIED_NAME, @CONTEXT_ID, @PARENT_CONTEXT_ID;
	if @ACTIVITY_INSTANCE_ID is null or @@ERROR <> 0 begin -- then
		return;
	end -- if;

	set @ID = newid();
	insert into WWF_ACTIVITY_STATUS_EVENTS
		( ID                           
		, CREATED_BY                   
		, DATE_ENTERED                 
		, WORKFLOW_INSTANCE_INTERNAL_ID
		, ACTIVITY_INSTANCE_ID         
		, EVENT_ORDER                  
		, EXECUTION_STATUS             
		, EVENT_DATE_TIME              
		)
	values 	( @ID                       
		, @MODIFIED_USER_ID             
		,  getdate()                    
		, @WORKFLOW_INSTANCE_INTERNAL_ID
		, @ACTIVITY_INSTANCE_ID         
		, @EVENT_ORDER                  
		, @EXECUTION_STATUS             
		, @EVENT_DATE_TIME              
		);
  end
GO
 
Grant Execute on dbo.spWWF_ACTIVITY_STATUS_EVENTS_Insert to public;
GO

