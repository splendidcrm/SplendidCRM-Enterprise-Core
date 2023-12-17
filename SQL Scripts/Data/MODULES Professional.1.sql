

print 'MODULES Professional';
GO

set nocount on;
GO

-- 05/02/2006 Paul.  Add TABLE_NAME as direct table queries are required by SOAP and we need a mapping. 
-- 05/20/2006 Paul.  Add REPORT_ENABLED if the module can be the basis of a report. ACL rules will still apply. 
-- 10/06/2006 Paul.  Add IMPORT_ENABLED if the module can allow importing. 
-- 04/11/2007 Paul.  Since we are using InsertOnly procedures, we don't need all the if exists filters. 
-- 02/09/2008 Paul.  Move maintenance code to separate file. 
-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/17/2008 Paul.  Set default value for MOBILE_ENABLED. 
-- 01/13/2010 Paul.  Set default for MASS_UPDATE_ENABLED. 
-- 04/01/2010 Paul.  Add Exchange Sync flag. 
-- 05/02/2010 Paul.  Add defaults for Exchange Folders and Exchange Create Parent. 
-- 08/01/2010 Paul.  Reorder to match the latest Sugar release. 
-- 12/06/2010 Paul.  Convert display name to use moduleList. 
-- 09/12/2011 Paul.  REST_ENABLED provides a way to enable/disable a module in the REST API. 

-- 05/07/2017 Paul.  Update Reports to default to enable MassUpdate.  This should have been done long ago. 
-- 07/15/2020 Paul.  Enable REST for Reports for React Client. 
exec dbo.spMODULES_InsertOnly null, 'Reports'               , '.moduleList.Reports'                  , '~/Reports/'                         , 1, 1,  7, 0, 0, 0, 0, 0, 'REPORTS'            , 0, 1, 0, 0, 0, 1;
if exists(select * from MODULES where MODULE_NAME = 'Reports' and MASS_UPDATE_ENABLED is null) begin -- then
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'Reports'
	   and MASS_UPDATE_ENABLED is null;
end -- if;
-- 07/15/2020 Paul.  We need a module configuration level to determine if we can modify/enable REST flag for React Client. 
if exists(select * from MODULES where MODULE_NAME = 'Reports' and REST_ENABLED = 0) begin -- then
	if not exists(select * from CONFIG where NAME = 'Module.Config.Level') or exists(select * from CONFIG where NAME = 'Module.Config.Level' and cast(VALUE as float) < 13.0) begin -- then
		update MODULES
		   set REST_ENABLED        = 1
		     , DATE_MODIFIED       = getdate()
		     , DATE_MODIFIED_UTC   = getutcdate()
		     , MODIFIED_USER_ID    = null
		 where MODULE_NAME         = 'Reports'
		   and REST_ENABLED        = 0;
	end -- if;
end -- if;
GO

-- 07/27/2014 Paul.  Enable ReportDesigner. 
-- 12/19/2014 Paul.  Code the report designer to become the primary report engine, unless it has been disabled. 
if not exists (select * from MODULES where MODULE_NAME = 'ReportDesigner' and DELETED = 0) begin -- then
	exec dbo.spMODULES_InsertOnly null, 'ReportDesigner'        , '.moduleList.ReportDesigner'           , '~/ReportDesigner/'                  , 1, 0,  0, 0, 0, 0, 0, 0, 'REPORTS'            , 0, 1, 0, 0, 0, 0;
	update MODULES
	   set TAB_ENABLED         = (select top 1 TAB_ENABLED         from vwMODULES where MODULE_NAME = 'Reports')
	     , TAB_ORDER           = (select top 1 TAB_ORDER           from vwMODULES where MODULE_NAME = 'Reports')
	     , MASS_UPDATE_ENABLED = (select top 1 MASS_UPDATE_ENABLED from vwMODULES where MODULE_NAME = 'Reports')
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'ReportDesigner';
	update MODULES
	   set TAB_ENABLED       = 0
	     , TAB_ORDER         = 0
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'Reports';
end -- if;
exec dbo.spMODULES_InsertOnly null, 'Quotes'                , '.moduleList.Quotes'                   , '~/Quotes/'                          , 1, 1, 11, 0, 1, 1, 0, 0, 'QUOTES'             , 0, 1, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Orders'                , '.moduleList.Orders'                   , '~/Orders/'                          , 1, 1, 12, 0, 1, 1, 0, 0, 'ORDERS'             , 0, 1, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Invoices'              , '.moduleList.Invoices'                 , '~/Invoices/'                        , 1, 1, 13, 0, 1, 1, 0, 0, 'INVOICES'           , 0, 1, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Contracts'             , '.moduleList.Contracts'                , '~/Contracts/'                       , 1, 1, 17, 0, 0, 1, 0, 0, 'CONTRACTS'          , 0, 1, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'KBDocuments'           , '.moduleList.KBDocuments'              , '~/KBDocuments/'                     , 1, 0, 18, 1, 1, 0, 1, 0, 'KBDOCUMENTS'        , 1, 1, 0, 0, 0, 0;

--exec dbo.spMODULES_InsertOnly null, 'Roles'                 , '.moduleList.Roles'                    , '~/Administration/Roles/'            , 1, 0,  0, 0, 1, 1, 0, 1, 'ROLES'              , 0, 0, 0, 0, 0, 0;
-- 07/07/2007 Paul.  Fix misspelled FORECASTS table name. 
-- 03/10/2008 Paul.  Don't bother to create Forecasts or ReportMaker until implemented. 
--exec dbo.spMODULES_InsertOnly null, 'Forecasts'             , '.moduleList.Forecasts'                , '~/Forecasts/'                       , 0, 0,  0, 0, 1, 1, 0, 0, 'FORECASTS'          , 0, 0, 0, 0, 0, 0;
--exec dbo.spMODULES_InsertOnly null, 'ReportMaker'           , '.moduleList.ReportMaker'              , '~/ReportMaker/'                     , 0, 0,  0, 0, 0, 0, 0, 0, null                 , 0, 0, 0, 0, 0, 0;

-- 06/02/2006 Paul.  Enable Products, Quotes and Reports. 
exec dbo.spMODULES_InsertOnly null, 'Products'              , '.moduleList.Products'                 , '~/Products/'                        , 1, 0,  0, 0, 1, 1, 0, 0, 'PRODUCTS'           , 0, 1, 0, 0, 0, 0;
-- 03/04/2008 Paul.  Add Product Types so that the shortcuts will display properly. 
-- 09/26/2010 Paul.  Fix relative path for ProductTypes. 
-- 09/26/2010 Paul.  Allow custom fields in ProductTypes. 
exec dbo.spMODULES_InsertOnly null, 'ProductTypes'          , '.moduleList.ProductTypes'             , '~/Administration/ProductTypes/'     , 1, 0,  0, 0, 1, 0, 0, 1, 'PRODUCT_TYPES'      , 0, 0, 0, 0, 0, 0;
-- 09/11/2009 Paul.  Quotes and Reporst should have the tabs enabled by default. 
-- 04/12/2016 Paul.  Add parent team and custom fields. 
exec dbo.spMODULES_InsertOnly null, 'Teams'                 , '.moduleList.Teams'                    , '~/Administration/Teams/'            , 1, 0,  0, 0, 1, 0, 0, 1, 'TEAMS'              , 0, 0, 0, 0, 0, 1;
if exists(select * from MODULES where MODULE_NAME = 'Teams' and CUSTOM_ENABLED = 0) begin -- then
	update MODULES
	   set CUSTOM_ENABLED = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME = 'Teams'
	   and CUSTOM_ENABLED = 0;
end -- if;
-- 02/15/2021 Paul.  React client relies upon MASS_UPDATE_ENABLED
if exists(select * from MODULES where MODULE_NAME = 'Teams' and MASS_UPDATE_ENABLED is null) begin -- then
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'Teams'
	   and MASS_UPDATE_ENABLED is null;
end -- if;

-- 03/04/2008 Paul.  Add Team Notices so that the shortcuts will display properly. 
exec dbo.spMODULES_InsertOnly null, 'TeamNotices'           , '.moduleList.TeamNotices'              , '~/Administration/TeamNotices/'      , 1, 0,  0, 0, 0, 0, 0, 1, 'TEAM_NOTICES'       , 0, 0, 0, 0, 0, 0;
-- 04/10/2022 Paul.  React client relies upon MASS_UPDATE_ENABLED
if exists(select * from MODULES where MODULE_NAME = 'TeamNotices' and MASS_UPDATE_ENABLED is null) begin -- then
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'TeamNotices'
	   and MASS_UPDATE_ENABLED is null;
end -- if;
GO

-- 01/11/2006 Paul.  Disable TestPlans for Beta 2 release. 
-- 04/24/2006 Paul.  Module was not disabled until just now. The MODULE_ENABLED flag was still 1. 
-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.

-- 04/22/2006 Paul.  Add ACLRoles as a module.  Set the CUSTOM_ENABLED flag. 
-- 05/26/2007 Paul.  There is not compelling reason to allow ACLRoles to be customized. 
-- 09/15/2008 Paul.  Remove ProductTasks.  It should have been deleted a long time ago. 
-- 02/03/2009 Paul.  Add TEAM_ID for team management. 
-- 02/28/2012 Paul.  Product Templates can have custom fields. 
-- 05/19/2012 Paul.  MassUpdate is supported in ProductTemplates. 
-- 02/03/2015 Paul.  Enable reporting for ProductTemplates so that RulesWizard can be supported. 
exec dbo.spMODULES_InsertOnly null, 'ProductTemplates'      , '.moduleList.ProductTemplates'         , '~/Administration/ProductTemplates/' , 1, 0,  0, 0, 1, 1, 0, 1, 'PRODUCT_TEMPLATES'  , 0, 1, 0, 0, 0, 1;
-- 11/11/2020 Paul.  Enable REST for ProductTemplates for the React client. 
if exists (select * from MODULES where MODULE_NAME = 'ProductTemplates' and isnull(REST_ENABLED, 0) = 0 and DELETED = 0) begin -- then
	print 'MODULES: Enable REST for ProductTemplates. ';
	update MODULES
	   set REST_ENABLED        = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'ProductTemplates'
	   and isnull(REST_ENABLED, 0) = 0
	   and DELETED             = 0;
end -- if;
GO

-- 02/04/2014 Paul.  Enable MassUpdate for ProductTemplates on old databases. 
-- 02/21/2021 Paul.  MASS_UPDATE_ENABLED mighte be null. 
if exists (select * from MODULES where MODULE_NAME = 'ProductTemplates' and isnull(MASS_UPDATE_ENABLED, 0) = 0 and DELETED = 0) begin -- then
	print 'MODULES: Enable MassUpdate for ProductTemplates. ';
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'ProductTemplates'
	   and isnull(MASS_UPDATE_ENABLED, 0) = 0
	   and DELETED             = 0;
end -- if;
-- 02/03/2015 Paul.  Enable reporting for ProductTemplates so that RulesWizard can be supported. 
if exists (select * from MODULES where MODULE_NAME = 'ProductTemplates' and REPORT_ENABLED = 0 and DELETED = 0) begin -- then
	print 'MODULES: Enable RulesWizard for ProductTemplates. ';
	update MODULES
	   set REPORT_ENABLED      = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'ProductTemplates'
	   and REPORT_ENABLED      = 0
	   and DELETED             = 0;
end -- if;
GO

-- 09/13/2009 Paul.  ProductCatalog is treated as a separate module even though it points to the same PRODUCT_TEMPLATES table. 
exec dbo.spMODULES_InsertOnly null, 'ProductCatalog'        , 'ProductCatalog.LBL_LIST_FORM_TITLE'   , '~/Products/ProductCatalog/'         , 1, 0,  0, 0, 0, 0, 0, 1, 'PRODUCT_TEMPLATES'  , 0, 0, 0, 0, 0, 0;
-- 09/26/2010 Paul.  Allow custom fields in ProductCategories. 
exec dbo.spMODULES_InsertOnly null, 'ProductCategories'     , '.moduleList.ProductCategories'        , '~/Administration/ProductCategories/', 1, 0,  0, 0, 1, 0, 0, 1, 'PRODUCT_CATEGORIES' , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Manufacturers'         , '.moduleList.Manufacturers'            , '~/Administration/Manufacturers/'    , 1, 0,  0, 0, 0, 0, 0, 1, 'MANUFACTURERS'      , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Shippers'              , '.moduleList.Shippers'                 , '~/Administration/Shippers/'         , 1, 0,  0, 0, 0, 0, 0, 1, 'SHIPPERS'           , 0, 0, 0, 0, 0, 0;
-- 02/15/2015 Paul.  Add PaymentTypes and PaymentTerms for QuickBooks Online sync. 
exec dbo.spMODULES_InsertOnly null, 'PaymentTypes'          , '.moduleList.PaymentTypes'             , '~/Administration/PaymentTypes/'     , 1, 0,  0, 0, 0, 0, 0, 1, 'PAYMENT_TYPES'      , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'PaymentTerms'          , '.moduleList.PaymentTerms'             , '~/Administration/PaymentTerms/'     , 1, 0,  0, 0, 0, 0, 0, 1, 'PAYMENT_TERMS'      , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'TaxRates'              , '.moduleList.TaxRates'                 , '~/Administration/TaxRates/'         , 1, 0,  0, 0, 0, 0, 0, 1, 'TAX_RATES'          , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'ContractTypes'         , '.moduleList.ContractTypes'            , '~/Administration/ContractTypes/'    , 1, 0,  0, 0, 0, 0, 0, 1, 'CONTRACT_TYPES'     , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'Payments'              , '.moduleList.Payments'                 , '~/Payments/'                        , 1, 0,  0, 0, 1, 1, 0, 0, 'PAYMENTS'           , 0, 1, 0, 0, 0, 0;
-- 02/10/2008 Paul.  Lets not display Forums to all users. Creating a forum is an admin-only function. 
exec dbo.spMODULES_InsertOnly null, 'Forums'                , '.moduleList.Forums'                   , '~/Forums/'                          , 1, 0,  0, 0, 0, 0, 0, 0, 'FORUMS'             , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'ForumTopics'           , '.moduleList.ForumTopics'              , '~/Administration/ForumTopics/'      , 1, 0,  0, 0, 0, 0, 0, 1, 'FORUM_TOPICS'       , 0, 0, 0, 0, 0, 0;
-- 02/29/2008 Paul.  Threads can now contain custom fields. 
exec dbo.spMODULES_InsertOnly null, 'Threads'               , '.moduleList.Threads'                  , '~/Threads/'                         , 1, 0,  0, 0, 1, 0, 0, 0, 'THREADS'            , 0, 0, 0, 0, 0, 0;
-- 09/10/2008 Paul.  Fix Posts table name. 
exec dbo.spMODULES_InsertOnly null, 'Posts'                 , '.moduleList.Posts'                    , '~/Posts/'                           , 1, 0,  0, 0, 0, 0, 0, 0, 'POSTS'              , 0, 0, 0, 0, 0, 0;
-- 09/09/2007 Paul.  Add modules for the line items so that it will be easier to add custom fields. 
-- 06/21/2011 Paul.  Enable reporting for line items so that we can also use them in the workflow engine. 
-- 08/13/2014 Paul.  Correct related path for line item modules. 
exec dbo.spMODULES_InsertOnly null, 'QuotesLineItems'       , '.moduleList.QuotesLineItems'          , '~/QuotesLineItems/'                 , 1, 0,  0, 0, 1, 1, 0, 0, 'QUOTES_LINE_ITEMS'  , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'OrdersLineItems'       , '.moduleList.OrdersLineItems'          , '~/OrdersLineItems/'                 , 1, 0,  0, 0, 1, 1, 0, 0, 'ORDERS_LINE_ITEMS'  , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'InvoicesLineItems'     , '.moduleList.InvoicesLineItems'        , '~/InvoicesLineItems/'               , 1, 0,  0, 0, 1, 1, 0, 0, 'INVOICES_LINE_ITEMS', 0, 0, 0, 0, 0, 0;
-- 08/07/2015 Paul.  Revenue Line Items. 
exec dbo.spMODULES_InsertOnly null, 'RevenueLineItems'      , '.moduleList.RevenueLineItems'         , '~/RevenueLineItems/'                , 1, 0,  0, 0, 1, 1, 0, 0, 'REVENUE_LINE_ITEMS' , 0, 0, 0, 0, 0, 0;

if exists (select * from MODULES where MODULE_NAME in ('QuotesLineItems', 'OrdersLineItems', 'InvoicesLineItems') and REPORT_ENABLED = 0 and DELETED = 0) begin -- then
	print 'MODULES: Enable reporting against line item tables. ';
	update MODULES
	   set REPORT_ENABLED    = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       in ('QuotesLineItems', 'OrdersLineItems', 'InvoicesLineItems')
	   and REPORT_ENABLED    = 0
	   and DELETED           = 0;
end -- if;
GO
-- 08/13/2014 Paul.  Correct related path for line item modules. 
if exists (select * from MODULES where MODULE_NAME = 'QuotesLineItems' and RELATIVE_PATH = '~/Quotes/' and DELETED = 0) begin -- then
	print 'MODULES: Correct related path for line item modules. ';
	update MODULES
	   set RELATIVE_PATH     = '~/QuotesLineItems/'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'QuotesLineItems'
	   and RELATIVE_PATH     = '~/Quotes/'
	   and DELETED           = 0;
end -- if;
GO
-- 08/13/2014 Paul.  Correct related path for line item modules. 
if exists (select * from MODULES where MODULE_NAME = 'OrdersLineItems' and RELATIVE_PATH = '~/Orders/' and DELETED = 0) begin -- then
	print 'MODULES: Correct related path for line item modules. ';
	update MODULES
	   set RELATIVE_PATH     = '~/OrdersLineItems/'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'OrdersLineItems'
	   and RELATIVE_PATH     = '~/Orders/'
	   and DELETED           = 0;
end -- if;
GO
-- 08/13/2014 Paul.  Correct related path for line item modules. 
if exists (select * from MODULES where MODULE_NAME = 'InvoicesLineItems' and RELATIVE_PATH = '~/Invoices/' and DELETED = 0) begin -- then
	print 'MODULES: Correct related path for line item modules. ';
	update MODULES
	   set RELATIVE_PATH     = '~/InvoicesLineItems/'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'InvoicesLineItems'
	   and RELATIVE_PATH     = '~/Invoices/'
	   and DELETED           = 0;
end -- if;
GO

-- 02/09/2008 Paul.  Add credit card management. 
-- 05/13/2008 Paul.  Fix misspelled CREDIT_CARDS table name. 
exec dbo.spMODULES_InsertOnly null, 'CreditCards'           , '.moduleList.CreditCards'              , '~/CreditCards/'                     , 1, 0,  0, 0, 1, 0, 0, 0, 'CREDIT_CARDS'       , 0, 0, 0, 0, 0, 0;
-- 10/18/2009 Paul.  Add Knowledge Base module. 
exec dbo.spMODULES_InsertOnly null, 'KBTags'                , '.moduleList.KBTags'                   , '~/KBDocuments/KBTags/'              , 1, 0,  0, 0, 0, 0, 0, 0, 'KBTAGS'             , 0, 0, 0, 0, 0, 0;
-- 03/09/2010 Paul.  Add ModuleBuilder so that admin roles can be applied. 
exec dbo.spMODULES_InsertOnly null, 'ModuleBuilder'         , 'ModuleBuilder.LBL_MODULEBUILDER'      , '~/Administration/ModuleBuilder/'    , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'PaymentGateway'        , '.moduleList.PaymentGateway'           , '~/Administration/PaymentGateway/'   , 1, 0,  0, 0, 0, 0, 0, 1, 'PAYMENT_GATEWAYS'   , 0, 0, 0, 0, 0, 0;
-- 07/20/2010 Paul.  Regions. 
exec dbo.spMODULES_InsertOnly null, 'Regions'               , '.moduleList.Regions'                  , '~/Administration/Regions/'          , 1, 0,  0, 0, 0, 0, 0, 1, 'REGIONS'            , 0, 0, 0, 0, 0, 0;
-- 04/10/2022 Paul.  React client relies upon MASS_UPDATE_ENABLED
if exists(select * from MODULES where MODULE_NAME = 'Regions' and MASS_UPDATE_ENABLED is null) begin -- then
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'Regions'
	   and MASS_UPDATE_ENABLED is null;
end -- if;
GO
-- 08/15/2010 Paul.  Discounts. 
exec dbo.spMODULES_InsertOnly null, 'Discounts'             , '.moduleList.Discounts'                , '~/Administration/Discounts/'        , 1, 0,  0, 0, 0, 0, 0, 1, 'DISCOUNTS'          , 0, 0, 0, 0, 0, 0;
-- 04/15/2011 Paul.  Create module for Exchange so that admin delegation can be applied. 
exec dbo.spMODULES_InsertOnly null, 'Exchange'              , '.moduleList.Exchange'                 , '~/Administration/Exchange/'         , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
-- 04/10/2022 Paul.  React client relies upon MASS_UPDATE_ENABLED
if exists(select * from MODULES where MODULE_NAME = 'Exchange' and MASS_UPDATE_ENABLED is null) begin -- then
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'Exchange'
	   and MASS_UPDATE_ENABLED is null;
end -- if;
GO

-- 09/16/2010 Paul.  Add support for multiple Payment Gateways.
if exists (select * from MODULES where MODULE_NAME = 'PaymentGateway' and TABLE_NAME is null and DELETED = 0) begin -- then
	update MODULES
	   set TABLE_NAME       = 'PAYMENT_GATEWAYS'
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'PaymentGateway'
	   and TABLE_NAME       is null
	   and DELETED          = 0;
end -- if;
GO

-- 10/29/2011 Paul.  Add charts. 
exec dbo.spMODULES_InsertOnly null, 'Charts'                , '.moduleList.Charts'                   , '~/Charts/'                          , 1, 1,  8, 0, 0, 0, 0, 0, 'CHARTS'             , 0, 1, 0, 0, 0, 0;
-- 05/22/2013 Paul.  Add Surveys module. 
-- delete from MODULES where MODULE_NAME like 'Survey%';
exec dbo.spMODULES_InsertOnly null, 'Surveys'               , '.moduleList.Surveys'                  , '~/Surveys/'                         , 1, 1, 27, 0, 1, 0, 0, 0, 'SURVEYS'            , 0, 1, 0, 0, 0, 1;
exec dbo.spMODULES_InsertOnly null, 'SurveyThemes'          , '.moduleList.SurveyThemes'             , '~/Administration/SurveyThemes/'     , 1, 0,  0, 0, 0, 0, 0, 1, 'SURVEY_THEMES'      , 0, 0, 0, 0, 0, 1;
exec dbo.spMODULES_InsertOnly null, 'SurveyPages'           , '.moduleList.SurveyPages'              , '~/SurveyPages/'                     , 1, 0,  0, 0, 0, 0, 0, 0, 'SURVEY_PAGES'       , 0, 1, 0, 0, 0, 1;
exec dbo.spMODULES_InsertOnly null, 'SurveyQuestions'       , '.moduleList.SurveyQuestions'          , '~/SurveyQuestions/'                 , 1, 0, 29, 0, 0, 0, 0, 0, 'SURVEY_QUESTIONS'   , 0, 1, 0, 0, 0, 1;
exec dbo.spMODULES_InsertOnly null, 'SurveyResults'         , '.moduleList.SurveyResults'            , '~/SurveyResults/'                   , 1, 0, 30, 0, 0, 1, 0, 0, 'SURVEY_RESULTS'     , 0, 1, 0, 0, 0, 1;
-- 08/28/2013 Paul.  Add SurveyQuestionResults module so that we can create workflow events. 
exec dbo.spMODULES_InsertOnly null, 'SurveyQuestionResults' , '.moduleList.SurveyQuestionResults'    , '~/SurveyQuestionResults/'           , 1, 0,  0, 0, 0, 1, 0, 0, 'SURVEY_QUESTIONS_RESULTS', 0, 0, 0, 0, 0, 1;

exec dbo.spMODULES_InsertOnly null, 'OutboundEmail'         , '.moduleList.OutboundEmail'            , '~/Administration/OutboundEmail/'    , 1, 0,  0, 0, 0, 0, 0, 1, 'OUTBOUND_EMAILS'    , 0, 0, 0, 0, 0, 0;
-- 09/04/2013 Paul.  Add AsteriskView. 
exec dbo.spMODULES_InsertOnly null, 'Asterisk'              , '.moduleList.Asterisk'                 , '~/Administration/Asterisk/'         , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 1, 0, 0, 0, 0;
-- 09/19/2013 Paul.  Add PayTrace module. 
exec dbo.spMODULES_InsertOnly null, 'PayTrace'              , '.moduleList.PayTrace'                 , '~/Administration/PayTrace/'         , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 1, 0, 0, 0, 0;
-- 10/24/2013 Paul.  Add TwitterMessages module.
exec dbo.spMODULES_InsertOnly null, 'TwitterTracks'         , '.moduleList.TwitterTracks'            , '~/TwitterTracks/'                   , 1, 1, 31, 0, 0, 0, 0, 0, 'TWITTER_TRACKS'     , 0, 1, 0, 0, 0, 1;
-- 07/15/2020 Paul.  We need a module configuration level to determine if we can modify/enable REST flag for React Client. 
if exists(select * from MODULES where MODULE_NAME = 'TwitterTracks' and REST_ENABLED = 0) begin -- then
	if not exists(select * from CONFIG where NAME = 'Module.Config.Level') or exists(select * from CONFIG where NAME = 'Module.Config.Level' and cast(VALUE as float) < 13.0) begin -- then
		update MODULES
		   set REST_ENABLED        = 1
		     , DATE_MODIFIED       = getdate()
		     , DATE_MODIFIED_UTC   = getutcdate()
		     , MODIFIED_USER_ID    = null
		 where MODULE_NAME         = 'TwitterTracks'
		   and REST_ENABLED        = 0;
		update MODULES
		   set REST_ENABLED        = 1
		     , DATE_MODIFIED       = getdate()
		     , DATE_MODIFIED_UTC   = getutcdate()
		     , MODIFIED_USER_ID    = null
		 where MODULE_NAME         = 'TwitterMessages'
		   and REST_ENABLED        = 0;
	end -- if;
end -- if;
GO

-- 12/18/2015 Paul.  Add AuthorizeNet module. 
exec dbo.spMODULES_InsertOnly null, 'AuthorizeNet'          , '.moduleList.AuthorizeNet'             , '~/Administration/AuthorizeNet/'     , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 1, 0, 0, 0, 0;

-- 05/18/2010 Paul.  Add defaults for Exchange Folders and Exchange Create Parent. 
-- 12/06/2010 Paul.  Convert display name to use moduleList. 
-- 09/12/2011 Paul.  REST_ENABLED provides a way to enable/disable a module in the REST API. 
-- 01/01/2016 Paul.  Move PayPal module to Professional. 
exec dbo.spMODULES_InsertOnly null, 'PayPal', '.moduleList.PayPal', '~/Administration/PayPalTransactions/', 1, 0,  0, 0, 0, 0, 0, 1, null, 0, 0, 0, 0, 0, 0;
-- 04/10/2022 Paul.  React client relies upon MASS_UPDATE_ENABLED
if exists(select * from MODULES where MODULE_NAME = 'PayPal' and MASS_UPDATE_ENABLED is null) begin -- then
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME         = 'PayPal'
	   and MASS_UPDATE_ENABLED is null;
end -- if;
GO
-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
exec dbo.spMODULES_InsertOnly null, 'ModulesArchiveRules'   , '.moduleList.ModulesArchiveRules'      , '~/Administration/ModulesArchiveRules/', 1, 0,  0, 0, 0, 0, 0, 1, 'MODULES_ARCHIVE_RULES', 0, 0, 0, 0, 0, 0;
-- 03/06/2018 Paul.  MailMerge requires access rights so it needs a module record. 
exec dbo.spMODULES_InsertOnly null, 'MailMerge'             , '.moduleList.MailMerge'                , '~/MailMerge/'                         , 1, 0,  0, 0, 0, 0, 0, 0, null                   , 0, 0, 0, 0, 0, 0;
GO

-- 03/14/2014 Paul.  DUP_CHECH_ENABLED enables duplicate checking. 
if exists(select * from MODULES where MODULE_NAME = N'Contracts' and DUPLICATE_CHECHING_ENABLED is null) begin -- then
	print 'MODULES: Update DUPLICATE_CHECHING_ENABLED defaults.';
	update MODULES
	   set DUPLICATE_CHECHING_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME in 
		( N'Contracts'
		, N'Reports'
		, N'Charts'
		, N'KBDocuments'
		, N'ProductTemplates'
		, N'Surveys'
		, N'SurveyQuestions'
		, N'TwitterTracks'
		);
end -- if;
GO

-- 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
if exists(select * from MODULES where MODULE_NAME = N'SurveyResults' and DEFAULT_SORT is null) begin -- then
	print 'MODULES: Update DEFAULT_SORT defaults.';
	update MODULES
	   set DEFAULT_SORT        = 'DATE_ENTERED desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'SurveyResults';

	update MODULES
	   set DEFAULT_SORT        = 'QUOTE_NUM desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Quotes';

	update MODULES
	   set DEFAULT_SORT        = 'INVOICE_NUM desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Invoices';

	update MODULES
	   set DEFAULT_SORT        = 'ORDER_NUM desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Orders';

	update MODULES
	   set DEFAULT_SORT        = 'PAYMENT_DATE desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Payments';

	update MODULES
	   set DEFAULT_SORT        = 'ACCOUNT_NAME asc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'CreditCards';

	update MODULES
	   set DEFAULT_SORT        = 'NAME desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Asterisk';
end -- if;
GO


-- 08/24/2008 Paul.  Reorder the modules. 
exec dbo.spMODULES_Reorder null;
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

call dbo.spMODULES_Professional()
/

call dbo.spSqlDropProcedure('spMODULES_Professional')
/

-- #endif IBM_DB2 */

