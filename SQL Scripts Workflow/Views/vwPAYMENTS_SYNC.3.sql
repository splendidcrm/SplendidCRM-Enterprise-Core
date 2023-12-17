if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPAYMENTS_SYNC')
	Drop View dbo.vwPAYMENTS_SYNC;
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
-- 02/22/2015 Paul.  Include zero amount in case a payment comes from QuickBooks that way. 
Create View dbo.vwPAYMENTS_SYNC
as
select PAYMENTS_SYNC.ID                        as SYNC_ID
     , PAYMENTS_SYNC.ASSIGNED_USER_ID          as SYNC_ASSIGNED_USER_ID
     , PAYMENTS_SYNC.LOCAL_ID                  as SYNC_LOCAL_ID
     , PAYMENTS_SYNC.LOCAL_DATE_MODIFIED       as SYNC_LOCAL_DATE_MODIFIED
     , PAYMENTS_SYNC.REMOTE_DATE_MODIFIED      as SYNC_REMOTE_DATE_MODIFIED
     , PAYMENTS_SYNC.LOCAL_DATE_MODIFIED_UTC   as SYNC_LOCAL_DATE_MODIFIED_UTC
     , PAYMENTS_SYNC.REMOTE_DATE_MODIFIED_UTC  as SYNC_REMOTE_DATE_MODIFIED_UTC
     , PAYMENTS_SYNC.REMOTE_KEY                as SYNC_REMOTE_KEY
     , PAYMENTS_SYNC.SERVICE_NAME              as SYNC_SERVICE_NAME
     , PAYMENTS_SYNC.RAW_CONTENT               as SYNC_RAW_CONTENT
     , vwPAYMENTS.NAME                         as SYNC_NAME
     , vwPAYMENTS.ID
     , vwPAYMENTS.DATE_MODIFIED
     , vwPAYMENTS.DATE_MODIFIED_UTC
  from            PAYMENTS_SYNC
  left outer join vwPAYMENTS
               on vwPAYMENTS.ID      = PAYMENTS_SYNC.LOCAL_ID
 where PAYMENTS_SYNC.DELETED = 0
   and AMOUNT_USDOLLAR >= 0.0

GO

Grant Select on dbo.vwPAYMENTS_SYNC to public;
GO


