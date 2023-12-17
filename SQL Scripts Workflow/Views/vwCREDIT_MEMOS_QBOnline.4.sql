if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCREDIT_MEMOS_QBOnline')
	Drop View dbo.vwCREDIT_MEMOS_QBOnline;
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
Create View dbo.vwCREDIT_MEMOS_QBOnline
as
select vwINVOICES_PAYMENTS.*
     , INVOICES.SHIPPING_USDOLLAR
     , INVOICES.TAX_USDOLLAR
     , INVOICES.TAXRATE_ID
  from      vwINVOICES_PAYMENTS
 inner join INVOICES
         on INVOICES.ID = vwINVOICES_PAYMENTS.INVOICE_ID
 where vwINVOICES_PAYMENTS.ACCOUNT_ID is not null
   and vwINVOICES_PAYMENTS.AMOUNT_USDOLLAR < 0.0
   and vwINVOICES_PAYMENTS.INVOICE_ID in (select SYNC_LOCAL_ID from vwINVOICES_SYNC where SYNC_SERVICE_NAME = N'QuickBooksOnline')

GO

Grant Select on dbo.vwCREDIT_MEMOS_QBOnline to public;
GO


