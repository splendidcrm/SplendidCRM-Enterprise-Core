

print 'SYSTEM_REST_TABLES Professional';
-- delete from SYSTEM_REST_TABLES
--GO

set nocount on;
GO

-- 06/18/2011 Paul.  SYSTEM_REST_TABLES are nearly identical to SYSTEM_SYNC_TABLES,
-- but the Module tables typically refer to the base view instead of the raw table. 
-- 06/18/2011 Paul.  We do not anticipate a need access to all the system tables via the REST API. 

-- System Tables
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'CONTRACT_TYPES'                  , 'vwCONTRACT_TYPES'                , 'ContractTypes'            , null                       , 0, null, 1, 0, null, 0;
--exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'FORUM_TOPICS'                    , 'vwFORUM_TOPICS'                  , 'ForumTopics'              , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'MANUFACTURERS'                   , 'vwMANUFACTURERS'                 , 'Manufacturers'            , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PRODUCT_CATEGORIES'              , 'vwPRODUCT_CATEGORIES'            , 'ProductCategories'        , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PRODUCT_TEMPLATES'               , 'vwPRODUCT_TEMPLATES'             , 'ProductCatalog'           , null                       , 0, null, 1, 0, null, 0;
-- 02/29/2016 Paul.  Product Catalog is different than Product Templates. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PRODUCT_CATALOG'                 , 'vwPRODUCT_TEMPLATES_Catalog'     , 'ProductCatalog'           , null                       , 0, null, 1, 0, null, 0;
-- 04/10/2021 Paul.  Products is needed by the React client Precompile. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PRODUCTS'                        , 'vwPRODUCTS'                      , 'Products'                 , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PRODUCT_TYPES'                   , 'vwPRODUCT_TYPES'                 , 'ProductTypes'             , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SHIPPERS'                        , 'vwSHIPPERS'                      , 'Shippers'                 , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'TAX_RATES'                       , 'vwTAX_RATES'                     , 'TaxRates'                 , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'DISCOUNTS'                       , 'vwDISCOUNTS'                     , 'Discounts'                , null                       , 0, null, 1, 0, null, 0;
-- 10/14/2020 Paul.  Not sure why regions and countries were disabled. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPAYMENT_GATEWAYS'              , 'vwPAYMENT_GATEWAYS'              , 'PaymentGateways'          , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'REGIONS'                         , 'vwREGIONS'                       , 'Regions'                  , null                       , 0, null, 1, 0, null, 0;
-- 10/16/2020 Paul.  The default behavior for a relationship view is to request the view, not the table. 
if exists(select * from SYSTEM_REST_TABLES where TABLE_NAME = 'REGIONS_COUNTRIES' and DELETED = 0) begin -- then
	update SYSTEM_REST_TABLES
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where TABLE_NAME        = 'REGIONS_COUNTRIES'
	   and DELETED           = 0;
end -- if;
-- 10/16/2020 Paul.  vwREGIONS_COUNTRIES is not a typical relationship table.  It uses terminology. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwREGIONS_COUNTRIES'             , 'vwREGIONS_COUNTRIES'             , 'Regions'                  , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwTEAMS_REGIONS'                 , 'vwTEAMS_REGIONS'                 , 'Teams'                    , 'Regions'                  , 0, null, 1, 0, null, 1;
GO

-- User Tables
--exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'TEAM_MEMBERSHIPS'                , 'vwTEAM_MEMBERSHIPS'              , 'Teams'                    , null                       , 0, null, 1, 1, 'USER_ID', 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'TEAM_NOTICES'                    , 'vwTEAM_NOTICES'                  , 'Teams'                    , 'TeamNotices'              , 0, null, 1, 0, null, 1;
--exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'TEAM_SETS_TEAMS'                 , 'vwTEAM_SETS_TEAMS'               , null                       , 'Teams'                    , 0, null, 0, 0, null, 1;
-- 04/19/2016 Paul.  Allow team lookup by zip code. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwTEAMS_ZIPCODES'                , 'vwTEAMS_ZIPCODES'                , 'Teams'                    , 'ZipCodes'                 , 0, null, 1, 0, null, 0;
-- 09/13/2019 Paul.  React Client needs access to user memberships.  USER_ID will be a required field. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwUSERS_TEAM_MEMBERSHIPS'        , 'vwUSERS_TEAM_MEMBERSHIPS'        , 'Users'                    , 'Teams'                    , 0, null, 0, 0, 'USER_ID', 1, 'USER_ID';
-- 10/14/2020 Paul.  vwTEAM_MEMBERSHIPS_List is needed by the React Client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwTEAM_MEMBERSHIPS_List'         , 'vwTEAM_MEMBERSHIPS_List'         , 'Teams'                    , 'Users'                    , 0, null, 1, 0, null, 1;
GO

-- Module Tables
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'CONTRACTS'                       , 'vwCONTRACTS'                     , 'Contracts'                , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 04/10/2021 Paul.  Enable FORUMS for the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'FORUMS'                          , 'vwFORUMS'                        , 'Forums'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'INVOICES'                        , 'vwINVOICES'                      , 'Invoices'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'KBDOCUMENTS'                     , 'vwKBDOCUMENTS'                   , 'KBDocuments'              , null                       , 0, null, 0, 0, null, 0;
-- 05/03/2020 Paul.  The React Client needs access to the KBDocuments Attachments, in part for email creating. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwKBDOCUMENTS_ATTACHMENTS'       , 'vwKBDOCUMENTS_ATTACHMENTS'       , 'KBDocuments'              , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'KBTAGS'                          , 'vwKBTAGS'                        , 'KBTags'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'ORDERS'                          , 'vwORDERS'                        , 'Orders'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PAYMENTS'                        , 'vwPAYMENTS'                      , 'Payments'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 04/10/2021 Paul.  Enable POSTS for the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'POSTS'                           , 'vwPOSTS'                         , 'Posts'                    , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'QUOTES'                          , 'vwQUOTES'                        , 'Quotes'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 08/18/2019 Paul.  Enable Reports and Charts on React Client. 
-- 08/18/2019 Paul.  We can't support both Reports and ReportDesigner, so just go with ReportDesigner. 
--exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'REPORTS'                         , 'vwREPORTS'                       , 'Reports'                  , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'REPORTS'                         , 'vwREPORTS'                       , 'ReportDesigner'           , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'CHARTS'                          , 'vwCHARTS'                        , 'Charts'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 05/19/2021 Paul.  ReportRules is needed by the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwREPORT_RULES'                  , 'vwREPORT_RULES'                  , 'ReportRules'              , null                       , 0, null, 0, 0, null, 0;
-- 06/06/2021 Paul.  BusinessRules is needed by the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwBUSINESS_RULES'                , 'vwBUSINESS_RULES'                , 'BusinessRules'            , null                       , 0, null, 0, 0, null, 0;

-- 04/10/2021 Paul.  Enable THREADS for the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'THREADS'                         , 'vwTHREADS'                       , 'Threads'                  , null                       , 0, null, 0, 0, null, 0;
-- 07/19/2020 Paul.  The React Client needs access to SmsMessages and TwitterMessages. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'TWITTER_TRACKS'                  , 'vwTWITTER_TRACKS'                , 'TwitterTracks'            , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
GO

-- 03/30/2016 Paul.  Convert requires special processing. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwOPPORTUNITIES_ConvertToOrder'  , 'vwOPPORTUNITIES_ConvertToOrder'  , 'Opportunities'            , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ConvertToOpportunity'   , 'vwQUOTES_ConvertToOpportunity'   , 'Quotes'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ConvertToOrder'         , 'vwQUOTES_ConvertToOrder'         , 'Quotes'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ConvertToInvoice'       , 'vwQUOTES_ConvertToInvoice'       , 'Quotes'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_ConvertToInvoice'       , 'vwORDERS_ConvertToInvoice'       , 'Orders'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
GO

-- Relationship Tables
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_BALANCE'              , 'vwACCOUNTS_BALANCE'              , 'Accounts'                 , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_CONTRACTS'            , 'vwACCOUNTS_CONTRACTS'            , 'Accounts'                 , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_INVOICES'             , 'vwACCOUNTS_INVOICES'             , 'Accounts'                 , 'Invoices'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_ORDERS'               , 'vwACCOUNTS_ORDERS'               , 'Accounts'                 , 'Orders'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_PAYMENTS'             , 'vwACCOUNTS_PAYMENTS'             , 'Accounts'                 , 'Payments'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_PRODUCTS'             , 'vwACCOUNTS_PRODUCTS'             , 'Accounts'                 , 'OrdersLineItems'          , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_QUOTES'               , 'vwACCOUNTS_QUOTES'               , 'Accounts'                 , 'Quotes'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_THREADS'              , 'vwACCOUNTS_THREADS'              , 'Accounts'                 , 'Threads'                  , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwBUGS_THREADS'                  , 'vwBUGS_THREADS'                  , 'Bugs'                     , 'Threads'                  , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCASES_THREADS'                 , 'vwCASES_THREADS'                 , 'Cases'                    , 'Threads'                  , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTACTS_INVOICES'             , 'vwCONTACTS_INVOICES'             , 'Contacts'                 , 'Invoices'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTACTS_ORDERS'               , 'vwCONTACTS_ORDERS'               , 'Contacts'                 , 'Orders'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTACTS_PRODUCTS'             , 'vwCONTACTS_PRODUCTS'             , 'Contacts'                 , 'OrdersLineItems'          , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTACTS_QUOTES'               , 'vwCONTACTS_QUOTES'               , 'Contacts'                 , 'Quotes'                   , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_ACTIVITIES'          , 'vwCONTRACTS_ACTIVITIES'          , 'Contracts'                , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_ACTIVITIES_HISTORY'  , 'vwCONTRACTS_ACTIVITIES_HISTORY'  , 'Contracts'                , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_ACTIVITIES_OPEN'     , 'vwCONTRACTS_ACTIVITIES_OPEN'     , 'Contracts'                , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_NOTES'               , 'vwCONTRACTS_NOTES'               , 'Contracts'                , 'Notes'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_CONTACTS'            , 'vwCONTRACTS_CONTACTS'            , 'Contracts'                , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_DOCUMENTS'           , 'vwCONTRACTS_DOCUMENTS'           , 'Contracts'                , 'Documents'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_OPPORTUNITIES'       , 'vwCONTRACTS_OPPORTUNITIES'       , 'Contracts'                , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_PRODUCTS'            , 'vwCONTRACTS_PRODUCTS'            , 'Contracts'                , 'OrdersLineItems'          , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACTS_QUOTES'              , 'vwCONTRACTS_QUOTES'              , 'Contracts'                , 'Quotes'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTRACT_TYPES_DOCUMENTS'      , 'vwCONTRACT_TYPES_DOCUMENTS'      , 'ContractTypes'            , 'Documents'                , 0, null, 0, 0, null, 1;

-- 09/15/2012 Paul.  New tables for Accounts, Bugs, Cases, Contacts, Contracts, Leads, Opportunities, Quotes. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDOCUMENTS_CONTRACTS'           , 'vwDOCUMENTS_CONTRACTS'           , 'Documents'                , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDOCUMENTS_QUOTES'              , 'vwDOCUMENTS_QUOTES'              , 'Documents'                , 'Quotes'                   , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwEMAILS_CONTRACTS'              , 'vwEMAILS_CONTRACTS'              , 'Emails'                   , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwEMAILS_QUOTES'                 , 'vwEMAILS_QUOTES'                 , 'Emails'                   , 'Quotes'                   , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_ACTIVITIES'           , 'vwINVOICES_ACTIVITIES'           , 'Invoices'                 , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_ACTIVITIES_HISTORY'   , 'vwINVOICES_ACTIVITIES_HISTORY'   , 'Invoices'                 , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_ACTIVITIES_OPEN'      , 'vwINVOICES_ACTIVITIES_OPEN'      , 'Invoices'                 , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_ACCOUNTS'             , 'vwINVOICES_ACCOUNTS'             , 'Invoices'                 , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_CASES'                , 'vwINVOICES_CASES'                , 'Invoices'                 , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_CONTACTS'             , 'vwINVOICES_CONTACTS'             , 'Invoices'                 , 'Contacts'                 , 0, null, 0, 0, null, 1;
-- 06/05/2014 Paul.  Line Items is not a relationship table. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'INVOICES_LINE_ITEMS'             , 'vwINVOICES_LINE_ITEMS'           , 'InvoicesLineItems'        , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_PAYMENTS'             , 'vwINVOICES_PAYMENTS'             , 'Invoices'                 , 'Payments'                 , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwKBDOCUMENTS_KBTAGS'            , 'vwKBDOCUMENTS_KBTAGS'            , 'KBDocuments'              , 'KBTags'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwLEADS_THREADS'                 , 'vwLEADS_THREADS'                 , 'Leads'                    , 'Threads'                  , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwOPPORTUNITIES_CONTRACTS'       , 'vwOPPORTUNITIES_CONTRACTS'       , 'Opportunities'            , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwOPPORTUNITIES_QUOTES'          , 'vwOPPORTUNITIES_QUOTES'          , 'Opportunities'            , 'Quotes'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwOPPORTUNITIES_THREADS'         , 'vwOPPORTUNITIES_THREADS'         , 'Opportunities'            , 'Threads'                  , 0, null, 0, 0, null, 1;
-- 03/05/2016 Paul.  Line Items is not a relationship table. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'OPPORTUNITIES_LINE_ITEMS'        , 'vwOPPORTUNITIES_LINE_ITEMS'      , 'OpportunitiesLineItems'   , null                       , 0, null, 0, 0, null, 0;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_ACTIVITIES'             , 'vwORDERS_ACTIVITIES'             , 'Orders'                   , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_ACTIVITIES_HISTORY'     , 'vwORDERS_ACTIVITIES_HISTORY'     , 'Orders'                   , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_ACTIVITIES_OPEN'        , 'vwORDERS_ACTIVITIES_OPEN'        , 'Orders'                   , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_ACCOUNTS'               , 'vwORDERS_ACCOUNTS'               , 'Orders'                   , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_CASES'                  , 'vwORDERS_CASES'                  , 'Orders'                   , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_CONTACTS'               , 'vwORDERS_CONTACTS'               , 'Orders'                   , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_INVOICES'               , 'vwORDERS_INVOICES'               , 'Orders'                   , 'Invoices'                 , 0, null, 0, 0, null, 1;
-- 06/05/2014 Paul.  Line Items is not a relationship table. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'ORDERS_LINE_ITEMS'               , 'vwORDERS_LINE_ITEMS'             , 'OrdersLineItems'          , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_OPPORTUNITIES'          , 'vwORDERS_OPPORTUNITIES'          , 'Orders'                   , 'Opportunities'            , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROJECTS_QUOTES'               , 'vwPROJECTS_QUOTES'               , 'Project'                  , 'Quotes'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROJECTS_THREADS'              , 'vwPROJECTS_THREADS'              , 'Project'                  , 'Threads'                  , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ACTIVITIES'             , 'vwQUOTES_ACTIVITIES'             , 'Quotes'                   , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ACTIVITIES_HISTORY'     , 'vwQUOTES_ACTIVITIES_HISTORY'     , 'Quotes'                   , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ACTIVITIES_OPEN'        , 'vwQUOTES_ACTIVITIES_OPEN'        , 'Quotes'                   , 'Activities'               , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ACCOUNTS'               , 'vwQUOTES_ACCOUNTS'               , 'Quotes'                   , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_CASES'                  , 'vwQUOTES_CASES'                  , 'Quotes'                   , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_CONTACTS'               , 'vwQUOTES_CONTACTS'               , 'Quotes'                   , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_CONTRACTS'              , 'vwQUOTES_CONTRACTS'              , 'Quotes'                   , 'Contracts'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_DOCUMENTS'              , 'vwQUOTES_DOCUMENTS'              , 'Quotes'                   , 'Documents'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_INVOICES'               , 'vwQUOTES_INVOICES'               , 'Quotes'                   , 'Invoices'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_OPPORTUNITIES'          , 'vwQUOTES_OPPORTUNITIES'          , 'Quotes'                   , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_ORDERS'                 , 'vwQUOTES_ORDERS'                 , 'Quotes'                   , 'Orders'                   , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_PROJECTS'               , 'vwQUOTES_PROJECTS'               , 'Quotes'                   , 'Project'                  , 0, null, 0, 0, null, 1;
-- 06/05/2014 Paul.  Line Items is not a relationship table. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'QUOTES_LINE_ITEMS'               , 'vwQUOTES_LINE_ITEMS'             , 'QuotesLineItems'          , null                       , 0, null, 0, 0, null, 0;
-- 09/15/2012 Paul.  New tables for Accounts, Bugs, Cases, Contacts, Opportunities, ProjectTask, Threads, Quotes. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROJECTS_THREADS'              , 'vwPROJECTS_THREADS'              , 'Project'                  , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROJECTS_QUOTES'               , 'vwPROJECTS_QUOTES'               , 'Project'                  , 'Quotes'                   , 0, null, 0, 0, null, 1;
-- 04/13/2021 Paul.  Missing tables for the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwFORUMS_THREADS'                , 'vwFORUMS_THREADS'                , 'Forums'                   , 'Threads'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPAYMENTS_TRANSACTIONS'         , 'vwPAYMENTS_TRANSACTIONS'         , 'Payments'                 , null                       , 0, null, 0, 0, null, 1, 'PAYMENT_ID';
-- 05/06/2022 Paul.  Missing tables for the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPAYMENTS_INVOICES'             , 'vwPAYMENTS_INVOICES'             , 'Payments'                 , 'Invoices'                 , 0, null, 0, 0, null, 1, 'PAYMENT_ID';
GO

-- 06/03/2013 Paul.  Add Survey tables. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SURVEY_THEMES'                   , 'vwSURVEY_THEMES'                 , 'SurveyThemes'             , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SURVEYS'                         , 'vwSURVEYS'                       , 'Surveys'                  , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SURVEY_PAGES'                    , 'vwSURVEY_PAGES'                  , 'SurveyPages'              , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SURVEY_QUESTIONS'                , 'vwSURVEY_QUESTIONS'              , 'SurveyQuestions'          , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 04/10/2021 Paul.  SurveyResults.ListView is used in the React Client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SURVEY_RESULTS'                  , 'vwSURVEY_RESULTS'                , 'SurveyResults'            , null                       , 0, null, 0, 0, null, 0;
-- 04/14/2021 Paul.  vwSURVEY_RESULTS is used in subpanels, such as Targets.SurveyResults. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwSURVEY_RESULTS'                , 'vwSURVEY_RESULTS'                , 'SurveyResults'            , null                       , 0, null, 0, 0, null, 1, 'PARENT_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'SURVEY_QUESTIONS_RESULTS'        , 'vwSURVEY_QUESTIONS_RESULTS'      , 'SurveyResults'            , null                       , 0, null, 0, 0, null, 0;
-- 09/12/2019 Paul.  Users.SurveyResults is used in the React Client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwUSERS_SURVEY_RESULTS'          , 'vwUSERS_SURVEY_RESULTS'          , 'Users'                    , 'SurveyResults'            , 0, null, 0, 0, null, 1, 'USER_ID';
-- 11/28/2021 Paul.  vwCONTACTS_SURVEY_RESULTS was missing REQUIRED_FIELDS. 
if exists(select * from SYSTEM_REST_TABLES where TABLE_NAME = 'vwUSERS_SURVEY_RESULTS' and ASSIGNED_FIELD_NAME = 'USER_ID' and DELETED = 0) begin -- then
	update SYSTEM_REST_TABLES
	   set ASSIGNED_FIELD_NAME = null
	     , REQUIRED_FIELDS     = 'USER_ID'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	 where TABLE_NAME          = 'vwUSERS_SURVEY_RESULTS'
	   and DELETED             = 0;
end -- if;
-- 04/14/2021 Paul.  Missing table required by React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTACTS_SURVEY_RESULTS'       , 'vwCONTACTS_SURVEY_RESULTS'       , 'Contacts'                 , 'SurveyResults'            , 0, null, 0, 0, null, 1, 'CONTACT_ID';
-- 11/28/2021 Paul.  vwCONTACTS_SURVEY_RESULTS was missing REQUIRED_FIELDS. 
if exists(select * from SYSTEM_REST_TABLES where TABLE_NAME = 'vwCONTACTS_SURVEY_RESULTS' and ASSIGNED_FIELD_NAME = 'CONTACT_ID' and DELETED = 0) begin -- then
	update SYSTEM_REST_TABLES
	   set ASSIGNED_FIELD_NAME = null
	     , REQUIRED_FIELDS     = 'CONTACT_ID'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	 where TABLE_NAME          = 'vwCONTACTS_SURVEY_RESULTS'
	   and DELETED             = 0;
end -- if;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwLEADS_SURVEY_RESULTS'          , 'vwLEADS_SURVEY_RESULTS'          , 'Leads'                    , 'SurveyResults'            , 0, null, 0, 0, null, 1, 'LEAD_ID';
-- 11/28/2021 Paul.  vwLEADS_SURVEY_RESULTS was missing REQUIRED_FIELDS. 
if exists(select * from SYSTEM_REST_TABLES where TABLE_NAME = 'vwLEADS_SURVEY_RESULTS' and ASSIGNED_FIELD_NAME = 'CONTACT_ID' and DELETED = 0) begin -- then
	update SYSTEM_REST_TABLES
	   set ASSIGNED_FIELD_NAME = null
	     , REQUIRED_FIELDS     = 'LEAD_ID'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	 where TABLE_NAME          = 'vwLEADS_SURVEY_RESULTS'
	   and DELETED             = 0;
end -- if;
-- 11/28/2021 Paul.  Missing table required by React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROSPECTS_SURVEY_RESULTS'      , 'vwPROSPECTS_SURVEY_RESULTS'      , 'Prospects'                , 'SurveyResults'            , 0, null, 0, 0, null, 1, 'PROSPECT_ID';
-- 11/19/2019 Paul.  vwSURVEYS_SURVEY_PAGES is used in the React Client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwSURVEYS_SURVEY_PAGES'          , 'vwSURVEYS_SURVEY_PAGES'          , 'Surveys'                  , 'SurveyPages'              , 0, null, 0, 0, null, 1, 'SURVEY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwSURVEY_PAGES_QUESTIONS'        , 'vwSURVEY_PAGES_QUESTIONS'        , 'SurveyPages'              , 'SurveyQuestions'          , 0, null, 0, 0, null, 1, 'SURVEY_PAGE_ID';
-- 11/30/2019 Paul.  vwSURVEY_QUESTIONS_SURVEYS is used in the React Client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwSURVEY_QUESTIONS_SURVEYS'      , 'vwSURVEY_QUESTIONS_SURVEYS'      , 'SurveyQuestions'          , 'Surveys'                  , 0, null, 0, 0, null, 1, 'SURVEY_QUESTION_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPRODUCTS_NOTES'                , 'vwPRODUCTS_NOTES'                , 'Products'                 , 'Notes'                    , 0, null, 0, 0, null, 1, 'PRODUCT_ID';

-- 05/21/2017 Paul.  Add RevenueLineItems. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'REVENUE_LINE_ITEMS'              , 'vwREVENUE_LINE_ITEMS'            , 'RevenueLineItems'         , null                       , 0, null, 0, 0, null, 0;
-- 05/21/2017 Paul.  Add HTML5 Dashboard. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwREVENUE_ByLeadSource'          , 'vwREVENUE_ByLeadSource'          , 'Opportunities'            , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwREVENUE_ByLeadOutcome'         , 'vwREVENUE_ByLeadOutcome'         , 'Opportunities'            , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwREVENUE_Pipeline'              , 'vwREVENUE_Pipeline'              , 'Opportunities'            , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwREVENUE_PipelineMonth'         , 'vwREVENUE_PipelineMonth'         , 'Opportunities'            , null                       , 0, null, 0, 0, null, 0;
-- 06/13/2017 Paul.  HTML5 My Dashboard views. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwQUOTES_MyList'                 , 'vwQUOTES_MyList'                 , 'Quotes'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwORDERS_MyList'                 , 'vwORDERS_MyList'                 , 'Orders'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwINVOICES_MyList'               , 'vwINVOICES_MyList'               , 'Invoices'                 , null                       , 0, null, 0, 0, null, 0;
-- 02/23/2021 Paul.  vwCALL_DETAIL_RECORDS is used in the React Client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCALL_DETAIL_RECORDS'           , 'vwCALL_DETAIL_RECORDS'           , null                       , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwTWITTER_TRACK_MESSAGES'        , 'vwTWITTER_TRACK_MESSAGES'        , 'TwitterTracks'            , 'TwitterMessages'          , 0, null, 0, 0, null, 1, 'TWITTER_TRACK_ID';
GO

-- 03/11/2021 Paul.  All system tables will require registration. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PAYMENT_GATEWAYS'                , 'vwPAYMENT_GATEWAYS'              , 'PaymentGateway'           , null                       , 0, null, 1, 0, null, 0, null;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PAYMENT_TERMS'                   , 'vwPAYMENT_TERMS'                 , 'PaymentTerms'             , null                       , 0, null, 1, 0, null, 0, null;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PAYMENT_TYPES'                   , 'vwPAYMENT_TYPES'                 , 'PaymentTypes'             , null                       , 0, null, 1, 0, null, 0, null;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'OUTBOUND_EMAILS'                 , 'vwOUTBOUND_EMAILS'               , 'OutboundEmail'            , null                       , 0, null, 1, 0, null, 0, null;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'EXCHANGE_USERS'                  , 'vwUSERS_EXCHANGE'                , 'Exchange'                 , null                       , 0, null, 1, 0, null, 0, null;
-- 04/29/2021 Paul.  MailMerge views. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDOCUMENTS_MailMergeTemplates'  , 'vwDOCUMENTS_MailMergeTemplates'  , 'Documents'                , null                       , 0, null, 0, 0, null, 0, null;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROSPECT_LISTS_MailMerge'      , 'vwPROSPECT_LISTS_MailMerge'      , 'ProspectLists'            , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCAMPAIGNS_MailMerge'           , 'vwCAMPAIGNS_MailMerge'           , 'Campaigns'                , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 07/05/2021 Paul.  ExecProcedures. 
-- delete from SYSTEM_REST_TABLES where TABLE_NAME in ('spSURVEY_PAGES_QUESTIONS_Page', 'spSURVEYS_MovePage');
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spSURVEY_PAGES_QUESTIONS_Page'   , 'spSURVEY_PAGES_QUESTIONS_Page'   , 'SurveyPages'              , null                       , 0, null, 0, 0, null, 0, 'SURVEY_QUESTION_ID OLD_PAGE_ID NEW_PAGE_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spSURVEYS_MovePage'              , 'spSURVEYS_MovePage'              , 'Surveys'                  , null                       , 0, null, 0, 0, null, 0, 'ID OLD_NUMBER NEW_NUMBER';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spSURVEY_PAGES_MoveQuestion'     , 'spSURVEY_PAGES_MoveQuestion'     , 'SurveyPages'              , null                       , 0, null, 0, 0, null, 0, 'ID OLD_NUMBER NEW_NUMBER';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spSURVEYS_DeleteResults'         , 'spSURVEYS_DeleteResults'         , 'Surveys'                  , null                       , 0, null, 0, 0, null, 0, 'ID';

-- 11/18/2021 Paul.  Add support for CreditCards. 
-- 05/24/2024 Paul.  No longer require ACCOUNT_ID to view credit card. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'CREDIT_CARDS'                    , 'vwCREDIT_CARDS'                  , 'CreditCards'              , null                       , 0, null, 0, 0, null, 0, null;
if exists(select * from SYSTEM_REST_TABLES where TABLE_NAME = 'CREDIT_CARDS' and REQUIRED_FIELDS = 'ACCOUNT_ID' and DELETED = 0) begin -- then
	update SYSTEM_REST_TABLES
	   set REQUIRED_FIELDS     = null
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	 where TABLE_NAME          = 'CREDIT_CARDS'
	   and DELETED             = 0;
end -- if;
GO

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_CREDIT_CARDS'         , 'vwACCOUNTS_CREDIT_CARDS'         , 'Accounts'                 , 'CreditCards'              , 0, null, 0, 0, null, 1, 'ACCOUNT_ID';
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

call dbo.spSYSTEM_REST_TABLES_Professional()
/

call dbo.spSqlDropProcedure('spSYSTEM_REST_TABLES_Professional')
/

-- #endif IBM_DB2 */

