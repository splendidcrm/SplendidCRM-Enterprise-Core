if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwBUGS_SYNC_ACTIVITY')
	Drop View dbo.vwBUGS_SYNC_ACTIVITY;
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
Create View dbo.vwBUGS_SYNC_ACTIVITY
as
select BUGS.ID
     , BUGS_USERS.USER_ID
  from            BUGS
       inner join BUGS_USERS
               on BUGS_USERS.BUG_ID                 = BUGS.ID
              and BUGS_USERS.DELETED                = 0
       inner join USERS
               on USERS.ID                          = BUGS_USERS.USER_ID
              and USERS.DELETED                     = 0
       inner join vwEXCHANGE_USERS
               on vwEXCHANGE_USERS.ASSIGNED_USER_ID = BUGS_USERS.USER_ID
 where BUGS.DELETED = 0

GO

Grant Select on dbo.vwBUGS_SYNC_ACTIVITY to public;
GO


