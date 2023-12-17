

print 'RELATIONSHIPS Professional';
GO

set nocount on;
GO

-- 07/13/2006 Paul.  Contracts, Products and Quotes modules have been added. 
-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 10/10/2008 Paul.  Add relationships used in workflow. 
-- 03/24/2011 Paul.  Add spacing to make the parameters align. 
exec dbo.spRELATIONSHIPS_InsertOnly 'account_contracts'       , 'Accounts' , 'accounts' , 'id', 'Contracts'    , 'contracts'    , 'account_id'      , null, null, null         , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contract_notes'          , 'Contracts', 'contracts', 'id', 'Notes'        , 'notes'        , 'parent_id'       , null, null, null         , 'one-to-many', 'parent_type'   , 'Contracts', 0;
-- 05/24/2016 Paul.  Add activity relationships for Contracts module. 
exec dbo.spRELATIONSHIPS_InsertOnly 'contract_calls'          , 'Contracts', 'contracts', 'id', 'Calls'        , 'calls'        , 'parent_id'       , null, null, null         , 'one-to-many', 'parent_type'   , 'Contracts', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contract_meetings'       , 'Contracts', 'contracts', 'id', 'Meetings'     , 'meetings'     , 'parent_id'       , null, null, null         , 'one-to-many', 'parent_type'   , 'Contracts', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contract_notes'          , 'Contracts', 'contracts', 'id', 'Notes'        , 'notes'        , 'parent_id'       , null, null, null         , 'one-to-many', 'parent_type'   , 'Contracts', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contract_tasks'          , 'Contracts', 'contracts', 'id', 'Tasks'        , 'tasks'        , 'parent_id'       , null, null, null         , 'one-to-many', 'parent_type'   , 'Contracts', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_assigned_user' , 'Users'    , 'users'    , 'id', 'Contracts'    , 'contracts'    , 'assigned_user_id', null, null, null         , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_contacts'      , 'Contracts', 'contracts', 'id', 'Contacts'     , 'contacts'     , 'id'              , 'contracts_contacts'     , 'contract_id', 'contact_id'    , 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_created_by'    , 'Users'    , 'users'    , 'id', 'Contracts'    , 'contracts'    , 'created_by'      , null, null, null         , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_modified_user' , 'Users'    , 'users'    , 'id', 'Contracts'    , 'contracts'    , 'modified_user_id', null, null, null         , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_opportunities' , 'Contracts', 'contracts', 'id', 'Opportunities', 'opportunities', 'id'              , 'contracts_opportunities', 'contract_id', 'opportunity_id', 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_products'      , 'Contracts', 'contracts', 'id', 'Products'     , 'products'     , 'id'              , 'contracts_products'     , 'contract_id', 'product_id'    , 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contracts_quotes'        , 'Contracts', 'contracts', 'id', 'Quotes'       , 'quotes'       , 'id'              , 'contracts_quotes'       , 'contract_id', 'quote_id'      , 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'emails_quotes'           , 'Emails'   , 'emails'   , 'id', 'Quotes'       , 'quotes'       , 'id'              , 'emails_quotes'          , 'email_id'   , 'quote_id'      , 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'product_notes'           , 'Products' , 'products' , 'id', 'Notes'        , 'notes'        , 'parent_id'       , null, null, null         , 'one-to-many', 'parent_type'   , 'Products', 0;
-- 11/20/2008 Paul.  We don't use PRODUCT_PRODUCT table. 
if exists(select * from RELATIONSHIPS where RELATIONSHIP_NAME = 'product_product') begin -- then
	delete from RELATIONSHIPS
	where RELATIONSHIP_NAME = 'product_product';
end -- if;
-- 11/20/2008 Paul.  We don't use PRODUCT_BUNDLE_QUOTE table. 
if exists(select * from RELATIONSHIPS where RELATIONSHIP_NAME = 'product_bundle_quote') begin -- then
	delete from RELATIONSHIPS
	where RELATIONSHIP_NAME = 'product_bundle_quote';
end -- if;

exec dbo.spRELATIONSHIPS_InsertOnly 'products_assigned_user'  , 'Users'    , 'users'    , 'id', 'Products'     , 'products'     , 'assigned_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'products_created_by'     , 'Users'    , 'users'    , 'id', 'Products'     , 'products'     , 'created_by_id'   , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'products_modified_user'  , 'Users'    , 'users'    , 'id', 'Products'     , 'products'     , 'modified_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quote_calls'             , 'Quotes'   , 'quotes'   , 'id', 'Calls'        , 'calls'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Quotes', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quote_meetings'          , 'Quotes'   , 'quotes'   , 'id', 'Meetings'     , 'meetings'     , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Quotes', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quote_notes'             , 'Quotes'   , 'quotes'   , 'id', 'Notes'        , 'notes'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Quotes', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quote_products'          , 'Quotes'   , 'quotes'   , 'id', 'Products'     , 'products'     , 'quote_id'        , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quote_tasks'             , 'Quotes'   , 'quotes'   , 'id', 'Tasks'        , 'tasks'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Quotes', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_assigned_user'    , 'Users'    , 'users'    , 'id', 'Quotes'       , 'quotes'       , 'assigned_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_billto_accounts'  , 'Quotes'   , 'quotes'   , 'id', 'Accounts'     , 'accounts'     , 'id'              , 'quotes_accounts'     , 'quote_id'   , 'account_id'    , 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_contacts_billto'  , 'Quotes'   , 'quotes'   , 'id', 'Contacts'     , 'contacts'     , 'id'              , 'quotes_contacts'     , 'quote_id'   , 'contact_id'    , 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_contacts_shipto'  , 'Quotes'   , 'quotes'   , 'id', 'Contacts'     , 'contacts'     , 'id'              , 'quotes_contacts'     , 'quote_id'   , 'contact_id'    , 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_created_by'       , 'Users'    , 'users'    , 'id', 'Quotes'       , 'quotes'       , 'created_by_id'   , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_modified_user'    , 'Users'    , 'users'    , 'id', 'Quotes'       , 'quotes'       , 'modified_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_opportunities'    , 'Quotes'   , 'quotes'   , 'id', 'Opportunities', 'opportunities', 'id'              , 'quotes_opportunities', 'quote_id'   , 'opportunity_id', 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'quotes_shipto_accounts'  , 'Quotes'   , 'quotes'   , 'id', 'Accounts'     , 'accounts'     , 'id'              , 'quotes_accounts'     , 'quote_id'   , 'account_id'    , 'many-to-many', 'account_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'projects_quotes'         , 'Project'  , 'project'  , 'id', 'Quotes'       , 'quotes'       , 'id'              , 'projects_quotes'     , 'project_id' , 'quote_id'      , 'many-to-many', null, null, 0;

exec dbo.spRELATIONSHIPS_InsertOnly 'invoice_calls'           , 'Invoices' , 'invoices' , 'id', 'Calls'        , 'calls'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Invoices', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoice_meetings'        , 'Invoices' , 'invoices' , 'id', 'Meetings'     , 'meetings'     , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Invoices', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoice_notes'           , 'Invoices' , 'invoices' , 'id', 'Notes'        , 'notes'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Invoices', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoice_products'        , 'Invoices' , 'invoices' , 'id', 'Products'     , 'products'     , 'invoice_id'      , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoice_tasks'           , 'Invoices' , 'invoices' , 'id', 'Tasks'        , 'tasks'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Invoices', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_assigned_user'  , 'Users'    , 'users'    , 'id', 'Invoices'     , 'invoices'     , 'assigned_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_billto_accounts', 'Invoices' , 'invoices' , 'id', 'Accounts'     , 'accounts'     , 'id'              , 'invoices_accounts'   , 'invoice_id', 'account_id'     , 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_contacts_billto', 'Invoices' , 'invoices' , 'id', 'Contacts'     , 'contacts'     , 'id'              , 'invoices_contacts'   , 'invoice_id', 'contact_id'     , 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_contacts_shipto', 'Invoices' , 'invoices' , 'id', 'Contacts'     , 'contacts'     , 'id'              , 'invoices_contacts'   , 'invoice_id', 'contact_id'     , 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_created_by'     , 'Users'    , 'users'    , 'id', 'Invoices'     , 'invoices'     , 'created_by_id'   , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_modified_user'  , 'Users'    , 'users'    , 'id', 'Invoices'     , 'invoices'     , 'modified_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_shipto_accounts', 'Invoices' , 'invoices' , 'id', 'Accounts'     , 'accounts'     , 'id'              , 'invoices_accounts'   , 'invoice_id', 'account_id'     , 'many-to-many', 'account_role', 'Ship To', 0;
-- 11/20/2008 Paul.  There is no INVOICES_OPPORTUNITIES table. 
-- 10/19/2010 Paul.  Add correct relationship for Invoices/Opportunities. 
exec dbo.spRELATIONSHIPS_InsertOnly 'invoices_opportunities'  , 'Invoices' , 'invoices' , 'opportunity_id', 'Opportunities', 'opportunities', 'id', null, null, null, 'one-to-many', null, null, 0;

exec dbo.spRELATIONSHIPS_InsertOnly 'order_calls'             , 'Orders'   , 'orders'   , 'id', 'Calls'        , 'calls'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Orders', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'order_meetings'          , 'Orders'   , 'orders'   , 'id', 'Meetings'     , 'meetings'     , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Orders', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'order_notes'             , 'Orders'   , 'orders'   , 'id', 'Notes'        , 'notes'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Orders', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'order_products'          , 'Orders'   , 'orders'   , 'id', 'Products'     , 'products'     , 'order_id'        , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'order_tasks'             , 'Orders'   , 'orders'   , 'id', 'Tasks'        , 'tasks'        , 'parent_id'       , null, null, null      , 'one-to-many', 'parent_type'   , 'Orders', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_assigned_user'    , 'Users'    , 'users'    , 'id', 'Orders'       , 'orders'       , 'assigned_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_billto_accounts'  , 'Orders'   , 'orders'   , 'id', 'Accounts'     , 'accounts'     , 'id'              , 'orders_accounts'     , 'order_id'   , 'account_id'    , 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_contacts_billto'  , 'Orders'   , 'orders'   , 'id', 'Contacts'     , 'contacts'     , 'id'              , 'orders_contacts'     , 'order_id'   , 'contact_id'    , 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_contacts_shipto'  , 'Orders'   , 'orders'   , 'id', 'Contacts'     , 'contacts'     , 'id'              , 'orders_contacts'     , 'order_id'   , 'contact_id'    , 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_created_by'       , 'Users'    , 'users'    , 'id', 'Orders'       , 'orders'       , 'created_by_id'   , null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_modified_user'    , 'Users'    , 'users'    , 'id', 'Orders'       , 'orders'       , 'modified_user_id', null, null, null      , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_opportunities'    , 'Orders'   , 'orders'   , 'id', 'Opportunities', 'opportunities', 'id'              , 'orders_opportunities', 'order_id'   , 'opportunity_id', 'many-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'orders_shipto_accounts'  , 'Orders'   , 'orders'   , 'id', 'Accounts'     , 'accounts'     , 'id'              , 'orders_accounts'     , 'order_id'   , 'account_id'    , 'many-to-many', 'account_role', 'Ship To', 0;

-- 03/24/2011 Paul.  Add relationships that reverse the LHS and RHS. 
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_quotes_billto'  , 'Contacts' , 'contacts' , 'id', 'Quotes'       , 'quotes'       , 'id'              , 'quotes_contacts'     , 'contact_id' , 'quote_id'      , 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_quotes_shipto'  , 'Contacts' , 'contacts' , 'id', 'Quotes'       , 'quotes'       , 'id'              , 'quotes_contacts'     , 'contact_id' , 'quote_id'      , 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_invoices_billto', 'Contacts' , 'contacts' , 'id', 'Invoices'     , 'invoices'     , 'id'              , 'invoices_contacts'   , 'contact_id' , 'invoice_id'    , 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_invoices_shipto', 'Contacts' , 'contacts' , 'id', 'Invoices'     , 'invoices'     , 'id'              , 'invoices_contacts'   , 'contact_id' , 'invoice_id'    , 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_orders_billto'  , 'Contacts' , 'contacts' , 'id', 'Orders'       , 'orders'       , 'id'              , 'orders_contacts'     , 'contact_id' , 'order_id'      , 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_orders_shipto'  , 'Contacts' , 'contacts' , 'id', 'Orders'       , 'orders'       , 'id'              , 'orders_contacts'     , 'contact_id' , 'order_id'      , 'many-to-many', 'contact_role', 'Ship To', 0;

exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_quotes_billto'  , 'Accounts' , 'accounts' , 'id', 'Quotes'       , 'quotes'       , 'id'              , 'quotes_accounts'     , 'account_id' , 'quote_id'      , 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_quotes_shipto'  , 'Accounts' , 'accounts' , 'id', 'Quotes'       , 'quotes'       , 'id'              , 'quotes_accounts'     , 'account_id' , 'quote_id'      , 'many-to-many', 'account_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_invoices_billto', 'Accounts' , 'accounts' , 'id', 'Invoices'     , 'invoices'     , 'id'              , 'invoices_accounts'   , 'account_id' , 'invoice_id'    , 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_invoices_shipto', 'Accounts' , 'accounts' , 'id', 'Invoices'     , 'invoices'     , 'id'              , 'invoices_accounts'   , 'account_id' , 'invoice_id'    , 'many-to-many', 'account_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_orders_billto'  , 'Accounts' , 'accounts' , 'id', 'Orders'       , 'orders'       , 'id'              , 'orders_accounts'     , 'account_id' , 'order_id'      , 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_orders_shipto'  , 'Accounts' , 'accounts' , 'id', 'Orders'       , 'orders'       , 'id'              , 'orders_accounts'     , 'account_id' , 'order_id'      , 'many-to-many', 'account_role', 'Ship To', 0;

-- delete from RELATIONSHIPS where date_entered > '2011-10-26'
-- 10/26/2011 Paul.  Add views and relationships to allow filtering on line items. 
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_quotes_line_items_billto'  , 'Contacts' , 'contacts' , 'id', 'QuotesLineItems'  , 'quotes_line_items'  , 'id', 'quotes_line_items_contacts'  , 'contact_id' , 'id', 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_quotes_line_items_shipto'  , 'Contacts' , 'contacts' , 'id', 'QuotesLineItems'  , 'quotes_line_items'  , 'id', 'quotes_line_items_contacts'  , 'contact_id' , 'id', 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_invoices_line_items_billto', 'Contacts' , 'contacts' , 'id', 'InvoicesLineItems', 'invoices_line_items', 'id', 'invoices_line_items_contacts', 'contact_id' , 'id', 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_invoices_line_items_shipto', 'Contacts' , 'contacts' , 'id', 'InvoicesLineItems', 'invoices_line_items', 'id', 'invoices_line_items_contacts', 'contact_id' , 'id', 'many-to-many', 'contact_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_orders_line_items_billto'  , 'Contacts' , 'contacts' , 'id', 'OrdersLineItems'  , 'orders_line_items'  , 'id', 'orders_line_items_contacts'  , 'contact_id' , 'id', 'many-to-many', 'contact_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'contacts_orders_line_items_shipto'  , 'Contacts' , 'contacts' , 'id', 'OrdersLineItems'  , 'orders_line_items'  , 'id', 'orders_line_items_contacts'  , 'contact_id' , 'id', 'many-to-many', 'contact_role', 'Ship To', 0;

exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_quotes_line_items_billto'  , 'Accounts' , 'accounts' , 'id', 'QuotesLineItems'  , 'quotes_line_items'  , 'id', 'quotes_line_items_accounts'  , 'account_id' , 'id', 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_quotes_line_items_shipto'  , 'Accounts' , 'accounts' , 'id', 'QuotesLineItems'  , 'quotes_line_items'  , 'id', 'quotes_line_items_accounts'  , 'account_id' , 'id', 'many-to-many', 'account_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_invoices_line_items_billto', 'Accounts' , 'accounts' , 'id', 'InvoicesLineItems', 'invoices_line_items', 'id', 'invoices_line_items_accounts', 'account_id' , 'id', 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_invoices_line_items_shipto', 'Accounts' , 'accounts' , 'id', 'InvoicesLineItems', 'invoices_line_items', 'id', 'invoices_line_items_accounts', 'account_id' , 'id', 'many-to-many', 'account_role', 'Ship To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_orders_line_items_billto'  , 'Accounts' , 'accounts' , 'id', 'OrdersLineItems'  , 'orders_line_items'  , 'id', 'orders_line_items_accounts'  , 'account_id' , 'id', 'many-to-many', 'account_role', 'Bill To', 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'accounts_orders_line_items_shipto'  , 'Accounts' , 'accounts' , 'id', 'OrdersLineItems'  , 'orders_line_items'  , 'id', 'orders_line_items_accounts'  , 'account_id' , 'id', 'many-to-many', 'account_role', 'Ship To', 0;

GO

-- 06/21/2011 Paul.  Add relationships so that we can report on LineItems.
exec dbo.spRELATIONSHIPS_InsertOnly 'quote_quoteslineitems'    , 'Quotes'  , 'quotes'   , 'id', 'QuotesLineItems'  , 'quotes_line_items'  , 'quote_id'  , null, null, null         , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'order_orderslineitems'    , 'Orders'  , 'orders'   , 'id', 'OrdersLineItems'  , 'orders_line_items'  , 'order_id'  , null, null, null         , 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'invoice_invoiceslineitems', 'Invoices', 'invoices' , 'id', 'InvoicesLineItems', 'invoices_line_items', 'invoice_id', null, null, null         , 'one-to-many', null, null, 0;

-- 10/25/2014 Paul.  Add survey relationships.
-- 12/30/2015 Paul.  Change to many-to-many so that the relationships will appear in the Target Dynamic List Query Builder. 
-- 01/30/2016 Paul.  one-to-many is the correct relationship type as we want them to appear in the Filter Modules dropdown, not the Related Modules dropdown.
-- delete from RELATIONSHIPS where RELATIONSHIP_NAME = 'survey_results_contacts';
exec dbo.spRELATIONSHIPS_InsertOnly 'survey_results_contacts' , 'Contacts' , 'contacts' , 'id', 'SurveyResults', 'survey_results', 'parent_id', null, null, null, 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'survey_results_leads'    , 'Leads'    , 'leads'    , 'id', 'SurveyResults', 'survey_results', 'parent_id', null, null, null, 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'survey_results_prospects', 'Prospects', 'prospects', 'id', 'SurveyResults', 'survey_results', 'parent_id', null, null, null, 'one-to-many', null, null, 0;
exec dbo.spRELATIONSHIPS_InsertOnly 'survey_results_users'    , 'Users'    , 'users'    , 'id', 'SurveyResults', 'survey_results', 'parent_id', null, null, null, 'one-to-many', null, null, 0;
if exists(select * from RELATIONSHIPS where RELATIONSHIP_NAME = 'survey_results_contacts' and RELATIONSHIP_TYPE = 'many-to-many' and DELETED = 0) begin -- then
	update RELATIONSHIPS
	   set RELATIONSHIP_TYPE = 'one-to-many'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where RELATIONSHIP_NAME in ('survey_results_contacts', 'survey_results_leads', 'survey_results_prospects')
	   and RELATIONSHIP_TYPE = 'many-to-many'
	   and DELETED = 0;
end -- if;
-- 01/30/2016 Paul.  Add Surveys to the results. 
-- delete from RELATIONSHIPS where RELATIONSHIP_NAME = 'survey_results_surveys';
-- select * from vwRELATIONSHIPS_Reporting  where RHS_MODULE = 'SurveyResults' and RELATIONSHIP_TYPE = 'one-to-many'
exec dbo.spRELATIONSHIPS_InsertOnly 'survey_results_surveys'  , 'Surveys'  , 'surveys'  , 'id', 'SurveyResults', 'survey_results', 'survey_id', null, null, null, 'one-to-many', null, null, 0;
GO

-- 05/28/2020 Paul.  The React Client needs this relationship. 
exec dbo.spRELATIONSHIPS_InsertOnly 'team_memberships'            , 'Teams'     , 'teams'     , 'id', 'Users'         , 'users'        , 'id', 'team_memberships', 'team_id', 'user_id', 'many-to-many', null, null, 0;
-- 11/10/2020 Paul.  The React Client needs this relationship. 
exec dbo.spRELATIONSHIPS_InsertOnly 'team_zipcodes'               , 'Teams'     , 'teams'     , 'id', 'ZipCodes'      , 'zipcodes'     , 'id', 'teams_zipcodes'  , 'team_id', 'zipcode_id', 'many-to-many', null, null, 0;
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

call dbo.spRELATIONSHIPS_Professional()
/

call dbo.spSqlDropProcedure('spRELATIONSHIPS_Professional')
/

-- #endif IBM_DB2 */

