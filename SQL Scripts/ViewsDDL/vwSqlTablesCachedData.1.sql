if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlTablesCachedData')
	Drop View dbo.vwSqlTablesCachedData;
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
-- 03/09/2016 Paul.  Change from terminology payment_types_dom to PaymentTypes list for QuickBooks Online. 
Create View dbo.vwSqlTablesCachedData
as
select TABLE_NAME
  from vwSqlTables
 where TABLE_NAME in
( N'CONTRACT_TYPES'
, N'CURRENCIES'
, N'FORUM_TOPICS'
, N'FORUMS'
, N'INBOUND_EMAILS'
, N'MANUFACTURERS'
, N'PRODUCT_CATEGORIES'
, N'PRODUCT_TYPES'
, N'RELEASES'
, N'SHIPPERS'
, N'TAX_RATES'
, N'TEAMS'
, N'USERS'
, N'PAYMENT_TYPES'
, N'PAYMENT_TERMS'
)
GO


Grant Select on dbo.vwSqlTablesCachedData to public;
GO

