if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_DATA_PRIVACY')
	Drop View dbo.vwACCOUNTS_DATA_PRIVACY;
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
Create View dbo.vwACCOUNTS_DATA_PRIVACY
as
select ACCOUNTS.ID               as ACCOUNT_ID
     , ACCOUNTS.NAME             as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID  as ACCOUNT_ASSIGNED_SET_ID
     , vwDATA_PRIVACY.ID         as DATA_PRIVACY_ID
     , vwDATA_PRIVACY.NAME       as DATA_PRIVACY_NAME
     , vwDATA_PRIVACY.*
  from           ACCOUNTS
      inner join ACCOUNTS_DATA_PRIVACY
              on ACCOUNTS_DATA_PRIVACY.ACCOUNT_ID = ACCOUNTS.ID
             and ACCOUNTS_DATA_PRIVACY.DELETED    = 0
      inner join vwDATA_PRIVACY
              on vwDATA_PRIVACY.ID                = ACCOUNTS_DATA_PRIVACY.DATA_PRIVACY_ID
 where ACCOUNTS.DELETED = 0

GO

Grant Select on dbo.vwACCOUNTS_DATA_PRIVACY to public;
GO

