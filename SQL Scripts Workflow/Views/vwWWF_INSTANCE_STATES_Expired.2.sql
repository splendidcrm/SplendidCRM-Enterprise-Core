if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWWF_INSTANCE_STATES_Expired')
	Drop View dbo.vwWWF_INSTANCE_STATES_Expired;
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
-- 07/16/2008 Paul.  Similar to RetrieveExpiredTimerIds
Create View dbo.vwWWF_INSTANCE_STATES_Expired
as
select ID
  from vwWWF_INSTANCE_STATES
 where NEXT_TIMER < getdate()
   and STATUS not in (N'Completed', N'Suspended', N'Terminated')  -- System.Workflow.Runtime.WorkflowStatus
   and ((UNLOCKED = 1 and OWNER_ID is null) or OWNED_UNTIL < getdate())

GO

Grant Select on dbo.vwWWF_INSTANCE_STATES_Expired to public;
GO
