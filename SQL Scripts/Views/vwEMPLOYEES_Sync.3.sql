if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMPLOYEES_Sync')
	Drop View dbo.vwEMPLOYEES_Sync;
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
-- 09/09/2019 Paul.  Employees access from the React Client. 
Create View dbo.vwEMPLOYEES_Sync
as
select ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as FULL_NAME
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as NAME
     , USER_NAME
     , FIRST_NAME
     , LAST_NAME
     , REPORTS_TO_ID
     , REPORTS_TO_NAME
     , TITLE
     , DEPARTMENT
     , PHONE_HOME
     , PHONE_MOBILE
     , PHONE_WORK
     , PHONE_OTHER
     , PHONE_FAX
     , EMAIL1
     , EMAIL2
     , STATUS
     , EMPLOYEE_STATUS
     , ADDRESS_STREET
     , ADDRESS_CITY
     , ADDRESS_STATE
     , ADDRESS_COUNTRY
     , ADDRESS_POSTALCODE
     , DATE_ENTERED
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , DESCRIPTION
     , USER_PREFERENCES
     , CREATED_BY            as CREATED_BY_ID
     , MODIFIED_USER_ID
     , DEFAULT_TEAM
     , THEME
     , DATE_FORMAT
     , TIME_FORMAT
     , LANG
     , CURRENCY_ID
     , TIMEZONE_ID
     , SAVE_QUERY
     , GROUP_TABS
     , SUBPANEL_TABS
     , EXTENSION
     , SMS_OPT_IN
     , PICTURE
     , PRIMARY_ROLE_ID    as PRIMARY_ROLE_ID
  from vwEMPLOYEES

GO

Grant Select on dbo.vwEMPLOYEES_Sync to public;
GO


