if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_Delete;
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
-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
Create Procedure dbo.spACCOUNTS_Delete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- 08/10/2013 Paul.  Delete Documents relationship. 
	-- BEGIN Oracle Exception
		update ACCOUNTS_DOCUMENTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
	-- BEGIN Oracle Exception
		update ACCOUNTS_BUGS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 04/24/2018 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
	/*
	-- BEGIN Oracle Exception
		update ACCOUNTS_CASES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	*/
	-- BEGIN Oracle Exception
		update ACCOUNTS_CONTACTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_OPPORTUNITIES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_ACCOUNTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update CASES_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from CASES
			  where ACCOUNT_ID       = @ID
			    and DELETED          = 0
			);
		update CASES
		   set ACCOUNT_ID       = null
		     , ACCOUNT_NAME     = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update LEADS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from LEADS
			  where ACCOUNT_ID       = @ID
			    and DELETED          = 0
			);
		update LEADS
		   set ACCOUNT_ID       = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 12/14/2008 Paul.  Delete records from quotes, orders and invoices. 
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update PRODUCT_TEMPLATES_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from PRODUCT_TEMPLATES
			  where ACCOUNT_ID       = @ID
			    and DELETED          = 0
			);
		update PRODUCT_TEMPLATES
		   set ACCOUNT_ID       = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update INVOICES_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from INVOICES
			  where ID in (select INVOICE_ID from INVOICES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
			    and DELETED          = 0
			);
		update INVOICES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID in (select INVOICE_ID from INVOICES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update INVOICES_ACCOUNTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update ORDERS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from ORDERS
			  where ID in (select ORDER_ID from ORDERS_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
			    and DELETED          = 0
			);
		update ORDERS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID in (select ORDER_ID from ORDERS_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ORDERS_ACCOUNTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update QUOTES_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from QUOTES
			  where ID in (select QUOTE_ID from QUOTES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
			    and DELETED          = 0
			);
		update QUOTES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID in (select QUOTE_ID from QUOTES_ACCOUNTS where ACCOUNT_ID = @ID and DELETED = 0)
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update QUOTES_ACCOUNTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_THREADS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update CONTRACTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from CONTRACTS
			  where ACCOUNT_ID       = @ID
			    and DELETED          = 0
			);
		update CONTRACTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 08/08/2013 Paul.  PRODUCTS has been deprecated, so there is no need to delete. 
	/*
		update PRODUCTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	*/
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update CREDIT_CARDS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from CREDIT_CARDS
			  where ACCOUNT_ID       = @ID
			    and DELETED          = 0
			);
		update CREDIT_CARDS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update PAYMENTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from PAYMENTS
			  where ACCOUNT_ID       = @ID
			    and DELETED          = 0
			);
		update PAYMENTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from TRACKER
		 where ITEM_ID          = @ID
		   and USER_ID          = @MODIFIED_USER_ID;
	-- END Oracle Exception
	
	exec dbo.spPARENT_Delete @ID, @MODIFIED_USER_ID;
	
	-- BEGIN Oracle Exception
		update ACCOUNTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 0;

		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update ACCOUNTS_CSTM
		   set ID_C             = ID_C
		 where ID_C             = @ID;
	-- END Oracle Exception

	-- 10/13/2015 Paul.  We need to delete all favorite records. 
	-- BEGIN Oracle Exception
		update SUGARFAVORITES
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where RECORD_ID         = @ID
		   and DELETED           = 0;
	-- END Oracle Exception
  end
GO

Grant Execute on dbo.spACCOUNTS_Delete to public;
GO

