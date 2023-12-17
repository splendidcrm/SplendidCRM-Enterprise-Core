if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPAYMENTS_QBOnline')
	Drop View dbo.vwPAYMENTS_QBOnline;
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
-- 03/24/2015 Paul.  The Payment Account must match the invoice account, otherwise we would get a Bad Request when trying to insert a payment. 
-- 03/24/2015 Paul.  Also, if CUSTOMER_REFERENCE/PaymentRefNum has a max length of 21. 
Create View dbo.vwPAYMENTS_QBOnline
as
select vwINVOICES_PAYMENTS.*
  from            vwINVOICES_PAYMENTS
  left outer join INVOICES_ACCOUNTS                         INVOICES_ACCOUNTS_BILLING
               on INVOICES_ACCOUNTS_BILLING.INVOICE_ID    = vwINVOICES_PAYMENTS.INVOICE_ID
              and INVOICES_ACCOUNTS_BILLING.ACCOUNT_ROLE  = N'Bill To'
              and INVOICES_ACCOUNTS_BILLING.DELETED       = 0
 where vwINVOICES_PAYMENTS.ACCOUNT_ID is not null
   and vwINVOICES_PAYMENTS.ACCOUNT_ID = INVOICES_ACCOUNTS_BILLING.ACCOUNT_ID
   and vwINVOICES_PAYMENTS.AMOUNT_USDOLLAR >= 0.0
   and vwINVOICES_PAYMENTS.INVOICE_ID in (select SYNC_LOCAL_ID from vwINVOICES_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')

GO

Grant Select on dbo.vwPAYMENTS_QBOnline to public;
GO


