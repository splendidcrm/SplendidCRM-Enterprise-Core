if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWF4_INSTANCE_EVENTS')
	Drop View dbo.vwWF4_INSTANCE_EVENTS;
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
-- 08/30/2016 Paul.  Microsoft provides EVENT_TIME as UTC and that is what we store.  But we need to return local time. 
Create View dbo.vwWF4_INSTANCE_EVENTS
as
select INSTANCE_ID
     , dbo.fnDateUtcToLocal(EVENT_TIME) as EVENT_TIME
     , 'Instance'             as EVENT_TYPE
     , RECORD_NUMBER
     , STATE
     , null                   as ACTIVITY
     , null                   as ACTIVITY_NAME
     , null                   as DESCRIPTION
  from WF4_TRACKING_WORKFLOW_INSTANCE
union all
select INSTANCE_ID
     , dbo.fnDateUtcToLocal(EVENT_TIME) as EVENT_TIME
     , 'State'                as EVENT_TYPE
     , RECORD_NUMBER
     , STATE
     , ACTIVITY
     , ACTIVITY_NAME
     , ACTIVITY_TYPE_NAME     as DESCRIPTION
  from WF4_TRACKING_ACTIVITY_STATE
union all
select INSTANCE_ID
     , dbo.fnDateUtcToLocal(EVENT_TIME) as EVENT_TIME
     , 'Schedule'             as EVENT_TYPE
     , RECORD_NUMBER
     , null                   as STATE
     , ACTIVITY
     , ACTIVITY_NAME
     , null                   as DESCRIPTION
  from WF4_TRACKING_ACTIVITY_SCHEDULE
union all
select INSTANCE_ID
     , dbo.fnDateUtcToLocal(EVENT_TIME) as EVENT_TIME
     , N'Fault'               as EVENT_TYPE
     , RECORD_NUMBER
     , N'Faulted'             as STATE
     , FAULT_SOURCE           as ACTIVITY
     , FAULT_SOURCE_NAME      as ACTIVITY_NAME
     , FAULT                  as DESCRIPTION
  from WF4_TRACKING_FAULT_PROPAGATION
union all
select INSTANCE_ID
     , dbo.fnDateUtcToLocal(EVENT_TIME) as EVENT_TIME
     , N'Bookmarks'           as EVENT_TYPE
     , RECORD_NUMBER
     , null                   as STATE
     , ACTIVITY_OWNER
     , ACTIVITY_OWNER_NAME
     , BOOKMARK_NAME          as DESCRIPTION
  from WF4_TRACKING_BOOKMARKS

GO

Grant Select on dbo.vwWF4_INSTANCE_EVENTS to public;
GO

