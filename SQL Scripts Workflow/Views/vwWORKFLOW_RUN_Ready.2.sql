if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOW_RUN_Ready')
	Drop View dbo.vwWORKFLOW_RUN_Ready;
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
-- 10/04/2008 Paul.  Return the XOML so that we can run the workflow. 
-- 11/16/2008 Paul.  We need to distinguish between normal and time-based workflows. 
Create View dbo.vwWORKFLOW_RUN_Ready
as
select vwWORKFLOW_RUN.ID
     , vwWORKFLOW_RUN.WORKFLOW_VERSION
     , vwWORKFLOW_RUN.WORKFLOW_ID
     , vwWORKFLOW_RUN.AUDIT_ID
     , vwWORKFLOW_RUN.AUDIT_TABLE
     , WORKFLOW.TYPE
     , WORKFLOW.XOML
  from      vwWORKFLOW_RUN
 inner join WORKFLOW
         on WORKFLOW.ID      = vwWORKFLOW_RUN.WORKFLOW_ID
        and WORKFLOW.DELETED = 0
        and WORKFLOW.STATUS  = 1
 where vwWORKFLOW_RUN.STATUS = N'Ready'

GO

Grant Select on dbo.vwWORKFLOW_RUN_Ready to public;
GO

