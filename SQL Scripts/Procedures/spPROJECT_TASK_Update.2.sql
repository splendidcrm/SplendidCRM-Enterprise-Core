if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROJECT_TASK_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROJECT_TASK_Update;
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
-- 08/13/2008 Paul.  We need an update version that matches the table name to simplify the worflow code. 
-- 09/13/2008 Paul.  Fix name of base procedure. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 01/19/2010 Paul.  Some customers have requested that we allow for fractional efforts. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPROJECT_TASK_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(50)
	, @STATUS            nvarchar(25)
	, @DATE_TIME_DUE     datetime
	, @DATE_TIME_START   datetime
	, @PARENT_ID         uniqueidentifier
	, @PRIORITY          nvarchar(25)
	, @DESCRIPTION       nvarchar(max)
	, @ORDER_NUMBER      int
	, @TASK_NUMBER       int
	, @DEPENDS_ON_ID     uniqueidentifier
	, @MILESTONE_FLAG    bit
	, @ESTIMATED_EFFORT  float
	, @ACTUAL_EFFORT     float
	, @UTILIZATION       int
	, @PERCENT_COMPLETE  int
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_LIST     varchar(8000) = null
	, @ASSIGNED_SET_LIST varchar(8000) = null
	)
as
  begin
	set nocount on
	
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spPROJECT_TASKS_Update @ID out
		, @MODIFIED_USER_ID
		, @ASSIGNED_USER_ID
		, @NAME
		, @STATUS
		, @DATE_TIME_DUE
		, @DATE_TIME_START
		, @PARENT_ID
		, @PRIORITY
		, @DESCRIPTION
		, @ORDER_NUMBER
		, @TASK_NUMBER
		, @DEPENDS_ON_ID
		, @MILESTONE_FLAG
		, @ESTIMATED_EFFORT
		, @ACTUAL_EFFORT
		, @UTILIZATION
		, @PERCENT_COMPLETE
		, @TEAM_ID
		, @TEAM_SET_LIST
		, @ASSIGNED_SET_LIST
		;
  end
GO

Grant Execute on dbo.spPROJECT_TASK_Update to public;
GO

