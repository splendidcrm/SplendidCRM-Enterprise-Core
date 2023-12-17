if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_LINE_ITEMS_QuickBooks')
	Drop View dbo.vwORDERS_LINE_ITEMS_QuickBooks;
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
-- 05/22/2012 Paul.  Reduce send errors by only including line items with matching items. 
-- 02/04/2014 Paul.  The Order will not exist in the sync table when this is called during insert. 
Create View dbo.vwORDERS_LINE_ITEMS_QuickBooks
as
select vwORDERS_LINE_ITEMS.*
     , vwORDERS.ORDER_NUM
  from      vwORDERS_LINE_ITEMS
 inner join vwORDERS
         on vwORDERS.ID = vwORDERS_LINE_ITEMS.ORDER_ID
 where vwORDERS_LINE_ITEMS.MFT_PART_NUM is not null
   and PRODUCT_TEMPLATE_ID in (select SYNC_LOCAL_ID from vwPRODUCT_TEMPLATES_SYNC where SYNC_SERVICE_NAME = N'QuickBooks')
--   and ORDER_ID            in (select SYNC_LOCAL_ID from vwORDERS_SYNC            where SYNC_SERVICE_NAME = N'QuickBooks')

GO

Grant Select on dbo.vwORDERS_LINE_ITEMS_QuickBooks to public;
GO


