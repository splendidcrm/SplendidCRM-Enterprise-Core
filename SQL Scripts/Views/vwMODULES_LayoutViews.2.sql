if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_LayoutViews')
	Drop View dbo.vwMODULES_LayoutViews;
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
-- 02/17/2011 Paul.  Need to allow ProductCategories and Discounts. 
Create View dbo.vwMODULES_LayoutViews
as
select MODULE_NAME
     , TABLE_NAME
     , RELATIVE_PATH
  from vwMODULES
 where (REPORT_ENABLED = 1 or MODULE_NAME in (N'Teams', N'ProductCategories', N'Discounts', N'Releases'))
   and MODULE_NAME not in (N'Payments')
GO

Grant Select on dbo.vwMODULES_LayoutViews to public;
GO


