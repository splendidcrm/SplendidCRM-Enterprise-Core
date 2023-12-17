if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS_RELATED_PRODUCTS')
	Drop View dbo.vwPRODUCTS_RELATED_PRODUCTS;
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
-- 07/10/2010 Paul.  Related products will only be used as product selection time. 
Create View dbo.vwPRODUCTS_RELATED_PRODUCTS
as
select PARENT_PRODUCTS.ID        as PARENT_ID
     , PARENT_PRODUCTS.NAME      as PARENT_NAME
     , vwPRODUCT_TEMPLATES.ID    as CHILD_ID
     , vwPRODUCT_TEMPLATES.NAME  as CHILD_NAME
     , vwPRODUCT_TEMPLATES.*
  from           vwPRODUCT_TEMPLATES         PARENT_PRODUCTS
      inner join PRODUCT_PRODUCT
              on PRODUCT_PRODUCT.PARENT_ID = PARENT_PRODUCTS.ID
             and PRODUCT_PRODUCT.DELETED   = 0
      inner join vwPRODUCT_TEMPLATES
              on vwPRODUCT_TEMPLATES.ID    = PRODUCT_PRODUCT.CHILD_ID

GO

Grant Select on dbo.vwPRODUCTS_RELATED_PRODUCTS to public;
GO


