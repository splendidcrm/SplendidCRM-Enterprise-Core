

print 'ACL_FIELDS_ALIASES Professional';
GO

set nocount on;
GO

exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Contracts'       , 'ACCOUNT_ID'         , 'Contracts'       ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'Contracts'       , 'CURRENCY_ID'        , 'Contracts'       ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'OPPORTUNITY_NAME'     , 'Contracts'       , 'OPPORTUNITY_ID'     , 'Contracts'       ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TYPE'                 , 'Contracts'       , 'TYPE_ID'            , 'Contracts'       ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'CreditCards'     , 'ACCOUNT_ID'         , 'CreditCards'     ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'BILLING_ACCOUNT_NAME' , 'Invoices'        , 'BILLING_ACCOUNT_ID' , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'BILLING_CONTACT_NAME' , 'Invoices'        , 'BILLING_CONTACT_ID' , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'Invoices'        , 'CURRENCY_ID'        , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'OPPORTUNITY_NAME'     , 'Invoices'        , 'OPPORTUNITY_ID'     , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ORDER_NAME'           , 'Invoices'        , 'ORDER_ID'           , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'QUOTE_NAME'           , 'Invoices'        , 'QUOTE_ID'           , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPER_NAME'         , 'Invoices'        , 'SHIPPER_ID'         , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPING_ACCOUNT_NAME', 'Invoices'        , 'SHIPPING_ACCOUNT_ID', 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPING_CONTACT_NAME', 'Invoices'        , 'SHIPPING_CONTACT_ID', 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TAXRATE_NAME'         , 'Invoices'        , 'TAXRATE_ID'         , 'Invoices'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'KBDOC_APPROVER_NAME'  , 'KBDocuments'     , 'KBDOC_APPROVER_ID'  , 'KBDocuments'     ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_TAG_NAME'      , 'KBTags'          , 'PARENT_TAG_ID'      , 'KBTags'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'BILLING_ACCOUNT_NAME' , 'Orders'          , 'BILLING_ACCOUNT_ID' , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'BILLING_CONTACT_NAME' , 'Orders'          , 'BILLING_CONTACT_ID' , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'Orders'          , 'CURRENCY_ID'        , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'OPPORTUNITY_NAME'     , 'Orders'          , 'OPPORTUNITY_ID'     , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'QUOTE_NAME'           , 'Orders'          , 'QUOTE_ID'           , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPER_NAME'         , 'Orders'          , 'SHIPPER_ID'         , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPING_ACCOUNT_NAME', 'Orders'          , 'SHIPPING_ACCOUNT_ID', 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPING_CONTACT_NAME', 'Orders'          , 'SHIPPING_CONTACT_ID', 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TAXRATE_NAME'         , 'Orders'          , 'TAXRATE_ID'         , 'Orders'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Payments'        , 'ACCOUNT_ID'         , 'Payments'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CREDIT_CARD_NAME'     , 'Payments'        , 'CREDIT_CARD_ID'     , 'Payments'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'ProductTemplates', 'ACCOUNT_ID'         , 'ProductTemplates';
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'ProductCatalog'  , 'ACCOUNT_ID'         , 'ProductCatalog'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CATEGORY_NAME'        , 'ProductTemplates', 'CATEGORY_ID'        , 'ProductTemplates';
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CATEGORY_NAME'        , 'ProductCatalog'  , 'CATEGORY_ID'        , 'ProductCatalog'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'ProductTemplates', 'CURRENCY_ID'        , 'ProductTemplates';
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'ProductCatalog'  , 'CURRENCY_ID'        , 'ProductCatalog'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'MANUFACTURER_NAME'    , 'ProductTemplates', 'MANUFACTURER_ID'    , 'ProductTemplates';
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'MANUFACTURER_NAME'    , 'ProductCatalog'  , 'MANUFACTURER_ID'    , 'ProductCatalog'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TYPE_NAME'            , 'ProductTemplates', 'TYPE_ID'            , 'ProductTemplates';
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TYPE_NAME'            , 'ProductCatalog'  , 'TYPE_ID'            , 'ProductCatalog'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Products'        , 'ACCOUNT_ID'         , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CATEGORY_NAME'        , 'Products'        , 'CATEGORY_ID'        , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CONTACT_NAME'         , 'Products'        , 'CONTACT_ID'         , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'Products'        , 'CURRENCY_ID'        , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'MANUFACTURER_NAME'    , 'Products'        , 'MANUFACTURER_ID'    , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'QUOTE_NAME'           , 'Products'        , 'QUOTE_ID'           , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TYPE_NAME'            , 'Products'        , 'TYPE_ID'            , 'Products'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'BILLING_ACCOUNT_NAME' , 'Quotes'          , 'BILLING_ACCOUNT_ID' , 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'BILLING_CONTACT_NAME' , 'Quotes'          , 'BILLING_CONTACT_ID' , 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'Quotes'          , 'CURRENCY_ID'        , 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'OPPORTUNITY_NAME'     , 'Quotes'          , 'OPPORTUNITY_ID'     , 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPER_NAME'         , 'Quotes'          , 'SHIPPER_ID'         , 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPING_ACCOUNT_NAME', 'Quotes'          , 'SHIPPING_ACCOUNT_ID', 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'SHIPPING_CONTACT_NAME', 'Quotes'          , 'SHIPPING_CONTACT_ID', 'Quotes'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TAXRATE_NAME'         , 'Quotes'          , 'TAXRATE_ID'         , 'Quotes'          ;
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

call dbo.spACL_FIELDS_ALIASES_Professional()
/

call dbo.spSqlDropProcedure('spACL_FIELDS_ALIASES_Professional')
/

-- #endif IBM_DB2 */

