if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_EXCHANGE')
	Drop View dbo.vwUSERS_EXCHANGE;
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
-- 04/04/2010 Paul.  The Watermark is needed for the Push and Pull Subscriptions. 
-- 04/28/2010 Paul.  We need the USER_ID when enabling. 
-- 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
-- 01/17/2017 Paul.  Add support for Office 365 OAuth credentials. 
Create View dbo.vwUSERS_EXCHANGE
as
select vwUSERS.ID   as USER_ID
     , vwUSERS.NAME
     , vwUSERS.FIRST_NAME
     , vwUSERS.LAST_NAME
     , vwUSERS.USER_NAME
     , vwUSERS.EMAIL1
     , EXCHANGE_USERS.ID
     , EXCHANGE_USERS.EXCHANGE_ALIAS
     , EXCHANGE_USERS.EXCHANGE_EMAIL
     , EXCHANGE_USERS.ASSIGNED_USER_ID
     , EXCHANGE_USERS.EXCHANGE_WATERMARK
     , OUTBOUND_EMAILS.MAIL_SMTPUSER
     , OUTBOUND_EMAILS.MAIL_SMTPPASS
     , (select count(*) from OAUTH_TOKENS where OAUTH_TOKENS.ASSIGNED_USER_ID = vwUSERS.ID and OAUTH_TOKENS.NAME = N'Office365' and OAUTH_TOKENS.DELETED = 0) as OFFICE365_OAUTH_ENABLED
  from            vwUSERS
  left outer join EXCHANGE_USERS
               on EXCHANGE_USERS.ASSIGNED_USER_ID = vwUSERS.ID
              and EXCHANGE_USERS.DELETED          = 0
  left outer join OUTBOUND_EMAILS
               on OUTBOUND_EMAILS.USER_ID         = vwUSERS.ID
              and OUTBOUND_EMAILS.TYPE            = N'system-override'
              and OUTBOUND_EMAILS.DELETED         = 0

GO

Grant Select on dbo.vwUSERS_EXCHANGE to public;
GO


