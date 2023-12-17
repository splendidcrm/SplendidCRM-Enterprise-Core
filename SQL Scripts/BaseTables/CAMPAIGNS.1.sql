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
-- 04/21/2006 Paul.  CURRENCY_ID was added in SugarCRM 4.2.
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/25/2007 Paul.  IMPRESSIONS was added in SugarCRM 4.5.1
-- 12/25/2007 Paul.  FREQUENCY was added in SugarCRM 4.5.1
-- 12/25/2007 Paul.  Add USDOLLAR fields so that they can be automatically converted. 
-- 07/25/2009 Paul.  TRACKER_KEY is now a string. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CAMPAIGNS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CAMPAIGNS';
	Create Table dbo.CAMPAIGNS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CAMPAIGNS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, TRACKER_KEY                        nvarchar( 30) null
		, TRACKER_COUNT                      int null default(0)
		, IMPRESSIONS                        int null default(0)
		, CAMPAIGN_NUMBER                    nvarchar(30) null
		, NAME                               nvarchar(50) null
		, REFER_URL                          nvarchar(255) null default('http://')
		, TRACKER_TEXT                       nvarchar(255) null
		, START_DATE                         datetime null
		, END_DATE                           datetime null
		, STATUS                             nvarchar(25) null
		, BUDGET                             money null
		, BUDGET_USDOLLAR                    money null
		, EXPECTED_COST                      money null
		, EXPECTED_COST_USDOLLAR             money null
		, ACTUAL_COST                        money null
		, ACTUAL_COST_USDOLLAR               money null
		, EXPECTED_REVENUE                   money null
		, EXPECTED_REVENUE_USDOLLAR          money null
		, CAMPAIGN_TYPE                      nvarchar(25) null
		, FREQUENCY                          nvarchar(25) null
		, OBJECTIVE                          nvarchar(max) null
		, CONTENT                            nvarchar(max) null
		, CURRENCY_ID                        uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_CAMPAIGNS_TRACKER_KEY      on dbo.CAMPAIGNS (TRACKER_KEY, ID, DELETED)
	create index IDX_CAMPAIGNS_NAME             on dbo.CAMPAIGNS (NAME, ID, DELETED)
	create index IDX_CAMPAIGNS_ASSIGNED_USER_ID on dbo.CAMPAIGNS (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_CAMPAIGNS_TEAM_ID          on dbo.CAMPAIGNS (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_CAMPAIGNS_TEAM_SET_ID      on dbo.CAMPAIGNS (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_CAMPAIGNS_ASSIGNED_SET_ID  on dbo.CAMPAIGNS (ASSIGNED_SET_ID, ID, DELETED)
  end
GO


