if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECTS_SYNC')
	Drop View dbo.vwPROSPECTS_SYNC;
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
Create View dbo.vwPROSPECTS_SYNC
as
select PROSPECTS_SYNC.ID                        as SYNC_ID
     , PROSPECTS_SYNC.ASSIGNED_USER_ID          as SYNC_ASSIGNED_USER_ID
     , PROSPECTS_SYNC.LOCAL_ID                  as SYNC_LOCAL_ID
     , PROSPECTS_SYNC.LOCAL_DATE_MODIFIED       as SYNC_LOCAL_DATE_MODIFIED
     , PROSPECTS_SYNC.REMOTE_DATE_MODIFIED      as SYNC_REMOTE_DATE_MODIFIED
     , PROSPECTS_SYNC.LOCAL_DATE_MODIFIED_UTC   as SYNC_LOCAL_DATE_MODIFIED_UTC
     , PROSPECTS_SYNC.REMOTE_DATE_MODIFIED_UTC  as SYNC_REMOTE_DATE_MODIFIED_UTC
     , PROSPECTS_SYNC.REMOTE_KEY                as SYNC_REMOTE_KEY
     , PROSPECTS_SYNC.SERVICE_NAME              as SYNC_SERVICE_NAME
     , PROSPECTS_SYNC.RAW_CONTENT               as SYNC_RAW_CONTENT
     , 0                                        as SYNC_PROSPECT
     , vwPROSPECTS.ID
     , vwPROSPECTS.DATE_MODIFIED
     , vwPROSPECTS.DATE_MODIFIED_UTC
  from            PROSPECTS_SYNC
  left outer join vwPROSPECTS
               on vwPROSPECTS.ID      = PROSPECTS_SYNC.LOCAL_ID
 where PROSPECTS_SYNC.DELETED = 0

GO

Grant Select on dbo.vwPROSPECTS_SYNC to public;
GO


