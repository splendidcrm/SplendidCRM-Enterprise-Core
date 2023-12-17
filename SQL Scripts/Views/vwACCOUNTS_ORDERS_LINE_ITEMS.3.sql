if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_ORDERS_LINE_ITEMS')
	Drop View dbo.vwACCOUNTS_ORDERS_LINE_ITEMS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_ORDERS_LINE_ITEMS
as
select vwORDERS_LINE_ITEMS.*
     , vwORDERS.ORDER_NUM
     , vwORDERS.ASSIGNED_TO
     , vwORDERS.ASSIGNED_TO_NAME
     , vwORDERS.ASSIGNED_USER_ID
     , vwORDERS.ASSIGNED_SET_ID
     , vwORDERS.ASSIGNED_SET_NAME
     , vwORDERS.ASSIGNED_SET_LIST
     , vwORDERS.TEAM_ID
     , vwORDERS.TEAM_NAME
     , vwORDERS.TEAM_SET_ID
     , vwORDERS.TEAM_SET_NAME
     , vwORDERS.BILLING_ACCOUNT_ID
     , vwORDERS.BILLING_ACCOUNT_NAME
     , vwORDERS.BILLING_ACCOUNT_ASSIGNED_ID
     , vwORDERS.BILLING_ACCOUNT_ASSIGNED_USER_ID
     , vwORDERS.BILLING_ACCOUNT_ASSIGNED_SET_ID
     , vwORDERS.BILLING_CONTACT_ID
     , vwORDERS.BILLING_CONTACT_NAME
     , vwORDERS.BILLING_CONTACT_ASSIGNED_ID
     , vwORDERS.BILLING_CONTACT_ASSIGNED_USER_ID
     , vwORDERS.BILLING_CONTACT_ASSIGNED_SET_ID
  from            vwORDERS_LINE_ITEMS
  left outer join vwORDERS
               on vwORDERS.ID        = vwORDERS_LINE_ITEMS.ORDER_ID

GO

Grant Select on dbo.vwACCOUNTS_ORDERS_LINE_ITEMS to public;
GO

