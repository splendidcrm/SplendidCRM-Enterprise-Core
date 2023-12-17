

print 'DYNAMIC_BUTTONS DetailView Professional.Portal';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.DetailView.Portal'
--GO

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.DetailView.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contracts.DetailView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Contracts.DetailView.Portal'            , 0, 'Invoices'        , 0;
end -- if;
GO

-- 04/05/2013 Paul.  Add PayNow button. 
-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices.DetailView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView.Portal'             , 0, 'Invoices'        , 'view', 'Invoices', 'view', 'Report'        , '../Reports/render.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}'        , 'ID', 'Invoices.LBL_PDF_BUTTON_LABEL'     , 'Invoices.LBL_PDF_BUTTON_LABEL'     , null, 'InvoicePDF', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Invoices.DetailView.Portal'             , 1, 'Invoices'        , 'edit', null      , null  , 'PayNow'        , null                                                                                   , 'Invoices.LBL_PAY_NOW'                    , 'Invoices.LBL_PAY_NOW'              , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView.Portal'             , 2, 'Invoices'        , 'view', 'Invoices', 'view', 'SignaturePopup', '../Reports/SignaturePopup.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}', 'ID', 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL', 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL', null, 'InvoiceSignature', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Invoices.DetailView.Portal'             , 3, 'Invoices'        , 0;
end else begin
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.Portal' and COMMAND_NAME = 'PayNow' and DELETED = 0) begin -- then
		print 'DYNAMIC_BUTTONS Invoices.DetailView.Portal: PayNow';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX     = CONTROL_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where VIEW_NAME         = 'Invoices.DetailView.Portal'
		   and CONTROL_INDEX    >= 1
		   and DELETED           = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButton     'Invoices.DetailView.Portal'             , 1, 'Invoices'        , 'edit'  , null, null, 'PayNow'              , null, 'Invoices.LBL_PAY_NOW', 'Invoices.LBL_PAY_NOW', null, null, null;
	end -- if;
	-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.Portal' and URL_FORMAT like '../Reports/SignaturePopup.aspx?%' and DELETED = 0) begin -- then
		print 'Invoices.DetailView.Portal: Add Report Signature Popup.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Invoices.DetailView.Portal'
		   and CONTROL_INDEX    >= 2
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.DetailView.Portal'             , 2, 'Invoices'        , 'view', 'Invoices', 'view', 'SignaturePopup', '../Reports/SignaturePopup.aspx?ID=BEA2A797-8A1D-47D8-A03E-B9841F494272&INVOICE_ID={0}', 'ID', 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL', 'Invoices.LBL_SIGN_PDF_BUTTON_LABEL', null, 'InvoiceSignature', null, null;
	end -- if;
end -- if;
GO

-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders.DetailView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView.Portal'               , 0, 'Orders'          , 'view', 'Orders'  , 'view', 'Report'        , '../Reports/render.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}'        , 'ID', 'Orders.LBL_PDF_BUTTON_LABEL'       , 'Orders.LBL_PDF_BUTTON_LABEL'       , null, 'OrderPDF', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Orders.DetailView.Portal'               , 1, 'Orders'          , 'edit', null      , null  , 'OrderNow'      , null                                                                                 , 'Orders.LBL_PAY_NOW'                , 'Orders.LBL_PAY_NOW'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView.Portal'               , 2, 'Orders'          , 'view', 'Orders'  , 'view', 'SignaturePopup', '../Reports/SignaturePopup.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}', 'ID', 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'OrderSignature', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Orders.DetailView.Portal'               , 3, 'Orders'          , 0;
end else begin
	-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.DetailView.Portal' and URL_FORMAT like '../Reports/SignaturePopup.aspx?%' and DELETED = 0) begin -- then
		print 'Orders.DetailView.Portal: Add Report Signature Popup.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Orders.DetailView.Portal'
		   and CONTROL_INDEX    >= 2
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.DetailView.Portal'               , 2, 'Orders'          , 'view', 'Orders'  , 'view', 'SignaturePopup', '../Reports/SignaturePopup.aspx?ID=F40989FE-24F5-4352-BB32-A23713EA6EC8&ORDER_ID={0}', 'ID', 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Orders.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'OrderSignature', null, null;
	end -- if;
end -- if;
GO

-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.DetailView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit       'Quotes.DetailView.Portal'               , 0, 'Quotes'          ;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView.Portal'               , 1, 'Quotes'          , 'view', 'Quotes'  , 'view', 'Report'        , '../Reports/render.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}'        , 'ID', 'Quotes.LBL_PDF_BUTTON_LABEL'       , 'Quotes.LBL_PDF_BUTTON_LABEL'       , null, 'QuotePDF', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Quotes.DetailView.Portal'               , 2, 'Quotes'          , 'edit', null      , null  , 'OrderNow'      , null                                                                                 , 'Quotes.LBL_ORDER_NOW'              , 'Quotes.LBL_ORDER_NOW'              , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView.Portal'               , 3, 'Quotes'          , 'view', 'Quotes'  , 'view', 'SignaturePopup', '../Reports/SignaturePopup.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}', 'ID', 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'QuoteSignature', null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Quotes.DetailView.Portal'               , 4, 'Quotes'          , 0;
end else begin
	-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
	if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.Portal' and URL_FORMAT like '../Reports/SignaturePopup.aspx?%' and DELETED = 0) begin -- then
		print 'Quotes.DetailView.Portal: Add Report Signature Popup.';
		update DYNAMIC_BUTTONS
		   set CONTROL_INDEX    = CONTROL_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'Quotes.DetailView.Portal'
		   and CONTROL_INDEX    >= 3
		   and DELETED          = 0;
		exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.DetailView.Portal'               , 3, 'Quotes'          , 'view', 'Quotes'  , 'view', 'SignaturePopup', '../Reports/SignaturePopup.aspx?ID=E0082268-2FFE-4C25-B700-83F3E5254167&QUOTE_ID={0}', 'ID', 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , 'Quotes.LBL_SIGN_PDF_BUTTON_LABEL'  , null, 'QuoteSignature', null, null;
	end -- if;
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

call dbo.spDYNAMIC_BUTTONS_DetailViewProfessionalPortal()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailViewProfessionalPortal')
/

-- #endif IBM_DB2 */

