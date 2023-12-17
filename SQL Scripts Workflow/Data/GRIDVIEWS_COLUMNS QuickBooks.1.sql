

print 'GRIDVIEWS_COLUMNS QuickBooks';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.QuickBooks';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.QuickBooks' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.ListView.QuickBooks';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.ListView.QuickBooks', 'Accounts', 'vwACCOUNTS_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.QuickBooks', 2, 'Accounts.LBL_LIST_ACCOUNT_NAME'           , 'Name'                 , 'Name'                 , '25%', 'listViewTdLinkS1', 'ID'         , '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooks', 3, 'Accounts.LBL_LIST_EMAIL1'                 , 'Email'                , 'Email'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooks', 4, 'Accounts.LBL_LIST_PHONE'                  , 'Phone'                , 'Phone'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooks', 5, 'Accounts.LBL_LIST_DESCRIPTION'            , 'Notes'                , 'Notes'                , '24%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooks', 6, 'Accounts.LBL_LIST_BILLING_ADDRESS_CITY'   , 'BillingCity'          , 'BillingCity'          , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooks', 7, 'Accounts.LBL_LIST_BILLING_ADDRESS_STATE'  , 'BillingState'         , 'BillingState'         , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Accounts.ListView.QuickBooks', 8, null, null, '1%', 'Accounts.LBL_BILLING_ADDRESS BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry', '<div class="ListViewInfoHover">
<b>{0}</b><br />
{1}<br />
{2}<br />
{3}, {4} {5} {6}<br />
</div>', 'info_inline';
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.QuickBooks';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.QuickBooks' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.QuickBooks';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.QuickBooks', 'Contacts', 'vwCONTACTS_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.QuickBooks', 2, 'Contacts.LBL_LIST_FIRST_NAME'             , 'FirstName'            , 'FirstName'            , '10%', 'listViewTdLinkS1', 'ID'         , '~/Contacts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.QuickBooks', 3, 'Contacts.LBL_LIST_LAST_NAME'              , 'LastName'             , 'LastName'             , '15%', 'listViewTdLinkS1', 'ID'         , '~/Contacts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.QuickBooks', 4, 'Contacts.LBL_LIST_EMAIL1'                 , 'Email'                , 'Email'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.QuickBooks', 5, 'Contacts.LBL_LIST_PHONE'                  , 'Phone'                , 'Phone'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.QuickBooks', 6, 'Contacts.LBL_LIST_DESCRIPTION'            , 'Notes'                , 'Notes'                , '24%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.QuickBooks', 7, 'Contacts.LBL_LIST_PRIMARY_ADDRESS_CITY'   , 'BillingCity'          , 'BillingCity'          , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.QuickBooks', 8, 'Contacts.LBL_LIST_PRIMARY_ADDRESS_STATE'  , 'BillingState'         , 'BillingState'         , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Contacts.ListView.QuickBooks', 9, null, null, '1%', 'Contacts.LBL_PRIMARY_ADDRESS BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry', '<div class="ListViewInfoHover">
<b>{0}</b><br />
{1}<br />
{2}<br />
{3}, {4} {5} {6}<br />
</div>', 'info_inline';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.QuickBooks';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.QuickBooks' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView.QuickBooks';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView.QuickBooks', 'Invoices', 'vwINVOICES_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.QuickBooks', 2, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'ReferenceNumber'           , 'ReferenceNumber'           , '15%', 'listViewTdLinkS1', 'ID'        , '~/Invoices/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.QuickBooks', 3, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'CustomerName'              , 'CustomerName'              , '15%', 'listViewTdLinkS1', 'CustomerId', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.QuickBooks', 4, 'Invoices.LBL_LIST_INVOICE_STAGE'          , 'IsPending'                 , 'IsPending'                 , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.QuickBooks', 5, 'Invoices.LBL_LIST_AMOUNT'                 , 'Amount'                    , 'Amount'                    , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.QuickBooks', 6, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'Balance'                   , 'Balance'                   , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.QuickBooks', 7, 'Invoices.LBL_LIST_DUE_DATE'               , 'DueDate'                   , 'DueDate'                   , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Invoices.ListView.QuickBooks', 8, null, null, '1%', 'Invoices.LBL_PURCHASE_ORDER_NUM POnumber Invoices.LBL_BILLING_ADDRESS BillingLine1 BillingCity BillingState BillingPostalCode BillingCountry Invoices.LBL_SHIPPING_ADDRESS ShippingLine1 ShippingCity ShippingState ShippingPostalCode ShippingCountry Invoices.LBL_SUBTOTAL Subtotal Invoices.LBL_TOTAL Amount', '<div class="ListViewInfoHover">
<b>{0}</b> {1}<br />
<b>{2}</b><br />
{3}<br />
{4}, {5} {6} {7}<br />
<b>{8}</b><br />
{9}<br />
{10}, {11} {12} {13}<br />
<br />
<b>{14}</b> {15:c}<br />
<b>{16}</b> {17:c}<br />
</div>', 'info_inline';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.QuickBooks';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.QuickBooks' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.ListView.QuickBooks';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.ListView.QuickBooks', 'Orders', 'vwORDERS_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.QuickBooks', 2, 'Orders.LBL_LIST_ORDER_NUM'                , 'ReferenceNumber'           , 'ReferenceNumber'           , '15%', 'listViewTdLinkS1', 'ID'        , '~/Orders/QuickBooks/view.aspx?QID={0}'  , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.QuickBooks', 3, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'CustomerName'              , 'CustomerName'              , '15%', 'listViewTdLinkS1', 'CustomerId', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.QuickBooks', 4, 'Orders.LBL_LIST_PAYMENT_TERMS'            , 'Terms'                     , 'Terms'                     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.QuickBooks', 5, 'Orders.LBL_LIST_AMOUNT'                   , 'TotalAmount'               , 'TotalAmount'               , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.QuickBooks', 6, 'Orders.LBL_LIST_DATE_ORDER_SHIPPED'       , 'ShipDate'                  , 'ShipDate'                  , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.QuickBooks', 7, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DueDate'                   , 'DueDate'                   , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Orders.ListView.QuickBooks', 8, null, null, '1%', 'Orders.LBL_PURCHASE_ORDER_NUM POnumber Orders.LBL_BILLING_ADDRESS BillingLine1 BillingCity BillingState BillingPostalCode BillingCountry Orders.LBL_SHIPPING_ADDRESS ShippingLine1 ShippingCity ShippingState ShippingPostalCode ShippingCountry Orders.LBL_SUBTOTAL Subtotal Orders.LBL_TOTAL TotalAmount', '<div class="ListViewInfoHover">
<b>{0}</b> {1}<br />
<b>{2}</b><br />
{3}<br />
{4}, {5} {6} {7}<br />
<b>{8}</b><br />
{9}<br />
{10}, {11} {12} {13}<br />
<br />
<b>{14}</b> {15:c}<br />
<b>{16}</b> {17:c}<br />
</div>', 'info_inline';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.QuickBooks';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.QuickBooks' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView.QuickBooks';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView.QuickBooks', 'Quotes', 'vwQUOTES_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.QuickBooks', 2, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'ReferenceNumber'           , 'ReferenceNumber'           , '15%', 'listViewTdLinkS1', 'ID'        , '~/Quotes/QuickBooks/view.aspx?QID={0}'  , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.QuickBooks', 3, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'CustomerName'              , 'CustomerName'              , '15%', 'listViewTdLinkS1', 'CustomerId', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.QuickBooks', 4, 'Quotes.LBL_LIST_PAYMENT_TERMS'            , 'Terms'                     , 'Terms'                     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.QuickBooks', 5, 'Quotes.LBL_LIST_AMOUNT'                   , 'TotalAmount'               , 'TotalAmount'               , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.QuickBooks', 6, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'Date'                      , 'Date'                      , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Quotes.ListView.QuickBooks', 7, null, null, '1%', 'Quotes.LBL_PURCHASE_ORDER_NUM POnumber Quotes.LBL_BILLING_ADDRESS BillingLine1 BillingCity BillingState BillingPostalCode BillingCountry Quotes.LBL_SUBTOTAL Subtotal Quotes.LBL_TOTAL TotalAmount', '<div class="ListViewInfoHover">
<b>{0}</b> {1}<br />
<b>{2}</b><br />
{3}<br />
{4}, {5} {6} {7}<br />
<br />
<b>{8}</b> {9:c}<br />
<b>{10}</b> {11:c}<br />
</div>', 'info_inline';
end -- if;
GO

-- 02/01/2015 Paul.  Shippers, TaxRates and ProductTemplates. 
-- 02/01/2015 Paul.  QuickBooks Online does not support ShipMethod. 
-- 04/08/2015 Paul.  Remove commented-out Shippers.ListView.QuickBooks to simplify migration to Oracle. 

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView.QuickBooks';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView.QuickBooks' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TaxRates.ListView.QuickBooks';
	exec dbo.spGRIDVIEWS_InsertOnly           'TaxRates.ListView.QuickBooks', 'TaxRates', 'vwTAX_RATES_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooks'        , 2, '.LBL_LIST_ID'                          , 'Id'                        , 'Id'                        , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TaxRates.ListView.QuickBooks'        , 3, 'TaxRates.LBL_LIST_NAME'                , 'Name'                      , 'Name'                      , '20%', 'listViewTdLinkS1', 'Id', '~/Administration/TaxRates/QuickBooks/view.aspx?qid={0}', null, 'TaxRates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooks'        , 3, 'TaxRates.LBL_LIST_VALUE'                , 'RateValue'                , 'RateValue'                 , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooks'        , 4, 'TaxRates.LBL_LIST_QUICKBOOKS_TAX_VENDOR', 'Agency'                   , 'Agency'                    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooks'        , 5, 'TaxRates.LBL_LIST_STATUS'               , 'Active'                   , 'Active'                    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooks'        , 6, 'TaxRates.LBL_LIST_DESCRIPTION'          , 'Description'              , 'Description'               , '25%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.QuickBooks' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.QuickBooks' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.ListView.QuickBooks', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_QuickBooks';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks',  2, '.LBL_LIST_ID'                                , 'Id'                        , 'Id'                        , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.ListView.QuickBooks',  3, 'ProductTemplates.LBL_LIST_NAME'              , 'Name'                      , 'Name'                      , '10%', 'listViewTdLinkS1', 'Id', '~/Administration/ProductTemplates/QuickBooks/view.aspx?qid={0}', null, 'Shippers', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks',  4, 'ProductTemplates.LBL_LIST_DESCRIPTION'       , 'Description'               , 'Description'               , '15';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks',  5, 'ProductTemplates.LBL_LIST_TYPE'              , 'Type'                      , 'Type'                      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks',  6, 'ProductTemplates.LBL_LIST_QUICKBOOKS_ACCOUNT', 'IncomeAccount'             , 'IncomeAccount'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks',  7, 'ProductTemplates.LBL_LIST_STATUS'            , 'Active'                    , 'Active'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks',  8, 'ProductTemplates.LBL_LIST_QUANTITY'          , 'QtyOnHand'                 , 'QtyOnHand'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.QuickBooks',  9, 'ProductTemplates.LBL_LIST_LIST_PRICE'        , 'UnitPrice'                 , 'UnitPrice'                 , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.QuickBooks', 10, 'ProductTemplates.LBL_LIST_COST_PRICE'        , 'PurchaseCost'              , 'PurchaseCost'              , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooks', 11, 'ProductTemplates.LBL_LIST_TAX_CLASS'         , 'Taxable'                   , 'Taxable'                   , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.QuickBooks', 12, '.LBL_LIST_DATE_MODIFIED'                     , 'TimeModified'              , 'TimeModified'              , '5%', 'DateTime';
end -- if;
GO


-- 06/23/2014 Paul.  The following views are used in the Admin area to display records that need to be synchronized. 

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Shippers';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Shippers' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.Shippers';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.Shippers', 'Shippers', 'vwSHIPPERS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Shippers'        , 2, 'Shippers.LBL_LIST_NAME'                , 'NAME'                      , 'NAME'                      , '60%', 'listViewTdLinkS1', 'ID', '~/Administration/Shippers/view.aspx?id={0}', null, 'Shippers', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.Shippers'        , 3, 'Shippers.LBL_LIST_STATUS'              , 'STATUS'                    , 'STATUS'                    , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.Shippers'        , 4, 'Shippers.LBL_LIST_ORDER'               , 'LIST_ORDER'                , 'LIST_ORDER'                , '12%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.TaxRates';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.TaxRates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.TaxRates';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.TaxRates', 'TaxRates', 'vwTAX_RATES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.TaxRates'        , 2, 'TaxRates.LBL_LIST_NAME'                 , 'NAME'                     , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID', '~/Administration/TaxRates/view.aspx?id={0}', null, 'TaxRates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.TaxRates'        , 3, 'TaxRates.LBL_LIST_VALUE'                , 'VALUE'                    , 'VALUE'                     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.TaxRates'        , 4, 'TaxRates.LBL_LIST_QUICKBOOKS_TAX_VENDOR', 'QUICKBOOKS_TAX_VENDOR'    , 'QUICKBOOKS_TAX_VENDOR'     , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'QuickBooks.TaxRates'        , 5, 'TaxRates.LBL_LIST_STATUS'               , 'STATUS'                   , 'STATUS'                    , '15%', 'tax_rate_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.TaxRates'        , 6, 'TaxRates.LBL_LIST_ORDER'                , 'LIST_ORDER'               , 'LIST_ORDER'                , '15%';
end -- if;
GO

-- 02/01/2015 Paul.  Correct ordering. Name and Part Num were overlapping. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.ProductTemplates' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.ProductTemplates' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.ProductTemplates', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.ProductTemplates', 2, 'ProductTemplates.LBL_LIST_MFT_PART_NUM', 'MFT_PART_NUM'              , 'MFT_PART_NUM'              , '10%', 'listViewTdLinkS1', 'ID', '~/Administration/ProductTemplates/view.aspx?id={0}', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.ProductTemplates', 3, 'ProductTemplates.LBL_LIST_NAME'        , 'NAME'                      , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID', '~/Administration/ProductTemplates/view.aspx?id={0}', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.ProductTemplates', 4, 'ProductTemplates.LBL_LIST_TYPE'        , 'TYPE_NAME'                 , 'TYPE_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.ProductTemplates', 5, 'ProductTemplates.LBL_LIST_CATEGORY'    , 'CATEGORY_NAME'             , 'CATEGORY_NAME'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'QuickBooks.ProductTemplates', 6, 'ProductTemplates.LBL_LIST_STATUS'      , 'STATUS'                    , 'STATUS'                    , '10%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.ProductTemplates', 7, 'ProductTemplates.LBL_LIST_QUANTITY'    , 'QUANTITY'                  , 'QUANTITY'                  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.ProductTemplates', 8, 'ProductTemplates.LBL_LIST_LIST_PRICE'  , 'LIST_USDOLLAR'             , 'LIST_USDOLLAR'             , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.ProductTemplates', 9, 'ProductTemplates.LBL_LIST_BOOK_VALUE'  , 'DISCOUNT_USDOLLAR'         , 'DISCOUNT_USDOLLAR'         , '10%', 'Currency';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Accounts';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Accounts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.Accounts';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.Accounts', 'Accounts', 'vwACCOUNTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Accounts'        , 2, 'Accounts.LBL_LIST_ACCOUNT_NAME'        , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.Accounts'        , 3, 'Accounts.LBL_LIST_CITY'                , 'CITY'                      , 'CITY'                      , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.Accounts'        , 4, 'Accounts.LBL_LIST_PHONE'               , 'PHONE'                     , 'PHONE'                     , '30%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.Quotes', 'Quotes', 'vwQUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Quotes'          , 2, 'Quotes.LBL_LIST_QUOTE_NUM'             , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Quotes'          , 3, 'Quotes.LBL_LIST_NAME'                  , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Quotes'          , 4, 'Quotes.LBL_LIST_ACCOUNT_NAME'          , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '30%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Quotes'          , 5, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Quotes'          , 6, 'Quotes.LBL_LIST_AMOUNT'                , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'QuickBooks.Quotes', 6, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Orders' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Orders' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.Orders';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.Orders', 'Orders', 'vwORDERS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Orders'          , 2, 'Orders.LBL_LIST_ORDER_NUM'             , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Orders'          , 3, 'Orders.LBL_LIST_NAME'                  , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Orders'          , 4, 'Orders.LBL_LIST_ACCOUNT_NAME'          , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '30%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Orders'          , 5, 'Orders.LBL_LIST_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Orders'          , 6, 'Orders.LBL_LIST_AMOUNT'                , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'QuickBooks.Orders', 6, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Invoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Invoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.Invoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.Invoices', 'Invoices', 'vwINVOICES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Invoices'        , 2, 'Invoices.LBL_LIST_INVOICE_NUM'         , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}', null, 'Invoices', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Invoices'        , 3, 'Invoices.LBL_LIST_NAME'                , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}', null, 'Invoices', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Invoices'        , 4, 'Invoices.LBL_LIST_ACCOUNT_NAME'        , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '30%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Invoices'        , 5, 'Invoices.LBL_LIST_DUE_DATE'            , 'DUE_DATE'                  , 'DUE_DATE'                  , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Invoices'        , 6, 'Invoices.LBL_LIST_AMOUNT'              , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'QuickBooks.Invoices', 6, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Payments' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.Payments' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.Payments';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.Payments', 'Payments', 'vwPAYMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Payments'        , 2, 'Payments.LBL_LIST_PAYMENT_NUM'         , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '25%', 'listViewTdLinkS1', 'ID'                , '~/Payments/view.aspx?id={0}', null, 'Payments', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.Payments'        , 3, 'Payments.LBL_LIST_ACCOUNT_NAME'        , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID'        , '~/Accounts/view.aspx?id={0}', null, 'Accounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Payments'        , 4, 'Payments.LBL_LIST_PAYMENT_DATE'        , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '25%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.Payments'        , 5, 'Payments.LBL_LIST_AMOUNT'              , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '25%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'QuickBooks.Payments', 5, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.CreditMemos' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.CreditMemos' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.CreditMemos';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.CreditMemos', 'Payments', 'vwPAYMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.CreditMemos'     , 2, 'Payments.LBL_LIST_PAYMENT_NUM'         , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '25%', 'listViewTdLinkS1', 'ID'                , '~/Payments/view.aspx?id={0}', null, 'Payments', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.CreditMemos'     , 3, 'Payments.LBL_LIST_ACCOUNT_NAME'        , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID'        , '~/Accounts/view.aspx?id={0}', null, 'Accounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.CreditMemos'     , 4, 'Payments.LBL_LIST_PAYMENT_DATE'        , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '25%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'QuickBooks.CreditMemos'     , 5, 'Payments.LBL_LIST_AMOUNT'              , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '25%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'QuickBooks.CreditMemos', 5, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.PaymentTypes';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.PaymentTypes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.PaymentTypes';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.PaymentTypes', 'PaymentTypes', 'vwPAYMENT_TYPES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.PaymentTypes'    , 2, 'PaymentTypes.LBL_LIST_NAME'                 , 'NAME'                     , 'NAME'                      , '60%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTypes/view.aspx?id={0}', null, 'PaymentTypes', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'QuickBooks.PaymentTypes'    , 3, 'PaymentTypes.LBL_LIST_STATUS'               , 'STATUS'                   , 'STATUS'                    , '20%', 'payment_type_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.PaymentTypes'    , 4, 'PaymentTypes.LBL_LIST_ORDER'                , 'LIST_ORDER'               , 'LIST_ORDER'                , '12%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.PaymentTerms';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'QuickBooks.PaymentTerms' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS QuickBooks.PaymentTerms';
	exec dbo.spGRIDVIEWS_InsertOnly           'QuickBooks.PaymentTerms', 'PaymentTerms', 'vwPAYMENT_TERMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'QuickBooks.PaymentTerms'    , 2, 'PaymentTerms.LBL_LIST_NAME'                 , 'NAME'                     , 'NAME'                      , '60%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTerms/view.aspx?id={0}', null, 'PaymentTerms', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'QuickBooks.PaymentTerms'    , 3, 'PaymentTerms.LBL_LIST_STATUS'               , 'STATUS'                   , 'STATUS'                    , '20%', 'payment_term_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'QuickBooks.PaymentTerms'    , 4, 'PaymentTerms.LBL_LIST_ORDER'                , 'LIST_ORDER'               , 'LIST_ORDER'                , '12%';
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

call dbo.spGRIDVIEWS_COLUMNS_QuickBooks()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_QuickBooks')
/

-- #endif IBM_DB2 */

