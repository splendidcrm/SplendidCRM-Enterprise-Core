if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONFIG_List')
	Drop View dbo.vwCONFIG_List;
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
-- 09/28/2008 Paul.  max_users is a protected config value that cannot be edited by an admin. 
-- 01/19/2013 Paul.  This view is not using on Surface RT. 
Create View dbo.vwCONFIG_List
as
select ID
     , NAME
     , VALUE
     , CATEGORY
     , DATE_MODIFIED
     , isnull(CATEGORY, N'') + N'_' + NAME as CATEGORY_NAME
  from CONFIG
 where DELETED = 0
   and NAME not in (N'max_users')

GO

Grant Select on dbo.vwCONFIG_List to public;
GO

