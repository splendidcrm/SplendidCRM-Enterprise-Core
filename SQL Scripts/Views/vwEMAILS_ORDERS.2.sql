if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_ORDERS')
	Drop View dbo.vwEMAILS_ORDERS;
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
Create View dbo.vwEMAILS_ORDERS
as
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwORDERS.ID             as ORDER_ID
     , vwORDERS.NAME           as ORDER_NAME
     , vwORDERS.*
  from            EMAILS
       inner join EMAILS_ORDERS
               on EMAILS_ORDERS.EMAIL_ID = EMAILS.ID
              and EMAILS_ORDERS.DELETED  = 0
       inner join vwORDERS
               on vwORDERS.ID            = EMAILS_ORDERS.ORDER_ID
 where EMAILS.DELETED = 0
union all
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwORDERS.ID             as ORDER_ID
     , vwORDERS.NAME           as ORDER_NAME
     , vwORDERS.*
  from            EMAILS
       inner join vwORDERS
               on vwORDERS.ID            = EMAILS.PARENT_ID
  left outer join EMAILS_ORDERS
               on EMAILS_ORDERS.EMAIL_ID = EMAILS.ID
              and EMAILS_ORDERS.ORDER_ID = vwORDERS.ID
              and EMAILS_ORDERS.DELETED  = 0
 where EMAILS.DELETED     = 0
   and EMAILS.PARENT_TYPE = N'Orders'
   and EMAILS_ORDERS.ID is null

GO

Grant Select on dbo.vwEMAILS_ORDERS to public;
GO

