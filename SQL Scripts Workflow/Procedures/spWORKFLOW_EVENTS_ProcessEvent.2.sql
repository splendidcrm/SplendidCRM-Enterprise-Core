if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_EVENTS_ProcessEvent' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_EVENTS_ProcessEvent;
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
Create Procedure dbo.spWORKFLOW_EVENTS_ProcessEvent
	( @EVENT_AUDIT_ID    uniqueidentifier
	, @AUDIT_TABLE       nvarchar(50)
	, @AUDIT_ACTION      int
	, @AUDIT_TOKEN       varchar(255)
	)
as
  begin
	set nocount on
	
	declare @WORKFLOW_ID               uniqueidentifier;
	declare @WORKFLOW_NAME             nvarchar(100);
	declare @WORKFLOW_FILTER_SQL       nvarchar(max);
	declare @COMMAND                   nvarchar(max);
	-- 08/19/2010 Paul.  Increase size to allow for Oracle definition. 
	declare @PARAM_DEFINTION           nvarchar(200);
	declare @RUN_WORKFLOW              bit;
	declare @STATUS_MESSAGE            nvarchar(max);
	declare @WORKFLOW_PROTECTION_LEVEL int;

-- #if SQL_Server /*
	declare workflow_cursor cursor for
	select ID
	     , NAME
	     , FILTER_SQL
	  from WORKFLOW
	 where DELETED     = 0
	   and STATUS      = 1
	   and TYPE        = N'normal'
	   and AUDIT_TABLE = @AUDIT_TABLE
	   and (RECORD_TYPE = N'all' or @AUDIT_ACTION is null or ((@AUDIT_ACTION = 0 and RECORD_TYPE = N'new') or (@AUDIT_ACTION = 1 and RECORD_TYPE = N'update')))
	 order by LIST_ORDER_Y asc;
-- #endif SQL_Server */

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	-- 08/09/2008 Paul.  Protection Level 10 is the most restrictive, and Protection Level 1 is the least restrictive. 
	set @WORKFLOW_PROTECTION_LEVEL = dbo.fnCONFIG_Int(N'workflow_protection_level');
	if @WORKFLOW_PROTECTION_LEVEL is null or @WORKFLOW_PROTECTION_LEVEL = 0 begin -- then
		set @WORKFLOW_PROTECTION_LEVEL = 10;
	end -- if;

	set @PARAM_DEFINTION = N'@AUDIT_ID uniqueidentifier, @FILTER_EXISTS bit OUTPUT';
	open workflow_cursor;
	fetch next from workflow_cursor into @WORKFLOW_ID, @WORKFLOW_NAME, @WORKFLOW_FILTER_SQL;
	while @@FETCH_STATUS = 0 begin -- do
		--print 'Workflow: ' + @WORKFLOW_NAME + ' - ' + cast(@WORKFLOW_ID as char(36));
		-- 08/09/2008 Paul.  First assume that we will run the workflow and then apply the circular protection filters. 
		set @RUN_WORKFLOW = 1;
		if exists(select * from WORKFLOW_TRANSACTION_LOG where AUDIT_TABLE = @AUDIT_TABLE and AUDIT_TOKEN = @AUDIT_TOKEN) begin -- then
			--print 'Token is in transaction log.';
			if @WORKFLOW_PROTECTION_LEVEL >= 10 begin -- then
				-- 08/09/2008 Paul.  At level 10, all triggers fired from within a workflow are skipped. 
				-- 08/09/2008 Paul.  There currently is no way to block two separate workflows that fire each other. 
				-- The only thing we can do at this stage is block all workflows from firing other workflows.
				-- At some point, we can relax this rule and attempt warn the user of a potential circular workflow. 
				set @RUN_WORKFLOW = 0;
				exec dbo.spWORKFLOW_RUN_InsertOnly null, @WORKFLOW_ID, @EVENT_AUDIT_ID, @AUDIT_TABLE, N'Protection Level 10';
			end else if @WORKFLOW_PROTECTION_LEVEL >= 8 begin -- then
				-- 08/09/2008 Paul.  At level 8, block a nested event using the workflow instance.
				-- When trying to isolate a nested trigger, we cannot use the audit token directly as we do not have a DB transaction across all activities. 
				-- Instead we use the Workflow Instance ID as it is static across the entire workflow. 
				-- So, we lookup the Workflow Instance ID and use it in place of the audit token. 
				if exists(select *
				            from WORKFLOW_TRANSACTION_LOG
				           where WORKFLOW_INSTANCE_ID in (select WORKFLOW_INSTANCE_ID from WORKFLOW_TRANSACTION_LOG where AUDIT_TOKEN = @AUDIT_TOKEN)
				             and WORKFLOW_ID = @WORKFLOW_ID
				         ) begin -- then
					set @RUN_WORKFLOW = 0;
					exec dbo.spWORKFLOW_RUN_InsertOnly null, @WORKFLOW_ID, @EVENT_AUDIT_ID, @AUDIT_TABLE, N'Protection Level 8';
				end -- if;
			end else if @WORKFLOW_PROTECTION_LEVEL >= 7 begin -- then
				-- 08/09/2008 Paul.  At level 7, block a nested event using the workflow instance and the audit table.
				-- This filter is slightly more permissive, but may not catch anything not already filtered above.  
				if exists(select *
				            from WORKFLOW_TRANSACTION_LOG
				           where WORKFLOW_INSTANCE_ID in (select WORKFLOW_INSTANCE_ID from WORKFLOW_TRANSACTION_LOG where AUDIT_TABLE = @AUDIT_TABLE and AUDIT_TOKEN = @AUDIT_TOKEN)
				             and AUDIT_TABLE = @AUDIT_TABLE
				             and WORKFLOW_ID = @WORKFLOW_ID
				         ) begin -- then
					set @RUN_WORKFLOW = 0;
					exec dbo.spWORKFLOW_RUN_InsertOnly null, @WORKFLOW_ID, @EVENT_AUDIT_ID, @AUDIT_TABLE, N'Protection Level 7';
				end -- if;
			end else if @WORKFLOW_PROTECTION_LEVEL >= 5 begin -- then
				-- 08/09/2008 Paul.  At level 5, a workflow cannot fire another identical workflow within the same activity. 
				-- This filter will only catch a workflow that updates itself or creates another new record. 
				if exists(select * from WORKFLOW_TRANSACTION_LOG where AUDIT_TABLE = @AUDIT_TABLE and AUDIT_TOKEN = @AUDIT_TOKEN and WORKFLOW_ID = @WORKFLOW_ID) begin -- then
					set @RUN_WORKFLOW = 0;
					exec dbo.spWORKFLOW_RUN_InsertOnly null, @WORKFLOW_ID, @EVENT_AUDIT_ID, @AUDIT_TABLE, N'Protection Level 5';
				end -- if;
			end -- if;
		end -- if;
		if @RUN_WORKFLOW = 1 begin -- then
			--print 'Workflow can run: ' + @WORKFLOW_NAME;
			if @WORKFLOW_FILTER_SQL is not null begin -- then
				-- 08/09/2008 Paul.  If there is a SQL filter, then clear the run flag and have the SQL filter decide if the workflow will run. 
				set @RUN_WORKFLOW = 0;
-- #if SQL_Server /*
				set @COMMAND = N'if exists(' + @WORKFLOW_FILTER_SQL + N') set @FILTER_EXISTS = 1;';
				
				-- 01/14/2010 Paul.  To prevent SQL Injection from a workflow, wrap the execute in a transaction and always roll the transaction back. 
				-- The rollback will not affect the value stored in @RUN_WORKFLOW. 
				-- 01/14/2010 Paul.  Cannot roll back SplendidWorkflow. No transaction or savepoint of that name was found. 
				-- Transaction count after EXECUTE indicates that a COMMIT or ROLLBACK TRANSACTION statement is missing
				-- 01/14/2010 Paul.  Use save transaction and make sure to commit the begin. 
				begin transaction SplendidWorkflow;
				save transaction SplendidWorkflow;
				exec sp_executesql @COMMAND, @PARAM_DEFINTION, @AUDIT_ID = @EVENT_AUDIT_ID, @FILTER_EXISTS = @RUN_WORKFLOW output;
				rollback transaction SplendidWorkflow;
				commit transaction SplendidWorkflow;
				
				-- 11/19/2008 Paul.  Print the workflow that generated the error. 
				if @@ERROR <> 0 begin -- then
					print 'Workflow Filter Failed: ' + @WORKFLOW_NAME + ' - ' + cast(@WORKFLOW_ID as char(36));
				end -- if;
-- #endif SQL_Server */
/* -- #if Oracle
				-- http://download.oracle.com/docs/cd/B19306_01/appdev.102/b14261/dynamic.htm#sthref1557
				-- 09/09/2010 Paul.  Not sure why, but the output field must be in column 1 of the using clause. 
				@COMMAND := N'BEGIN select 1 into :1 from dual where exists(' + replace(@WORKFLOW_FILTER_SQL, '@AUDIT_ID', ':2') + N'); EXCEPTION when NO_DATA_FOUND then null; END;';
				-- 09/09/2010 Paul.  Make sure to use the input parameter @EVENT_AUDIT_ID. 
				EXECUTE IMMEDIATE @COMMAND USING in out @RUN_WORKFLOW, @EVENT_AUDIT_ID;
-- #endif Oracle */
			end -- if;
			if @RUN_WORKFLOW = 1 begin -- then
				--print 'Workflow ready: ' + @WORKFLOW_NAME;
				exec dbo.spWORKFLOW_RUN_InsertOnly null, @WORKFLOW_ID, @EVENT_AUDIT_ID, @AUDIT_TABLE, N'Ready';
			end -- if;
		end -- if;

		fetch next from workflow_cursor into @WORKFLOW_ID, @WORKFLOW_NAME, @WORKFLOW_FILTER_SQL;
/* -- #if Oracle
		IF workflow_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close workflow_cursor;

	deallocate workflow_cursor;
  end
GO

Grant Execute on dbo.spWORKFLOW_EVENTS_ProcessEvent to public;
GO

