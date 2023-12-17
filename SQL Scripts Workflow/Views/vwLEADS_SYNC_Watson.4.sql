if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_SYNC_Watson')
	Drop View dbo.vwLEADS_SYNC_Watson;
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
Create View dbo.vwLEADS_SYNC_Watson
as
select vwLEADS.*
     , vwPROSPECT_LISTS_RELATED_SYNC.PROSPECT_LIST_ID
     , vwPROSPECT_LISTS_RELATED_SYNC.SYNC_REMOTE_KEY
     , vwPROSPECT_LISTS_RELATED_SYNC.SYNC_REMOTE_DATE_MODIFIED
  from      vwLEADS
 inner join vwPROSPECT_LISTS_RELATED_SYNC
         on vwPROSPECT_LISTS_RELATED_SYNC.RELATED_ID   = vwLEADS.ID
        and vwPROSPECT_LISTS_RELATED_SYNC.RELATED_TYPE = N'Leads'
 where SYNC_SERVICE_NAME = N'Watson'
GO

Grant Select on dbo.vwLEADS_SYNC_Watson to public;
GO

