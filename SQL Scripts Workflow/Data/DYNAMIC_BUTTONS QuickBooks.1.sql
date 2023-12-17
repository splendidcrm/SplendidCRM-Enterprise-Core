

print 'DYNAMIC_BUTTONS QuickBooks';
GO

set nocount on;
GO

-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts.DetailView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Accounts.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooks', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end else begin
	-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.QuickBooks' and CONTROL_TYPE = 'ButtonLink' and MODULE_ACCESS_TYPE = 'edit' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Accounts.DetailView.QuickBooks:  Correct buttons to post-back so that ID can be treated as QID. ';
		update DYNAMIC_BUTTONS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where VIEW_NAME          = 'Accounts.DetailView.QuickBooks'
		   and CONTROL_TYPE       = 'ButtonLink'
		   and MODULE_ACCESS_TYPE = 'edit'
		   and DELETED            = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.EditView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Accounts.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DetailView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Contacts.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DetailView.QuickBooks', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Contacts.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices.DetailView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Invoices.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooks', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end else begin
	-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.QuickBooks' and CONTROL_TYPE = 'ButtonLink' and MODULE_ACCESS_TYPE = 'edit' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Invoices.DetailView.QuickBooks:  Correct buttons to post-back so that ID can be treated as QID. ';
		update DYNAMIC_BUTTONS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where VIEW_NAME          = 'Invoices.DetailView.QuickBooks'
		   and CONTROL_TYPE       = 'ButtonLink'
		   and MODULE_ACCESS_TYPE = 'edit'
		   and DELETED            = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Invoices.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders.DetailView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Orders.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.DetailView.QuickBooks', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end else begin
	-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView.QuickBooks' and CONTROL_TYPE = 'ButtonLink' and MODULE_ACCESS_TYPE = 'edit' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Orders.DetailView.QuickBooks:  Correct buttons to post-back so that ID can be treated as QID. ';
		update DYNAMIC_BUTTONS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where VIEW_NAME          = 'Orders.DetailView.QuickBooks'
		   and CONTROL_TYPE       = 'ButtonLink'
		   and MODULE_ACCESS_TYPE = 'edit'
		   and DELETED            = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EditView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Orders.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.DetailView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Quotes.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooks', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end else begin
	-- 02/04/2014 Paul.  Correct buttons to post-back so that ID can be treated as QID. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.QuickBooks' and CONTROL_TYPE = 'ButtonLink' and MODULE_ACCESS_TYPE = 'edit' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Quotes.DetailView.QuickBooks:  Correct buttons to post-back so that ID can be treated as QID. ';
		update DYNAMIC_BUTTONS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where VIEW_NAME          = 'Quotes.DetailView.QuickBooks'
		   and CONTROL_TYPE       = 'ButtonLink'
		   and MODULE_ACCESS_TYPE = 'edit'
		   and DELETED            = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   'Quotes.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Quotes.EditView.QuickBooks', 1, null, 0;
end -- if;
GO

-- 06/03/2014 Paul.  Add Authorize button. 
-- 04/27/2015 Paul.  Add Reconnect button. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', 2, null, null  , null, null, 'Test'     , null, '.LBL_TEST_BUTTON_LABEL'               , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', 3, null, null  , null, null, 'Authorize', null, 'QuickBooks.LBL_AUTHORIZE_BUTTON_LABEL', 'QuickBooks.LBL_AUTHORIZE_BUTTON_LABEL', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', 4, null, null  , null, null, 'Reconnect', null, 'QuickBooks.LBL_RECONNECT_BUTTON_LABEL', 'QuickBooks.LBL_RECONNECT_BUTTON_LABEL', null, null, null;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.ConfigView' and COMMAND_NAME = 'Authorize' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', -1, null, null  , null, null, 'Authorize', null, 'QuickBooks.LBL_AUTHORIZE_BUTTON_LABEL', 'QuickBooks.LBL_AUTHORIZE_BUTTON_LABEL', null, null, null;
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.ConfigView' and COMMAND_NAME = 'Reconnect' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsButton  'QuickBooks.ConfigView', -1, null, null  , null, null, 'Reconnect', null, 'QuickBooks.LBL_RECONNECT_BUTTON_LABEL', 'QuickBooks.LBL_RECONNECT_BUTTON_LABEL', null, null, null;
	end -- if;
end -- if;
GO

-- 03/01/2015 Paul.  Add ShowSync links. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'QuickBooks.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.DetailView', 5, null, null  , null, null, '~/Administration/QuickBooks/default.aspx?ShowSynchronized=1', null, 'QuickBooks.LBL_SHOW_SYNCHRONIZED'    , null, null, null, null, 0;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.DetailView', 6, null, null  , null, null, '~/Administration/QuickBooks/default.aspx'                   , null, 'QuickBooks.LBL_SHOW_NOT_SYNCHRONIZED', null, null, null, null, 0;
end else begin
	-- 03/01/2015 Paul.  Add ShowSync links. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.DetailView' and URL_FORMAT = '~/Administration/QuickBooks/default.aspx?ShowSynchronized=1' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.DetailView', 5, null, null  , null, null, '~/Administration/QuickBooks/default.aspx?ShowSynchronized=1', null, 'QuickBooks.LBL_SHOW_SYNCHRONIZED'    , null, null, null, null, 0;
		exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.DetailView', 6, null, null  , null, null, '~/Administration/QuickBooks/default.aspx'                   , null, 'QuickBooks.LBL_SHOW_NOT_SYNCHRONIZED', null, null, null, null, 0;
	end -- if;
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'QuickBooks.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/01/2015 Paul.  Update not supported by QBO V2. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.DetailView.QuickBooks';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS TaxRates.DetailView.QuickBooks';
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TaxRates.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TaxRates.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'TaxRates.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'TaxRates.DetailView.QuickBooks', 0, null, 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS TaxRates.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'TaxRates.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TaxRates.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProductTemplates.DetailView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.DetailView.QuickBooks', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.DetailView.QuickBooks', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'ProductTemplates.DetailView.QuickBooks', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.DetailView.QuickBooks', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProductTemplates.EditView.QuickBooks';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'ProductTemplates.EditView.QuickBooks', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like 'QuickBooks.%' and VIEW_NAME not like 'QuickBooks.DetailView' and VIEW_NAME not like 'QuickBooks.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'QuickBooks.ProductTemplates' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.PaymentTypes'    , 0, 'QuickBooks', 'view', 'PaymentTypes'    , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.PaymentTypes'    , 1, 'QuickBooks', 'view', 'PaymentTypes'    , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.PaymentTypes'    , 2, 'QuickBooks', 'view', 'PaymentTypes'    , 'edit', '~/Administration/PaymentTypes/QuickBooks/'    , null, 'QuickBooks.LBL_VIEW_PAYMENT_TYPES', null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.PaymentTerms'    , 0, 'QuickBooks', 'view', 'PaymentTerms'    , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.PaymentTerms'    , 1, 'QuickBooks', 'view', 'PaymentTerms'    , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.PaymentTerms'    , 2, 'QuickBooks', 'view', 'PaymentTerms'    , 'edit', '~/Administration/PaymentTerms/QuickBooks/'    , null, 'QuickBooks.LBL_VIEW_PAYMENT_TERMS', null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.ProductTemplates', 0, 'QuickBooks', 'view', 'ProductTemplates', 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.ProductTemplates', 1, 'QuickBooks', 'view', 'ProductTemplates', 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.ProductTemplates', 2, 'QuickBooks', 'view', 'ProductTemplates', 'edit', '~/Administration/ProductTemplates/QuickBooks/', null, 'QuickBooks.LBL_VIEW_ITEMS'        , null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.TaxRates'        , 0, 'QuickBooks', 'view', 'TaxRates'        , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.TaxRates'        , 1, 'QuickBooks', 'view', 'TaxRates'        , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.TaxRates'        , 2, 'QuickBooks', 'view', 'TaxRates'        , 'edit', '~/Administration/TaxRates/QuickBooks/'        , null, 'QuickBooks.LBL_VIEW_TAX_RATES'    , null, null, null, null, 0;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.TaxRates'        , 3, 'QuickBooks', 'view', 'TaxRates'        , 'edit', '~/Administration/TaxCodes/QuickBooks/'        , null, 'QuickBooks.LBL_VIEW_TAX_CODE'     , null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Accounts'        , 0, 'QuickBooks', 'view', 'Accounts'        , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Accounts'        , 1, 'QuickBooks', 'view', 'Accounts'        , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.Accounts'        , 2, 'QuickBooks', 'view', 'Accounts'        , 'edit', '~/Accounts/QuickBooks/'                       , null, 'QuickBooks.LBL_VIEW_CUSTOMERS'    , null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Invoices'        , 0, 'QuickBooks', 'view', 'Invoices'        , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Invoices'        , 1, 'QuickBooks', 'view', 'Invoices'        , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.Invoices'        , 2, 'QuickBooks', 'view', 'Invoices'        , 'edit', '~/Invoices/QuickBooks/'                       , null, 'QuickBooks.LBL_VIEW_INVOICES'     , null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Quotes'          , 0, 'QuickBooks', 'view', 'Quotes'          , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Quotes'          , 1, 'QuickBooks', 'view', 'Quotes'          , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.Quotes'          , 2, 'QuickBooks', 'view', 'Quotes'          , 'edit', '~/Quotes/QuickBooks/'                         , null, 'QuickBooks.LBL_VIEW_ESTIMATES'    , null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Payments'        , 0, 'QuickBooks', 'view', 'Payments'        , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.Payments'        , 1, 'QuickBooks', 'view', 'Payments'        , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.Payments'        , 2, 'QuickBooks', 'view', 'Payments'        , 'edit', '~/Payments/QuickBooks/'                       , null, 'QuickBooks.LBL_VIEW_PAYMENTS'     , null, null, null, null, 0;

	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.CreditMemos'     , 0, 'QuickBooks', 'view', 'Payments'        , 'edit', 'Sync'   , null, '.LBL_SYNC_BUTTON_LABEL'      , '.LBL_SYNC_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'QuickBooks.CreditMemos'     , 1, 'QuickBooks', 'view', 'Payments'        , 'edit', 'SyncAll', null, '.LBL_SYNC_ALL_BUTTON_LABEL'  , '.LBL_SYNC_ALL_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink  'QuickBooks.CreditMemos'     , 2, 'QuickBooks', 'view', 'Payments'        , 'edit', '~/Payments/CreditMemos/QuickBooks/'           , null, 'QuickBooks.LBL_VIEW_CREDIT_MEMOS' , null, null, null, null, 0;
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

call dbo.spDYNAMIC_BUTTONS_QuickBooks()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_QuickBooks')
/

-- #endif IBM_DB2 */

