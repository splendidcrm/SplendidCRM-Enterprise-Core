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
-- 11/30/2007 Paul.  Change TYPE to unique identifier and rename to TYPE_ID. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTRACTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CONTRACTS';
	Create Table dbo.CONTRACTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CONTRACTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(255) null
		, REFERENCE_CODE                     nvarchar(255) null
		, STATUS                             nvarchar(25) null
		, TYPE_ID                            uniqueidentifier null
		, ACCOUNT_ID                         uniqueidentifier null
		, B2C_CONTACT_ID                     uniqueidentifier null
		, START_DATE                         datetime null
		, END_DATE                           datetime null
		, COMPANY_SIGNED_DATE                datetime null
		, CUSTOMER_SIGNED_DATE               datetime null
		, EXPIRATION_NOTICE                  datetime null
		, CURRENCY_ID                        uniqueidentifier null
		, TOTAL_CONTRACT_VALUE               money null
		, TOTAL_CONTRACT_VALUE_USDOLLAR      money null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_CONTRACTS_ASSIGNED_USER_ID on dbo.CONTRACTS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_CONTRACTS_TEAM_ID          on dbo.CONTRACTS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_CONTRACTS_TEAM_SET_ID      on dbo.CONTRACTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_CONTRACTS_ASSIGNED_SET_ID  on dbo.CONTRACTS (ASSIGNED_SET_ID, DELETED, ID)

	alter table dbo.CONTRACTS add constraint FK_CONTRACTS_ACCOUNT_ID foreign key ( ACCOUNT_ID ) references dbo.ACCOUNTS ( ID )
  end
GO


