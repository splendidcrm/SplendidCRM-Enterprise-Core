if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPRODUCTS_Edit')
	Drop View dbo.vwPRODUCTS_Edit;
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
-- 12/28/2007 Paul.  The description is now returned by the line items table. 
-- 01/02/2008 Paul.  Restore editing of items in the PRODUCTS table, but make sure that we still allow the display of order line items. 
-- 04/11/2021 Paul.  We no longer need the products view, but React client hits it in Precompile, so fix to match vwPRODUCT_List. 
Create View dbo.vwPRODUCTS_Edit
as
select *
  from vwPRODUCTS

GO

Grant Select on dbo.vwPRODUCTS_Edit to public;
GO


