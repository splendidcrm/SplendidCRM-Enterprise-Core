if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTAX_RATES')
	Drop View dbo.vwTAX_RATES;
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
-- 05/13/2012 Paul.  DATE_MODIFIED is needed for sync with QuickBooks. 
-- 06/02/2012 Paul.  Tax Vendor is required to create a QuickBooks tax rate. 
-- 02/24/2015 Paul.  Add state for lookup. 
-- 04/07/2016 Paul.  Tax rates per team. 
Create View dbo.vwTAX_RATES
as
select TAX_RATES.ID
     , TAX_RATES.NAME
     , TAX_RATES.STATUS
     , TAX_RATES.VALUE
     , TAX_RATES.LIST_ORDER
     , TAX_RATES.DATE_MODIFIED
     , TAX_RATES.DATE_MODIFIED_UTC
     , TAX_RATES.QUICKBOOKS_TAX_VENDOR
     , TAX_RATES.DESCRIPTION
     , TAX_RATES.ADDRESS_STATE
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
  from            TAX_RATES
  left outer join TEAMS
               on TEAMS.ID                 = TAX_RATES.TEAM_ID
              and TEAMS.DELETED            = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID             = TAX_RATES.TEAM_SET_ID
              and TEAM_SETS.DELETED        = 0
 where TAX_RATES.DELETED = 0

GO

Grant Select on dbo.vwTAX_RATES to public;
GO

 
