if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_Login')
	Drop View dbo.vwUSERS_Login;
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
-- 07/14/2006 Paul.  Inactive users should not be able to login. 
-- 07/14/2006 Paul.  New users created via NTLM will have a status of NULL. 
-- 11/25/2006 Paul.  We need to keep TEAM_ID in the session for quick access. 
-- 04/13/2009 Paul.  Now that we have a portal product, we need to prevent portal users from logging-in.
-- 05/06/2009 Paul.  Use DEFAULT_TEAM before attempting to use the private team. 
-- 10/14/2009 Paul.  Exclude Employees and Inbound emails. 
-- 03/16/2010 Paul.  Add IS_ADMIN_DELEGATE. 
-- 04/04/2010 Paul.  Add EXCHANGE_ALIAS. 
-- 04/07/2010 Paul.  Add EXCHANGE_EMAIL as it will be need for Push Subscriptions. 
-- 07/09/2010 Paul.  Move the SMTP values from USER_PREFERENCES to the main table to make it easier to access. 
-- 07/09/2010 Paul.  SMTP values belong in the OUTBOUND_EMAILS table. 
-- 11/05/2010 Paul.  Each user can have their own email account, so we need to store EMAIL1 in the session. 
-- 02/22/2011 Paul.  Add PWD_LAST_CHANGED and SYSTEM_GENERATED_PASSWORD for password management. 
-- 03/19/2011 Paul.  Facebook login uses the MESSENGER_ID field. 
-- 03/25/2011 Paul.  Create a separate field for the Facebook ID. 
-- 08/28/2012 Paul.  PRIVATE_TEAM_ID is used in the Campaign GenerateCalls. 
-- 12/15/2012 Paul.  Move USER_PREFERENCES to separate fields for easier access on Surface RT. 
-- 09/20/2013 Paul.  Move EXTENSION to the main table. 
-- 05/05/2016 Paul.  The User Primary Role is used with role-based views. 
-- 05/05/2016 Paul.  Remove the space characters and quotes to make SQL parsing easier. 
-- 01/17/2017 Paul.  Add support for Office 365 OAuth credentials. 
Create View dbo.vwUSERS_Login
as
select USERS.ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as FULL_NAME
     , USERS.USER_NAME
     , USERS.USER_PASSWORD
     , USERS.USER_HASH
     , USERS.FIRST_NAME
     , USERS.LAST_NAME
     , USERS.IS_ADMIN
     , USERS.IS_ADMIN_DELEGATE
     , USERS.PORTAL_ONLY
     , USERS.STATUS
     , TEAMS.ID            as TEAM_ID
     , TEAMS.NAME          as TEAM_NAME
     , EXCHANGE_USERS.EXCHANGE_ALIAS
     , EXCHANGE_USERS.EXCHANGE_EMAIL
     , OUTBOUND_EMAILS.MAIL_SMTPUSER
     , OUTBOUND_EMAILS.MAIL_SMTPPASS
     , USERS.EMAIL1
     , USERS.PWD_LAST_CHANGED
     , USERS.SYSTEM_GENERATED_PASSWORD
     , USERS.FACEBOOK_ID
     , TEAM_MEMBERSHIPS.TEAM_ID as PRIVATE_TEAM_ID
     , USERS.THEME
     , USERS.DATE_FORMAT
     , USERS.TIME_FORMAT
     , USERS.LANG
     , USERS.CURRENCY_ID
     , USERS.TIMEZONE_ID
     , USERS.SAVE_QUERY
     , USERS.GROUP_TABS
     , USERS.SUBPANEL_TABS
     , USERS.EXTENSION
     , USERS.PRIMARY_ROLE_ID       as PRIMARY_ROLE_ID
     , replace(replace(ACL_ROLES.NAME, ' ', ''), '''', '') as PRIMARY_ROLE_NAME
     , (select count(*) from OAUTH_TOKENS where OAUTH_TOKENS.ASSIGNED_USER_ID = USERS.ID and OAUTH_TOKENS.NAME = N'Office365'  and OAUTH_TOKENS.DELETED = 0) as OFFICE365_OAUTH_ENABLED
     , (select count(*) from OAUTH_TOKENS where OAUTH_TOKENS.ASSIGNED_USER_ID = USERS.ID and OAUTH_TOKENS.NAME = N'GoogleApps' and OAUTH_TOKENS.DELETED = 0) as GOOGLEAPPS_OAUTH_ENABLED
  from            USERS
  left outer join TEAM_MEMBERSHIPS
               on TEAM_MEMBERSHIPS.USER_ID = USERS.ID
              and TEAM_MEMBERSHIPS.PRIVATE = 1
              and TEAM_MEMBERSHIPS.DELETED = 0
  left outer join TEAMS
               on TEAMS.ID                 = isnull(USERS.DEFAULT_TEAM, TEAM_MEMBERSHIPS.TEAM_ID)
              and TEAMS.DELETED            = 0
  left outer join EXCHANGE_USERS
               on EXCHANGE_USERS.ASSIGNED_USER_ID = USERS.ID
              and EXCHANGE_USERS.DELETED          = 0
  left outer join OUTBOUND_EMAILS
               on OUTBOUND_EMAILS.USER_ID         = USERS.ID
              and OUTBOUND_EMAILS.TYPE            = N'system-override'
              and OUTBOUND_EMAILS.DELETED         = 0
  left outer join ACL_ROLES_USERS
               on ACL_ROLES_USERS.USER_ID   = USERS.ID
              and ACL_ROLES_USERS.ROLE_ID   = USERS.PRIMARY_ROLE_ID
              and ACL_ROLES_USERS.DELETED   = 0
  left outer join ACL_ROLES
               on ACL_ROLES.ID              = ACL_ROLES_USERS.ROLE_ID
              and ACL_ROLES.DELETED         = 0
 where USERS.DELETED = 0
   and USERS.USER_NAME is not null
   and (USERS.STATUS is null or USERS.STATUS = N'Active')
   and (USERS.PORTAL_ONLY is null or USERS.PORTAL_ONLY = 0)

GO

Grant Select on dbo.vwUSERS_Login to public;
GO


