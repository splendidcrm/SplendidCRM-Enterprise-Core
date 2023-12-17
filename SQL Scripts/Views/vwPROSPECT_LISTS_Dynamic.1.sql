if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_Dynamic')
	Drop View dbo.vwPROSPECT_LISTS_Dynamic;
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
-- 02/22/2016 Paul.  Exclude portal users. 
-- 10/27/2017 Paul.  Add Accounts as email source. 
Create View dbo.vwPROSPECT_LISTS_Dynamic
as
select ID               as RELATED_ID
     , N'Contacts'      as RELATED_TYPE
  from CONTACTS
 where DELETED = 0
union all
select ID               as RELATED_ID
     , N'Leads'         as RELATED_TYPE
  from LEADS
 where DELETED = 0
union all
select ID               as RELATED_ID
     , N'Prospects'     as RELATED_TYPE
  from PROSPECTS
 where DELETED = 0
union all
select ID               as RELATED_ID
     , N'Users'         as RELATED_TYPE
  from USERS
 where DELETED = 0
   and PORTAL_ONLY = 0
union all
select ID               as RELATED_ID
     , N'Accounts'      as RELATED_TYPE
  from ACCOUNTS
 where DELETED = 0

GO

Grant Select on dbo.vwPROSPECT_LISTS_Dynamic to public;
GO

