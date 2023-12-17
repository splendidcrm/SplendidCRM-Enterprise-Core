if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPAYMENTS_QuickBooks')
	Drop View dbo.vwPAYMENTS_QuickBooks;
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
-- 02/19/2015 Paul.  Payments can only be positive. Negative payments are a CreditMemo. 
-- 02/22/2015 Paul.  Include zero amount in case a payment comes from QuickBooks that way. 
Create View dbo.vwPAYMENTS_QuickBooks
as
select *
  from vwINVOICES_PAYMENTS
 where ACCOUNT_ID is not null
   and AMOUNT_USDOLLAR >= 0.0
   and INVOICE_ID in (select SYNC_LOCAL_ID from vwINVOICES_SYNC where SYNC_SERVICE_NAME = N'QuickBooks')

GO

Grant Select on dbo.vwPAYMENTS_QuickBooks to public;
GO


