if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_INSTANCES_RUNNABLE_Get' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_INSTANCES_RUNNABLE_Get;
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
-- 08/31/2016 Paul.  We need a Get operation for use by the manual terminate operation. 
Create Procedure dbo.spWF4_INSTANCES_RUNNABLE_Get
	( @ID                              uniqueidentifier
	, @AUDIT_ID                        uniqueidentifier output
	, @BUSINESS_PROCESS_ID             uniqueidentifier output
	, @BUSINESS_PROCESS_RUN_ID         uniqueidentifier output
	, @BLOCKING_BOOKMARKS              nvarchar(max) output
	, @XAML                            nvarchar(max) output
	)
as
  begin
	set nocount on

	set @AUDIT_ID                = null;
	set @BUSINESS_PROCESS_ID     = null;
	set @BUSINESS_PROCESS_RUN_ID = null;
	set @BLOCKING_BOOKMARKS      = null;
	set @XAML                    = null;
	select @AUDIT_ID                = BUSINESS_PROCESSES_RUN.AUDIT_ID
	     , @BUSINESS_PROCESS_ID     = BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_ID
	     , @BUSINESS_PROCESS_RUN_ID = BUSINESS_PROCESSES_RUN.ID
	     , @BLOCKING_BOOKMARKS      = BLOCKING_BOOKMARKS
	     , @XAML                    = WF4_DEFINITION_IDENTITY.XAML
	  from            WF4_INSTANCES_RUNNABLE
	  left outer join BUSINESS_PROCESSES_RUN
	               on BUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_INSTANCE_ID = WF4_INSTANCES_RUNNABLE.ID
	  left outer join WF4_DEFINITION_IDENTITY
	               on WF4_DEFINITION_IDENTITY.ID = WF4_INSTANCES_RUNNABLE.DEFINITION_IDENTITY_ID
	 where WF4_INSTANCES_RUNNABLE.ID = @ID
	;
  end
GO

Grant Execute on dbo.spWF4_INSTANCES_RUNNABLE_Get to public;
GO

