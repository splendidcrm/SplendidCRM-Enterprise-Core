

print 'EDITVIEWS_FIELDS Professional.Portal';
--delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView.Portal'
--GO

set nocount on;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Portal'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.Portal';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.Portal', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Portal'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.Portal'         ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditView.Portal'         ,  2, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Portal'         ,  3, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 0, 2, 'quote_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Portal'         ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Portal'         ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Portal'         ,  6, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'PaymentTerms'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Portal'         ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, 2, 'DatePicker'         , null, null, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Portal' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Quotes.EditView.Portal'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and CACHE_NAME        = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress.Portal'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditAddress.Portal';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditAddress.Portal', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	-- 08/29/2009 Paul.  Don't convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditAddress.Portal'      ,  0, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_NAME'       , null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress.Portal'      ,  1, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditAddress.Portal'      ,  2, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_NAME'      , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditAddress.Portal'      ,  3, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_NAME'       , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditAddress.Portal'      ,  4, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_NAME'      , null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditAddress.Portal'      ,  5, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditAddress.Portal'      ,  6, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      ,  7, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      ,  8, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      ,  9, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      , 10, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      , 11, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      , 12, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      , 13, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Portal'      , 14, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress.Portal'      , 15, null                                     , 'BILLING_ACCOUNT_ID'         , 0, null, 'Hidden', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress.Portal'      , 16, null                                     , 'SHIPPING_ACCOUNT_ID'        , 0, null, 'Hidden', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress.Portal'      , 17, null                                     , 'BILLING_CONTACT_ID'         , 0, null, 'Hidden', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress.Portal'      , 18, null                                     , 'SHIPPING_CONTACT_ID'        , 0, null, 'Hidden', null, null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditDescription.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditDescription.Portal';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditDescription.Portal', 'Quotes', 'vwQUOTES_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditDescription.Portal'  ,  0, 'Quotes.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

/*
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditCards.EditView.Portal' and DELETED = 0) begin -- then 
	print 'EDITVIEWS_FIELDS CreditCards.EditView.Portal'; 
	exec dbo.spEDITVIEWS_InsertOnly 'CreditCards.EditView.Portal', 'CreditCards', 'vwCREDIT_CARDS_Edit', '15%', '35%', null; 
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal',  0, 'CreditCards.LBL_NAME'              , 'NAME'              , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.EditView.Portal',  1, 'CreditCards.LBL_CARD_TYPE'         , 'CARD_TYPE'         , 1, 1, 'credit_card_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal',  2, 'CreditCards.LBL_CARD_NUMBER'       , 'CARD_NUMBER'       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.EditView.Portal',  3, 'CreditCards.LBL_EXPIRATION_DATE'   , 'EXPIRATION_MONTH'  , 1, 1, 'dom_cal_month_long'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.EditView.Portal',  4, null                                , 'EXPIRATION_YEAR'   , 1, 1, 'credit_card_year'    , -1, null;

	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal',  5, 'CreditCards.LBL_SECURITY_CODE'     , 'SECURITY_CODE'     , 0, 1, 10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'CreditCards.EditView.Portal',  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'CreditCards.EditView.Portal',  7, 'CreditCards.LBL_IS_PRIMARY'        , 'IS_PRIMARY'        , 0, 1, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal',  8, 'CreditCards.LBL_ADDRESS_STREET'    , 'ADDRESS_STREET'    , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal',  9, 'CreditCards.LBL_ADDRESS_CITY'      , 'ADDRESS_CITY'      , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal', 10, 'CreditCards.LBL_ADDRESS_STATE'     , 'ADDRESS_STATE'     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal', 11, 'CreditCards.LBL_ADDRESS_POSTALCODE', 'ADDRESS_POSTALCODE', 0, 1,  20, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView.Portal', 12, 'CreditCards.LBL_ADDRESS_COUNTRY'   , 'ADDRESS_COUNTRY'   , 0, 1, 100, 35, null;
end -- if;
*/
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

call dbo.spEDITVIEWS_FIELDS_ProfessionalPortal()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_ProfessionalPortal')
/

-- #endif IBM_DB2 */

