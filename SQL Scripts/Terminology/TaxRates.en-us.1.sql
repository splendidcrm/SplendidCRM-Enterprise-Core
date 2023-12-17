

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:42 AM.
print 'TERMINOLOGY TaxRates en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'TaxRates', null, null, N'Tax Rate List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'TaxRates', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'TaxRates', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'TaxRates', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'TaxRates', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_VALUE'                                , N'en-US', N'TaxRates', null, null, N'Percentage(%)';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'TaxRates', null, null, N'Tax Rates';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'TaxRates', null, null, N'Tax';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'TaxRates', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'TaxRates', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'TaxRates', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'TaxRates', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS_DESC'                               , N'en-US', N'TaxRates', null, null, N'Set to inactive to hide this item.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALUE'                                     , N'en-US', N'TaxRates', null, null, N'Percentage(%):';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_TAX_RATE_LIST'                             , N'en-US', N'TaxRates', null, null, N'Tax Rates';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_TAX_RATE'                              , N'en-US', N'TaxRates', null, null, N'Create Tax Rate';
-- 02/24/2015 Paul.  Add state for lookup. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS_STATE'                             , N'en-US', N'TaxRates', null, null, N'State (abbr.):';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ADDRESS_STATE'                        , N'en-US', N'TaxRates', null, null, N'State';

-- 06/02/2012 Paul.  Tax Vendor is required to create a QuickBooks tax rate. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUICKBOOKS_TAX_VENDOR'                     , N'en-US', N'TaxRates', null, null, N'QuickBooks Tax Vendor:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_QUICKBOOKS_TAX_VENDOR'                , N'en-US', N'TaxRates', null, null, N'Tax Vendor';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'TaxRates', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'TaxRates', null, null, N'Description';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'TaxRates'                                      , N'en-US', null, N'moduleList'                        ,  72, N'Tax Rates';

exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'tax_rate_status_dom'               ,   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'tax_rate_status_dom'               ,   2, N'Inactive';
GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_TaxRates_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_TaxRates_en_us')
/
-- #endif IBM_DB2 */
