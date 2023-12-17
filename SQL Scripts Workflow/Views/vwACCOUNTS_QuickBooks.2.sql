if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_QuickBooks')
	Drop View dbo.vwACCOUNTS_QuickBooks;
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
-- 05/22/2012 Paul.  Exclude invalid or duplicate names. 
-- 05/23/2012 Paul.  QuickBooks Desktop has a 41 character limit for the Name field. 
Create View dbo.vwACCOUNTS_QuickBooks
as
select *
  from vwACCOUNTS
 where NAME is not null
   and len(NAME) <= 41
   and NAME in (select NAME
                  from vwACCOUNTS
                 group by NAME
                 having count(*) = 1
               )

GO

Grant Select on dbo.vwACCOUNTS_QuickBooks to public;
GO

