if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_QuickBooks')
	Drop View dbo.vwORDERS_QuickBooks;
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
-- 05/22/2012 Paul.  Exclude invalid or duplicate names. 
-- 05/22/2012 Paul.  Reduce send errors by only including orders with matching customers and items. 
-- 02/04/2014 Paul.  We cannot filter the order on line items because we filter line items on the order. 
Create View dbo.vwORDERS_QuickBooks
as
select *
  from vwORDERS
 where ORDER_NUM is not null
   and ORDER_NUM          in (select ORDER_NUM     from vwORDERS group by ORDER_NUM having count(*) = 1)
   and BILLING_ACCOUNT_ID in (select SYNC_LOCAL_ID from vwACCOUNTS_SYNC where SYNC_SERVICE_NAME = N'QuickBooks')
--   and ID                 in (select ORDER_ID      from vwORDERS_LINE_ITEMS_QuickBooks)

GO

Grant Select on dbo.vwORDERS_QuickBooks to public;
GO


