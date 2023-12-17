if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSER_PREFERENCES')
	Drop View dbo.vwUSER_PREFERENCES;
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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwUSER_PREFERENCES
as
select USER_PREFERENCES.ID
     , USER_PREFERENCES.CATEGORY
     , USER_PREFERENCES.ASSIGNED_USER_ID
     , USER_PREFERENCES.DATE_MODIFIED
     , USER_PREFERENCES.DATE_MODIFIED_UTC
     , lower(USERS.USER_NAME)             as ASSIGNED_USER_NAME
  from            USER_PREFERENCES
  left outer join USERS
               on USERS.ID = USER_PREFERENCES.ASSIGNED_USER_ID
 where USER_PREFERENCES.DELETED = 0

GO

Grant Select on dbo.vwUSER_PREFERENCES to public;
GO

