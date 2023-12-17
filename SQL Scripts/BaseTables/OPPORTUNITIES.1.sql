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
-- 07/16/2005 Paul.  Version 3.0.1 increased the size of the NEXT_STEP field. 
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/25/2007 Paul.  CAMPAIGN_ID was added in SugarCRM 4.5.1
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 10/05/2010 Paul.  Increase the size of the NAME field. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OPPORTUNITIES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.OPPORTUNITIES';
	Create Table dbo.OPPORTUNITIES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_OPPORTUNITIES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, OPPORTUNITY_NUMBER                 nvarchar(30) null
		, NAME                               nvarchar(150) null
		, OPPORTUNITY_TYPE                   nvarchar(255) null
		, LEAD_SOURCE                        nvarchar(50) null
		, AMOUNT                             money null
		, AMOUNT_BACKUP                      nvarchar(25) null
		, AMOUNT_USDOLLAR                    money null
		, CURRENCY_ID                        uniqueidentifier null
		, DATE_CLOSED                        datetime null
		, NEXT_STEP                          nvarchar(100) null
		, SALES_STAGE                        nvarchar(25) null
		, PROBABILITY                        float null
		, DESCRIPTION                        nvarchar(max) null
		, CAMPAIGN_ID                        uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, B2C_CONTACT_ID                     uniqueidentifier null
		)

	create index IDX_OPPORTUNITIES_NAME             on dbo.OPPORTUNITIES (NAME, DELETED, ID)
	create index IDX_OPPORTUNITIES_ASSIGNED_USER_ID on dbo.OPPORTUNITIES (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_OPPORTUNITIES_TEAM_ID          on dbo.OPPORTUNITIES (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_OPPORTUNITIES_TEAM_SET_ID      on dbo.OPPORTUNITIES (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_OPPORTUNITIES_ASSIGNED_SET_ID  on dbo.OPPORTUNITIES (ASSIGNED_SET_ID, DELETED, ID)
	create index IDX_OPPORTUNITIES_CAMPAIGN_ID      on dbo.OPPORTUNITIES (CAMPAIGN_ID, SALES_STAGE, DELETED, AMOUNT)
  end
GO


