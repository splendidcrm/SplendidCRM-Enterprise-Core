if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINBOUND_EMAILS_Monitored')
	Drop View dbo.vwINBOUND_EMAILS_Monitored;
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
-- 01/20/2008 Paul.  GROUP_ID is required. 
-- 04/19/2011 Paul.  Add IS_PERSONAL to exclude EmailClient inbound from being included in monitored list. 
-- 05/24/2014 Paul.  We need to track the Last Email UID in order to support Only Since flag. 
-- 01/26/2017 Paul.  Add support for Office 365 as an OutboundEmail. 
-- 01/28/2017 Paul.  EXCHANGE_WATERMARK for support of Exchange and Office365.
-- 01/28/2017 Paul.  GROUP_TEAM_ID for inbound emails. 
Create View dbo.vwINBOUND_EMAILS_Monitored
as
select ID
     , NAME
     , SERVER_URL
     , EMAIL_USER
     , EMAIL_PASSWORD
     , PORT
     , SERVICE
     , MAILBOX_SSL
     , MAILBOX
     , MARK_READ
     , ONLY_SINCE
     , MAILBOX_TYPE
     , FROM_NAME
     , FROM_ADDR
     , FILTER_DOMAIN
     , GROUP_ID
     , TEMPLATE_ID
     , LAST_EMAIL_UID
     , GROUP_TEAM_ID
     , EXCHANGE_WATERMARK
     , OFFICE365_OAUTH_ENABLED
     , GOOGLEAPPS_OAUTH_ENABLED
  from vwINBOUND_EMAILS
 where STATUS       = N'Active'
   and MAILBOX_TYPE <> N'bounce'
   and IS_PERSONAL  = 0

GO

Grant Select on dbo.vwINBOUND_EMAILS_Monitored to public;
GO


