if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_RELATED_Watson')
	Drop View dbo.vwPROSPECT_LISTS_RELATED_Watson;
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
Create View dbo.vwPROSPECT_LISTS_RELATED_Watson
as
select vwPROSPECT_LISTS_RELATED.*
     , PROSPECT_LISTS_SYNC.REMOTE_KEY as SYNC_PARENT_REMOTE_KEY
  from      vwPROSPECT_LISTS_RELATED
 inner join PROSPECT_LISTS_SYNC
         on PROSPECT_LISTS_SYNC.LOCAL_ID     = vwPROSPECT_LISTS_RELATED.PROSPECT_LIST_ID
        and PROSPECT_LISTS_SYNC.SERVICE_NAME = N'Watson'
        and PROSPECT_LISTS_SYNC.DELETED      = 0
 where vwPROSPECT_LISTS_RELATED.EMAIL1 is not null

GO

Grant Select on dbo.vwPROSPECT_LISTS_RELATED_Watson to public;
GO

