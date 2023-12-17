if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES_PAYMENTS')
	Drop View dbo.vwINVOICES_PAYMENTS;
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
-- 06/21/2007 Paul.  Add INVOICES_ASSIGNED_USER_ID so that ACL rules can be applied. 
-- 04/23/2008 Paul.  fnPAYMENTS_IsValid contains logic to determine if a credit card transaction is valid. 
-- 10/16/2008 Paul.  Include ORDER information to simplify PayPal import. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwINVOICES_PAYMENTS
as
select INVOICES_PAYMENTS.ID              as INVOICE_PAYMENT_ID
     , (case when dbo.fnPAYMENTS_IsValid(PAYMENT_ID, PAYMENT_TYPE) = 1 
             then INVOICES_PAYMENTS.AMOUNT
             else null
        end)                             as ALLOCATED
     , (case when dbo.fnPAYMENTS_IsValid(PAYMENT_ID, PAYMENT_TYPE) = 1 
             then INVOICES_PAYMENTS.AMOUNT_USDOLLAR
             else null
        end)                             as ALLOCATED_USDOLLAR
     , INVOICES.ID                       as INVOICE_ID
     , INVOICES.NAME                     as INVOICE_NAME
     , INVOICES.INVOICE_NUM              as INVOICE_NUM
     , INVOICES.ASSIGNED_USER_ID         as INVOICE_ASSIGNED_USER_ID
     , INVOICES.ASSIGNED_SET_ID          as INVOICE_ASSIGNED_SET_ID
     , ORDERS.ID                         as ORDER_ID
     , ORDERS.NAME                       as ORDER_NAME
     , ORDERS.ORDER_NUM                  as ORDER_NUM
     , ORDERS.ASSIGNED_USER_ID           as ORDER_ASSIGNED_USER_ID
     , ORDERS.ASSIGNED_SET_ID            as ORDER_ASSIGNED_SET_ID
     , vwPAYMENTS.ID                     as PAYMENT_ID
     , vwPAYMENTS.PAYMENT_NUM            as PAYMENT_NAME
     , vwPAYMENTS.*
  from            INVOICES_PAYMENTS
       inner join INVOICES
               on INVOICES.ID      = INVOICES_PAYMENTS.INVOICE_ID
              and INVOICES.DELETED = 0
       inner join vwPAYMENTS
               on vwPAYMENTS.ID    = INVOICES_PAYMENTS.PAYMENT_ID
  left outer join ORDERS
               on ORDERS.ID        = INVOICES.ORDER_ID
              and ORDERS.DELETED = 0
 where INVOICES_PAYMENTS.DELETED = 0

GO

Grant Select on dbo.vwINVOICES_PAYMENTS to public;
GO

