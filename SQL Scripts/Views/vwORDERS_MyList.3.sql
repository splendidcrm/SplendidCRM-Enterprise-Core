if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_MyList')
	Drop View dbo.vwORDERS_MyList;
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
-- 11/04/2010 Paul.  Only show orders that are pending, or was cancelled in the last month. 
-- 04/05/2013 Paul.  Include Ordered so that it will show on the portal. 
-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
Create View dbo.vwORDERS_MyList
as
select *
  from vwORDERS_List
 where  ORDER_STAGE is null
    or  ORDER_STAGE in (N'On Hold', N'Pending', N'Ordered', N'Shipped', N'Confirmed', N'Pending Signature')
    or (ORDER_STAGE in (N'Cancelled', N'Refunded') and dbo.fnDateAdd('month', 1, DATE_MODIFIED) > getdate())

GO

Grant Select on dbo.vwORDERS_MyList to public;
GO

