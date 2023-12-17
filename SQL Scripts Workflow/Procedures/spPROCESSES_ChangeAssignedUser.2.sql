if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_ChangeAssignedUser' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_ChangeAssignedUser;
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
-- 03/20/2020 Paul.  Not sure why, but notes were not being saved until now. 
Create Procedure dbo.spPROCESSES_ChangeAssignedUser
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @PROCESS_NOTES     nvarchar(max)
	)
as
  begin
	set nocount on

	declare @PARENT_ID                    uniqueidentifier;
	declare @BUSINESS_PROCESS_ID          uniqueidentifier;
	declare @BUSINESS_PROCESS_INSTANCE_ID uniqueidentifier;
	declare @STATUS                       nvarchar(50);
	declare @MODULE_TABLE                 nvarchar(50);
	declare @COMMAND                      nvarchar(max);
	declare @PARAM_DEFINTION              nvarchar(200);
	declare @CRLF                         char(2);

	-- BEGIN Oracle Exception
		select @PARENT_ID                    = PROCESSES.PARENT_ID
		     , @BUSINESS_PROCESS_ID          = PROCESSES.BUSINESS_PROCESS_ID
		     , @BUSINESS_PROCESS_INSTANCE_ID = PROCESSES.BUSINESS_PROCESS_INSTANCE_ID
		     , @MODULE_TABLE                 = substring(BUSINESS_PROCESSES.AUDIT_TABLE, 1, len(BUSINESS_PROCESSES.AUDIT_TABLE) - 6)
		     , @STATUS                       = PROCESSES.STATUS        
		  from      PROCESSES
		 inner join BUSINESS_PROCESSES
		         on BUSINESS_PROCESSES.ID = PROCESSES.BUSINESS_PROCESS_ID
		 where PROCESSES.ID = @ID;
	-- END Oracle Exception
	
	-- 08/06/2016 Paul.  We need to use the transaction log protection to prevent changing the record from firing another workflow. 
	exec dbo.spWORKFLOW_TRANS_LOG_InsertOnly @MODIFIED_USER_ID, @MODULE_TABLE, @BUSINESS_PROCESS_ID, @BUSINESS_PROCESS_INSTANCE_ID;

	set @CRLF = char(13) + char(10);
	set @COMMAND = '';
	set @COMMAND = @COMMAND + 'update ' + @MODULE_TABLE + @CRLF;
	set @COMMAND = @COMMAND + '   set MODIFIED_USER_ID  = @MODIFIED_USER_ID' + @CRLF;
	set @COMMAND = @COMMAND + '     , DATE_MODIFIED     = getdate()        ' + @CRLF;
	set @COMMAND = @COMMAND + '     , DATE_MODIFIED_UTC = getutcdate()     ' + @CRLF;
	set @COMMAND = @COMMAND + '     , ASSIGNED_USER_ID  = @ASSIGNED_USER_ID' + @CRLF;
	set @COMMAND = @COMMAND + ' where ID                = @ID              ' + @CRLF;
	set @PARAM_DEFINTION = N'@MODIFIED_USER_ID uniqueidentifier, @ASSIGNED_USER_ID uniqueidentifier, @ID uniqueidentifier';
	exec sp_executesql @COMMAND, @PARAM_DEFINTION,  @MODIFIED_USER_ID = @MODIFIED_USER_ID, @ASSIGNED_USER_ID = @ASSIGNED_USER_ID, @ID = @PARENT_ID;

	exec dbo.spPROCESSES_HISTORY_InsertOnly @MODIFIED_USER_ID, @ID, @BUSINESS_PROCESS_INSTANCE_ID, N'ChangeAssignedUser', NULL, @ASSIGNED_USER_ID, null, @STATUS;

	-- 03/20/2020 Paul.  Not sure why, but notes were not being saved until now. 
	if @PROCESS_NOTES is not null begin -- then
		exec dbo.spPROCESSES_NOTES_InsertOnly @MODIFIED_USER_ID, @ID, @PROCESS_NOTES;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPROCESSES_ChangeAssignedUser to public;
GO
 
