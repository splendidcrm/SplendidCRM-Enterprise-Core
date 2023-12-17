if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPAYMENTS_TRANSACTIONS')
	Drop View dbo.vwPAYMENTS_TRANSACTIONS;
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
-- 01/08/2011 Paul.  One implementation of SplendidCRM uses the CONTACTS table as the relationship for credit cards.
-- 12/21/2012 Paul.  Provide access to Invoice ID. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
Create View dbo.vwPAYMENTS_TRANSACTIONS
as
select PAYMENTS_TRANSACTIONS.ID
     , PAYMENTS_TRANSACTIONS.PAYMENT_GATEWAY    
     , PAYMENTS_TRANSACTIONS.TRANSACTION_TYPE   
     , PAYMENTS_TRANSACTIONS.AMOUNT             
     , PAYMENTS_TRANSACTIONS.CURRENCY_ID        
     , PAYMENTS_TRANSACTIONS.INVOICE_NUMBER   
     , INVOICES_PAYMENTS.INVOICE_ID
     , PAYMENTS_TRANSACTIONS.CREDIT_CARD_ID     
     , PAYMENTS_TRANSACTIONS.CARD_NAME          
     , PAYMENTS_TRANSACTIONS.CARD_TYPE          
     , PAYMENTS_TRANSACTIONS.CARD_NUMBER_DISPLAY
     , PAYMENTS_TRANSACTIONS.BANK_NAME          
     , PAYMENTS_TRANSACTIONS.STATUS             
     , PAYMENTS_TRANSACTIONS.TRANSACTION_NUMBER 
     , PAYMENTS_TRANSACTIONS.REFERENCE_NUMBER   
     , PAYMENTS_TRANSACTIONS.AUTHORIZATION_CODE 
     , PAYMENTS_TRANSACTIONS.AVS_CODE           
     , PAYMENTS_TRANSACTIONS.ERROR_CODE         
     , PAYMENTS_TRANSACTIONS.ERROR_MESSAGE      
     , PAYMENTS.ID                              as PAYMENT_ID
     , PAYMENTS.PAYMENT_NUM
     , isnull(ACCOUNTS.ID  , CONTACTS.ID  )     as ACCOUNT_ID
     , isnull(ACCOUNTS.NAME, dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME))   as ACCOUNT_NAME
     , CONTACTS.ID                                               as CONTACT_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME)   as CONTACT_NAME
     , USERS_CREATED_BY.USER_NAME               as CREATED_BY
     , PAYMENTS_TRANSACTIONS.CREATED_BY         as CREATED_BY_ID
     , PAYMENTS_TRANSACTIONS.DATE_ENTERED
     , PAYMENTS_TRANSACTIONS.DATE_MODIFIED
     , PAYMENTS_TRANSACTIONS.DESCRIPTION
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
  from            PAYMENTS_TRANSACTIONS
       inner join PAYMENTS
               on PAYMENTS.ID                  = PAYMENTS_TRANSACTIONS.PAYMENT_ID
              and PAYMENTS.DELETED             = 0
  left outer join INVOICES_PAYMENTS
               on INVOICES_PAYMENTS.PAYMENT_ID = PAYMENTS.ID
              and INVOICES_PAYMENTS.DELETED    = 0
  left outer join ACCOUNTS
               on ACCOUNTS.ID                  = PAYMENTS_TRANSACTIONS.ACCOUNT_ID
              and ACCOUNTS.DELETED             = 0
  left outer join CONTACTS
               on CONTACTS.ID                  = PAYMENTS_TRANSACTIONS.ACCOUNT_ID
              and CONTACTS.DELETED             = 0
  left outer join USERS                          USERS_CREATED_BY
               on USERS_CREATED_BY.ID          = PAYMENTS_TRANSACTIONS.CREATED_BY
 where PAYMENTS_TRANSACTIONS.DELETED = 0

GO

Grant Select on dbo.vwPAYMENTS_TRANSACTIONS to public;
GO

