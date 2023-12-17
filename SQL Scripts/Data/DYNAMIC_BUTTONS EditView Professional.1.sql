

print 'DYNAMIC_BUTTONS EditView Professional';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.EditView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
--	exec dbo.spDYNAMIC_BUTTONS_InsButton  '.EditView'                      , 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'     , '.LBL_SAVE_BUTTON_TITLE'     , '.LBL_SAVE_BUTTON_KEY'     , null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton  '.EditView'                      , 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , '.LBL_CANCEL_BUTTON_KEY'   , null, null;

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   '.EditView'                       , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel '.EditView'                       , 1, null, 0;  -- EditView Cancel is always visible. 
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Contracts.EditView'       , 'Contracts'       ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Forums.EditView'          , 'Forums'          ;
--exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Invoices.EditView'        , 'Invoices'        ;
--exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Orders.EditView'          , 'Orders'          ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Posts.EditView'           , 'Posts'           ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Products.EditView'        , 'Products'        ;
--exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Quotes.EditView'          , 'Quotes'          ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Threads.EditView'         , 'Threads'         ;
-- 10/18/2009 Paul.  Add Knowledge Base module. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'KBDocuments.EditView'     , 'KBDocuments'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'KBTags.EditView'          , 'KBTags'          ;
-- 10/10/2016 Paul.  Add Buttons for OrdersLineItems. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'OrdersLineItems.EditView' , 'OrdersLineItems' ;
GO

-- 09/12/2010 Paul.  Restore the original logic where the cancel button returns to the original location. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Invoices.EditView', 0, 'Invoices', 'edit', null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , '.LBL_SAVE_BUTTON_KEY'  , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Invoices.EditView', 1, 'Invoices', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', '.LBL_CANCEL_BUTTON_KEY', null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView' and COMMAND_NAME = 'Cancel' and CONTROL_TYPE = 'ButtonLink' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Invoices.EditView: Restore Cancel behavior. ';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE      = 'Button'
		     , TEXT_FIELD        = null
		     , URL_FORMAT        = null
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Invoices.EditView'
		   and COMMAND_NAME      = 'Cancel'
		   and CONTROL_TYPE      = 'ButtonLink'
		   and DELETED           = 0;
	end -- if;
end -- if;

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Orders.EditView', 0, 'Orders', 'edit', null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , '.LBL_SAVE_BUTTON_KEY'  , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Orders.EditView', 1, 'Orders', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', '.LBL_CANCEL_BUTTON_KEY', null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EditView' and COMMAND_NAME = 'Cancel' and CONTROL_TYPE = 'ButtonLink' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Orders.EditView: Restore Cancel behavior. ';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE      = 'Button'
		     , TEXT_FIELD        = null
		     , URL_FORMAT        = null
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Orders.EditView'
		   and COMMAND_NAME      = 'Cancel'
		   and CONTROL_TYPE      = 'ButtonLink'
		   and DELETED           = 0;
	end -- if;
end -- if;

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Quotes.EditView', 0, 'Quotes', 'edit', null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , '.LBL_SAVE_BUTTON_KEY'  , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Quotes.EditView', 1, 'Quotes', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', '.LBL_CANCEL_BUTTON_KEY', null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView' and COMMAND_NAME = 'Cancel' and CONTROL_TYPE = 'ButtonLink' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Quotes.EditView: Restore Cancel behavior. ';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE      = 'Button'
		     , TEXT_FIELD        = null
		     , URL_FORMAT        = null
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Quotes.EditView'
		   and COMMAND_NAME      = 'Cancel'
		   and CONTROL_TYPE      = 'ButtonLink'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 04/22/2008 Paul.  Remove Run Report. 
-- 04/22/2008 Paul.  Remove Refund Now.  It has been moved to the Payment Transaction grid.
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   'Payments.EditView'               , 0, 'Payments'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Payments.EditView'               , 1, 'Payments'        , 0;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Payments.EditView'               , 2, 'Payments'        , 'edit', null             , null, 'Charge'                   , null, 'Payments.LBL_CHARGE_BUTTON_LABEL'            , 'Payments.LBL_CHARGE_BUTTON_TITLE'            , null, null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Payments.EditView'               , 4, 'Payments'        , 'edit', null             , null, 'Refund'                   , null, 'Payments.LBL_REFUND_BUTTON_LABEL'            , 'Payments.LBL_REFUND_BUTTON_TITLE'            , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Payments.EditView'               , 5, 'Payments'        , 'edit', null             , null, 'SelectGateway'            , null, 'Payments.LBL_CHARGE_BUTTON_LABEL'            , 'Payments.LBL_CHARGE_BUTTON_TITLE'            , null, 'SelectGateway(); return false;', null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView' and COMMAND_NAME = 'Run' and DELETED = 0) begin -- then
		print 'Payments.EditView: Remove Run Report.';
		update DYNAMIC_BUTTONS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Payments.EditView'
		   and COMMAND_NAME     = 'Run'
		   and DELETED          = 0;
	end -- if;
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView' and COMMAND_NAME = 'Refund' and DELETED = 0) begin -- then
		print 'Payments.EditView: Remove Refund Now.';
		update DYNAMIC_BUTTONS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Payments.EditView'
		   and COMMAND_NAME     = 'Refund'
		   and DELETED          = 0;
	end -- if;
	-- select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView' order by CONTROL_INDEX
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView' and COMMAND_NAME = 'SelectGateway' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsButton 'Payments.EditView'               , 5, 'Payments'        , 'edit', null             , null, 'SelectGateway'            , null, 'Payments.LBL_CHARGE_BUTTON_LABEL'            , 'Payments.LBL_CHARGE_BUTTON_TITLE'            , null, 'SelectGateway(); return false;', null;
	end -- if;
end -- if;
GO

-- 02/07/2010 Paul.  Add button to Send as Attachment. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.EditView'                , 0, 'Reports'         , 'view', null              , null, 'Run'                     , null, 'Reports.LBL_RUN_BUTTON_LABEL'                , 'Reports.LBL_RUN_BUTTON_TITLE'                , 'Reports.LBL_RUN_BUTTON_KEY'                , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.EditView'                , 1, 'Reports'         , 'edit', null              , null, 'Save'                    , null, 'Reports.LBL_SAVE_BUTTON_LABEL'               , 'Reports.LBL_SAVE_BUTTON_TITLE'               , 'Reports.LBL_SAVE_BUTTON_KEY'               , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.EditView'                , 2, 'Reports'         , 'view', null              , null, 'Print'                   , null, 'Reports.LBL_PRINT_BUTTON_LABEL'              , 'Reports.LBL_PRINT_BUTTON_TITLE'              , 'Reports.LBL_PRINT_BUTTON_KEY'              , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.EditView'                , 3, 'Reports'         , 'view', null              , null, 'Attachment'              , null, 'Reports.LBL_ATTACHMENT_BUTTON_LABEL'         , 'Reports.LBL_ATTACHMENT_BUTTON_TITLE'         , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Reports.EditView'                , 4, 'Reports'         , 0;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.EditView' and COMMAND_NAME like 'Attachment' and DELETED = 0) begin -- then
		print 'Reports.DetailView: Add Attachment button.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Reports.EditView'
		   and CONTROL_INDEX    >= 3
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.EditView'                , 3, 'Reports'         , 'view', null              , null, 'Attachment'              , null, 'Reports.LBL_ATTACHMENT_BUTTON_LABEL'         , 'Reports.LBL_ATTACHMENT_BUTTON_TITLE'         , null                                        , null, null;
	end -- if;
end -- if;
GO

-- 12/22/2014 Paul.  ReportDesigner needs a separate set of buttons. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ReportDesigner.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ReportDesigner.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ReportDesigner.EditView'         , 0, 'ReportDesigner'  , 'view', null              , null, 'Run'                     , null, 'Reports.LBL_RUN_BUTTON_LABEL'                , 'Reports.LBL_RUN_BUTTON_TITLE'                , 'Reports.LBL_RUN_BUTTON_KEY'                , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ReportDesigner.EditView'         , 1, 'ReportDesigner'  , 'edit', null              , null, 'Save'                    , null, 'Reports.LBL_SAVE_BUTTON_LABEL'               , 'Reports.LBL_SAVE_BUTTON_TITLE'               , 'Reports.LBL_SAVE_BUTTON_KEY'               , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ReportDesigner.EditView'         , 2, 'ReportDesigner'  , 'view', null              , null, 'Print'                   , null, 'Reports.LBL_PRINT_BUTTON_LABEL'              , 'Reports.LBL_PRINT_BUTTON_TITLE'              , 'Reports.LBL_PRINT_BUTTON_KEY'              , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ReportDesigner.EditView'         , 3, 'ReportDesigner'  , 'view', null              , null, 'Attachment'              , null, 'Reports.LBL_ATTACHMENT_BUTTON_LABEL'         , 'Reports.LBL_ATTACHMENT_BUTTON_TITLE'         , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'ReportDesigner.EditView'         , 4, 'ReportDesigner'  , 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.ImportView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.ImportView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.ImportView'              , 0, 'Reports'         , 'edit', null              , null, 'Import'                  , null, 'Reports.LBL_IMPORT_BUTTON_LABEL'             , 'Reports.LBL_IMPORT_BUTTON_TITLE'             , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Reports.ImportView'              , 1, 'Reports'         , 0;
end -- if;
GO

-- 05/27/2008 Paul.  CreditCards.EditView: Cancel should be a Button.
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'CreditCards.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS CreditCards.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   'CreditCards.EditView'            , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'CreditCards.EditView'            , 1, null              , null  , null              , null, 'Cancel'                 , null, '.LBL_CANCEL_BUTTON_LABEL'                     , '.LBL_CANCEL_BUTTON_TITLE'                    , '.LBL_CANCEL_BUTTON_KEY'                    , null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'CreditCards.EditView' and CONTROL_TYPE = 'ButtonLink' and  COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
		print 'CreditCards.EditView: Cancel should be a Button.';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE     = 'Button'
		     , URL_FORMAT       = null
		     , TEXT_FIELD       = null
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'CreditCards.EditView'
		   and CONTROL_TYPE     = 'ButtonLink'
		   and COMMAND_NAME     = 'Cancel'
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- Administration
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.AdminEditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .AdminEditView';
	exec dbo.spDYNAMIC_BUTTONS_InsSave    '.AdminEditView'                 , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsSaveNew '.AdminEditView'                 , 1, null;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'ProductTemplates.EditView' , 'ProductTemplates' ;
--exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Roles.EditView'            , 'Roles'            ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'TeamNotices.EditView'      , 'TeamNotices'      ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Teams.EditView'            , 'Teams'            ;
-- 02/07/2012 Paul.  Regions buttons should have been added long ago. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView'     , 'Regions.EditView'          , 'Regions'          ;

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'ContractTypes.EditView'    , 'ContractTypes'    ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'ForumTopics.EditView'      , 'ForumTopics'      ;

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'Manufacturers.EditView'    , 'Manufacturers'    ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'ProductTypes.EditView'     , 'ProductTypes'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'Shippers.EditView'         , 'Shippers'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'TaxRates.EditView'         , 'TaxRates'         ;
-- 08/15/2010 Paul.  Discounts use the same quick edit as Discounts. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'Discounts.EditView'        , 'Discounts'        ;
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'PaymentTypes.EditView'     , 'PaymentTypes'     ;
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminEditView', 'PaymentTerms.EditView'     , 'PaymentTerms'     ;
GO

-- 06/02/2012 Paul.  Add cancel button. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ContractTypes.EditView' and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'ContractTypes.EditView', 2, null, 0;
end -- if;
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Manufacturers.EditView' and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Manufacturers.EditView', 2, null, 0;
end -- if;
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTypes.EditView' and COMMAND_NAME = 'Cancel';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTypes.EditView' and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'ProductTypes.EditView' , 2, null, 0;
end -- if;
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Shippers.EditView' and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Shippers.EditView'     , 2, null, 0;
end -- if;
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.EditView' and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'TaxRates.EditView'     , 2, null, 0;
end -- if;
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Discounts.EditView' and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Discounts.EditView'    , 2, null, 0;
end -- if;
GO

-- 05/09/2008 Paul.  The PaymentGateway Cancel needs to be processed as a Command. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentGateway.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS PaymentGateway.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'PaymentGateway.EditView'         , 0, null              , null  , null              , null, 'Save'                    , null, '.LBL_SAVE_BUTTON_LABEL'                      , '.LBL_SAVE_BUTTON_TITLE'                      , '.LBL_SAVE_BUTTON_KEY'                      , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'PaymentGateway.EditView'         , 1, null              , null  , null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , '.LBL_CANCEL_BUTTON_KEY'                    , null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentGateway.EditView' and CONTROL_TYPE = 'ButtonLink' and  COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
		print 'PaymentGateway.EditView: Cancel should be a Button.';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE     = 'Button'
		     , URL_FORMAT       = null
		     , TEXT_FIELD       = null
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'PaymentGateway.EditView'
		   and CONTROL_TYPE     = 'ButtonLink'
		   and COMMAND_NAME     = 'Cancel'
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- 03/22/2010 Paul.  Add ExchangeView. 
-- 01/17/2017 Paul.  Add support for OAuth. 
-- 12/09/2020 Paul.  Add Sync buttons. 
-- 12/09/2020 Paul.  Add System Sync Log. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 0, null, 'edit', null, null, 'Save'              , null, '.LBL_SAVE_BUTTON_LABEL'          , '.LBL_SAVE_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 1, null, null  , null, null, 'Cancel'            , null, '.LBL_CANCEL_BUTTON_LABEL'        , '.LBL_CANCEL_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 2, null, null  , null, null, 'Test'              , null, 'Exchange.LBL_TEST_BUTTON_LABEL'  , 'Exchange.LBL_TEST_BUTTON_LABEL'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 3, null, null  , null, null, 'Authorize'         , null, 'OAuth.LBL_AUTHORIZE_BUTTON_LABEL', 'OAuth.LBL_AUTHORIZE_BUTTON_LABEL', null, 'return Office365Authorize();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 4, null, null  , null, null, 'Exchange.SyncAll'  , null, 'Users.LBL_EXCHANGE_SYNC_ALL'     , 'Users.LBL_EXCHANGE_SYNC_ALL'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Exchange.EditView', 5, null, null  , null, null, 'Log'               , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 3, null, null  , null, null, 'Authorize'         , null, 'OAuth.LBL_AUTHORIZE_BUTTON_LABEL', 'OAuth.LBL_AUTHORIZE_BUTTON_LABEL', null, 'return Office365Authorize();', null;
	-- 12/09/2020 Paul.  Add Sync buttons. 
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.EditView', 4, null, null  , null, null, 'Exchange.SyncAll'  , null, 'Users.LBL_EXCHANGE_SYNC_ALL'     , 'Users.LBL_EXCHANGE_SYNC_ALL'     , null, null, null;
	-- 12/09/2020 Paul.  Add System Sync Log. 
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Exchange.EditView', 5, null, null  , null, null, 'Log'               , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.EditView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Exchange.EditView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 09/04/2013 Paul.  Add AsteriskView. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Asterisk.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Asterisk.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Asterisk.EditView', 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'        , '.LBL_SAVE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Asterisk.EditView', 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'      , '.LBL_CANCEL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Asterisk.EditView', 2, null, null  , null, null, 'Test'     , null, 'Asterisk.LBL_TEST_BUTTON_LABEL', 'Asterisk.LBL_TEST_BUTTON_LABEL', null, null, null;
end -- if;
GO

-- 09/04/2010 Paul.  ProductCategories will now use standard Save/Cancel buttons. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'ProductCategories.EditView', 'ProductCategories'         ;
if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductCategories.EditView' and COMMAND_NAME = 'SaveNew' and DELETED = 0) begin -- then
	update DYNAMIC_BUTTONS
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where VIEW_NAME         = 'ProductCategories.EditView'
	   and COMMAND_NAME      = 'SaveNew'
	   and DELETED           = 0;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'ProductCategories.EditView'     , 1, null              , 0;
end -- if;
GO

-- 09/26/2010 Paul.  ProductTypes will now use standard Save/Cancel buttons. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'ProductTypes.EditView', 'ProductTypes'         ;
if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTypes.EditView' and COMMAND_NAME = 'SaveNew' and DELETED = 0) begin -- then
	update DYNAMIC_BUTTONS
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where VIEW_NAME         = 'ProductTypes.EditView'
	   and COMMAND_NAME      = 'SaveNew'
	   and DELETED           = 0;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'ProductTypes.EditView'     , 1, null              , 0;
end -- if;
GO

-- 04/16/2011 Paul.  Add Google panel. 
-- 06/06/2011 Paul.  The Google Cancel needs to be processed as a Command. 
-- 09/21/2015 Paul.  Move Google entries to DYNAMIC_BUTTONS EditView Cloud Services.1.sql. 

-- 10/29/2011 Paul.  Add charts. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Charts.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Charts.EditView'                 , 0, 'Charts'          , 'edit', null              , null, 'Save'                    , null, 'Reports.LBL_SAVE_BUTTON_LABEL'               , 'Reports.LBL_SAVE_BUTTON_TITLE'               , 'Reports.LBL_SAVE_BUTTON_KEY'               , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Charts.EditView'                 , 1, 'Charts'          , 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.ImportView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Charts.ImportView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Charts.ImportView'               , 0, 'Charts'          , 'edit', null              , null, 'Import'                  , null, 'Reports.LBL_IMPORT_BUTTON_LABEL'             , 'Charts.LBL_IMPORT_BUTTON_TITLE'              , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Charts.ImportView'               , 1, 'Charts'          , 0;
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Surveys.EditView'         , 'Surveys'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'SurveyThemes.EditView'    , 'SurveyThemes'    ;

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.EditView';
-- 06/22/2013 Paul.  Restore the original logic where the cancel button returns to the original location. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'SurveyPages.EditView', 0, 'SurveyPages', 'edit', null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , '.LBL_SAVE_BUTTON_KEY'  , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'SurveyPages.EditView', 1, 'SurveyPages', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', '.LBL_CANCEL_BUTTON_KEY', null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.EditView' and COMMAND_NAME = 'Cancel' and CONTROL_TYPE = 'ButtonLink' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS SurveyPages.EditView: Restore Cancel behavior. ';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE      = 'Button'
		     , TEXT_FIELD        = null
		     , URL_FORMAT        = null
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'SurveyPages.EditView'
		   and COMMAND_NAME      = 'Cancel'
		   and CONTROL_TYPE      = 'ButtonLink'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 06/22/2013 Paul.  Restore the original logic where the cancel button returns to the original location. 
-- 07/31/2013 Paul.  Add SaveNew button to SurveyQuestion. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'SurveyQuestions.EditView', 0, 'SurveyQuestions', 'edit', null, null, 'Save'   , null, '.LBL_SAVE_BUTTON_LABEL'    , '.LBL_SAVE_BUTTON_TITLE'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'SurveyQuestions.EditView', 1, 'SurveyQuestions', 'edit', null, null, 'SaveNew', null, '.LBL_SAVE_NEW_BUTTON_LABEL', '.LBL_SAVE_NEW_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'SurveyQuestions.EditView', 2, 'SurveyQuestions', null  , null, null, 'Cancel' , null, '.LBL_CANCEL_BUTTON_LABEL'  , '.LBL_CANCEL_BUTTON_TITLE'  , null, null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.EditView' and COMMAND_NAME = 'Cancel' and CONTROL_TYPE = 'ButtonLink' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS SurveyQuestions.EditView: Restore Cancel behavior. ';
		update DYNAMIC_BUTTONS
		   set CONTROL_TYPE      = 'Button'
		     , TEXT_FIELD        = null
		     , URL_FORMAT        = null
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'SurveyQuestions.EditView'
		   and COMMAND_NAME      = 'Cancel'
		   and CONTROL_TYPE      = 'ButtonLink'
		   and DELETED           = 0;
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.EditView' and COMMAND_NAME like 'SaveNew' and DELETED = 0) begin -- then
		print 'SurveyQuestions.EditView: Add SaveNew button.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'SurveyQuestions.EditView'
		   and CONTROL_INDEX    >= 1
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton     'SurveyQuestions.EditView', 1, 'SurveyQuestions', 'edit', null, null, 'SaveNew', null, '.LBL_SAVE_NEW_BUTTON_LABEL', '.LBL_SAVE_NEW_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- 06/23/2013 Paul.  Add import button. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.ImportView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.ImportView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys.ImportView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Surveys.ImportView'              , 0, 'Surveys'         , 'edit', null              , null, 'Import'                  , null, 'Surveys.LBL_IMPORT_BUTTON_LABEL'             , 'Surveys.LBL_IMPORT_BUTTON_LABEL'             , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'Surveys.ImportView'              , 1, 'Surveys'         , 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'OutboundEmail.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS OutboundEmail.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   'OutboundEmail.EditView'          , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'OutboundEmail.EditView'          , 2, null              , 0;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'OutboundEmail.EditView'          , 3, null              , null  , null              , null, 'Test'                    , null, 'OutboundEmail.LBL_TEST_BUTTON_LABEL'         , 'OutboundEmail.LBL_TEST_BUTTON_LABEL'        , null, null, null;
end -- if;
GO

-- 09/13/2013 Paul.  Add PayTrace. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'PayTrace.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PayTrace.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PayTrace.EditView', 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'        , '.LBL_SAVE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PayTrace.EditView', 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'      , '.LBL_CANCEL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PayTrace.EditView', 2, null, null  , null, null, 'Test'     , null, 'PayTrace.LBL_TEST_BUTTON_LABEL', 'PayTrace.LBL_TEST_BUTTON_LABEL', null, null, null;
end -- if;
GO

-- 10/26/2013 Paul.  Buttons for Twitter Streaming. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Twitter.EditView' and COMMAND_NAME = 'Start' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Twitter.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Twitter.EditView', 2, null, null  , null, null, 'Start', null, 'Twitter.LBL_START_BUTTON', 'Twitter.LBL_START_BUTTON', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Twitter.EditView', 3, null, null  , null, null, 'Stop' , null, 'Twitter.LBL_STOP_BUTTON' , 'Twitter.LBL_STOP_BUTTON' , null, null, null;
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module.
--exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'TwitterTracks.EditView' , 'TwitterTracks' ;
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TwitterTracks.EditView' and COMMAND_NAME = 'Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS TwitterTracks.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   'TwitterTracks.EditView', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'TwitterTracks.EditView', 1, null, 0;  -- EditView Cancel is always visible. 
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'TwitterTracks.EditView', 2, 'TwitterTracks', 'edit', null, null, 'Search'  , null, '.LBL_SEARCH_BUTTON_LABEL'  , '.LBL_SEARCH_BUTTON_TITLE'  , null, null, null;
end -- if;
GO

-- 12/16/2015 Paul.  Add Authorize.Net. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'AuthorizeNet.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'AuthorizeNet.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'AuthorizeNet.EditView', 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'            , '.LBL_SAVE_BUTTON_TITLE'            , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'AuthorizeNet.EditView', 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'          , '.LBL_CANCEL_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'AuthorizeNet.EditView', 2, null, null  , null, null, 'Test'     , null, 'AuthorizeNet.LBL_TEST_BUTTON_LABEL', 'AuthorizeNet.LBL_TEST_BUTTON_LABEL', null, null, null;
end -- if;
GO

-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'ModulesArchiveRules.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ModulesArchiveRules.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ModulesArchiveRules.EditView', 0, null, 'edit', null, null, 'Save'          , null, '.LBL_SAVE_BUTTON_LABEL'                , '.LBL_SAVE_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ModulesArchiveRules.EditView', 1, null, null  , null, null, 'Cancel'        , null, '.LBL_CANCEL_BUTTON_LABEL'              , '.LBL_CANCEL_BUTTON_TITLE'              , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'ModulesArchiveRules.EditView', 2, null, null  , null, null, 'Filter.Preview', null, 'ModulesArchiveRules.LBL_PREVIEW_BUTTON', 'ModulesArchiveRules.LBL_PREVIEW_BUTTON', null, null, null;
end -- if;
GO

-- 04/30/2020 Paul.  MailMerge needed for React client. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'MailMerge.ListView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'MailMerge.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'MailMerge.ListView', 0, null, null, null, null, 'Generate', null, 'MailMerge.LBL_GENERATE_BUTTON', 'MailMerge.LBL_GENERATE_BUTTON', null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_EditViewProfessional()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditViewProfessional')
/

-- #endif IBM_DB2 */

