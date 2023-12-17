if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOWS')
	Drop View dbo.vwWORKFLOWS;
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
-- 11/16/2008 Paul.  Add support for type-based workflows. 
-- 03/10/2009 Paul.  We need DATE_MODIFIED for the concurrency check. 
-- 05/23/2009 Paul.  We need AUDIT_TABLE to properly export the workflow. 
Create View dbo.vwWORKFLOWS
as
select ID
     , NAME
     , BASE_MODULE
     , AUDIT_TABLE
     , STATUS
     , TYPE
     , FIRE_ORDER
     , PARENT_ID
     , RECORD_TYPE
     , LIST_ORDER_Y
     , CUSTOM_XOML
     , FILTER_SQL
     , JOB_INTERVAL
     , LAST_RUN
     , DATE_MODIFIED
  from WORKFLOW
 where DELETED = 0

GO

Grant Select on dbo.vwWORKFLOWS to public;
GO

