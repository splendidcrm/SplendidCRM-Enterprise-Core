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
-- 05/29/2008 Paul.  CARD_NAME will be NULL when transaction originates from PayPal. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 12/12/2015 Paul.  Need to increase PAYMENT_GATEWAY to allow for combined Gateway and Login. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PAYMENTS_TRANSACTIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PAYMENTS_TRANSACTIONS';
	Create Table dbo.PAYMENTS_TRANSACTIONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PAYMENTS_TRANSACTIONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		-- Payment information
		, PAYMENT_ID                         uniqueidentifier not null
		, PAYMENT_GATEWAY                    nvarchar( 100) null
		, TRANSACTION_TYPE                   nvarchar(  25) null
		, AMOUNT                             money null
		, CURRENCY_ID                        uniqueidentifier null
		, INVOICE_NUMBER                     nvarchar( 400) null
		, DESCRIPTION                        nvarchar(max) null

		-- Card information 
		, CREDIT_CARD_ID                     uniqueidentifier null
		, CARD_NAME                          nvarchar( 150) null
		, CARD_TYPE                          nvarchar(  25) null
		, CARD_NUMBER_DISPLAY                nvarchar(  10) null
		, BANK_NAME                          nvarchar( 150) null

		-- Address information
		, ACCOUNT_ID                         uniqueidentifier not null
		, ADDRESS_STREET                     nvarchar( 150) null
		, ADDRESS_CITY                       nvarchar( 100) null
		, ADDRESS_STATE                      nvarchar( 100) null
		, ADDRESS_POSTALCODE                 nvarchar(  20) null
		, ADDRESS_COUNTRY                    nvarchar( 100) null
		, EMAIL                              nvarchar( 100) null
		, PHONE                              nvarchar(  25) null

		-- Transaction returned values
		, STATUS                             nvarchar(  25) null
		, TRANSACTION_NUMBER                 nvarchar(  50) null
		, REFERENCE_NUMBER                   nvarchar(  50) null
		, AUTHORIZATION_CODE                 nvarchar(  50) null
		, AVS_CODE                           nvarchar( 250) null
		, ERROR_CODE                         nvarchar(  20) null
		, ERROR_MESSAGE                      nvarchar(max) null
		)
  end
GO

