if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPAYMENTS_INVOICES')
	Drop View dbo.vwPAYMENTS_INVOICES;
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
-- 05/26/2007 Paul.  Use both AMOUNT and ALLOCATED as one is used for edit and the other is use for listing. 
-- 04/23/2008 Paul.  We need payment type so that we can filter credit card payments. 
-- 04/23/2008 Paul.  fnPAYMENTS_IsValid contains logic to determine if a credit card transaction is valid. 
-- 05/05/2008 Paul.  DATE_ENTERED and INVOICE_NUM are used in the code-behind.
-- 08/19/2016 Paul.  Add support for Business Processes. 
Create View dbo.vwPAYMENTS_INVOICES
as
select INVOICES_PAYMENTS.ID              as ID
     , INVOICES_PAYMENTS.AMOUNT
     , INVOICES_PAYMENTS.AMOUNT_USDOLLAR
     , (case when dbo.fnPAYMENTS_IsValid(PAYMENT_ID, PAYMENT_TYPE) = 1 
             then INVOICES_PAYMENTS.AMOUNT
             else null
        end)                             as ALLOCATED
     , (case when dbo.fnPAYMENTS_IsValid(PAYMENT_ID, PAYMENT_TYPE) = 1 
             then INVOICES_PAYMENTS.AMOUNT_USDOLLAR
             else null
        end)                             as ALLOCATED_USDOLLAR
     , INVOICES_PAYMENTS.DATE_ENTERED    as DATE_ENTERED
     , INVOICES_PAYMENTS.DATE_MODIFIED   as DATE_MODIFIED
     , INVOICES_PAYMENTS.DATE_MODIFIED_UTC as DATE_MODIFIED_UTC
     , PAYMENTS.ID                       as PAYMENT_ID
     , PAYMENTS.PAYMENT_NUM              as PAYMENT_NAME
     , PAYMENTS.PAYMENT_TYPE             as PAYMENT_TYPE
     , INVOICES.ID                       as INVOICE_ID
     , INVOICES.NAME                     as INVOICE_NAME
     , INVOICES.INVOICE_NUM
     , INVOICES.TOTAL
     , INVOICES.TOTAL_USDOLLAR
     , INVOICES.AMOUNT_DUE
     , INVOICES.AMOUNT_DUE_USDOLLAR
     , INVOICES.ASSIGNED_USER_ID
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
  from            INVOICES_PAYMENTS
       inner join PAYMENTS
               on PAYMENTS.ID                   = INVOICES_PAYMENTS.PAYMENT_ID
              and PAYMENTS.DELETED              = 0
       inner join INVOICES
               on INVOICES.ID                   = INVOICES_PAYMENTS.INVOICE_ID
              and INVOICES.DELETED              = 0
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = INVOICES.ID
 where INVOICES_PAYMENTS.DELETED = 0

GO

Grant Select on dbo.vwPAYMENTS_INVOICES to public;
GO

