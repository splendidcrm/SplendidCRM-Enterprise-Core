if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDATA_PRIVACY_ACCOUNTS')
	Drop View dbo.vwDATA_PRIVACY_ACCOUNTS;
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
Create View dbo.vwDATA_PRIVACY_ACCOUNTS
as
select DATA_PRIVACY.ID               as DATA_PRIVACY_ID
     , DATA_PRIVACY.NAME             as DATA_PRIVACY_NAME
     , DATA_PRIVACY.ASSIGNED_USER_ID as DATA_PRIVACY_ASSIGNED_USER_ID
     , DATA_PRIVACY.ASSIGNED_SET_ID  as DATA_PRIVACY_ASSIGNED_SET_ID
     , vwACCOUNTS.ID                 as ACCOUNT_ID
     , vwACCOUNTS.NAME               as ACCOUNT_NAME
     , vwACCOUNTS.*
  from            DATA_PRIVACY
       inner join ACCOUNTS_DATA_PRIVACY
               on ACCOUNTS_DATA_PRIVACY.DATA_PRIVACY_ID = DATA_PRIVACY.ID
              and ACCOUNTS_DATA_PRIVACY.DELETED         = 0
       inner join vwACCOUNTS
               on vwACCOUNTS.ID                         = ACCOUNTS_DATA_PRIVACY.ACCOUNT_ID
 where DATA_PRIVACY.DELETED = 0

GO

Grant Select on dbo.vwDATA_PRIVACY_ACCOUNTS to public;
GO

