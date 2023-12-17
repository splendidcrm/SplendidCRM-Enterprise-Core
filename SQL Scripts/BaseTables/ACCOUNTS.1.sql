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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 12/25/2007 Paul.  CAMPAIGN_ID was added in SugarCRM 4.5.1
-- 07/26/2009 Paul.  Enough customers requested ACCOUNT_NUMBER that it makes sense to add it now. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 05/24/2015 Paul.  Add Picture. 
-- 10/27/2017 Paul.  Add Accounts as email source. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ACCOUNTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.ACCOUNTS';
	Create Table dbo.ACCOUNTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_ACCOUNTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, ACCOUNT_NUMBER                     nvarchar(30) null
		, NAME                               nvarchar(150) null
		, ACCOUNT_TYPE                       nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, INDUSTRY                           nvarchar(25) null
		, ANNUAL_REVENUE                     nvarchar(25) null
		, PHONE_FAX                          nvarchar(25) null
		, BILLING_ADDRESS_STREET             nvarchar(150) null
		, BILLING_ADDRESS_CITY               nvarchar(100) null
		, BILLING_ADDRESS_STATE              nvarchar(100) null
		, BILLING_ADDRESS_POSTALCODE         nvarchar(20) null
		, BILLING_ADDRESS_COUNTRY            nvarchar(100) null
		, DESCRIPTION                        nvarchar(max) null
		, RATING                             nvarchar(25) null
		, PHONE_OFFICE                       nvarchar(25) null
		, PHONE_ALTERNATE                    nvarchar(25) null
		, EMAIL1                             nvarchar(100) null
		, EMAIL2                             nvarchar(100) null
		, WEBSITE                            nvarchar(255) null
		, OWNERSHIP                          nvarchar(100) null
		, EMPLOYEES                          nvarchar(10) null
		, SIC_CODE                           nvarchar(10) null
		, TICKER_SYMBOL                      nvarchar(10) null
		, SHIPPING_ADDRESS_STREET            nvarchar(150) null
		, SHIPPING_ADDRESS_CITY              nvarchar(100) null
		, SHIPPING_ADDRESS_STATE             nvarchar(100) null
		, SHIPPING_ADDRESS_POSTALCODE        nvarchar(20) null
		, SHIPPING_ADDRESS_COUNTRY           nvarchar(100) null
		, CAMPAIGN_ID                        uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, PICTURE                            nvarchar(max) null
		, DO_NOT_CALL                        bit null default(0)
		, EMAIL_OPT_OUT                      bit null default(0)
		, INVALID_EMAIL                      bit null default(0)
		)

	create index IDX_ACCOUNTS_NUMBER           on dbo.ACCOUNTS (ACCOUNT_NUMBER, ID, DELETED)
	create index IDX_ACCOUNTS_NAME             on dbo.ACCOUNTS (NAME, ID, DELETED)
	create index IDX_ACCOUNTS_ASSIGNED_USER_ID on dbo.ACCOUNTS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_ACCOUNTS_TEAM_ID          on dbo.ACCOUNTS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_ACCOUNTS_TEAM_SET_ID      on dbo.ACCOUNTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_ACCOUNTS_ASSIGNED_SET_ID  on dbo.ACCOUNTS (ASSIGNED_SET_ID, DELETED, ID)
	create index IDX_ACCOUNTS_PARENT_ID        on dbo.ACCOUNTS (PARENT_ID, DELETED, ID)
  end
GO

