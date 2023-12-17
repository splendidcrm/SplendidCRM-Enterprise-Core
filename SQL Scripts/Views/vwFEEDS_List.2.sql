if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFEEDS_List')
	Drop View dbo.vwFEEDS_List;
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
-- 01/09/2008 Paul.  Fix name of USERS_FEED_ID.  It must be singular. 
Create View dbo.vwFEEDS_List
as
select vwFEEDS.*
     , USERS_FEEDS.ID              as USERS_FEED_ID
     , USERS_FEEDS.USER_ID         as USER_ID
     , USERS_FEEDS.RANK            as RANK
  from            vwFEEDS
  left outer join USERS_FEEDS
               on USERS_FEEDS.FEED_ID  = vwFEEDS.ID
              and USERS_FEEDS.DELETED  = 0

GO

Grant Select on dbo.vwFEEDS_List to public;
GO


