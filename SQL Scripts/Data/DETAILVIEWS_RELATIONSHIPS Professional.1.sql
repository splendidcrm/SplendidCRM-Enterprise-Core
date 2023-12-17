

print 'DETAILVIEWS_RELATIONSHIPS Professional';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 09/08/2007 Paul.  We need a title when we migrate to WebParts. 
-- 09/11/2007 Paul.  Make sure that the threads panels are added to the older relationships. 
-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
-- 11/30/2012 Paul.  Use separate panels for Open Activities and History Activities as the HTML5 Offline Client does not allow for a single Activities panel that combines both. 

-- 10/20/2006 Paul.  Fix Project module name. 
-- 09/11/2007 Paul.  Add the Orders panel to the Accounts DetailView. 
-- 02/09/2008 Paul.  Add credit card management. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
-- 09/23/2008 Paul.  Move professional modules to a separate file. 
-- 07/26/2009 Paul.  Fix the Title for the Balance control. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView' and MODULE_NAME in ('Quotes', 'Invoices', 'Orders') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Products'         , 'Products'           ,  8, 'Products.LBL_MODULE_NAME'         , 'vwACCOUNTS_PRODUCTS'    , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Quotes'           , 'Quotes'             ,  9, 'Quotes.LBL_MODULE_NAME'           , 'vwACCOUNTS_QUOTES'      , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Contracts'        , 'Contracts'          , 10, 'Contracts.LBL_MODULE_NAME'        , 'vwACCOUNTS_CONTRACTS'   , 'ACCOUNT_ID', 'CONTRACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Invoices'         , 'Invoices'           , 11, 'Invoices.LBL_MODULE_NAME'         , 'vwACCOUNTS_INVOICES'    , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Payments'         , 'Payments'           , 12, 'Payments.LBL_MODULE_NAME'         , 'vwACCOUNTS_PAYMENTS'    , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Threads'          , 'Threads'            , 13, 'Threads.LBL_MODULE_NAME'          , 'vwACCOUNTS_THREADS'     , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Orders'           , 'Orders'             , 14, 'Orders.LBL_MODULE_NAME'           , 'vwACCOUNTS_ORDERS'      , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'CreditCards'      , 'CreditCards'        , 15, 'CreditCards.LBL_MODULE_NAME'      , 'vwACCOUNTS_CREDIT_CARDS', 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'Payments'         , 'Balance'            , 16, 'Accounts.LBL_BALANCE'             , 'vwACCOUNTS_BALANCE'     , 'ACCOUNT_ID', 'BALANCE_DATE asc, NAME', 'asc';
end else begin
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView' and CONTROL_NAME = 'Balance' and TITLE = 'Payments.LBL_MODULE_NAME') begin -- then
		print N'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView: Fix Balance Title';
		update DETAILVIEWS_RELATIONSHIPS
		   set TITLE            = 'Accounts.LBL_BALANCE'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where DETAIL_NAME      = 'Accounts.DetailView'
		   and CONTROL_NAME     = 'Balance'
		   and TITLE            = 'Payments.LBL_MODULE_NAME'
		   and DELETED          = 0;
	end -- if;
	-- 10/27/2015 Paul.  Correct the sort fields for the Balance control. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView' and CONTROL_NAME = 'Balance' and SORT_FIELD is null) begin -- then
		print N'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView: Fix Balance sort fields';
		update DETAILVIEWS_RELATIONSHIPS
		   set SORT_FIELD       = 'BALANCE_DATE asc, NAME'
		     , SORT_DIRECTION   = 'asc'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where DETAIL_NAME      = 'Accounts.DetailView'
		   and CONTROL_NAME     = 'Balance'
		   and SORT_FIELD       is null
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- 07/15/2006 Paul.  Add Bugs.Threads to an existing installation. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Bugs.DetailView' and MODULE_NAME = 'Threads' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Bugs.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Bugs.DetailView'          , 'Threads'          , 'Threads'            ,  4, 'Threads.LBL_MODULE_NAME'          , 'vwBUGS_THREADS', 'BUG_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 07/15/2006 Paul.  Add Cases.Threads to an existing installation. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Cases.DetailView' and MODULE_NAME = 'Threads' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Cases.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Cases.DetailView'         , 'Threads'          , 'Threads'            ,  3, 'Threads.LBL_MODULE_NAME'          , 'vwCASES_THREADS', 'CASE_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 06/21/2011 Paul.  Add relationship between KBDocuments and Cases. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Cases.DetailView' and MODULE_NAME = 'KBDocuments' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Cases.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Cases.DetailView'         , 'KBDocuments'      , 'KBDocuments'        ,  4, 'KBDocuments.LBL_MODULE_NAME'      , 'vwCASES_KBDOCUMENTS', 'CASE_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'KBDocuments.DetailView' and MODULE_NAME = 'Cases' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS KBDocuments.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'KBDocuments.DetailView'   , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwKBDOCUMENTS_STREAM', 'ID'           , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'KBDocuments.DetailView'   , 'Cases'            , 'Cases'              ,  1, 'Cases.LBL_MODULE_NAME'            , 'vwKBDOCUMENTS_CASES' , 'KBDOCUMENT_ID', 'DATE_ENTERED', 'desc';
end else begin
	-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Bugs.DetailView' and CONTROL_NAME = 'ActivityStream' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Bugs.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'KBDocuments.DetailView'   , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwKBDOCUMENTS_STREAM', 'ID'           , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	end -- if;
end -- if;
GO

-- 07/13/2006 Paul.  Add Contacts.Products to an existing installation. 
-- 08/18/2010 Paul.  Add Contacts.Invoices relationship. 
-- 05/01/2013 Paul.  Add CreditCards but disable. 
-- 03/14/2016 Paul.  Allow a contract to be created from a Contact. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME in ('Products', 'Quotes') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Products'         , 'Products'           ,   7, 'Products.LBL_MODULE_NAME'        , 'vwCONTACTS_PRODUCTS'    , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Quotes'           , 'Quotes'             ,   8, 'Quotes.LBL_MODULE_NAME'          , 'vwCONTACTS_QUOTES'      , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Invoices'         , 'Invoices'           ,   9, 'Invoices.LBL_MODULE_NAME'        , 'vwCONTACTS_INVOICES'    , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Orders'           , 'Orders'             ,  10, 'Orders.LBL_MODULE_NAME'          , 'vwCONTACTS_ORDERS'      , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'CreditCards'      , 'CreditCards'        ,  11, 'CreditCards.LBL_MODULE_NAME'     , 'vwACCOUNTS_CREDIT_CARDS', 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Contracts'        , 'Contracts'          ,  12, 'Contracts.LBL_MODULE_NAME'       , 'vwCONTACTS_CONTRACTS'   , 'CONTACT_ID', 'CONTRACT_NAME'   , 'asc';
	-- 05/01/2013 Paul.  Add CreditCards but disable. 
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	 where DETAIL_NAME          = 'Contacts.DetailView'
	   and MODULE_NAME          = 'CreditCards'
	   and DELETED              = 0;
	-- 06/14/2016 Paul.  Add Contracts but disable. 
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	 where DETAIL_NAME          = 'Contacts.DetailView'
	   and MODULE_NAME          = 'Contracts'
	   and DELETED              = 0;
end else begin
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Invoices'         , 'Invoices'           , null, 'Invoices.LBL_MODULE_NAME'       , 'vwCONTACTS_INVOICES'    , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Orders'           , 'Orders'             , null, 'Orders.LBL_MODULE_NAME'         , 'vwCONTACTS_ORDERS'      , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME = 'CreditCards' and DELETED = 0) begin -- then
		-- 05/01/2013 Paul.  Add CreditCards but disable. 
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'CreditCards'      , 'CreditCards'        ,  null, 'CreditCards.LBL_MODULE_NAME'     , 'vwACCOUNTS_CREDIT_CARDS', 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ENABLED = 0
		 where DETAIL_NAME          = 'Contacts.DetailView'
		   and MODULE_NAME          = 'CreditCards'
		   and DELETED              = 0;
	end -- if;
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME = 'Contracts' and DELETED = 0) begin -- then
		-- 03/14/2016 Paul.  Allow a contract to be created from a Contact. 
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Contracts'        , 'Contracts'          ,  null, 'Contracts.LBL_MODULE_NAME'       , 'vwCONTACTS_CONTRACTS', 'CONTACT_ID', 'CONTRACT_NAME'    , 'asc';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ENABLED = 0
		 where DETAIL_NAME          = 'Contacts.DetailView'
		   and MODULE_NAME          = 'Contracts'
		   and DELETED              = 0;
	end -- if;
end -- if;
GO

-- 10/24/2014 Paul.  Add SurveyResults. 
-- 11/18/2021 Paul.  Sort by DATE_MODIFIED as DATE_ENTERED is not available in the view. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME = 'SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'SurveyResults'    , 'SurveyResults'      , null, 'SurveyResults.LBL_MODULE_NAME'   , 'vwCONTACTS_SURVEY_RESULTS' , 'CONTACT_ID', 'DATE_MODIFIED' , 'desc';
end else begin
	-- 11/18/2021 Paul.  Sort by DATE_MODIFIED as DATE_ENTERED is not available in the view. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME = 'SurveyResults' and (SORT_FIELD is null or SORT_FIELD = 'DATE_ENTERED') and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set SORT_FIELD         = 'DATE_MODIFIED'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Contacts.DetailView'
		   and MODULE_NAME        = 'SurveyResults'
		   and (SORT_FIELD is null or SORT_FIELD = 'DATE_ENTERED')
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 04/21/2006 Paul.  SugarCRM 4.2 has several more email relationships. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Emails.DetailView' and MODULE_NAME = 'Quotes' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Emails.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView'        , 'Quotes'           , 'Quotes'             , null, 'Quotes.LBL_MODULE_NAME'           , 'vwEMAILS_QUOTES'          , 'EMAIL_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 07/15/2006 Paul.  Add Leads.Threads to an existing installation. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and MODULE_NAME = 'Threads' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Leads.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView'         , 'Threads'          , 'Threads'            , null, 'Threads.LBL_MODULE_NAME'          , 'vwLEADS_THREADS'          , 'LEAD_ID', 'DATE_ENTERED' , 'desc';
end -- if;

-- 10/24/2014 Paul.  Add SurveyResults. 
-- 11/18/2021 Paul.  Sort by DATE_MODIFIED as DATE_ENTERED is not available in the view. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and MODULE_NAME = 'SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView'         , 'SurveyResults'    , 'SurveyResults'      , null, 'SurveyResults.LBL_MODULE_NAME'    , 'vwLEADS_SURVEY_RESULTS'   , 'LEAD_ID', 'DATE_MODIFIED' , 'desc';
end else begin
	-- 11/18/2021 Paul.  Sort by DATE_MODIFIED as DATE_ENTERED is not available in the view. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and MODULE_NAME = 'SurveyResults' and (SORT_FIELD is null or SORT_FIELD = 'DATE_ENTERED') and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set SORT_FIELD         = 'DATE_MODIFIED'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Leads.DetailView'
		   and MODULE_NAME        = 'SurveyResults'
		   and (SORT_FIELD is null or SORT_FIELD = 'DATE_ENTERED')
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 10/24/2014 Paul.  Add SurveyResults. 
-- 11/28/2021 Paul.  Correct table name to be vwPROSPECTS_SURVEY_RESULTS. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Prospects.DetailView' and MODULE_NAME = 'SurveyResults' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Prospects.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Prospects.DetailView'     , 'SurveyResults'    , 'SurveyResults'      , null, 'SurveyResults.LBL_MODULE_NAME'    , 'vwPROSPECTS_SURVEY_RESULTS', 'PROSPECT_ID', 'DATE_MODIFIED' , 'desc';
end else begin
	-- 11/28/2021 Paul.  Correct table name to be vwPROSPECTS_SURVEY_RESULTS. 
	-- 11/28/2021 Paul.  Correct primary field is PROSPECT_ID. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Prospects.DetailView' and MODULE_NAME = 'SurveyResults' and (TABLE_NAME <> 'vwPROSPECTS_SURVEY_RESULTS' or PRIMARY_FIELD <> 'PROSPECT_ID' or SORT_FIELD = 'DATE_ENTERED') and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwPROSPECTS_SURVEY_RESULTS'
		     , PRIMARY_FIELD      = 'PROSPECT_ID'
		     , SORT_FIELD         = 'DATE_MODIFIED'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Prospects.DetailView'
		   and MODULE_NAME        = 'SurveyResults'
		   and (TABLE_NAME        <> 'vwPROSPECTS_SURVEY_RESULTS' or PRIMARY_FIELD <> 'PROSPECT_ID' or SORT_FIELD = 'DATE_ENTERED')
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 10/24/2014 Paul.  Add SurveyResults. 
-- 11/18/2021 Paul.  Sort by DATE_MODIFIED as DATE_ENTERED is not available in the view. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Users.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Users.DetailView' and MODULE_NAME = 'SurveyResults' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Users.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Users.DetailView'         , 'SurveyResults'    , 'SurveyResults'      , null, 'SurveyResults.LBL_MODULE_NAME'    , 'vwUSERS_SURVEY_RESULTS'   , 'USER_ID'    , 'DATE_MODIFIED' , 'desc';
end else begin
	-- 11/18/2021 Paul.  Sort by DATE_MODIFIED as DATE_ENTERED is not available in the view. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Users.DetailView' and MODULE_NAME = 'SurveyResults' and (SORT_FIELD is null or SORT_FIELD = 'DATE_ENTERED') and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set SORT_FIELD         = 'DATE_MODIFIED'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Users.DetailView'
		   and MODULE_NAME        = 'SurveyResults'
		   and (SORT_FIELD is null or SORT_FIELD = 'DATE_ENTERED')
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Opportunities.DetailView' and MODULE_NAME in ('Quotes', 'Contracts', 'Threads') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Opportunities.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView' , 'Quotes'           , 'Quotes'             ,  4, 'Quotes.LBL_MODULE_NAME'           , 'vwOPPORTUNITIES_QUOTES'            , 'OPPORTUNITY_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView' , 'Contracts'        , 'Contracts'          ,  5, 'Contracts.LBL_MODULE_NAME'        , 'vwOPPORTUNITIES_CONTRACTS'         , 'OPPORTUNITY_ID', 'CONTRACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView' , 'Threads'          , 'Threads'            ,  6, 'Threads.LBL_MODULE_NAME'          , 'vwOPPORTUNITIES_THREADS'           , 'OPPORTUNITY_ID', 'DATE_ENTERED' , 'desc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Project.DetailView' and MODULE_NAME in ('Quotes', 'Threads') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Project.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Project.DetailView'       , 'Quotes'           , 'Quotes'             ,  5, 'Quotes.LBL_MODULE_NAME'           , 'vwPROJECTS_QUOTES' , 'PROJECT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Project.DetailView'       , 'Threads'          , 'Threads'            ,  6, 'Threads.LBL_MODULE_NAME'          , 'vwPROJECTS_THREADS', 'PROJECT_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 12/28/2007 Paul.  UnifiedSearch should be customizable. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.UnifiedSearch';
-- 01/01/2008 Paul.  We should not need to fix the search on a clean install. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.UnifiedSearch' and MODULE_NAME = 'Contracts' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.UnifiedSearch Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.UnifiedSearch'       , 'Contracts'        , '~/Contracts/SearchContracts'        , 7, 'Contracts.LBL_LIST_FORM_TITLE'    , null, null, null, null;
end -- if;
GO

-- 08/03/2010 Paul.  Add global searching to Quotes, Orders and Invoices. 
-- 08/26/2010 Paul.  Add global searching to Payments. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.UnifiedSearch' and MODULE_NAME = 'Quotes' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.UnifiedSearch Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.UnifiedSearch'       , 'Quotes'           , '~/Quotes/SearchQuotes'              , 8, 'Quotes.LBL_LIST_FORM_TITLE'    , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.UnifiedSearch'       , 'Orders'           , '~/Orders/SearchOrders'              , 9, 'Orders.LBL_LIST_FORM_TITLE'    , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.UnifiedSearch'       , 'Invoices'         , '~/Invoices/SearchInvoices'          ,10, 'Invoices.LBL_LIST_FORM_TITLE'  , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.UnifiedSearch'       , 'Payments'         , '~/Payments/SearchPayments'          ,11, 'Payments.LBL_LIST_FORM_TITLE'  , null, null, null, null;
end -- if;
GO

-- 06/03/2006 Paul.  Add Contracts view. 
-- 11/30/2012 Paul.  Use separate panels for Open Activities and History Activities as the HTML5 Offline Client does not allow for a single Activities panel that combines both. 
-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contracts.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contracts.DetailView Professional';
	--exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Activities'       , 'Activities'         ,  0, 'Activities.LBL_MODULE_NAME'       , 'vwCONTRACTS_ACTIVITIES', 'CONTRACT_ID', 'DATE_MODIFIED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwCONTRACTS_STREAM'            , 'ID'         , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Activities'       , 'ActivitiesOpen'     ,  1, 'Activities.LBL_OPEN_ACTIVITIES'   , 'vwCONTRACTS_ACTIVITIES_OPEN'   , 'CONTRACT_ID', 'DATE_DUE'     , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Activities'       , 'ActivitiesHistory'  ,  2, 'Activities.LBL_HISTORY'           , 'vwCONTRACTS_ACTIVITIES_HISTORY', 'CONTRACT_ID', 'DATE_MODIFIED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Documents'        , 'Documents'          ,  3, 'Documents.LBL_MODULE_NAME'        , 'vwCONTRACTS_DOCUMENTS'         , 'CONTRACT_ID', 'DOCUMENT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Notes'            , 'Notes'              ,  4, 'Notes.LBL_MODULE_NAME'            , 'vwCONTRACTS_NOTES'             , 'CONTRACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Contacts'         , 'Contacts'           ,  5, 'Contacts.LBL_MODULE_NAME'         , 'vwCONTRACTS_CONTACTS'          , 'CONTRACT_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Products'         , 'Products'           ,  6, 'Products.LBL_MODULE_NAME'         , 'vwCONTRACTS_PRODUCTS'          , 'CONTRACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Quotes'           , 'Quotes'             ,  7, 'Quotes.LBL_MODULE_NAME'           , 'vwCONTRACTS_QUOTES'            , 'CONTRACT_ID', 'DATE_ENTERED' , 'desc';
end else begin
	-- 02/13/2009 Paul.  Add relationships to activities. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contracts.DetailView' and MODULE_NAME = 'Activities' and DELETED = 0) begin -- then
		print N'DETAILVIEWS_RELATIONSHIPS Contracts: Add activities.';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Contracts.DetailView'
		   and DELETED            = 0;
		-- 03/01/2013 Paul.  Use DATE_MODIFIED instead of DATE_ENTERED. 
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Activities'       , 'Activities'         ,  0, 'Activities.LBL_MODULE_NAME'       , 'vwCONTRACTS_ACTIVITIES', 'CONTRACT_ID', 'DATE_MODIFIED', 'desc';
	end -- if;

	-- 08/13/2009 Paul.  All the user to reorder the activities panels by creating separate controls for open and history. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contracts.DetailView' and CONTROL_NAME = 'ActivitiesOpen' and DELETED = 0) begin -- then
		-- 11/30/2012 Paul.  Enable separate controls for Open and History while disabling the combined Activities control. 
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Contracts.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Activities'       , 'ActivitiesOpen'     ,  0, 'Activities.LBL_OPEN_ACTIVITIES', 'vwCONTRACTS_ACTIVITIES_OPEN'   , 'CONTRACT_ID', 'DATE_DUE'     , 'desc';
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'Activities'       , 'ActivitiesHistory'  ,  1, 'Activities.LBL_HISTORY'        , 'vwCONTRACTS_ACTIVITIES_HISTORY', 'CONTRACT_ID', 'DATE_MODIFIED', 'desc';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ENABLED = 0
		     , DATE_MODIFIED        = getdate()
		     , DATE_MODIFIED_UTC    = getutcdate()
		     , MODIFIED_USER_ID     = null
		 where DETAIL_NAME          = 'Contracts.DetailView'
		   and CONTROL_NAME         = 'Activities'
		   and DELETED              = 0;
	end -- if;

	-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contracts.DetailView' and CONTROL_NAME = 'ActivityStream' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Contracts.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView'     , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwCONTRACTS_STREAM'            , 'ID'         , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	end -- if;
end -- if;
GO

-- 06/03/2006 Paul.  Add Products view. 
-- 07/20/2010 Paul.  Related products is no longer used to refer to customer products. 
-- We now treat related products as part of a parent/child relationship. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Products.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Products.DetailView Professional';
--	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Products.DetailView'      , 'Products'         , 'RelatedProducts'    ,  0, 'Products.LBL_MODULE_NAME'         , 'vwPRODUCTS_RELATED_PRODUCTS', 'PARENT_ID' , 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Products.DetailView'      , 'Notes'            , 'Notes'              ,  1, 'Notes.LBL_MODULE_NAME'            , 'vwPRODUCTS_NOTES'           , 'PRODUCT_ID', 'DATE_ENTERED', 'desc';
end else begin
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Products.DetailView' and CONTROL_NAME = 'RelatedProducts' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set DELETED              = 1
		     , DATE_MODIFIED        = getdate()
		     , DATE_MODIFIED_UTC    = getutcdate()
		     , MODIFIED_USER_ID     = null
		 where DETAIL_NAME          = 'Products.DetailView'
		   and CONTROL_NAME         = 'RelatedProducts'
		   and DELETED              = 0;
	end -- if;
end -- if;
GO

-- 06/07/2006 Paul.  Add Quotes view. 
-- 10/20/2006 Paul.  Fix Project module name. 
-- 11/30/2012 Paul.  Use separate panels for Open Activities and History Activities as the HTML5 Offline Client does not allow for a single Activities panel that combines both. 
-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Quotes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Quotes.DetailView Professional';
	--exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Activities'       , 'Activities'         ,  0, 'Activities.LBL_MODULE_NAME'       , 'vwQUOTES_ACTIVITIES'        , 'QUOTE_ID', 'DATE_MODIFIED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwQUOTES_STREAM'            , 'ID'      , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Activities'       , 'ActivitiesOpen'     ,  1, 'Activities.LBL_OPEN_ACTIVITIES'   , 'vwQUOTES_ACTIVITIES_OPEN'   , 'QUOTE_ID', 'DATE_DUE'     , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Activities'       , 'ActivitiesHistory'  ,  2, 'Activities.LBL_HISTORY'           , 'vwQUOTES_ACTIVITIES_HISTORY', 'QUOTE_ID', 'DATE_MODIFIED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Project'          , 'Projects'           ,  3, 'Project.LBL_MODULE_NAME'          , 'vwQUOTES_PROJECTS'          , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Contracts'        , 'Contracts'          ,  4, 'Contracts.LBL_MODULE_NAME'        , 'vwQUOTES_CONTRACTS'         , 'QUOTE_ID', 'CONTRACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Orders'           , 'Orders'             ,  5, 'Orders.LBL_MODULE_NAME'           , 'vwQUOTES_ORDERS'            , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Invoices'         , 'Invoices'           ,  6, 'Invoices.LBL_MODULE_NAME'         , 'vwQUOTES_INVOICES'          , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Cases'            , 'Cases'              ,  7, 'Cases.LBL_MODULE_NAME'            , 'vwQUOTES_CASES'             , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Documents'        , 'Documents'          ,  8, 'Documents.LBL_MODULE_NAME'        , 'vwQUOTES_DOCUMENTS'         , 'QUOTE_ID', 'DOCUMENT_NAME', 'asc';
end else begin
	-- 04/28/2007 Paul.  Add relationships to orders and invoices. 
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Orders'           , 'Orders'             , null, 'Orders.LBL_MODULE_NAME'         , 'vwQUOTES_ORDERS'            , 'QUOTE_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Invoices'         , 'Invoices'           , null, 'Invoices.LBL_MODULE_NAME'       , 'vwQUOTES_INVOICES'          , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Cases'            , 'Cases'              , null, 'Cases.LBL_MODULE_NAME'          , 'vwQUOTES_CASES'             , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';

	-- 08/13/2009 Paul.  All the user to reorder the activities panels by creating separate controls for open and history. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Quotes.DetailView' and CONTROL_NAME = 'ActivitiesOpen' and DELETED = 0) begin -- then
		-- 11/30/2012 Paul.  Enable separate controls for Open and History while disabling the combined Activities control. 
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Quotes.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Activities'       , 'ActivitiesOpen'     ,  0, 'Activities.LBL_OPEN_ACTIVITIES', 'vwQUOTES_ACTIVITIES_OPEN'   , 'QUOTE_ID', 'DATE_DUE'     , 'desc';
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'        , 'Activities'       , 'ActivitiesHistory'  ,  1, 'Activities.LBL_HISTORY'        , 'vwQUOTES_ACTIVITIES_HISTORY', 'QUOTE_ID', 'DATE_MODIFIED', 'desc';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ENABLED = 0
		     , DATE_MODIFIED        = getdate()
		     , DATE_MODIFIED_UTC    = getutcdate()
		     , MODIFIED_USER_ID     = null
		 where DETAIL_NAME          = 'Quotes.DetailView'
		   and CONTROL_NAME         = 'Activities'
		   and DELETED              = 0;
	end -- if;

	-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Quotes.DetailView' and CONTROL_NAME = 'ActivityStream' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Quotes.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView'     , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwQUOTES_STREAM'            , 'ID'         , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	end -- if;
end -- if;
GO

-- 10/15/2006 Paul.  Add Teams view. 
-- 04/12/2016 Paul.  Add ZipCodes. 
-- 04/28/2016 Paul.  Allow team hierarchy. 
-- 01/01/2016 Paul.  Allow regions to be associated with teams. 
-- sp_helptext spDETAILVIEWS_RELATIONSHIPS_InsertOnly
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Teams.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'Teams'            , 'Hierarchy'          ,  0, 'Teams.LBL_HIERARCHY'              , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'Users'            , 'Users'              ,  1, 'Users.LBL_MODULE_NAME'            , 'vwTEAM_MEMBERSHIPS_List', 'TEAM_ID', 'FULL_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'ZipCodes'         , 'ZipCodes'           ,  2, 'ZipCodes.LBL_MODULE_NAME'         , 'vwTEAMS_ZIPCODES'       , 'TEAM_ID', 'NAME'     , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'Regions'          , 'Regions'            ,  3, 'Regions.LBL_MODULE_NAME'          , 'vwTEAMS_REGIONS'        , 'TEAM_ID', 'NAME'     , 'asc';
end else begin
	-- 04/28/2016 Paul.  Allow team hierarchy. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and CONTROL_NAME = 'Hierarchy' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Teams.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'Teams'            , 'Hierarchy'          ,  0, 'Teams.LBL_HIERARCHY'              , null, null, null, null;
	end -- if;
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and CONTROL_NAME = 'ZipCodes' and DELETED = 0) begin -- then
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'ZipCodes'         , 'ZipCodes'           ,  2, 'ZipCodes.LBL_MODULE_NAME'         , null, null, null, null;
	end -- if;
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and CONTROL_NAME = 'Regions' and DELETED = 0) begin -- then
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Teams.DetailView'         , 'Regions'          , 'Regions'            ,  3, 'Regions.LBL_MODULE_NAME'          , null, null, null, null;
	end -- if;

	-- 10/14/2020 Paul.  The React Client requires tables. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and CONTROL_NAME = 'Users' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwTEAM_MEMBERSHIPS_List'
		     , PRIMARY_FIELD      = 'TEAM_ID'
		     , SORT_FIELD         = 'FULL_NAME'
		     , SORT_DIRECTION     = 'asc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Teams.DetailView'
		   and CONTROL_NAME       = 'Users'
		   and TABLE_NAME         is null
		   and DELETED            = 0;
	end -- if;
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and CONTROL_NAME = 'ZipCodes' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwTEAMS_ZIPCODES'
		     , PRIMARY_FIELD      = 'TEAM_ID'
		     , SORT_FIELD         = 'NAME'
		     , SORT_DIRECTION     = 'asc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Teams.DetailView'
		   and CONTROL_NAME       = 'ZipCodes'
		   and TABLE_NAME         is null
		   and DELETED            = 0;
	end -- if;
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Teams.DetailView' and CONTROL_NAME = 'Regions' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwTEAMS_REGIONS'
		     , PRIMARY_FIELD      = 'TEAM_ID'
		     , SORT_FIELD         = 'NAME'
		     , SORT_DIRECTION     = 'asc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Teams.DetailView'
		   and CONTROL_NAME       = 'Regions'
		   and TABLE_NAME         is null
		   and DELETED            = 0;
	end -- if;

end -- if;
GO

-- 08/05/2010 Paul.  Add Cases to view. 
-- 09/06/2012 Paul.  Add Quotes and Orders.  Not sure why they were previously omitted. 
-- 11/30/2012 Paul.  Use separate panels for Open Activities and History Activities as the HTML5 Offline Client does not allow for a single Activities panel that combines both. 
-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Orders.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Orders.DetailView Professional';
	--exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'Activities'       , 'Activities'         ,  0, 'Activities.LBL_MODULE_NAME'       , 'vwORDERS_ACTIVITIES'        , 'ORDER_ID', 'DATE_MODIFIED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwORDERS_STREAM'            , 'ID'      , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'Activities'       , 'ActivitiesOpen'     ,  1, 'Activities.LBL_OPEN_ACTIVITIES'   , 'vwORDERS_ACTIVITIES_OPEN'   , 'ORDER_ID', 'DATE_DUE'     , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'Activities'       , 'ActivitiesHistory'  ,  2, 'Activities.LBL_HISTORY'           , 'vwORDERS_ACTIVITIES_HISTORY', 'ORDER_ID', 'DATE_MODIFIED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'Invoices'         , 'Invoices'           ,  3, 'Invoices.LBL_MODULE_NAME'         , 'vwORDERS_INVOICES'          , 'ORDER_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'Cases'            , 'Cases'              ,  4, 'Cases.LBL_MODULE_NAME'            , 'vwORDERS_CASES'             , 'ORDER_ID', 'DATE_ENTERED' , 'desc';
	-- exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'       , 'Quotes'           , 'Quotes'             ,  5, 'Quotes.LBL_MODULE_NAME'           , 'vwORDERS_QUOTES'            , 'ORDER_ID', 'DATE_ENTERED' , 'desc';
end else begin
	-- 08/05/2010 Paul.  Add Cases to view. 
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'          , 'Cases'            , 'Cases'              , null, 'Cases.LBL_MODULE_NAME'          , 'vwORDERS_CASES'             , 'ORDER_ID', 'DATE_ENTERED' , 'desc';
	-- exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'       , 'Quotes'           , 'Quotes'             , null, 'Quotes.LBL_MODULE_NAME'         , 'vwORDERS_QUOTES'            , 'ORDER_ID', 'DATE_ENTERED' , 'desc';

	-- 08/13/2009 Paul.  All the user to reorder the activities panels by creating separate controls for open and history. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Orders.DetailView' and CONTROL_NAME = 'ActivitiesOpen' and DELETED = 0) begin -- then
		-- 11/30/2012 Paul.  Enable separate controls for Open and History while disabling the combined Activities control. 
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Orders.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'        , 'Activities'       , 'ActivitiesOpen'     ,  0, 'Activities.LBL_OPEN_ACTIVITIES'  , 'vwORDERS_ACTIVITIES_OPEN'   , 'ORDER_ID', 'DATE_DUE'     , 'desc';
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'        , 'Activities'       , 'ActivitiesHistory'  ,  1, 'Activities.LBL_HISTORY'          , 'vwORDERS_ACTIVITIES_HISTORY', 'ORDER_ID', 'DATE_MODIFIED', 'desc';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ENABLED = 0
		     , DATE_MODIFIED        = getdate()
		     , DATE_MODIFIED_UTC    = getutcdate()
		     , MODIFIED_USER_ID     = null
		 where DETAIL_NAME          = 'Orders.DetailView'
		   and CONTROL_NAME         = 'Activities'
		   and DELETED              = 0;
	end -- if;

	-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Orders.DetailView' and CONTROL_NAME = 'ActivityStream' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Orders.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView'      , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwORDERS_STREAM'            , 'ID'        , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	end -- if;
end -- if;
GO

-- 08/05/2010 Paul.  Add Cases to view. 
-- 11/30/2012 Paul.  Use separate panels for Open Activities and History Activities as the HTML5 Offline Client does not allow for a single Activities panel that combines both. 
-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Invoices.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Invoices.DetailView Professional';
	--exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'Activities'       , 'Activities'         ,  0, 'Activities.LBL_MODULE_NAME'       , 'vwINVOICES_ACTIVITIES'        , 'INVOICE_ID', 'DATE_MODIFIED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwINVOICES_STREAM'            , 'ID'        , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'Activities'       , 'ActivitiesOpen'     ,  1, 'Activities.LBL_OPEN_ACTIVITIES'   , 'vwINVOICES_ACTIVITIES_OPEN'   , 'INVOICE_ID', 'DATE_DUE'     , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'Activities'       , 'ActivitiesHistory'  ,  2, 'Activities.LBL_HISTORY'           , 'vwINVOICES_ACTIVITIES_HISTORY', 'INVOICE_ID', 'DATE_MODIFIED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'Payments'         , 'Payments'           ,  3, 'Payments.LBL_MODULE_NAME'         , 'vwINVOICES_PAYMENTS'          , 'INVOICE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'Cases'            , 'Cases'              ,  4, 'Cases.LBL_MODULE_NAME'            , 'vwINVOICES_CASES'             , 'INVOICE_ID', 'DATE_ENTERED' , 'desc';
end else begin
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'Cases'            , 'Cases'              , null, 'Cases.LBL_MODULE_NAME'          , 'vwINVOICES_CASES'             , 'INVOICE_ID', 'DATE_ENTERED' , 'desc';

	-- 08/13/2009 Paul.  All the user to reorder the activities panels by creating separate controls for open and history. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Invoices.DetailView' and CONTROL_NAME = 'ActivitiesOpen' and DELETED = 0) begin -- then
		-- 11/30/2012 Paul.  Enable separate controls for Open and History while disabling the combined Activities control. 
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Invoices.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'      , 'Activities'       , 'ActivitiesOpen'     ,  0, 'Activities.LBL_OPEN_ACTIVITIES'  , 'vwINVOICES_ACTIVITIES_OPEN'   , 'INVOICE_ID', 'DATE_DUE'     , 'desc';
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'      , 'Activities'       , 'ActivitiesHistory'  ,  1, 'Activities.LBL_HISTORY'          , 'vwINVOICES_ACTIVITIES_HISTORY', 'INVOICE_ID', 'DATE_MODIFIED', 'desc';
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ENABLED = 0
		     , DATE_MODIFIED        = getdate()
		     , DATE_MODIFIED_UTC    = getutcdate()
		     , MODIFIED_USER_ID     = null
		 where DETAIL_NAME          = 'Invoices.DetailView'
		   and CONTROL_NAME         = 'Activities'
		   and DELETED              = 0;
	end -- if;

	-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Invoices.DetailView' and CONTROL_NAME = 'ActivityStream' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Invoices.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Invoices.DetailView'        , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwINVOICES_STREAM'            , 'ID'        , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	end -- if;
end -- if;
GO

-- 07/15/2007 Paul.  Add forums/threaded discussions.
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Forums.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Forums.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Forums.DetailView'          , 'Threads'          , 'Threads'            ,  0, 'Threads.LBL_MODULE_NAME'          , 'vwFORUMS_THREADS', 'FORUM_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Threads.DetailView';
/*
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Threads.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Threads.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Threads.DetailView'         , 'Posts'            , 'Posts'              ,  0'Posts'            , .LBL_MODULE_NAME'Posts'              , 'vwTHREADS_POSTS', 'THREAD_ID', 'DATE_ENTERED', 'asc';
end -- if;
*/
GO

-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Payments.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Payments.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Payments.DetailView Professional';
	exec dbo.spDETAILVIEWS_InsertOnly               'Payments.DetailView'       , 'Payments', 'vwPAYMENTS_TRANSACTIONS', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Payments.DetailView'       , 'Payments'         , 'PaymentTransactions',  0, 'Payments.LBL_PAYMENT_TRANSACTIONS', 'vwPAYMENTS_TRANSACTIONS', 'PAYMENT_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME in ('ProductsView', 'ContractsView', 'ForumsView') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'ProductsView'       ,  6, 'Administration.LBL_PRODUCTS_QUOTES_TITLE'     , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'ContractsView'      ,  7, 'Administration.LBL_CONTRACTS_TITLE'           , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'ForumsView'         ,  8, 'Administration.LBL_FORUM_TOPICS_TITLE'        , null, null, null, null;
end -- if;
GO

-- 09/20/2009 Paul.  Move Team Notices to the Professional file. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.DetailView.Right' and CONTROL_NAME = '~/Administration/TeamNotices/MyTeamNotices' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.DetailView.Right';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Right'    , 'Home'             , '~/Administration/TeamNotices/MyTeamNotices', 0, 'Home.LBL_TEAM_NOTICES_TITLE'        , null, null, null, null;
end -- if;
GO

-- 03/22/2010 Paul.  Add ExchangeView. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'ExchangeView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'ExchangeView'       ,  10, 'Administration.LBL_EXCHANGE_TITLE'            , null, null, null, null;
end -- if;
GO

-- 08/14/2013 Paul.  Add Surveys panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'SurveysView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'SurveysView'        ,  -1, 'Administration.LBL_SURVEYS_TITLE'             , null, null, null, null;
end -- if;
GO

-- 09/04/2013 Paul.  Add AsteriskView. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'AsteriskView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'AsteriskView'       ,  -1, 'Asterisk.LBL_ASTERISK_TITLE'            , null, null, null, null;
end -- if;
GO

-- 07/10/2010 Paul.  Add RelatedProducts. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'ProductTemplates.DetailView' and CONTROL_NAME = 'RelatedProducts' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS ProductTemplates.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'ProductTemplates.DetailView', 'ProductTemplates' , 'RelatedProducts'    ,  0, 'ProductTemplates.LBL_RELATED_PRODUCTS', 'vwPRODUCTS_RELATED_PRODUCTS', 'PARENT_ID', 'CHILD_NAME', 'asc';
end -- if;
GO

-- 04/23/2011 Paul.  Use the DETAILVIEWS_RELATIONSHIPS table to allow configuration of the Mail Merge modules. 
-- The CONTROL_NAME field cannot be blank, so just use the search module as the filler. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Modules.MailMerge' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Modules.MailMerge';
	exec dbo.spDETAILVIEWS_InsertOnly               'Modules.MailMerge'       , 'Modules'          , 'vwMODULES', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Modules.MailMerge'       , 'Accounts'         , '~/Accounts/SearchAccounts'          , 0, '.moduleList.Accounts'     , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Modules.MailMerge'       , 'Contacts'         , '~/Contacts/SearchContacts'          , 1, '.moduleList.Contacts'     , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Modules.MailMerge'       , 'Leads'            , '~/Leads/SearchLeads'                , 2, '.moduleList.Leads'        , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Modules.MailMerge'       , 'Prospects'        , '~/Prospects/SearchProspects'        , 3, '.moduleList.Prospects'    , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Modules.MailMerge'       , 'Cases'            , '~/Cases/SearchCases'                , 4, '.moduleList.Cases'        , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Modules.MailMerge'       , 'Opportunities'    , '~/Opportunities/SearchOpportunities', 5, '.moduleList.Opportunities', null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.MailMerge' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.MailMerge';
	exec dbo.spDETAILVIEWS_InsertOnly               'Accounts.MailMerge'      , 'Accounts'         , 'vwACCOUNTS', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.MailMerge'      , 'Contacts'         , '~/Contacts/SearchContacts'          , 0, '.moduleList.Contacts'     , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.MailMerge'      , 'Opportunities'    , '~/Opportunities/SearchOpportunities', 1, '.moduleList.Opportunities', null, null, null, null;
end -- if;
GO

-- 09/09/2012 Paul.  Fix to add relationship for Cases.MailMerge and not Accounts.MailMerge. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Cases.MailMerge' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Cases.MailMerge';
	exec dbo.spDETAILVIEWS_InsertOnly               'Cases.MailMerge'         , 'Cases'            , 'vwCASES', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Cases.MailMerge'         , 'Contacts'         , '~/Contacts/SearchContacts'          , 0, '.moduleList.Contacts'     , null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Opportunities.MailMerge' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Opportunities.MailMerge';
	exec dbo.spDETAILVIEWS_InsertOnly               'Opportunities.MailMerge' , 'Opportunities'     , 'vwOPPORTUNITIES', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.MailMerge' , 'Contacts'         , '~/Contacts/SearchContacts'          , 0, '.moduleList.Contacts'     , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.MailMerge' , 'Accounts'         , '~/Accounts/SearchAccounts'          , 1, '.moduleList.Accounts'     , null, null, null, null;
end -- if;
GO

-- 07/20/2010 Paul.  Regions. 
-- 11/23/2011 Paul.  Move Regions to Professional file. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Regions.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Regions.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Regions.DetailView'        , 'Regions'          , 'Countries'          ,  0, 'Regions.LBL_COUNTRIES', 'vwREGIONS_COUNTRIES', 'REGION_ID', 'COUNTRY', 'asc';
end -- if;
GO

-- 02/04/2012 Paul.  Add Documents relationship to Accounts, Contacts, Leads and Opportunities. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Documents.DetailView' and MODULE_NAME = 'Contracts' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Documents.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView'      , 'Contracts'        , 'Contracts'          ,  null, 'Contracts.LBL_MODULE_NAME', 'vwDOCUMENTS_CONTRACTS', 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 09/09/2012 Paul.  Add Documents relationship to Bugs, Cases and Quotes. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Documents.DetailView' and MODULE_NAME = 'Quotes' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Documents.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView'      , 'Quotes'           , 'Quotes'             ,  null, 'Quotes.LBL_MODULE_NAME', 'vwDOCUMENTS_QUOTES', 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO

-- 05/31/2013 Paul.  Add Surveys module. 
-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
-- 07/03/2021 Paul.  ActivityStream should be at position 0. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Surveys.DetailView' and MODULE_NAME = 'SurveyPages' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Surveys.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Surveys.DetailView'        , 'SurveyPages'      , 'SurveyPages'        ,  null, 'SurveyPages.LBL_MODULE_NAME'   , 'vwSURVEYS_SURVEY_PAGES'      , 'SURVEY_ID' , 'PAGE_NUMBER', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Surveys.DetailView'        , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwSURVEYS_STREAM'            , 'ID'        , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
end else begin
	-- 10/01/2015 Paul.  Add the ActivityStream at the top. 
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Surveys.DetailView'        , 'ActivityStream'   , 'ActivityStream'     ,  0, '.LBL_ACTIVITY_STREAM'             , 'vwSURVEYS_STREAM'            , 'ID'        , 'STREAM_DATE desc, STREAM_VERSION desc' , 'desc';
	-- 07/03/2021 Paul.  ActivityStream should be at position 0. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Surveys.DetailView' and MODULE_NAME = 'ActivityStream' and RELATIONSHIP_ORDER = 1 and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = 0
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where DETAIL_NAME        = 'Surveys.DetailView'
		   and CONTROL_NAME       = 'ActivityStream'
		   and RELATIONSHIP_ORDER = 1
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'SurveyPages.DetailView' and MODULE_NAME = 'SurveyQuestions' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS SurveyPages.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'SurveyPages.DetailView'    , 'SurveyQuestions'  , 'SurveyQuestions'    ,  null, 'SurveyQuestions.LBL_MODULE_NAME', 'vwSURVEY_PAGES_QUESTIONS', 'SURVEY_PAGE_ID', 'QUESTION_NUMBER', 'asc';
end -- if;
GO

-- 11/30/2019 Paul.  The Primary ID is SURVEY_QUESTION_ID not SURVEY_ID. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'SurveyQuestions.DetailView' and MODULE_NAME = 'Surveys' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS SurveyQuestions.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'SurveyQuestions.DetailView' , 'Surveys'         , 'Surveys'            ,  null, 'Surveys.LBL_MODULE_NAME', 'vwSURVEY_QUESTIONS_SURVEYS', 'SURVEY_QUESTION_ID', 'SURVEY_NAME', 'asc';
end else begin
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'SurveyQuestions.DetailView' and MODULE_NAME = 'Surveys' and PRIMARY_FIELD = 'SURVEY_ID' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set PRIMARY_FIELD     = 'SURVEY_QUESTION_ID'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'SurveyQuestions.DetailView'
		   and CONTROL_NAME      = 'Surveys'
		   and PRIMARY_FIELD     = 'SURVEY_ID'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 09/19/2013 Paul.  Add PayTrace module. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and MODULE_NAME = 'PayTraceView' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'PayTraceView'         ,  -1, 'PayTrace.LBL_PAYTRACE_TITLE';
end -- if;
GO

-- 01/01/2016 Paul.  PayTrace links moved to PaymentsView. 
/*
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'PayTrace.DetailView' and MODULE_NAME = 'PayTrace' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS PayTrace.DetailView PayTrace';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'PayTrace.DetailView', 'PayTrace', 'LineItems',  1, 'PayTrace.LBL_LINE_ITEMS';
end -- if;
*/


-- 11/05/2013 Paul.  Add Tweets to TwitterTracks. 
-- 04/14/2021 Paul.  React client requires TABLE_NAME and related fields. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'TwitterTracks.DetailView' and MODULE_NAME = 'Tweets';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'TwitterTracks.DetailView' and MODULE_NAME = 'TwitterMessages' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS TwitterTracks.DetailView TwitterMessages';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'TwitterTracks.DetailView', 'TwitterMessages', 'TwitterMessages',  1, 'TwitterMessages.LBL_MODULE_NAME', 'vwTWITTER_TRACK_MESSAGES', 'TWITTER_TRACK_ID', 'DATE_ENTERED', 'desc';
end else begin
	-- 04/14/2021 Paul.  React client requires TABLE_NAME and related fields. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'TwitterTracks.DetailView' and MODULE_NAME = 'TwitterMessages' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME        = 'vwTWITTER_TRACK_MESSAGES'
		     , PRIMARY_FIELD     = 'TWITTER_TRACK_ID'
		     , SORT_FIELD        = 'DATE_ENTERED'
		     , SORT_DIRECTION    = 'desc'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'TwitterTracks.DetailView'
		   and MODULE_NAME       = 'TwitterMessages'
		   and TABLE_NAME        is null
		   and DELETED           = 0;
	end -- if;
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'PayTrace.DetailView' and MODULE_NAME = 'PayTrace' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS PayTrace.DetailView PayTrace';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'PayTrace.DetailView', 'PayTrace', 'LineItems',  1, 'PayTrace.LBL_LINE_ITEMS';
end -- if;
GO

-- 12/18/2015 Paul.  Add AuthorizeNet module. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'AuthorizeNet.DetailView' and MODULE_NAME = 'AuthorizeNet' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS AuthorizeNet.DetailView AuthorizeNet';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'AuthorizeNet.DetailView', 'AuthorizeNet', 'LineItems',  1, 'AuthorizeNet.LBL_LINE_ITEMS';

	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'AuthorizeNet.CustomerProfiles.DetailView', 'AuthorizeNet', 'PaymentProfiles'  ,  1, 'AuthorizeNet.LBL_PAYMENT_PROFILES';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'AuthorizeNet.CustomerProfiles.DetailView', 'AuthorizeNet', 'ShippingAddresses',  2, 'AuthorizeNet.LBL_SHIPPING_ADDRESSES';
end -- if;
GO

-- 01/01/2016 Paul.  PayPal links moved to PaymentsView. 
--exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'PayPalView'         ,  10, 'Administration.LBL_PAYPAL_TRANSACTIONS_TITLE'        ;

-- 01/01/2016 Paul.  Combine PayPal, PayTrace and AuthorizeNet into a single panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'PaymentView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView', 'Administration', 'PaymentView',  -1, 'Administration.LBL_PAYMENT_SERVICES_TITLE', null, null, null, null;
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , DATE_MODIFIED        = getdate()
	     , DATE_MODIFIED_UTC    = getutcdate()
	 where DETAIL_NAME          = 'Administration.ListView'
	   and CONTROL_NAME         in ('PayPalView', 'PayTraceView')
	   and DELETED              = 0;
end -- if;
GO

-- 01/01/2016 Paul.  Combine Asterisk and Avaya into a single panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'VoIPView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView', 'Administration', 'VoIPView',  -1, 'Administration.LBL_VOIP_SERVICES_TITLE', null, null, null, null;
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , DATE_MODIFIED        = getdate()
	     , DATE_MODIFIED_UTC    = getutcdate()
	 where DETAIL_NAME          = 'Administration.ListView'
	   and CONTROL_NAME         in ('AsteriskView', 'AvayaView')
	   and DELETED              = 0;
end -- if;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 
-- 05/19/2016 Paul.  Move DETAILVIEWS_RELATIONSHIPS to correct file type. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'PayPal.DetailView' and MODULE_NAME = 'TokenUsageLimit';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'PayPal.DetailView' and MODULE_NAME = 'PayPal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS PayPal.DetailView PayPal';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'PayPal.DetailView', 'PayPal', 'LineItems',  1, 'PayPal.LBL_LINE_ITEMS';
end -- if;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Professional()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Professional')
/

-- #endif IBM_DB2 */

