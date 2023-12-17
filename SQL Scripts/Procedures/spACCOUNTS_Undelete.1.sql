if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_Undelete;
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
-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
Create Procedure dbo.spACCOUNTS_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_BUGS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_BUGS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- 04/24/2018 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
	/*
	-- BEGIN Oracle Exception
		update ACCOUNTS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	*/
	-- BEGIN Oracle Exception
		update ACCOUNTS_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_OPPORTUNITIES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_OPPORTUNITIES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_ACCOUNTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from EMAILS_ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- 08/07/2013 Paul.  Mapping the account back is a bit more difficult in that we need the previous case record. 
	-- First we use a group clause to get the previous record version number. 
	-- Then we get the previous record and make sure that the previous relationship ID matches. 
	-- We will not check the deleted flag in the main table because the record may have been deleted as part of the transaction 
	-- and it may be undeleted as part of the new transaction. 
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CASES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from CASES
			 where ACCOUNT_ID       is null
			   and ID in (select CASES_AUDIT.ID
			                from      CASES_AUDIT
			               inner join (select CASES_AUDIT_PREVIOUS.ID, max(CASES_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
			                             from      CASES_AUDIT                          CASES_AUDIT_CURRENT
			                            inner join CASES_AUDIT                          CASES_AUDIT_PREVIOUS
			                                    on CASES_AUDIT_PREVIOUS.ID            = CASES_AUDIT_CURRENT.ID
			                                   and CASES_AUDIT_PREVIOUS.AUDIT_VERSION < CASES_AUDIT_CURRENT.AUDIT_VERSION
			                                 where CASES_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
			                                 group by CASES_AUDIT_PREVIOUS.ID
			                          )                                        CASES_AUDIT_PREV_VERSION
			                       on CASES_AUDIT_PREV_VERSION.ID            = CASES_AUDIT.ID
			               inner join CASES_AUDIT                              CASES_AUDIT_PREV_ACCOUNT
			                       on CASES_AUDIT_PREV_ACCOUNT.ID            = CASES_AUDIT_PREV_VERSION.ID
			                      and CASES_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = CASES_AUDIT_PREV_VERSION.AUDIT_VERSION
			                      and CASES_AUDIT_PREV_ACCOUNT.ACCOUNT_ID    = @ID
			                      and CASES_AUDIT_PREV_ACCOUNT.DELETED       = 0
			               where CASES_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
			             )
			);
		update CASES
		   set ACCOUNT_ID       = @ID
		     , ACCOUNT_NAME     = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       is null
		   and ID in (select CASES_AUDIT.ID
		                from      CASES_AUDIT
		               inner join (select CASES_AUDIT_PREVIOUS.ID, max(CASES_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      CASES_AUDIT                          CASES_AUDIT_CURRENT
		                            inner join CASES_AUDIT                          CASES_AUDIT_PREVIOUS
		                                    on CASES_AUDIT_PREVIOUS.ID            = CASES_AUDIT_CURRENT.ID
		                                   and CASES_AUDIT_PREVIOUS.AUDIT_VERSION < CASES_AUDIT_CURRENT.AUDIT_VERSION
		                                 where CASES_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by CASES_AUDIT_PREVIOUS.ID
		                          )                                        CASES_AUDIT_PREV_VERSION
		                       on CASES_AUDIT_PREV_VERSION.ID            = CASES_AUDIT.ID
		               inner join CASES_AUDIT                              CASES_AUDIT_PREV_ACCOUNT
		                       on CASES_AUDIT_PREV_ACCOUNT.ID            = CASES_AUDIT_PREV_VERSION.ID
		                      and CASES_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = CASES_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and CASES_AUDIT_PREV_ACCOUNT.ACCOUNT_ID    = @ID
		                      and CASES_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where CASES_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update LEADS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from LEADS
			 where ACCOUNT_ID       is null
			   and ID in (select LEADS_AUDIT.ID
			                from      LEADS_AUDIT
			               inner join (select LEADS_AUDIT_PREVIOUS.ID, max(LEADS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
			                             from      LEADS_AUDIT                          LEADS_AUDIT_CURRENT
			                            inner join LEADS_AUDIT                          LEADS_AUDIT_PREVIOUS
			                                    on LEADS_AUDIT_PREVIOUS.ID            = LEADS_AUDIT_CURRENT.ID
			                                   and LEADS_AUDIT_PREVIOUS.AUDIT_VERSION < LEADS_AUDIT_CURRENT.AUDIT_VERSION
			                                 where LEADS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
			                                 group by LEADS_AUDIT_PREVIOUS.ID
			                          )                                        LEADS_AUDIT_PREV_VERSION
			                       on LEADS_AUDIT_PREV_VERSION.ID            = LEADS_AUDIT.ID
			               inner join LEADS_AUDIT                              LEADS_AUDIT_PREV_ACCOUNT
			                       on LEADS_AUDIT_PREV_ACCOUNT.ID            = LEADS_AUDIT_PREV_VERSION.ID
			                      and LEADS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = LEADS_AUDIT_PREV_VERSION.AUDIT_VERSION
			                      and LEADS_AUDIT_PREV_ACCOUNT.ACCOUNT_ID    = @ID
			                      and LEADS_AUDIT_PREV_ACCOUNT.DELETED       = 0
			               where LEADS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
			             )
			);
		update LEADS
		   set ACCOUNT_ID       = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       is null
		   and ID in (select LEADS_AUDIT.ID
		                from      LEADS_AUDIT
		               inner join (select LEADS_AUDIT_PREVIOUS.ID, max(LEADS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      LEADS_AUDIT                          LEADS_AUDIT_CURRENT
		                            inner join LEADS_AUDIT                          LEADS_AUDIT_PREVIOUS
		                                    on LEADS_AUDIT_PREVIOUS.ID            = LEADS_AUDIT_CURRENT.ID
		                                   and LEADS_AUDIT_PREVIOUS.AUDIT_VERSION < LEADS_AUDIT_CURRENT.AUDIT_VERSION
		                                 where LEADS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by LEADS_AUDIT_PREVIOUS.ID
		                          )                                        LEADS_AUDIT_PREV_VERSION
		                       on LEADS_AUDIT_PREV_VERSION.ID            = LEADS_AUDIT.ID
		               inner join LEADS_AUDIT                              LEADS_AUDIT_PREV_ACCOUNT
		                       on LEADS_AUDIT_PREV_ACCOUNT.ID            = LEADS_AUDIT_PREV_VERSION.ID
		                      and LEADS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = LEADS_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and LEADS_AUDIT_PREV_ACCOUNT.ACCOUNT_ID    = @ID
		                      and LEADS_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where LEADS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update PRODUCT_TEMPLATES
		   set ACCOUNT_ID       = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       is null
		   and ID in (select PRODUCT_TEMPLATES_AUDIT.ID
		                from      PRODUCT_TEMPLATES_AUDIT
		               inner join (select PRODUCT_TEMPLATES_AUDIT_PREVIOUS.ID, max(PRODUCT_TEMPLATES_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      PRODUCT_TEMPLATES_AUDIT                          PRODUCT_TEMPLATES_AUDIT_CURRENT
		                            inner join PRODUCT_TEMPLATES_AUDIT                          PRODUCT_TEMPLATES_AUDIT_PREVIOUS
		                                    on PRODUCT_TEMPLATES_AUDIT_PREVIOUS.ID            = PRODUCT_TEMPLATES_AUDIT_CURRENT.ID
		                                   and PRODUCT_TEMPLATES_AUDIT_PREVIOUS.AUDIT_VERSION < PRODUCT_TEMPLATES_AUDIT_CURRENT.AUDIT_VERSION
		                                 where PRODUCT_TEMPLATES_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by PRODUCT_TEMPLATES_AUDIT_PREVIOUS.ID
		                          )                                        PRODUCT_TEMPLATES_AUDIT_PREV_VERSION
		                       on PRODUCT_TEMPLATES_AUDIT_PREV_VERSION.ID            = PRODUCT_TEMPLATES_AUDIT.ID
		               inner join PRODUCT_TEMPLATES_AUDIT                              PRODUCT_TEMPLATES_AUDIT_PREV_ACCOUNT
		                       on PRODUCT_TEMPLATES_AUDIT_PREV_ACCOUNT.ID            = PRODUCT_TEMPLATES_AUDIT_PREV_VERSION.ID
		                      and PRODUCT_TEMPLATES_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = PRODUCT_TEMPLATES_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and PRODUCT_TEMPLATES_AUDIT_PREV_ACCOUNT.ACCOUNT_ID    = @ID 
		                      and PRODUCT_TEMPLATES_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where PRODUCT_TEMPLATES_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update INVOICES_ACCOUNTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from INVOICES_ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update INVOICES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from INVOICES
			 where ID in (select INVOICE_ID from INVOICES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
			   and DELETED          = 1
			   and ID in (select ID from INVOICES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN)
			);
		update INVOICES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID in (select INVOICE_ID from INVOICES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
		   and DELETED          = 1
		   and ID in (select ID from INVOICES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ORDERS_ACCOUNTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ORDERS_ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update ORDERS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from ORDERS
			 where ID in (select ORDER_ID from ORDERS_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
			   and DELETED          = 1
			   and ID in (select ID from ORDERS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN)
			);
		update ORDERS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID in (select ORDER_ID from ORDERS_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
		   and DELETED          = 1
		   and ID in (select ID from ORDERS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update QUOTES_ACCOUNTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update QUOTES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from QUOTES
			 where ID in (select QUOTE_ID from QUOTES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
			   and DELETED          = 1
			   and ID in (select ID from QUOTES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN)
			);
		update QUOTES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID in (select QUOTE_ID from QUOTES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_THREADS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_THREADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CONTRACTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from CONTRACTS
			 where ACCOUNT_ID       = @ID
			   and DELETED          = 1
			   and ID in (select ID from CONTRACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID)
			);
		update CONTRACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTRACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- 08/08/2013 Paul.  PRODUCTS has been deprecated, so there is no need to undelete. 
	/*
		update PRODUCTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from PRODUCTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	*/
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CREDIT_CARDS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from CREDIT_CARDS
			 where ACCOUNT_ID       = @ID
			   and DELETED          = 1
			   and ID in (select ID from CREDIT_CARDS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID)
			);
		update CREDIT_CARDS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CREDIT_CARDS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update PAYMENTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from PAYMENTS
			 where ACCOUNT_ID       = @ID
			   and DELETED          = 1
			   and ID in (select ID from PAYMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID)
			);
		update PAYMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from PAYMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ACCOUNT_ID = @ID);
	-- END Oracle Exception
	
	exec dbo.spPARENT_Undelete @ID, @MODIFIED_USER_ID, @AUDIT_TOKEN, N'Accounts';
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update ACCOUNTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from ACCOUNTS
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update ACCOUNTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception

  end
GO

Grant Execute on dbo.spACCOUNTS_Undelete to public;
GO

