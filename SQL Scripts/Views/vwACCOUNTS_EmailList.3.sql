if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_EmailList')
	Drop View dbo.vwACCOUNTS_EmailList;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_EmailList
as
select ID
     , NAME
     , cast(null as nvarchar(100)) as FIRST_NAME
     , NAME                        as LAST_NAME
     , cast(null as nvarchar(50))  as TITLE
     , NAME                        as ACCOUNT_NAME
     , ID                          as ACCOUNT_ID
     , cast(null as nvarchar(25))  as PHONE_HOME
     , PHONE_ALTERNATE             as PHONE_MOBILE
     , PHONE_OFFICE                as PHONE_WORK
     , cast(null as nvarchar(25))  as PHONE_OTHER
     , PHONE_FAX                   as PHONE_FAX
     , EMAIL1
     , EMAIL2
     , cast(null as nvarchar(75))  as ASSISTANT
     , cast(null as nvarchar(25))  as ASSISTANT_PHONE
     , ASSIGNED_TO
     , ASSIGNED_USER_ID
     , TEAM_ID
     , TEAM_NAME
     , TEAM_SET_ID
     , TEAM_SET_NAME
     , ASSIGNED_SET_ID
     , ASSIGNED_SET_NAME
     , ASSIGNED_SET_LIST
  from vwACCOUNTS_List
 where EMAIL1 is not null

GO

Grant Select on dbo.vwACCOUNTS_EmailList to public;
GO


