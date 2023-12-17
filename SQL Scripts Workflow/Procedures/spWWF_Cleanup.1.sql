if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_Cleanup' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_Cleanup;
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
Create Procedure dbo.spWWF_Cleanup
	( @QUALIFIED_NAME nvarchar(128)
	)
as
  begin
	set nocount on
	
	-- 02/26/2010 Paul.  We want to be selective on the entries that we delete
	-- so that we don't delete useful bug tracking or auditing information. 

	-- 02/26/2010 Paul.  Status Events are not displayed anywhere, so we can simply delete based on time. 
	delete from WWF_ACTIVITY_STATUS_EVENTS
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate());

	delete from WWF_USER_EVENTS
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate());

	delete from WWF_ACTIVITY_INSTANCES
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate())
	   and ID not in (select ACTIVITY_INSTANCE_ID
	                    from WWF_ACTIVITY_STATUS_EVENTS
	                   union
	                  select ACTIVITY_INSTANCE_ID
	                    from WWF_USER_EVENTS
	                 );

	-- 02/26/2010 Paul.  The Completed event is useful, but Created, Started and Persisted can all be deleted. 
	delete from WWF_INSTANCE_EVENTS
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate())
	   and TRACKING_WORKFLOW_EVENT <> 'Completed';

	-- 02/26/2010 Paul.  We can delete all activities that are not available to the current build. 
	delete from WWF_ACTIVITIES
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate())
	   and QUALIFIED_NAME like 'SplendidCRM,%'
	   and QUALIFIED_NAME <> @QUALIFIED_NAME;

	-- 02/26/2010 Paul.  Lets delete the base activities if more than 3 months old. 
	-- 09/03/2016 Paul.  Keep data for only one month. 
	delete from WWF_ACTIVITIES
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate())
	   and QUALIFIED_NAME like 'System.Workflow.Activities,%';

	-- 09/03/2016 Paul.  Delete old definitions and types. 
	delete from WWF_DEFINITIONS
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate());

	-- 09/03/2016 Paul.  Delete old definitions and types. 
	-- 06/22/2017 Paul.  Can't delete types that are used in WWF_ACTIVITIES. 
	delete from WWF_TYPES
	 where DATE_ENTERED < dbo.fnDateAdd('month', -1, getdate())
	   and ID not in (select WORKFLOW_TYPE_ID from WWF_DEFINITIONS)
	   and ID not in (select WORKFLOW_TYPE_ID from WWF_ACTIVITIES);

	-- 09/03/2016 Paul.  Include Workflow 4 cleanup. 
	exec spWF4_Cleanup ;
  end
GO

Grant Execute on dbo.spWWF_Cleanup to public;
GO

