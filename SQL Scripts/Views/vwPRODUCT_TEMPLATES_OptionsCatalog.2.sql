if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCT_TEMPLATES_OptionsCatalog')
	Drop View dbo.vwPRODUCT_TEMPLATES_OptionsCatalog;
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
-- 11/30/2015 Paul.  Only show available products in list. 
-- 05/29/2016 Paul.  Include published items. 
Create View dbo.vwPRODUCT_TEMPLATES_OptionsCatalog
as
select vwPRODUCT_TEMPLATES.*
     , cast(null as uniqueidentifier) as PARENT_ID
     , NAME + N' ' + cast(ID as char(36))    as NAME_SORT
  from vwPRODUCT_TEMPLATES
  where STATUS in (N'Available', N'Published')
 union all
select vwPRODUCT_TEMPLATES.*
     , PARENT_PRODUCTS.ID             as PARENT_ID
     , PARENT_PRODUCTS.NAME + N' ' + cast(PRODUCT_PRODUCT.PARENT_ID as char(36)) + N' ' + vwPRODUCT_TEMPLATES.NAME as NAME_SORT
  from           vwPRODUCT_TEMPLATES         PARENT_PRODUCTS
      inner join PRODUCT_PRODUCT
              on PRODUCT_PRODUCT.PARENT_ID = PARENT_PRODUCTS.ID
             and PRODUCT_PRODUCT.DELETED   = 0
      inner join vwPRODUCT_TEMPLATES
              on vwPRODUCT_TEMPLATES.ID    = PRODUCT_PRODUCT.CHILD_ID
             and vwPRODUCT_TEMPLATES.STATUS in (N'Available', N'Published')
 where PARENT_PRODUCTS.STATUS in (N'Available', N'Published')

GO

Grant Select on dbo.vwPRODUCT_TEMPLATES_OptionsCatalog to public;
GO


