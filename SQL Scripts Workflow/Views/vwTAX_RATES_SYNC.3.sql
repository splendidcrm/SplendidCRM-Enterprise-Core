if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTAX_RATES_SYNC')
	Drop View dbo.vwTAX_RATES_SYNC;
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
-- 02/26/2015 Paul.  We need to use QUICKBOOKS_TAX_VENDOR when setting the TaxCodeTaxRate. 
Create View dbo.vwTAX_RATES_SYNC
as
select TAX_RATES_SYNC.ID                        as SYNC_ID
     , TAX_RATES_SYNC.ASSIGNED_USER_ID          as SYNC_ASSIGNED_USER_ID
     , TAX_RATES_SYNC.LOCAL_ID                  as SYNC_LOCAL_ID
     , TAX_RATES_SYNC.LOCAL_DATE_MODIFIED       as SYNC_LOCAL_DATE_MODIFIED
     , TAX_RATES_SYNC.REMOTE_DATE_MODIFIED      as SYNC_REMOTE_DATE_MODIFIED
     , TAX_RATES_SYNC.LOCAL_DATE_MODIFIED_UTC   as SYNC_LOCAL_DATE_MODIFIED_UTC
     , TAX_RATES_SYNC.REMOTE_DATE_MODIFIED_UTC  as SYNC_REMOTE_DATE_MODIFIED_UTC
     , TAX_RATES_SYNC.REMOTE_KEY                as SYNC_REMOTE_KEY
     , TAX_RATES_SYNC.SERVICE_NAME              as SYNC_SERVICE_NAME
     , TAX_RATES_SYNC.RAW_CONTENT               as SYNC_RAW_CONTENT
     , vwTAX_RATES.ID
     , vwTAX_RATES.DATE_MODIFIED
     , vwTAX_RATES.DATE_MODIFIED_UTC
     , vwTAX_RATES.QUICKBOOKS_TAX_VENDOR
  from            TAX_RATES_SYNC
  left outer join vwTAX_RATES
               on vwTAX_RATES.ID      = TAX_RATES_SYNC.LOCAL_ID
 where TAX_RATES_SYNC.DELETED = 0

GO

Grant Select on dbo.vwTAX_RATES_SYNC to public;
GO


