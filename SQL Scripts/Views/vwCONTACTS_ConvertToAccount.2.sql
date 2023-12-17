if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_ConvertToAccount')
	Drop View dbo.vwCONTACTS_ConvertToAccount;
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
-- 02/04/2020 Paul.  Add Tags module. 
Create View dbo.vwCONTACTS_ConvertToAccount
as
select ID                             as CONTACT_ID
     , NAME                           as CONTACT_NAME
     , ID
     , SALUTATION
     , NAME
     , FIRST_NAME
     , LAST_NAME
     , LEAD_SOURCE
     , TITLE
     , DEPARTMENT
     , REPORTS_TO_ID
     , REPORTS_TO_NAME
     , BIRTHDATE
     , DO_NOT_CALL
     , PHONE_HOME
     , PHONE_MOBILE
     , PHONE_WORK                     as PHONE_OFFICE
     , PHONE_OTHER                    as PHONE_ALTERNATE
     , PHONE_FAX
     , EMAIL1
     , EMAIL2
     , ASSISTANT
     , ASSISTANT_PHONE
     , EMAIL_OPT_OUT
     , INVALID_EMAIL
     , PRIMARY_ADDRESS_STREET         as BILLING_ADDRESS_STREET
     , PRIMARY_ADDRESS_CITY           as BILLING_ADDRESS_CITY
     , PRIMARY_ADDRESS_STATE          as BILLING_ADDRESS_STATE
     , PRIMARY_ADDRESS_POSTALCODE     as BILLING_ADDRESS_POSTALCODE
     , PRIMARY_ADDRESS_COUNTRY        as BILLING_ADDRESS_COUNTRY
     , ALT_ADDRESS_STREET             as SHIPPING_ADDRESS_STREET
     , ALT_ADDRESS_CITY               as SHIPPING_ADDRESS_CITY
     , ALT_ADDRESS_STATE              as SHIPPING_ADDRESS_STATE
     , ALT_ADDRESS_POSTALCODE         as SHIPPING_ADDRESS_POSTALCODE
     , ALT_ADDRESS_COUNTRY            as SHIPPING_ADDRESS_COUNTRY
     , PORTAL_NAME
     , PORTAL_ACTIVE
     , PORTAL_APP
     , ASSIGNED_USER_ID
     , DATE_ENTERED
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , DESCRIPTION
     , TEAM_ID
     , TEAM_NAME
     , ASSIGNED_TO
     , CREATED_BY
     , MODIFIED_BY
     , CREATED_BY_ID
     , MODIFIED_USER_ID
     , TEAM_SET_ID
     , TEAM_SET_NAME
     , null                           as ACCOUNT_TYPE
     , cast(null as uniqueidentifier) as PARENT_ID
     , null                           as INDUSTRY
     , null                           as ANNUAL_REVENUE
     , null                           as RATING
     , null                           as WEBSITE
     , null                           as OWNERSHIP
     , null                           as EMPLOYEES
     , null                           as SIC_CODE
     , null                           as TICKER_SYMBOL
     , ASSIGNED_SET_ID
     , ASSIGNED_SET_NAME
     , ASSIGNED_SET_LIST
     , TAG_SET_NAME
  from vwCONTACTS

GO

Grant Select on dbo.vwCONTACTS_ConvertToAccount to public;
GO

 
