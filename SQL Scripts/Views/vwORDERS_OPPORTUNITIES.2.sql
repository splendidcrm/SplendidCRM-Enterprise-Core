if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_OPPORTUNITIES')
	Drop View dbo.vwORDERS_OPPORTUNITIES;
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
Create View dbo.vwORDERS_OPPORTUNITIES
as
select ORDERS.ID                    as ORDER_ID
     , ORDERS.ASSIGNED_USER_ID      as ORDER_ASSIGNED_USER_ID
     , ORDERS.ASSIGNED_SET_ID       as ORDER_ASSIGNED_SET_ID
     , ORDERS.NAME                  as ORDER_NAME
     , vwOPPORTUNITIES.ID           as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME         as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from           ORDERS
      inner join ORDERS_OPPORTUNITIES
              on ORDERS_OPPORTUNITIES.ORDER_ID = ORDERS.ID
             and ORDERS_OPPORTUNITIES.DELETED  = 0
      inner join vwOPPORTUNITIES
              on vwOPPORTUNITIES.ID            = ORDERS_OPPORTUNITIES.OPPORTUNITY_ID
 where ORDERS.DELETED = 0

GO

Grant Select on dbo.vwORDERS_OPPORTUNITIES to public;
GO


