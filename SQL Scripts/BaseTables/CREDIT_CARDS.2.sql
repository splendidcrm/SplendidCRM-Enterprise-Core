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
-- drop table CREDIT_CARDS;
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 10/07/2010 Paul.  Add Contact field. 
-- 04/16/2013 Paul.  ACCOUNT_ID should be nullable so that CRM can be used for B2C. 
-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CREDIT_CARDS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CREDIT_CARDS';
	Create Table dbo.CREDIT_CARDS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CREDIT_CARDS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ACCOUNT_ID                         uniqueidentifier null
		, CONTACT_ID                         uniqueidentifier null
		, NAME                               nvarchar(150) not null
		, CARD_TYPE                          nvarchar( 25) not null
		, CARD_NUMBER                        nvarchar(100) not null
		, CARD_TOKEN                         nvarchar( 50) null
		, CARD_NUMBER_DISPLAY                nvarchar( 10) null
		, SECURITY_CODE                      nvarchar( 10) null
		, EXPIRATION_DATE                    datetime not null
		, BANK_NAME                          nvarchar(150) null
		, BANK_ROUTING_NUMBER                nvarchar(100) null
		, IS_PRIMARY                         bit null default(0)
		, IS_ENCRYPTED                       bit null default(0)
		, ADDRESS_STREET                     nvarchar(150) null
		, ADDRESS_CITY                       nvarchar(100) null
		, ADDRESS_STATE                      nvarchar(100) null
		, ADDRESS_POSTALCODE                 nvarchar( 20) null
		, ADDRESS_COUNTRY                    nvarchar(100) null
		, EMAIL                              nvarchar(100) null
		, PHONE                              nvarchar( 25) null
		)

	create index IDX_CREDIT_CARDS_ACCOUNT_ID on dbo.CREDIT_CARDS (ACCOUNT_ID)
	create index IDX_CREDIT_CARDS_CONTACT_ID on dbo.CREDIT_CARDS (CONTACT_ID)

	alter table dbo.CREDIT_CARDS add constraint FK_CREDIT_CARDS_ACCOUNT_ID foreign key ( ACCOUNT_ID ) references dbo.ACCOUNTS ( ID )
  end
GO

