

print 'SYSTEM_SYNC_TABLES Professional';
-- delete from SYSTEM_SYNC_TABLES
--GO

set nocount on;
GO

-- 01/12/2010 Paul.  Remove the ID first parameter. 
-- System Tables
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACT_TYPES'                , 'CONTRACT_TYPES'                , 'ContractTypes'            , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'FORUM_TOPICS'                  , 'FORUM_TOPICS'                  , 'ForumTopics'              , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MANUFACTURERS'                 , 'MANUFACTURERS'                 , 'Manufacturers'            , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PRODUCT_CATEGORIES'            , 'PRODUCT_CATEGORIES'            , 'ProductCategories'        , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PRODUCT_TEMPLATES'             , 'PRODUCT_TEMPLATES'             , 'ProductCatalog'           , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PRODUCT_TYPES'                 , 'PRODUCT_TYPES'                 , 'ProductTypes'             , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'SHIPPERS'                      , 'SHIPPERS'                      , 'Shippers'                 , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TAX_RATES'                     , 'TAX_RATES'                     , 'TaxRates'                 , null                       , 0, null, 1, 0, null, 0;
-- 12/05/2010 Paul.  Add Discounts, PaymentGateways and REGIONS tables. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DISCOUNTS'                     , 'DISCOUNTS'                     , 'Discounts'                , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PAYMENT_GATEWAYS'              , 'PAYMENT_GATEWAYS'              , 'PaymentGateways'          , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'REGIONS'                       , 'REGIONS'                       , 'Regions'                  , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'REGIONS_COUNTRIES'             , 'REGIONS_COUNTRIES'             , 'Regions'                  , null                       , 0, null, 1, 0, null, 0;
GO

-- User Tables
-- delete from SYSTEM_SYNC_TABLES where TABLE_NAME in ('TEAM_MEMBERSHIPS', 'TEAM_SETS_TEAMS', 'TEAM_NOTICES');
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TEAM_MEMBERSHIPS'              , 'TEAM_MEMBERSHIPS'              , 'Teams'                    , null                       , 0, null, 1, 1, 'USER_ID', 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TEAM_NOTICES'                  , 'TEAM_NOTICES'                  , null                       , 'Teams'                    , 0, null, 1, 0, null, 1;
-- 11/26/2009 Paul.  TEAM_SETS_TEAMS needs to be treated as a non-system table so that it will get updated with module updates. 
-- 08/27/2014 Paul.  Back to treating TEAM_SETS as a system table.  We update with regular modules by hard-coding into client side query. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TEAM_SETS_TEAMS'               , 'TEAM_SETS_TEAMS'               , null                       , 'Teams'                    , 0, null, 1, 0, null, 1;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'TEAM_SETS_TEAMS' and IS_SYSTEM = 0 and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set IS_SYSTEM         = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where TABLE_NAME        = 'TEAM_SETS_TEAMS'
	   and IS_SYSTEM         = 0
	   and DELETED           = 0;
end -- if;
GO

-- Module Tables
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACTS'                     , 'CONTRACTS'                     , 'Contracts'                , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'FORUMS'                        , 'FORUMS'                        , 'Forums'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'INVOICES'                      , 'INVOICES'                      , 'Invoices'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'KBDOCUMENTS'                   , 'KBDOCUMENTS'                   , 'KBDocuments'              , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'KBTAGS'                        , 'KBTAGS'                        , 'KBTags'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ORDERS'                        , 'ORDERS'                        , 'Orders'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PAYMENTS'                      , 'PAYMENTS'                      , 'Payments'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'POSTS'                         , 'POSTS'                         , 'Posts'                    , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'QUOTES'                        , 'QUOTES'                        , 'Quotes'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
--exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'REPORTS'                     , 'REPORTS'                       , 'Reports'                  , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'THREADS'                       , 'THREADS'                       , 'Threads'                  , null                       , 0, null, 0, 0, null, 0;
GO

-- Relationship Tables
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS_THREADS'              , 'ACCOUNTS_THREADS'              , 'Accounts'                 , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'BUGS_THREADS'                  , 'BUGS_THREADS'                  , 'Bugs'                     , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CASES_THREADS'                 , 'CASES_THREADS'                 , 'Cases'                    , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACT_TYPES_DOCUMENTS'      , 'CONTRACT_TYPES_DOCUMENTS'      , 'ContractTypes'            , 'Documents'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACTS_CONTACTS'            , 'CONTRACTS_CONTACTS'            , 'Contracts'                , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACTS_DOCUMENTS'           , 'CONTRACTS_DOCUMENTS'           , 'Contracts'                , 'Documents'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACTS_OPPORTUNITIES'       , 'CONTRACTS_OPPORTUNITIES'       , 'Contracts'                , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACTS_PRODUCTS'            , 'CONTRACTS_PRODUCTS'            , 'Contracts'                , 'Products'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTRACTS_QUOTES'              , 'CONTRACTS_QUOTES'              , 'Contracts'                , 'Quotes'                   , 0, null, 0, 0, null, 1;
-- 09/15/2012 Paul.  New tables for Accounts, Bugs, Cases, Contacts, Contracts, Leads, Opportunities, Quotes. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_CONTRACTS'           , 'DOCUMENTS_CONTRACTS'           , 'Documents'                , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_QUOTES'              , 'DOCUMENTS_QUOTES'              , 'Documents'                , 'Quotes'                   , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_CONTRACTS'              , 'EMAILS_CONTRACTS'              , 'Emails'                   , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_QUOTES'                 , 'EMAILS_QUOTES'                 , 'Emails'                   , 'Quotes'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'INVOICES_ACCOUNTS'             , 'INVOICES_ACCOUNTS'             , 'Invoices'                 , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'INVOICES_CONTACTS'             , 'INVOICES_CONTACTS'             , 'Invoices'                 , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'INVOICES_LINE_ITEMS'           , 'INVOICES_LINE_ITEMS'           , 'InvoicesLineItems'        , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'INVOICES_PAYMENTS'             , 'INVOICES_PAYMENTS'             , 'Invoices'                 , 'Payments'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'KBDOCUMENTS_KBTAGS'            , 'KBDOCUMENTS_KBTAGS'            , 'KBDocuments'              , 'KBTags'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'LEADS_THREADS'                 , 'LEADS_THREADS'                 , 'Leads'                    , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'OPPORTUNITIES_THREADS'         , 'OPPORTUNITIES_THREADS'         , 'Opportunities'            , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ORDERS_ACCOUNTS'               , 'ORDERS_ACCOUNTS'               , 'Orders'                   , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ORDERS_CONTACTS'               , 'ORDERS_CONTACTS'               , 'Orders'                   , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ORDERS_LINE_ITEMS'             , 'ORDERS_LINE_ITEMS'             , 'OrdersLineItems'          , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ORDERS_OPPORTUNITIES'          , 'ORDERS_OPPORTUNITIES'          , 'Orders'                   , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECT_THREADS'               , 'PROJECT_THREADS'               , 'Project'                  , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'QUOTES_ACCOUNTS'               , 'QUOTES_ACCOUNTS'               , 'Quotes'                   , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'QUOTES_CONTACTS'               , 'QUOTES_CONTACTS'               , 'Quotes'                   , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'QUOTES_LINE_ITEMS'             , 'QUOTES_LINE_ITEMS'             , 'QuotesLineItems'          , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'QUOTES_OPPORTUNITIES'          , 'QUOTES_OPPORTUNITIES'          , 'Quotes'                   , 'Opportunities'            , 0, null, 0, 0, null, 1;
-- 09/15/2012 Paul.  New tables for Accounts, Bugs, Cases, Contacts, Opportunities, ProjectTask, Threads, Quotes. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_THREADS'              , 'PROJECTS_THREADS'              , 'Project'                  , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_QUOTES'               , 'PROJECTS_QUOTES'               , 'Project'                  , 'Quotes'                   , 0, null, 0, 0, null, 1;
GO

set nocount off;
GO

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spSYSTEM_SYNC_TABLES_Professional()
/

call dbo.spSqlDropProcedure('spSYSTEM_SYNC_TABLES_Professional')
/

-- #endif IBM_DB2 */

