if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSOAP_Contact_By_Email')
	Drop View dbo.vwSOAP_Contact_By_Email;
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
-- 05/02/2006 Paul.  ASSIGNED_USER_ID is needed for ACL. 
Create View dbo.vwSOAP_Contact_By_Email
as
select ID                     as ID
     , FIRST_NAME             as NAME1
     , LAST_NAME              as NAME2
     , ACCOUNT_NAME           as ASSOCIATION
     , N'Lead'                as TYPE
     , EMAIL1                 as EMAIL_ADDRESS
     , EMAIL1                 as EMAIL1
     , EMAIL2                 as EMAIL2
     , vwLEADS.ASSIGNED_USER_ID       as ASSIGNED_USER_ID
  from vwLEADS
union all
select ID                     as ID
     , FIRST_NAME             as NAME1
     , LAST_NAME              as NAME2
     , ACCOUNT_NAME           as ASSOCIATION
     , N'Contact'             as TYPE
     , EMAIL1                 as EMAIL_ADDRESS
     , EMAIL1                 as EMAIL1
     , EMAIL2                 as EMAIL2
     , vwCONTACTS.ASSIGNED_USER_ID       as ASSIGNED_USER_ID
  from vwCONTACTS
union all
select vwACCOUNTS.ID          as ID
     , N''                    as NAME1
     , vwACCOUNTS.NAME        as NAME2
     , BILLING_ADDRESS_CITY   as ASSOCIATION
     , N'Account'             as TYPE
     , vwACCOUNTS.EMAIL1      as EMAIL_ADDRESS
     , CONTACTS.EMAIL1        as EMAIL1
     , CONTACTS.EMAIL2        as EMAIL2
     , vwACCOUNTS.ASSIGNED_USER_ID       as ASSIGNED_USER_ID
  from           vwACCOUNTS
      inner join ACCOUNTS_CONTACTS
              on ACCOUNTS_CONTACTS.ACCOUNT_ID = vwACCOUNTS.ID
             and ACCOUNTS_CONTACTS.DELETED    = 0
      inner join CONTACTS
              on CONTACTS.ID                  = ACCOUNTS_CONTACTS.CONTACT_ID
             and CONTACTS.DELETED             = 0
union all
select vwOPPORTUNITIES.ID     as ID
     , N''                    as NAME1
     , vwOPPORTUNITIES.NAME   as NAME2
     , ACCOUNT_NAME           as ASSOCIATION
     , N'Opportunity'         as TYPE
     , N''                    as EMAIL_ADDRESS
     , CONTACTS.EMAIL1        as EMAIL1
     , CONTACTS.EMAIL2        as EMAIL2
     , vwOPPORTUNITIES.ASSIGNED_USER_ID       as ASSIGNED_USER_ID
  from           vwOPPORTUNITIES
      inner join OPPORTUNITIES_CONTACTS
              on OPPORTUNITIES_CONTACTS.OPPORTUNITY_ID = vwOPPORTUNITIES.ID
             and OPPORTUNITIES_CONTACTS.DELETED        = 0
      inner join CONTACTS
              on CONTACTS.ID                           = OPPORTUNITIES_CONTACTS.CONTACT_ID
             and CONTACTS.DELETED                      = 0
union all
select vwCASES.ID             as ID
     , N''                    as NAME1
     , vwCASES.NAME           as NAME2
     , ACCOUNT_NAME           as ASSOCIATION
     , N'Case'                as TYPE
     , N''                    as EMAIL_ADDRESS
     , CONTACTS.EMAIL1        as EMAIL1
     , CONTACTS.EMAIL2        as EMAIL2
     , vwCASES.ASSIGNED_USER_ID       as ASSIGNED_USER_ID
  from           vwCASES
      inner join CONTACTS_CASES
              on CONTACTS_CASES.CASE_ID = vwCASES.ID
             and CONTACTS_CASES.DELETED = 0
      inner join CONTACTS
              on CONTACTS.ID            = CONTACTS_CASES.CONTACT_ID
             and CONTACTS.DELETED       = 0

GO

Grant Select on dbo.vwSOAP_Contact_By_Email to public;
GO


