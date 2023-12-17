

print 'DYNAMIC_BUTTONS DetailView Professional';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.DetailView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    '.DetailView', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , '.LBL_EDIT_BUTTON_KEY'     , null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    '.DetailView', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', '.LBL_DUPLICATE_BUTTON_KEY', null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    '.DetailView', 2, null, 'delete', null, null, 'Delete'   , null, '.LBL_DELETE_BUTTON_LABEL'   , '.LBL_DELETE_BUTTON_TITLE'   , '.LBL_DELETE_BUTTON_KEY'   , 'return ConfirmDelete();', null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    '.DetailView', 3, null, null    , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , '.LBL_CANCEL_BUTTON_KEY'   , null, null;

-- 05/21/2014 Paul.  Add View Log as a default. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      '.DetailView'                     , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate '.DetailView'                     , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    '.DetailView'                     , 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    '.DetailView'                     , 3, null, 1;  -- DetailView Cancel is only visible on mobile. 
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   '.DetailView'                     , 4, null;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'Contracts.DetailView'       , 'Contracts'       ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'CreditCards.DetailView'     , 'CreditCards'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'Forums.DetailView'          , 'Forums'          ;
--exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'Payments.DetailView'        , 'Payments'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'Products.DetailView'        , 'Products'        ;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Posts.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Posts.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      'Posts.DetailView'                , 0, 'Posts'           ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Posts.DetailView'                , 1, 'Posts'           ;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'Posts.DetailView'                , 2, 'Posts'           , 1;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Posts.PostView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Posts.PostView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Posts.PostView'                  , 0, 'Posts'           , 'edit', null, null, 'Reply'                 , null, 'Threads.LBL_REPLY_BUTTON_LABEL'              , 'Threads.LBL_REPLY_BUTTON_TITLE'              , 'Threads.LBL_REPLY_BUTTON_KEY'              , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Posts.PostView'                  , 1, 'Posts'           , 'edit', null, null, 'Quote'                 , null, 'Threads.LBL_QUOTE_BUTTON_LABEL'              , 'Threads.LBL_QUOTE_BUTTON_TITLE'              , 'Threads.LBL_QUOTE_BUTTON_KEY'              , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      'Posts.PostView'                  , 2, 'Posts'           ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Posts.PostView'                  , 3, 'Posts'           ;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'Posts.PostView'                  , 4, 'Posts'           , 1;
end -- if;
GO

-- 10/16/2012 Paul.  New Payment reporting buttons. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Payments.DetailView'             , 0, 'Payments'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate  'Payments.DetailView'             , 1, 'Payments'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Payments.DetailView'             , 2, 'Payments'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.DetailView'             , 3, 'Payments'        , 'view', 'Payments', 'view', 'Report'        , '../Reports/view.aspx?ID=7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF&PAYMENT_ID={0}'      , 'ID', 'Payments.LBL_REPORT_BUTTON_LABEL'    , 'Payments.LBL_REPORT_BUTTON_LABEL'    , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.DetailView'             , 4, 'Payments'        , 'view', 'Payments', 'view', 'Report'        , '../Reports/render.aspx?ID=7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF&PAYMENT_ID={0}'    , 'ID', 'Payments.LBL_PDF_BUTTON_LABEL'       , 'Payments.LBL_PDF_BUTTON_LABEL'       , null, 'PaymentPDF', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.DetailView'             , 5, 'Payments'        , 'view', 'Payments', 'view', 'Report'        , '../Reports/attachment.aspx?ID=7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF&PAYMENT_ID={0}', 'ID', 'Payments.LBL_ATTACHMENT_BUTTON_LABEL', 'Payments.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Payments.DetailView'             , 6, 'Payments'        , 1;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.DetailView' and COMMAND_NAME = 'Report' and DELETED = 0) begin -- then
		print 'Payments.DetailView: Add Generate Report.';
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.DetailView'             , null, 'Payments'        , 'view', 'Payments', 'view', 'Report'        , '../Reports/view.aspx?ID=7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF&PAYMENT_ID={0}'      , 'ID', 'Payments.LBL_REPORT_BUTTON_LABEL'    , 'Payments.LBL_REPORT_BUTTON_LABEL'    , null, null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.DetailView'             , null, 'Payments'        , 'view', 'Payments', 'view', 'Report'        , '../Reports/render.aspx?ID=7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF&PAYMENT_ID={0}'    , 'ID', 'Payments.LBL_PDF_BUTTON_LABEL'       , 'Payments.LBL_PDF_BUTTON_LABEL'       , null, 'PaymentPDF', null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Payments.DetailView'             , null, 'Payments'        , 'view', 'Payments', 'view', 'Report'        , '../Reports/attachment.aspx?ID=7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF&PAYMENT_ID={0}', 'ID', 'Payments.LBL_ATTACHMENT_BUTTON_LABEL', 'Payments.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	end -- if;
end -- if;
GO

-- 02/05/2010 Paul.  Report as Attachment. 
-- 08/22/2010 Paul.  Add ONCLICK_SCRIPT to spDYNAMIC_BUTTONS_InsButtonLink. 
-- 05/21/2014 Paul.  ViewLog has been missing for a long time. 
-- 03/24/2016 Paul.  Receive signature from jQuery Signature popup. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Invoices.DetailView'             , 0, 'Invoices'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate  'Invoices.DetailView'             , 1, 'Invoices'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Invoices.DetailView'             , 2, 'Invoices'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 3, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/view.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}'          , 'ID', 'Invoices.LBL_REPORT_BUTTON_LABEL'    , 'Invoices.LBL_REPORT_BUTTON_LABEL'    , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 4, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/render.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}'        , 'ID', 'Invoices.LBL_PDF_BUTTON_LABEL'       , 'Invoices.LBL_PDF_BUTTON_LABEL'       , null, 'InvoicePDF', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 5, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/SignaturePopup.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}', 'ID', 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'InvoiceSignature', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 5, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/attachment.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}'    , 'ID', 'Invoices.LBL_ATTACHMENT_BUTTON_LABEL', 'Invoices.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Invoices.DetailView'             , 6, 'Invoices'        , 1;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Invoices.DetailView'             , 7, 'Invoices'        ;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView' and COMMAND_NAME = 'Report' and DELETED = 0) begin -- then
		print 'Invoices.DetailView: Add Generate Report.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 2
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Invoices.DetailView'
		   and CONTROL_INDEX    >= 3
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 3, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/view.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}'  , 'ID', 'Invoices.LBL_REPORT_BUTTON_LABEL', 'Invoices.LBL_REPORT_BUTTON_LABEL', null, null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 4, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/render.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}', 'ID', 'Invoices.LBL_PDF_BUTTON_LABEL'   , 'Invoices.LBL_PDF_BUTTON_LABEL'   , null, 'InvoicePDF', null, null;
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView' and URL_FORMAT like '../Reports/attachment.aspx?%' and DELETED = 0) begin -- then
		print 'Invoices.DetailView: Add Report Attachment.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Invoices.DetailView'
		   and CONTROL_INDEX    >= 5
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'             , 5, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/attachment.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}', 'ID', 'Invoices.LBL_ATTACHMENT_BUTTON_LABEL', 'Invoices.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	end -- if;
	-- 03/24/2016 Paul.  Receive signature from jQuery Signature popup. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView' and URL_FORMAT like '../Reports/SignaturePopup.aspx?%' and DELETED = 0) begin -- then
		print 'Invoices.DetailView: Add Report Signature Popup.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Invoices.DetailView'
		   and CONTROL_INDEX    >= 5
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'               , 5, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/SignaturePopup.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}', 'ID', 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'InvoiceSignature', null, null;
	end -- if;
end -- if;
GO

-- 02/05/2010 Paul.  Report as Attachment. 
-- 08/22/2010 Paul.  Add ONCLICK_SCRIPT to spDYNAMIC_BUTTONS_InsButtonLink. 
-- 05/21/2014 Paul.  ViewLog has been missing for a long time. 
-- 03/24/2016 Paul.  Receive signature from jQuery Signature popup. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Orders.DetailView'               , 0, 'Orders'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate  'Orders.DetailView'               , 1, 'Orders'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Orders.DetailView'               , 2, 'Orders'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 3, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/view.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}'          , 'ID', 'Orders.LBL_REPORT_BUTTON_LABEL'    , 'Orders.LBL_REPORT_BUTTON_LABEL'    , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 4, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/render.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}'        , 'ID', 'Orders.LBL_PDF_BUTTON_LABEL'       , 'Orders.LBL_PDF_BUTTON_LABEL'       , null, 'OrderPDF', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 5, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/SignaturePopup.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}', 'ID', 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'OrderSignature', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 6, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/attachment.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}'    , 'ID', 'Orders.LBL_ATTACHMENT_BUTTON_LABEL', 'Orders.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 7, 'Orders'          , 'view', 'Invoices', 'edit', 'Convert'       , '../Invoices/edit.aspx?ORDER_ID={0}'                                                 , 'ID', 'Orders.LBL_CONVERT_BUTTON_LABEL'   , 'Orders.LBL_CONVERT_BUTTON_LABEL'   , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Orders.DetailView'               , 8, 'Orders'          , 1;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Orders.DetailView'               , 9, 'Orders'          ;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView' and COMMAND_NAME = 'Report' and DELETED = 0) begin -- then
		print 'Orders.DetailView: Add Generate Report.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 2
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Orders.DetailView'
		   and CONTROL_INDEX    >= 3
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 3, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/view.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}'  , 'ID', 'Orders.LBL_REPORT_BUTTON_LABEL', 'Orders.LBL_REPORT_BUTTON_LABEL', null, null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 4, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/render.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}', 'ID', 'Orders.LBL_PDF_BUTTON_LABEL'   , 'Orders.LBL_PDF_BUTTON_LABEL'   , null, 'OrderPDF', null, null;
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView' and URL_FORMAT like '../Reports/attachment.aspx?%' and DELETED = 0) begin -- then
		print 'Orders.DetailView: Add Report Attachment.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Orders.DetailView'
		   and CONTROL_INDEX    >= 5
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 5, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/attachment.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}', 'ID', 'Orders.LBL_ATTACHMENT_BUTTON_LABEL', 'Orders.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	end -- if;
	-- 03/24/2016 Paul.  Receive signature from jQuery Signature popup. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView' and URL_FORMAT like '../Reports/SignaturePopup.aspx?%' and DELETED = 0) begin -- then
		print 'Orders.DetailView: Add Report Signature Popup.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Orders.DetailView'
		   and CONTROL_INDEX    >= 5
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'               , 5, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/SignaturePopup.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}', 'ID', 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'OrderSignature', null, null;
	end -- if;
end -- if;
GO

-- 08/22/2010 Paul.  Add ONCLICK_SCRIPT to spDYNAMIC_BUTTONS_InsButtonLink. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'OrdersLineItems.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'OrdersLineItems.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS OrdersLineItems.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'OrdersLineItems.DetailView'      , 0, 'Orders'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'OrdersLineItems.DetailView'      , 1, 'Orders'          , 'view', null, null, 'Cancel', '../Orders/view.aspx?ID={0}', 'ORDER_ID', '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , '.LBL_CANCEL_BUTTON_KEY', null, null, null;
end -- if;
GO

-- 02/07/2010 Paul.  Add Send as Attachment button to Report View. 
-- 04/06/0211 Paul.  Add submit button for parameters. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.DetailView'                , 0, 'Reports'         , 'view', null              , null, 'Attachment'              , null, 'Reports.LBL_ATTACHMENT_BUTTON_LABEL'         , 'Reports.LBL_ATTACHMENT_BUTTON_TITLE'         , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.DetailView'                , 1, 'Reports'         , 'view', null              , null, 'Submit'                  , null, '.LBL_SUBMIT_BUTTON_LABEL'                    , '.LBL_SUBMIT_BUTTON_TITLE'                    , null                                        , null, null;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.DetailView' and COMMAND_NAME = 'Submit' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.DetailView'                , 1, 'Reports'         , 'view', null              , null, 'Submit'                  , null, '.LBL_SUBMIT_BUTTON_LABEL'                    , '.LBL_SUBMIT_BUTTON_TITLE'                    , null                                        , null, null;
	end -- if;
end -- if;
GO

-- 02/04/2021 Paul.  React client needs buttons for SignagureView. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.SignatureView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.SignatureView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.SignatureView'             , 0, 'Reports'         , 'view', null              , null, 'Submit'                  , null, '.LBL_SUBMIT_BUTTON_LABEL'                    , '.LBL_SUBMIT_BUTTON_TITLE'                    , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.SignatureView'             , 1, 'Reports'         , 'view', null              , null, 'Clear'                   , null, '.LBL_CLEAR_BUTTON_LABEL'                     , '.LBL_CLEAR_BUTTON_TITLE'                     , null                                        , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.SignatureView'             , 2, 'Reports'         , 'view', null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , null                                        , null, null;
end -- if;
GO


-- 04/01/2008 Paul.  Instead of using PopupControlExtender, just create convert buttons. 
-- 02/05/2010 Paul.  Report as Attachment. 
-- 08/22/2010 Paul.  Add ONCLICK_SCRIPT to spDYNAMIC_BUTTONS_InsButtonLink. 
-- 05/21/2014 Paul.  ViewLog has been missing for a long time. 
-- 03/24/2016 Paul.  Receive signature from jQuery Signature popup. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Quotes.DetailView'               , 0, 'Quotes'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate  'Quotes.DetailView'               , 1, 'Quotes'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Quotes.DetailView'               , 2, 'Quotes'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 3, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/view.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}'          , 'ID', 'Quotes.LBL_REPORT_BUTTON_LABEL'    , 'Quotes.LBL_REPORT_BUTTON_LABEL'    , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 4, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/render.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}'        , 'ID', 'Quotes.LBL_PDF_BUTTON_LABEL'       , 'Quotes.LBL_PDF_BUTTON_LABEL'       , null, 'QuotePDF', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 5, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/SignaturePopup.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}', 'ID', 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'QuoteSignature', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 6, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/attachment.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}'    , 'ID', 'Quotes.LBL_ATTACHMENT_BUTTON_LABEL', 'Quotes.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 7, 'Quotes'          , 'view', 'Orders'       , 'edit', 'Convert.ToOrder'      , '../Orders/edit.aspx?QUOTE_ID={0}'                                                   , 'ID', 'Quotes.LBL_CONVERT_TO_ORDER'       , 'Quotes.LBL_CONVERT_TO_ORDER'       , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 8, 'Quotes'          , 'view', 'Invoices'     , 'edit', 'Convert.ToInvoice'    , '../Invoices/edit.aspx?QUOTE_ID={0}'                                                 , 'ID', 'Quotes.LBL_CONVERT_TO_INVOICE'     , 'Quotes.LBL_CONVERT_TO_INVOICE'     , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 9, 'Quotes'          , 'view', 'Opportunities', 'edit', 'Convert.ToOpportunity', '../Opportunities/edit.aspx?QUOTE_ID={0}'                                            , 'ID', 'Quotes.LBL_CONVERT_TO_OPPORTUNITY' , 'Quotes.LBL_CONVERT_TO_OPPORTUNITY' , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Quotes.DetailView'               ,10, 'Quotes'          , 1;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Quotes.DetailView'               ,11, 'Quotes'          ;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView' and COMMAND_NAME = 'Report' and DELETED = 0) begin -- then
		print 'Quotes.DetailView: Add Generate Report.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 2
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Quotes.DetailView'
		   and CONTROL_INDEX    >= 3
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 3, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/view.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}'  , 'ID', 'Quotes.LBL_REPORT_BUTTON_LABEL', 'Quotes.LBL_REPORT_BUTTON_LABEL', null, null, null, null;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 4, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/render.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}', 'ID', 'Quotes.LBL_PDF_BUTTON_LABEL'   , 'Quotes.LBL_PDF_BUTTON_LABEL'   , null, 'QuotePDF', null, null;
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView' and URL_FORMAT like '../Reports/attachment.aspx?%' and DELETED = 0) begin -- then
		print 'Quotes.DetailView: Add Report Attachment.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Quotes.DetailView'
		   and CONTROL_INDEX    >= 5
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 5, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/attachment.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}', 'ID', 'Quotes.LBL_ATTACHMENT_BUTTON_LABEL', 'Quotes.LBL_ATTACHMENT_BUTTON_LABEL', null, null, null, null;
	end -- if;
	-- 03/24/2016 Paul.  Receive signature from jQuery Signature popup. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView' and URL_FORMAT like '../Reports/SignaturePopup.aspx?%' and DELETED = 0) begin -- then
		print 'Quotes.DetailView: Add Report Signature Popup.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Quotes.DetailView'
		   and CONTROL_INDEX    >= 5
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'               , 5, 'Quotes'          , 'view', 'Quotes'       , 'view', 'Report'               , '../Reports/SignaturePopup.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}', 'ID', 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'QuoteSignature', null, null;
	end -- if;
end -- if;
GO


-- 08/22/2010 Paul.  Add ONCLICK_SCRIPT to spDYNAMIC_BUTTONS_InsButtonLink. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Threads.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Threads.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Threads.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Threads.DetailView'              , 0, 'Threads'         , 'edit', null, null, 'Reply'                 , '../Posts/edit.aspx?THREAD_ID={0}', 'ID'           , 'Threads.LBL_REPLY_BUTTON_LABEL'              , 'Threads.LBL_REPLY_BUTTON_TITLE'               , 'Threads.LBL_REPLY_BUTTON_KEY', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Threads.DetailView'              , 1, 'Threads'         , 'edit', null, null, 'Quote'                 , '../Posts/edit.aspx?QUOTE=1&THREAD_ID={0}', 'ID'   , 'Threads.LBL_QUOTE_BUTTON_LABEL'              , 'Threads.LBL_QUOTE_BUTTON_TITLE'               , 'Threads.LBL_QUOTE_BUTTON_KEY', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Threads.DetailView'              , 2, 'Threads'         ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Threads.DetailView'              , 3, 'Threads'         ;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Threads.DetailView'              , 4, 'Threads'         , 1;
end -- if;
GO

-- Administration
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.AdminDetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .AdminDetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      '.AdminDetailView'                , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    '.AdminDetailView'                , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    '.AdminDetailView'                , 2, null, 1;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView', 'ContractTypes.DetailView'   , 'ContractTypes'   ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView', 'ForumTopics.DetailView'     , 'ForumTopics'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView'     , 'ProductTemplates.DetailView', 'ProductTemplates';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView'     , 'TeamNotices.DetailView'     , 'TeamNotices'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView'     , 'Teams.DetailView'           , 'Teams'           ;
-- 10/18/2009 Paul.  Add Knowledge Base module. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView'     , 'KBTags.DetailView'          , 'KBTags'          ;
GO

-- 09/04/2010 Paul.  Create full editing for ProductCategories. 
if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductCategories.DetailView' and COMMAND_NAME = 'ViewLog' and DELETED = 0) begin -- then
	update DYNAMIC_BUTTONS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'ProductCategories.DetailView'
	   and DELETED          = 0;
end -- if;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'ProductCategories.DetailView', 'ProductCategories';
GO

-- 09/26/2010 Paul.  Create full editing for ProductTypes. 
if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTypes.DetailView' and COMMAND_NAME = 'ViewLog' and DELETED = 0) begin -- then
	update DYNAMIC_BUTTONS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'ProductTypes.DetailView'
	   and DELETED          = 0;
end -- if;
GO
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'ProductTypes.DetailView'    , 'ProductTypes'    ;
GO

-- 09/16/2010 Paul.  Move Regions to Professional file. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'Regions.DetailView'         , 'Regions'         ;
-- 09/16/2010 Paul.  Add support for multiple Payment Gateways.
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'PaymentGateway.DetailView'  , 'PaymentGateway'  ;
-- 06/02/2012 Paul.  Create full editing for TaxRates. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'TaxRates.DetailView'        , 'TaxRates'        ;
-- 06/02/2012 Paul.  Create full editing for Shippers. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'Shippers.DetailView'        , 'Shippers'        ;
-- 06/02/2012 Paul.  Create full editing for Discounts. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'Discounts.DetailView'       , 'Discounts'       ;
-- 06/02/2012 Paul.  Create full editing for Discounts. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'Manufacturers.DetailView'   , 'Manufacturers'   ;
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'PaymentTypes.DetailView'    , 'PaymentTypes'    ;
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.AdminDetailView'     , 'PaymentTerms.DetailView'    , 'PaymentTerms'    ;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Threads.PostView'
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Threads.PostView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Threads.PostView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Threads.PostView'                , 0, 'Threads'         , 'edit'  , null, null, 'Reply'               , null, 'Threads.LBL_REPLY_BUTTON_LABEL'              , 'Threads.LBL_REPLY_BUTTON_TITLE'              , 'Threads.LBL_REPLY_BUTTON_KEY'              , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Threads.PostView'                , 1, 'Threads'         , 'edit'  , null, null, 'Quote'               , null, 'Threads.LBL_QUOTE_BUTTON_LABEL'              , 'Threads.LBL_QUOTE_BUTTON_TITLE'              , 'Threads.LBL_QUOTE_BUTTON_KEY'              , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      'Threads.PostView'                , 2, 'Threads'         ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Threads.PostView'                , 3, 'Threads'         ;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'Threads.PostView'                , 4, 'Threads'         , 1;
end -- if;
GO

-- 08/22/2010 Paul.  Add ONCLICK_SCRIPT to spDYNAMIC_BUTTONS_InsButtonLink. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.DetailView'
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS KBDocuments.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'KBDocuments.DetailView'          , 0, 'KBDocuments'     ;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate  'KBDocuments.DetailView'          , 1, 'KBDocuments'     ;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'KBDocuments.DetailView'          , 2, 'KBDocuments'     ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'KBDocuments.DetailView'          , 3, 'KBDocuments'     , 'view', 'KBDocuments', null, null, '../Emails/edit.aspx?KBDOCUMENT_ID={0}', 'ID', 'KBDocuments.LBL_SEND_EMAIL_BUTTON_LABEL', 'KBDocuments.LBL_SEND_EMAIL_BUTTON_LABEL', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'KBDocuments.DetailView'          , 4, 'KBDocuments'     , 1;
end -- if;
GO

-- 01/10/2010 Paul.  Add Dynamic Update button. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProspectLists.DetailView' and COMMAND_NAME = 'UpdateDynamic' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProspectLists.DetailView UpdateDynamic';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProspectLists.DetailView'         , 4, 'ProspectLists', 'edit'  , null, null, 'UpdateDynamic', null, 'ProspectLists.LBL_DYNAMIC_UPDATE', 'ProspectLists.LBL_DYNAMIC_UPDATE', null, null, null;
end -- if;
GO

-- 07/28/2010 Paul.  Move View Change Log to a button. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.DetailView' and COMMAND_NAME = 'ViewLog' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'Contracts.DetailView'       , 4, 'Contracts'       ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'CreditCards.DetailView'     , 4, 'CreditCards'     ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'Invoices.DetailView'        , 4, 'Invoices'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'KBDocuments.DetailView'     , 5, 'KBDocuments'     ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'Orders.DetailView'          , 4, 'Orders'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'Payments.DetailView'        , 4, 'Payments'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'ProductTemplates.DetailView', 4, 'ProductTemplates';
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'Quotes.DetailView'          , 4, 'Quotes'          ;
end -- if;
GO

-- 11/08/2011 Paul.  Add charts. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'Charts.DetailView'         , 'Charts'         ;

-- 05/22/2021 Paul.  Submit only for embedded. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Charts.EmbeddedView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.EmbeddedView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Charts.EmbeddedView'                , 0, 'Charts'          , 'view', null              , null, 'Submit'                  , null, '.LBL_SUBMIT_BUTTON_LABEL'                    , '.LBL_SUBMIT_BUTTON_TITLE', null, null, null;
end -- if;
GO

-- 05/31/2015 Paul.  Convert to Dynamic Duttons so that the Seven theme can be applied. 
-- 12/09/2020 Paul.  Add System Sync Log. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.DetailView'
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Exchange.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.DetailView'              , 0, null, null, null, null, 'Exchange.Sync'     , null, 'Users.LBL_EXCHANGE_SYNC'      , 'Users.LBL_EXCHANGE_SYNC'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Exchange.DetailView'              , 1, null, null, null, null, 'Exchange.SyncAll'  , null, 'Users.LBL_EXCHANGE_SYNC_ALL'  , 'Users.LBL_EXCHANGE_SYNC_ALL'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Exchange.DetailView'              , 2, 'Exchange', 0;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Exchange.DetailView'              , 3, null, null  , null, null, 'Log'             , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 12/09/2020 Paul.  Add System Sync Log. 
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Exchange.DetailView'              , 3, null, null  , null, null, 'Log'             , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Exchange.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Exchange.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 12/21/2010 Paul.  Sync buttons on Users.DetailView. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Users.iCloudSync' and COMMAND_NAME = 'iCloud.Sync' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Users.iCloudSync';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Users.ExchangeSync'               , 0, null, null, null, null, 'Exchange.Sync'     , null, 'Users.LBL_EXCHANGE_SYNC'      , 'Users.LBL_EXCHANGE_SYNC'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Users.ExchangeSync'               , 1, null, null, null, null, 'Exchange.SyncAll'  , null, 'Users.LBL_EXCHANGE_SYNC_ALL'  , 'Users.LBL_EXCHANGE_SYNC_ALL'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Users.GoogleSync'                 , 0, null, null, null, null, 'GoogleApps.Sync'   , null, 'Users.LBL_GOOGLEAPPS_SYNC'    , 'Users.LBL_GOOGLEAPPS_SYNC'    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Users.GoogleSync'                 , 1, null, null, null, null, 'GoogleApps.SyncAll', null, 'Users.LBL_GOOGLEAPPS_SYNC_ALL', 'Users.LBL_GOOGLEAPPS_SYNC_ALL', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Users.iCloudSync'                 , 0, null, null, null, null, 'iCloud.Sync'       , null, 'Users.LBL_ICLOUD_SYNC'        , 'Users.LBL_ICLOUD_SYNC'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Users.iCloudSync'                 , 1, null, null, null, null, 'iCloud.SyncAll'    , null, 'Users.LBL_ICLOUD_SYNC_ALL'    , 'Users.LBL_ICLOUD_SYNC_ALL'    , null, null, null;
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'SurveyThemes.DetailView'   , 'SurveyThemes'   ;
GO

-- 06/22/2013 Paul.  Survey Page should have a cancel button. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SurveyPages.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyPages.DetailView'           , 0, 'SurveyPages', 'edit', null, null, 'Edit'  , null, '.LBL_EDIT_BUTTON_LABEL'  , '.LBL_EDIT_BUTTON_TITLE'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate 'SurveyPages.DetailView'           , 1, 'SurveyPages';
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'SurveyPages.DetailView'           , 2, 'SurveyPages';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyPages.DetailView'           , 3, 'SurveyPages', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.DetailView' and URL_FORMAT is not null and COMMAND_NAME = 'Edit' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'SurveyPages.DetailView'
		   and URL_FORMAT        is not null
		   and COMMAND_NAME      = 'Edit'
		   and DELETED           = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyPages.DetailView'           , 0, 'SurveyPages', 'edit', null, null, 'Edit'  , null, '.LBL_EDIT_BUTTON_LABEL'  , '.LBL_EDIT_BUTTON_TITLE'  , null, null, null;
	end -- if;
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.DetailView' and MOBILE_ONLY = 1 and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'SurveyPages.DetailView'
		   and MOBILE_ONLY       = 1
		   and COMMAND_NAME      = 'Cancel'
		   and DELETED           = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyPages.DetailView'           , 3, 'SurveyPages', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- 06/22/2013 Paul.  Survey Question should have a cancel button. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SurveyQuestions.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyQuestions.DetailView'       , 0, 'SurveyQuestions', 'edit', null, null, 'Edit'  , null, '.LBL_EDIT_BUTTON_LABEL'  , '.LBL_EDIT_BUTTON_TITLE'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate 'SurveyQuestions.DetailView'       , 1, 'SurveyQuestions';
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'SurveyQuestions.DetailView'       , 2, 'SurveyQuestions';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyQuestions.DetailView'       , 3, 'SurveyQuestions', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
end else begin
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.DetailView' and URL_FORMAT is not null and COMMAND_NAME = 'Edit' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'SurveyQuestions.DetailView'
		   and URL_FORMAT        is not null
		   and COMMAND_NAME      = 'Edit'
		   and DELETED           = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyQuestions.DetailView'       , 0, 'SurveyQuestions', 'edit', null, null, 'Edit'  , null, '.LBL_EDIT_BUTTON_LABEL'  , '.LBL_EDIT_BUTTON_TITLE'  , null, null, null;
	end -- if;
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyQuestions.DetailView' and MOBILE_ONLY = 1 and COMMAND_NAME = 'Cancel' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'SurveyQuestions.DetailView'
		   and MOBILE_ONLY       = 1
		   and COMMAND_NAME      = 'Cancel'
		   and DELETED           = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyQuestions.DetailView'       , 3, 'SurveyQuestions', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
	end -- if;
end -- if;
GO

-- 05/21/2014 Paul.  ViewLog has been missing for a long time. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Surveys.DetailView'              , 0, 'Surveys';
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.DetailView'              , 1, 'Surveys', 'edit'  , null, null, 'Duplicate'           , null                      , '.LBL_DUPLICATE_BUTTON_LABEL'      , '.LBL_DUPLICATE_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Surveys.DetailView'              , 2, 'Surveys';
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.DetailView'              , 3, 'Surveys', null    , null, null, 'Survey.Preview'      , null                      , 'Surveys.LBL_PREVIEW'              , 'Surveys.LBL_PREVIEW'              , null, 'return Preview();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.DetailView'              , 4, 'Surveys', null    , null, null, 'Survey.Test'         , null                      , 'Surveys.LBL_TEST_BUTTON_LABEL'    , 'Surveys.LBL_TEST_BUTTON_LABEL'    , null, 'return Test();'   , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Surveys.DetailView'              , 5, 'Surveys', 'export', null, null, 'Export'              , 'export.aspx?ID={0}', 'ID', 'Surveys.LBL_EXPORT_BUTTON_LABEL'  , 'Surveys.LBL_EXPORT_BUTTON_LABEL'  , null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Surveys.DetailView'              , 6, 'Surveys'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.DetailView'              , 7, 'Surveys', null    , null, null, 'Survey.DeleteResults', null                      , 'Surveys.LBL_DELETE_RESULTS_BUTTON', 'Surveys.LBL_DELETE_RESULTS_BUTTON', null, 'return ConfirmDelete();', null;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.DetailView' and COMMAND_NAME = 'Export' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Surveys.DetailView'              , 5, 'Surveys', 'export', null, null, 'Export'        , 'export.aspx?ID={0}', 'ID', 'Surveys.LBL_EXPORT_BUTTON_LABEL', 'Surveys.LBL_EXPORT_BUTTON_LABEL', null, null, null, null;
	end -- if;
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.DetailView' and COMMAND_NAME = 'Duplicate' and CONTROL_TYPE = 'ButtonLink' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'Surveys.DetailView'
		   and COMMAND_NAME      = 'Duplicate'
		   and CONTROL_TYPE      = 'ButtonLink'
		   and DELETED           = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.DetailView'              , 1, 'Surveys', 'edit'  , null, null, 'Duplicate'     , null                      , '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	end -- if;
	-- 10/24/2014 Paul.  ViewLog was not being added to existing systems. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.DetailView' and COMMAND_NAME = 'ViewLog' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Surveys.DetailView'              , 6, 'Surveys'        ;
	end -- if;
	-- 10/24/2014 Paul.  Need to provide a way to delete all survey results. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.DetailView' and COMMAND_NAME = 'Survey.DeleteResults' and DELETED = 0) begin -- then
		exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.DetailView'              , 7, 'Surveys', null    , null, null, 'Survey.DeleteResults', null                      , 'Surveys.LBL_DELETE_RESULTS_BUTTON', 'Surveys.LBL_DELETE_RESULTS_BUTTON', null, 'return ConfirmDelete();', null;
	end -- if;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.LinkView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys.LinkView';
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink 'Surveys.LinkView'                , 0, 'Surveys', 'view', null, null, '~/Surveys/summary.aspx?ID={0}', 'ID', 'Surveys.LBL_SUMMARY', 'Surveys.LBL_SUMMARY', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink 'Surveys.LinkView'                , 1, 'Surveys', 'view', null, null, '~/Surveys/results.aspx?ID={0}', 'ID', 'Surveys.LBL_RESULTS', 'Surveys.LBL_RESULTS', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.SummaryView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys.SummaryView';
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink 'Surveys.SummaryView'             , 0, 'Surveys', 'view', null, null, '~/Surveys/results.aspx?ID={0}', 'ID', 'Surveys.LBL_RESULTS', 'Surveys.LBL_RESULTS', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink 'Surveys.SummaryView'             , 1, 'Surveys', 'view', null, null, '~/Surveys/view.aspx?ID={0}'   , 'ID', 'Surveys.LBL_DETAILS', 'Surveys.LBL_DETAILS', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.ResultsView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys.ResultsView';
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink 'Surveys.ResultsView'             , 0, 'Surveys', 'view', null, null, '~/Surveys/summary.aspx?ID={0}', 'ID', 'Surveys.LBL_SUMMARY', 'Surveys.LBL_SUMMARY', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsHyperLink 'Surveys.ResultsView'             , 1, 'Surveys', 'view', null, null, '~/Surveys/view.aspx?ID={0}'   , 'ID', 'Surveys.LBL_DETAILS', 'Surveys.LBL_DETAILS', null, null, null, null;
end -- if;
GO

-- 11/01/2015 Paul.  Separate buttons for ResultsDetailView.  Put Test first because we don't want
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.ResultsDetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Surveys.ResultsDetailView'      , 0, 'Surveys';
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Surveys.ResultsDetailView'      , 1, 'Surveys', null    , null, null, 'Survey.DeleteResults', null                      , 'Surveys.LBL_DELETE_RESULTS_BUTTON', 'Surveys.LBL_DELETE_RESULTS_BUTTON', null, 'return ConfirmDelete();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Surveys.ResultsDetailView'      , 2, null, 1;  -- DetailView Cancel is only visible on mobile. 
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'OutboundEmail.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS OutboundEmail.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'OutboundEmail.DetailView'         , 0, 'OutboundEmail', 'edit', null, null, 'Edit', null, '.LBL_EDIT_BUTTON_LABEL'  , '.LBL_EDIT_BUTTON_TITLE'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate 'OutboundEmail.DetailView'         , 1, 'OutboundEmail';
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'OutboundEmail.DetailView'         , 2, 'OutboundEmail';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'OutboundEmail.DetailView'         , 3, 'OutboundEmail', 'edit', null, null, 'Test', null, 'OutboundEmail.LBL_TEST_BUTTON_LABEL', 'OutboundEmail.LBL_TEST_BUTTON_LABEL', null, null, null;
end -- if;
GO

-- 09/10/2013 Paul.  Add buttons for Asterisk. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Asterisk.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Asterisk.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Asterisk.DetailView'              , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Asterisk.DetailView'              , 1, 'Asterisk', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
end -- if;
GO

-- 09/19/2013 Paul.  Add PayTrace module. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'PayTrace.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PayTrace.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PayTrace.DetailView'     , 0, 'PayTrace', 'edit'  , null, null, 'Import'              , null, 'PayTrace.LBL_IMPORT_BUTTON_LABEL'    , 'PayTrace.LBL_IMPORT_BUTTON_LABEL'    , null                                        , null                     , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PayTrace.DetailView'     , 1, 'PayTrace', 'edit'  , null, null, 'Refund'              , null, 'PayTrace.LBL_REFUND_BUTTON_LABEL'    , 'PayTrace.LBL_REFUND_BUTTON_LABEL'    , null                                        , 'return ConfirmRefund();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'PayTrace.DetailView'     , 2, 'PayTrace', 0;
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module.
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'TwitterTracks.DetailView' , 'TwitterTracks' ;
GO

-- 05/21/2014 Paul.  ViewLog has been missing for a long time. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView' and COMMAND_NAME = 'ViewLog' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Invoices.DetailView'             , 7, 'Invoices'        ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Orders.DetailView'               , 8, 'Orders'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Quotes.DetailView'               ,10, 'Quotes'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog    'Surveys.DetailView'              , 6, 'Surveys'         ;
end -- if;
GO

-- 12/09/2015 Paul.  Provide ability to convert Opportunity to Order. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.DetailView' and COMMAND_NAME = 'Convert.ToOrder' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Opportunities.DetailView'               , 5, 'Opportunities'          , 'view', 'Orders'       , 'edit', 'Convert.ToOrder'      , '../Orders/edit.aspx?OPPORTUNITY_ID={0}'                                               , 'ID', 'Quotes.LBL_CONVERT_TO_ORDER'       , 'Quotes.LBL_CONVERT_TO_ORDER'       , null, null, null, null;
end -- if;
GO

-- 12/16/2015 Paul.  Add Authorize.Net. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'AuthorizeNet.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'AuthorizeNet.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'AuthorizeNet.DetailView'     , 0, 'PayTrace', 'edit'  , null, null, 'Import', null, 'AuthorizeNet.LBL_IMPORT_BUTTON_LABEL', 'AuthorizeNet.LBL_IMPORT_BUTTON_LABEL', null, null                     , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'AuthorizeNet.DetailView'     , 1, 'PayTrace', 'edit'  , null, null, 'Refund', null, 'AuthorizeNet.LBL_REFUND_BUTTON_LABEL', 'AuthorizeNet.LBL_REFUND_BUTTON_LABEL', null, 'return ConfirmRefund();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'AuthorizeNet.DetailView'     , 2, 'PayTrace', 0;
end -- if;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'PayPal.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PayPal.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PayPal.DetailView'     , 0, 'PayPal', 'edit'  , null, null, 'Import'              , null, 'PayPal.LBL_IMPORT_BUTTON_LABEL'    , 'PayPal.LBL_IMPORT_BUTTON_TITLE'    , null                                        , null                     , null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PayPal.DetailView'     , 1, 'PayPal', 'edit'  , null, null, 'Refund'              , null, 'PayPal.LBL_REFUND_BUTTON_LABEL'    , 'PayPal.LBL_REFUND_BUTTON_TITLE'    , null                                        , 'return ConfirmRefund();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'PayPal.DetailView'     , 2, null, 0;
end -- if;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 
-- 09/20/2013 Paul.  Move PayPal.MassUpdate from Pro folders to Workflow folders. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PayPal.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS PayPal MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PayPal.MassUpdate'        , 0, 'PayPal'        , 'import', null, null, 'Import' , null, 'PayPal.LBL_IMPORT_BUTTON_LABEL', 'PayPal.LBL_IMPORT_BUTTON_TITLE', null, null, null;
end -- if;
GO

-- 04/04/2016 Paul.  Add buttons for related activities. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView' and URL_FORMAT like '~/Activities/popup.aspx%' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView'       , -1, 'Quotes'       , 'view', null, null, 'ViewRelatedActivities'       , '~/Activities/popup.aspx?PARENT_ID={0}&IncludeRelationships=1', 'ID', '.LBL_VIEW_RELATED_ACTIVITIES', '.LBL_VIEW_RELATED_ACTIVITIES', null, 'RelatedActivities', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView'       , -1, 'Orders'       , 'view', null, null, 'ViewRelatedActivities'       , '~/Activities/popup.aspx?PARENT_ID={0}&IncludeRelationships=1', 'ID', '.LBL_VIEW_RELATED_ACTIVITIES', '.LBL_VIEW_RELATED_ACTIVITIES', null, 'RelatedActivities', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView'     , -1, 'Invoices'     , 'view', null, null, 'ViewRelatedActivities'       , '~/Activities/popup.aspx?PARENT_ID={0}&IncludeRelationships=1', 'ID', '.LBL_VIEW_RELATED_ACTIVITIES', '.LBL_VIEW_RELATED_ACTIVITIES', null, 'RelatedActivities', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contracts.DetailView'    , -1, 'Contracts'    , 'view', null, null, 'ViewRelatedActivities'       , '~/Activities/popup.aspx?PARENT_ID={0}&IncludeRelationships=1', 'ID', '.LBL_VIEW_RELATED_ACTIVITIES', '.LBL_VIEW_RELATED_ACTIVITIES', null, 'RelatedActivities', null, null;
end -- if;
GO

-- 03/06/2018 Paul.  Add ViewLog to Teams if missing. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.DetailView' and COMMAND_NAME = 'ViewLog' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsViewLog   'Teams.DetailView'                     , -1, null;
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

call dbo.spDYNAMIC_BUTTONS_DetailViewProfessional()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailViewProfessional')
/

-- #endif IBM_DB2 */

