

print 'DYNAMIC_BUTTONS QuickBooks';
GO

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%View.QuickBooksOnline';

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Accounts.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.EditView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Accounts.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Contacts.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Contacts.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Invoices.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Invoices.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.MassUpdate.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices MassUpdate.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.MassUpdate.QuickBooksOnline', 0, 'Invoices'     , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO


-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Quotes.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Quotes.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.MassUpdate.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes MassUpdate.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.MassUpdate.QuickBooksOnline', 0, 'Quotes'     , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

-- 02/01/2015 Paul.  Update not supported by QBO V2. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.DetailView.QuickBooksOnline';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'TaxRates.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS TaxRates.DetailView.QuickBooksOnline';
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TaxRates.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    'TaxRates.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'TaxRates.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'TaxRates.DetailView.QuickBooksOnline', 0, null, 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProductTemplates.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'ProductTemplates.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProductTemplates.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'ProductTemplates.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentTypes.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS PaymentTypes.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PaymentTypes.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PaymentTypes.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'PaymentTypes.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PaymentTypes.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PaymentTypes.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS PaymentTypes.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'PaymentTypes.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'PaymentTypes.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Payments.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'Payments.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.MassUpdate.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments MassUpdate.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Payments.MassUpdate.QuickBooksOnline', 0, 'Payments'     , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'CreditMemos.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS CreditMemos.DetailView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'CreditMemos.DetailView.QuickBooksOnline', 0, null, 'edit'  , null, null, 'Edit'     , null, '.LBL_EDIT_BUTTON_LABEL'     , '.LBL_EDIT_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'CreditMemos.DetailView.QuickBooksOnline', 1, null, 'edit'  , null, null, 'Duplicate', null, '.LBL_DUPLICATE_BUTTON_LABEL', '.LBL_DUPLICATE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'CreditMemos.DetailView.QuickBooksOnline', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'CreditMemos.DetailView.QuickBooksOnline', 3, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'CreditMemos.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS CreditMemos.EditView.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsSave      'CreditMemos.EditView.QuickBooksOnline', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'CreditMemos.EditView.QuickBooksOnline', 1, null, 'view'  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'CreditMemos.MassUpdate.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS CreditMemos MassUpdate.QuickBooksOnline';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'CreditMemos.MassUpdate.QuickBooksOnline', 0, 'Payments'     , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
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

call dbo.spDYNAMIC_BUTTONS_QBOline()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_QBOline')
/

-- #endif IBM_DB2 */

