if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTERMINOLOGY_LayoutLabel')
	Drop View dbo.vwTERMINOLOGY_LayoutLabel;
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
-- 12/05/2006 Paul.  Literals should be in unicode to reduce conversions at runtime. 
Create View dbo.vwTERMINOLOGY_LayoutLabel
as
select distinct
       MODULE_NAME
     , dbo.fnTermName(MODULE_NAME, LIST_NAME, NAME) as NAME
     , dbo.fnTermName(MODULE_NAME, LIST_NAME, NAME) as DISPLAY_NAME
  from vwTERMINOLOGY
 where LANG = N'en-US'
   and LIST_NAME is null

GO

Grant Select on dbo.vwTERMINOLOGY_LayoutLabel to public;
GO


