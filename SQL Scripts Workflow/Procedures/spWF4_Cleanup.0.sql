if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_Cleanup' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_Cleanup;
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
Create Procedure dbo.spWF4_Cleanup
as
  begin
	set nocount on
	
	delete from WF4_TRACKING_ACTIVITY_SCHEDULE;

	delete from WF4_TRACKING_WORKFLOW_INSTANCE
	 where STATE in (N'Unloaded', N'Idle', N'Persisted', N'Deleted')
	   and DATE_ENTERED < dbo.fnDateAdd('week', -1, getdate());

	delete from WF4_TRACKING_ACTIVITY_STATE
	 where ACTIVITY_NAME in (N'Sequence', N'Parallel', N'Flowchart', N'DynamicActivity', N'CSharpValue<Boolean>', N'Assign')
	   and DATE_ENTERED < dbo.fnDateAdd('week', -1, getdate());

	delete from WF4_TRACKING_ACTIVITY_STATE
	 where STATE in (N'Closed')
	   and DATE_ENTERED < dbo.fnDateAdd('week', -1, getdate());
  end
GO

Grant Execute on dbo.spWF4_Cleanup to public;
GO

