if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCT_CATALOG')
	Drop View dbo.vwPRODUCT_CATALOG;
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
-- 02/03/2009 Paul.  PRODUCT_TEMPLATES now supports TEAM_ID. 
-- 05/13/2009 Paul.  Carry forward the description from product to quote, order and invoice. 
-- 09/01/2009 Paul.  Add TEAM_SET_ID so that the team filter will not fail. 
-- 08/15/2010 Paul.  Add DISCOUNT_ID. 
-- 12/13/2013 Paul.  Allow each product to have a default tax rate. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
-- 11/30/2015 Paul.  Only show available products in list. 
-- 12/18/2015 Paul.  Published is new status for us on Portal. 
-- 01/29/2019 Paul.  Provice access to custom fields. 
-- 01/29/2019 Paul.  Add Tags module. 
Create View dbo.vwPRODUCT_CATALOG
as
select vwPRODUCT_TEMPLATES.ID
     , NAME
     , MFT_PART_NUM
     , VENDOR_PART_NUM
     , TAX_CLASS
     , TAXRATE_ID
     , WEIGHT
     , CURRENCY_ID
     , COST_PRICE
     , COST_USDOLLAR
     , LIST_PRICE
     , LIST_USDOLLAR
     , DISCOUNT_PRICE     as UNIT_PRICE
     , DISCOUNT_USDOLLAR  as UNIT_USDOLLAR
     , PRICING_FORMULA
     , cast(null as uniqueidentifier) as ASSIGNED_USER_ID
     , TEAM_ID
     , TEAM_SET_ID
     , DESCRIPTION
     , DISCOUNT_ID
     , MINIMUM_QUANTITY
     , MAXIMUM_QUANTITY
     , LIST_ORDER
     , STATUS
     , TAG_SETS.TAG_SET_NAME
     , PRODUCT_TEMPLATES_CSTM.*
  from            vwPRODUCT_TEMPLATES
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID            = vwPRODUCT_TEMPLATES.ID
              and TAG_SETS.DELETED            = 0
  left outer join PRODUCT_TEMPLATES_CSTM
               on PRODUCT_TEMPLATES_CSTM.ID_C = vwPRODUCT_TEMPLATES.ID
 where STATUS in (N'Available', N'Published')

GO

Grant Select on dbo.vwPRODUCT_CATALOG to public;
GO

