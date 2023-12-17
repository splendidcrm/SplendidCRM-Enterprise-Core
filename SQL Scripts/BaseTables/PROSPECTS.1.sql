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
-- 04/21/2006 Paul.  LEAD_ID was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  ACCOUNT_NAME was added in SugarCRM 4.0.
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/25/2007 Paul.  CAMPAIGN_ID was added in SugarCRM 4.5.1
-- 07/25/2009 Paul.  TRACKER_KEY is now a string. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 10/16/2011 Paul.  Increase size of FIRST_NAME and LAST_NAME to match CONTACTS and PROSPECTS. 
-- 09/27/2013 Paul.  SMS messages need to be opt-in. 
-- 10/22/2013 Paul.  Provide a way to map Tweets to a parent. 
-- 05/24/2015 Paul.  Add Picture. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 06/23/2018 Paul.  Add LEAD_SOURCE, DP_BUSINESS_PURPOSE and DP_CONSENT_LAST_UPDATED for data privacy. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROSPECTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PROSPECTS';
	Create Table dbo.PROSPECTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PROSPECTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, TRACKER_KEY                        nvarchar(30) null
		, PROSPECT_NUMBER                     nvarchar(30) null
		, SALUTATION                         nvarchar(25) null
		, FIRST_NAME                         nvarchar(100) null
		, LAST_NAME                          nvarchar(100) null
		, TITLE                              nvarchar(25) null
		, DEPARTMENT                         nvarchar(255) null
		, BIRTHDATE                          datetime null
		, DO_NOT_CALL                        bit null default(0)
		, PHONE_HOME                         nvarchar(25) null
		, PHONE_MOBILE                       nvarchar(25) null
		, PHONE_WORK                         nvarchar(25) null
		, PHONE_OTHER                        nvarchar(25) null
		, PHONE_FAX                          nvarchar(25) null
		, EMAIL1                             nvarchar(100) null
		, EMAIL2                             nvarchar(100) null
		, ASSISTANT                          nvarchar(75) null
		, ASSISTANT_PHONE                    nvarchar(25) null
		, EMAIL_OPT_OUT                      bit null default(0)
		, INVALID_EMAIL                      bit null default(0)
		, SMS_OPT_IN                         nvarchar(25) null
		, TWITTER_SCREEN_NAME                nvarchar(20) null
		, PRIMARY_ADDRESS_STREET             nvarchar(150) null
		, PRIMARY_ADDRESS_CITY               nvarchar(100) null
		, PRIMARY_ADDRESS_STATE              nvarchar(100) null
		, PRIMARY_ADDRESS_POSTALCODE         nvarchar(20) null
		, PRIMARY_ADDRESS_COUNTRY            nvarchar(100) null
		, ALT_ADDRESS_STREET                 nvarchar(150) null
		, ALT_ADDRESS_CITY                   nvarchar(100) null
		, ALT_ADDRESS_STATE                  nvarchar(100) null
		, ALT_ADDRESS_POSTALCODE             nvarchar(20) null
		, ALT_ADDRESS_COUNTRY                nvarchar(100) null
		, DESCRIPTION                        nvarchar(max) null
		, LEAD_ID                            uniqueidentifier null
		, ACCOUNT_NAME                       nvarchar(150) null
		, CAMPAIGN_ID                        uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, PICTURE                            nvarchar(max) null
		, LEAD_SOURCE                        nvarchar(100) null
		, DP_BUSINESS_PURPOSE                nvarchar(max) null
		, DP_CONSENT_LAST_UPDATED            datetime null
		)

	create index IDX_PROSPECTS_TRACKER_KEY          on dbo.PROSPECTS (TRACKER_KEY, DELETED, ID)
	create index IDX_PROSPECTS_LAST_NAME_FIRST_NAME on dbo.PROSPECTS (LAST_NAME, FIRST_NAME, DELETED, ID)
	-- 10/24/2009 Paul.  Searching by first name is popular. 
	create index IDX_PROSPECTS_FIRST_NAME_LAST_NAME on dbo.PROSPECTS (FIRST_NAME, LAST_NAME, DELETED, ID)
	create index IDX_PROSPECTS_LAST_NAME            on dbo.PROSPECTS (LAST_NAME, DELETED, ID)
	create index IDX_PROSPECTS_ASSIGNED_USER_ID     on dbo.PROSPECTS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_PROSPECTS_TEAM_ID              on dbo.PROSPECTS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PROSPECTS_TEAM_SET_ID          on dbo.PROSPECTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_PROSPECTS_ASSIGNED_SET_ID      on dbo.PROSPECTS (ASSIGNED_SET_ID, DELETED, ID)
	-- 10/22/2013 Paul.  An index is necessary for quick mapping to tweets. 
	create index IDX_PROSPECTS_TWITTER_SCREEN       on dbo.PROSPECTS (TWITTER_SCREEN_NAME, DELETED, ID)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_PROSPECTS_EMAIL1               on dbo.PROSPECTS (EMAIL1, DELETED, ID)
  end
GO


