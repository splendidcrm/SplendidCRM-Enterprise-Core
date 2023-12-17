if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCT_CATEGORIES')
	Drop View dbo.vwPRODUCT_CATEGORIES;
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
-- 09/26/2010 Paul.  Add support for custom fields. 
-- 04/06/2019 Paul.  DATE_MODIFIED and DATE_ENTERED for detail view. 
Create View dbo.vwPRODUCT_CATEGORIES
as
select PRODUCT_CATEGORIES.ID
     , PRODUCT_CATEGORIES.NAME
     , PRODUCT_CATEGORIES.LIST_ORDER
     , PRODUCT_CATEGORIES.DESCRIPTION
     , PRODUCT_CATEGORIES.DATE_ENTERED
     , PRODUCT_CATEGORIES.DATE_MODIFIED
     , PRODUCT_CATEGORIES.DATE_MODIFIED_UTC
     , PARENT_CATEGORY.ID              as PARENT_ID
     , PARENT_CATEGORY.NAME            as PARENT_NAME
     , PRODUCT_CATEGORIES_CSTM.*
  from            PRODUCT_CATEGORIES
  left outer join PRODUCT_CATEGORIES        PARENT_CATEGORY
               on PARENT_CATEGORY.ID      = PRODUCT_CATEGORIES.PARENT_ID
              and PARENT_CATEGORY.DELETED = 0
  left outer join PRODUCT_CATEGORIES_CSTM
               on PRODUCT_CATEGORIES_CSTM.ID_C = PRODUCT_CATEGORIES.ID
 where PRODUCT_CATEGORIES.DELETED = 0

GO

Grant Select on dbo.vwPRODUCT_CATEGORIES to public;
GO

