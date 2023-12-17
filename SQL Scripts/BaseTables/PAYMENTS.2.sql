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
-- 07/25/2009 Paul.  PAYMENT_NUM is now a string. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PAYMENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PAYMENTS';
	Create Table dbo.PAYMENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PAYMENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, ACCOUNT_ID                         uniqueidentifier null
		, B2C_CONTACT_ID                     uniqueidentifier null
		, PAYMENT_NUM                        nvarchar(30) null
		, PAYMENT_DATE                       datetime null
		, PAYMENT_TYPE                       nvarchar( 25) null
		, CUSTOMER_REFERENCE                 nvarchar( 50) null
		, EXCHANGE_RATE                      float null default(0.0)
		, CURRENCY_ID                        uniqueidentifier null
		, AMOUNT                             money null
		, AMOUNT_USDOLLAR                    money null
		, BANK_FEE                           money null
		, BANK_FEE_USDOLLAR                  money null
		, CREDIT_CARD_ID                     uniqueidentifier null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	-- 07/18/2006 Paul.  MySQL requires an index on auto_increment.
	-- #42000 Incorrect table definition; there can be only one auto column and it must be defined as a key
	create index IDX_PAYMENTS_PAYMENT_NUM      on dbo.PAYMENTS (PAYMENT_NUM, DELETED, ID)
	create index IDX_PAYMENTS_ASSIGNED_USER_ID on dbo.PAYMENTS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_PAYMENTS_TEAM_ID          on dbo.PAYMENTS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_PAYMENTS_TEAM_SET_ID      on dbo.PAYMENTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_PAYMENTS_ASSIGNED_SET_ID  on dbo.PAYMENTS (ASSIGNED_SET_ID, DELETED, ID)

	-- 02/11/2008 Paul.  The account should be required. 
	alter table dbo.PAYMENTS add constraint FK_PAYMENTS_ACCOUNT_ID foreign key ( ACCOUNT_ID ) references dbo.ACCOUNTS ( ID )
  end
GO

