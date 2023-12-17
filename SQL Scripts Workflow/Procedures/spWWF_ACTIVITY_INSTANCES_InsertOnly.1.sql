if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_ACTIVITY_INSTANCES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_ACTIVITY_INSTANCES_InsertOnly;
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
-- 06/28/2008 Paul.  Similar to GetActivityInstanceId. 
-- 06/28/2008 Paul.  The name is InsertOnly because it only inserts the record if it does not already exist. 
-- 10/28/2023 Paul.  WF3 to WF4 will use WORKFLOW_INSTANCE_ID instead of @WORKFLOW_INSTANCE_INTERNAL_ID. 
Create Procedure dbo.spWWF_ACTIVITY_INSTANCES_InsertOnly
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @QUALIFIED_NAME                 nvarchar(128)
	, @CONTEXT_ID                     uniqueidentifier
	, @PARENT_CONTEXT_ID              uniqueidentifier
	)
as
  begin
	set nocount on

	declare @WORKFLOW_INSTANCE_EVENT_ID uniqueidentifier;

	-- 10/28/2023 Paul.  WF3 to WF4 will use WORKFLOW_INSTANCE_ID instead of @WORKFLOW_INSTANCE_INTERNAL_ID. 
	if exists(select * from WWF_INSTANCES where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_INTERNAL_ID) begin -- then
		select @WORKFLOW_INSTANCE_INTERNAL_ID = ID
		  from WWF_INSTANCES
		 where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_INTERNAL_ID;
	end -- if;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from WWF_ACTIVITY_INSTANCES
			 where WORKFLOW_INSTANCE_INTERNAL_ID = @WORKFLOW_INSTANCE_INTERNAL_ID
			   and QUALIFIED_NAME                = @QUALIFIED_NAME
			   and CONTEXT_ID                    = @CONTEXT_ID
			   and PARENT_CONTEXT_ID             = @PARENT_CONTEXT_ID;
		-- END Oracle Exception

		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select top 1
				       @WORKFLOW_INSTANCE_EVENT_ID   = WORKFLOW_INSTANCE_EVENT_ID
				  from WWF_ADDED_ACTIVITIES
				 where WORKFLOW_INSTANCE_INTERNAL_ID = @WORKFLOW_INSTANCE_INTERNAL_ID
				   and QUALIFIED_NAME                = @QUALIFIED_NAME
				 order by DATE_ENTERED desc;
			-- END Oracle Exception

			set @ID = newid();
			insert into WWF_ACTIVITY_INSTANCES
				( ID
				, CREATED_BY
				, DATE_ENTERED
				, WORKFLOW_INSTANCE_INTERNAL_ID
				, QUALIFIED_NAME
				, CONTEXT_ID
				, PARENT_CONTEXT_ID
				, WORKFLOW_INSTANCE_EVENT_ID
				)
			values	( @ID
				, @MODIFIED_USER_ID
				, getdate()
				, @WORKFLOW_INSTANCE_INTERNAL_ID
				, @QUALIFIED_NAME
				, @CONTEXT_ID
				, @PARENT_CONTEXT_ID
				, @WORKFLOW_INSTANCE_EVENT_ID
				);
-- #if SQL_Server /*
			if @@ROWCOUNT = 0 begin -- then
				raiserror(N'Failed inserting into WWF_ACTIVITY_INSTANCES', 16, 4);
			end -- if;
-- #endif SQL_Server */
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spWWF_ACTIVITY_INSTANCES_InsertOnly to public;
GO

