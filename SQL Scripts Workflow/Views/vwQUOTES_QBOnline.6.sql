if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_QBOnline')
	Drop View dbo.vwQUOTES_QBOnline;
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
-- 02/06/2015 Paul.  Exclude invalid or duplicate names. 
-- 02/06/2015 Paul.  Reduce send errors by only including quotes with matching customers and items. 
-- 02/12/2015 Paul.  Make sure quote has line items.  Let system generate an error when a line item is invalid to prevent masking the invalid data. 
-- 03/06/2015 Paul.  Add support for comment lines. 
Create View dbo.vwQUOTES_QBOnline
as
select *
  from vwQUOTES
 where QUOTE_NUM is not null
   and QUOTE_NUM in (select QUOTE_NUM     from vwQUOTES group by QUOTE_NUM having count(*) = 1)
   and exists(select * from vwQUOTES_LINE_ITEMS where QUOTE_ID = vwQUOTES.ID and (PRODUCT_TEMPLATE_ID is not null or LINE_ITEM_TYPE = 'Comment'))
   and (   BILLING_ACCOUNT_ID in (select SYNC_LOCAL_ID from vwACCOUNTS_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')
        or BILLING_ACCOUNT_ID in (select SYNC_LOCAL_ID from vwCONTACTS_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')
       )

GO

Grant Select on dbo.vwQUOTES_QBOnline to public;
GO


