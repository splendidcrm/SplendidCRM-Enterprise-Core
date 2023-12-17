if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_LINE_ITEMS_QBOnline')
	Drop View dbo.vwQUOTES_LINE_ITEMS_QBOnline;
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
-- 05/22/2012 Paul.  Reduce send errors by only including line items with matching items. 
-- 02/04/2014 Paul.  The Quote will not exist in the sync table when this is called during insert. 
-- 03/06/2015 Paul.  Add support for comment lines. 
Create View dbo.vwQUOTES_LINE_ITEMS_QBOnline
as
select vwQUOTES_LINE_ITEMS.*
     , vwQUOTES.QUOTE_NUM
  from      vwQUOTES_LINE_ITEMS
 inner join vwQUOTES
         on vwQUOTES.ID = vwQUOTES_LINE_ITEMS.QUOTE_ID
 where PRODUCT_TEMPLATE_ID in (select SYNC_LOCAL_ID from vwPRODUCT_TEMPLATES_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')
    or LINE_ITEM_TYPE = 'Comment'
GO

Grant Select on dbo.vwQUOTES_LINE_ITEMS_QBOnline to public;
GO


