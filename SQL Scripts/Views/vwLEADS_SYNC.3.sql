if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_SYNC')
	Drop View dbo.vwLEADS_SYNC;
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
Create View dbo.vwLEADS_SYNC
as
select LEADS_SYNC.ID                        as SYNC_ID
     , LEADS_SYNC.ASSIGNED_USER_ID          as SYNC_ASSIGNED_USER_ID
     , LEADS_SYNC.LOCAL_ID                  as SYNC_LOCAL_ID
     , LEADS_SYNC.LOCAL_DATE_MODIFIED       as SYNC_LOCAL_DATE_MODIFIED
     , LEADS_SYNC.REMOTE_DATE_MODIFIED      as SYNC_REMOTE_DATE_MODIFIED
     , LEADS_SYNC.LOCAL_DATE_MODIFIED_UTC   as SYNC_LOCAL_DATE_MODIFIED_UTC
     , LEADS_SYNC.REMOTE_DATE_MODIFIED_UTC  as SYNC_REMOTE_DATE_MODIFIED_UTC
     , LEADS_SYNC.REMOTE_KEY                as SYNC_REMOTE_KEY
     , LEADS_SYNC.SERVICE_NAME              as SYNC_SERVICE_NAME
     , LEADS_SYNC.RAW_CONTENT               as SYNC_RAW_CONTENT
     , (case when vwLEADS_USERS.LEAD_ID is null then 0 else 1 end) as SYNC_LEAD
     , vwLEADS.ID
     , vwLEADS.DATE_MODIFIED
     , vwLEADS.DATE_MODIFIED_UTC
  from            LEADS_SYNC
  left outer join vwLEADS
               on vwLEADS.ID      = LEADS_SYNC.LOCAL_ID
  left outer join vwLEADS_USERS                                
               on vwLEADS_USERS.LEAD_ID = vwLEADS.ID
              and vwLEADS_USERS.USER_ID    = LEADS_SYNC.ASSIGNED_USER_ID
 where LEADS_SYNC.DELETED = 0

GO

Grant Select on dbo.vwLEADS_SYNC to public;
GO


