if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOW_TRIGGER_SHELLS')
	Drop View dbo.vwWORKFLOW_TRIGGER_SHELLS;
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
-- 04/15/2021 Paul.  React client treats this as a relationship table with Workflows, so it needs a Workflow ID. 
-- 11/05/2023 Paul.  React requires DATE_MODIFIED. 
Create View dbo.vwWORKFLOW_TRIGGER_SHELLS
as
select ID
     , ID              as WORKFLOW_TRIGGER_SHELL_ID
     , DATE_ENTERED
     , DATE_MODIFIED
     , PARENT_ID
     , PARENT_ID       as WORKFLOW_ID
     , FIELD
     , TYPE
     , FRAME_TYPE
     , EVAL
     , SHOW_PAST
     , REL_MODULE
     , REL_MODULE_TYPE
     , PARAMETERS
     , PARAMETERS      as VALUE
     , TYPE            as DESCRIPTION
  from WORKFLOW_TRIGGER_SHELLS
 where DELETED = 0

GO

Grant Select on dbo.vwWORKFLOW_TRIGGER_SHELLS to public;
GO

