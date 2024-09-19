if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCREDIT_CARDS')
	Drop View dbo.vwCREDIT_CARDS;
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
-- 02/25/2008 Paul.  Use the ASSIGNED_USER_ID of the ACCOUNT. 
-- 03/12/2008 Paul.  Some customers may want a simplified mm/yy entry format. 
-- 03/10/2009 Paul.  Include custom table so that custom fields can be added. 
-- 09/01/2009 Paul.  Add TEAM_SET_ID so that the team filter will not fail. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/07/2010 Paul.  Add Contact field. 
-- 05/01/2013 Paul.  Outer join to ACCOUNTS to support B2C. 
-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 05/24/2024 Paul.  DATE_MODIFIED_UTC is needed by React Client. 
Create View dbo.vwCREDIT_CARDS
as
select CREDIT_CARDS.ID
     , CREDIT_CARDS.NAME
     , CREDIT_CARDS.CARD_TYPE
     , CREDIT_CARDS.CARD_NUMBER_DISPLAY
     , CREDIT_CARDS.SECURITY_CODE
     , CREDIT_CARDS.EXPIRATION_DATE
     , month(CREDIT_CARDS.EXPIRATION_DATE) as EXPIRATION_MONTH
     , year(CREDIT_CARDS.EXPIRATION_DATE ) as EXPIRATION_YEAR
     , CREDIT_CARDS.BANK_NAME
     , CREDIT_CARDS.BANK_ROUTING_NUMBER
     , CREDIT_CARDS.IS_PRIMARY
     , CREDIT_CARDS.IS_ENCRYPTED
     , CREDIT_CARDS.ADDRESS_STREET
     , CREDIT_CARDS.ADDRESS_CITY
     , CREDIT_CARDS.ADDRESS_STATE
     , CREDIT_CARDS.ADDRESS_POSTALCODE
     , CREDIT_CARDS.ADDRESS_COUNTRY
     , CREDIT_CARDS.EMAIL
     , CREDIT_CARDS.PHONE
     , CREDIT_CARDS.DATE_ENTERED
     , CREDIT_CARDS.DATE_MODIFIED
     , CREDIT_CARDS.DATE_MODIFIED_UTC
     , ACCOUNTS.ID                    as ACCOUNT_ID
     , ACCOUNTS.NAME                  as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID      as ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID       as ASSIGNED_SET_ID
     , CONTACTS.ID                    as CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , CONTACTS.ASSIGNED_USER_ID      as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID       as CONTACT_ASSIGNED_SET_ID
     , USERS_ASSIGNED.USER_NAME       as ASSIGNED_TO
     , cast(null as uniqueidentifier) as TEAM_ID
     , cast(null as nvarchar(128))    as TEAM_NAME
     , cast(null as uniqueidentifier) as TEAM_SET_ID
     , cast(null as nvarchar(200))    as TEAM_SET_NAME
     , USERS_CREATED_BY.USER_NAME     as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME    as MODIFIED_BY
     , CREDIT_CARDS.CREATED_BY        as CREATED_BY_ID
     , CREDIT_CARDS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , CREDIT_CARDS_CSTM.*
  from            CREDIT_CARDS
  left outer join ACCOUNTS
               on ACCOUNTS.ID              = CREDIT_CARDS.ACCOUNT_ID
              and ACCOUNTS.DELETED         = 0
  left outer join CONTACTS
               on CONTACTS.ID              = CREDIT_CARDS.CONTACT_ID
              and CONTACTS.DELETED         = 0
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = ACCOUNTS.ASSIGNED_USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = CREDIT_CARDS.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = CREDIT_CARDS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID         = ACCOUNTS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED    = 0
  left outer join CREDIT_CARDS_CSTM
               on CREDIT_CARDS_CSTM.ID_C   = CREDIT_CARDS.ID
 where CREDIT_CARDS.DELETED = 0

GO

Grant Select on dbo.vwCREDIT_CARDS to public;
GO


