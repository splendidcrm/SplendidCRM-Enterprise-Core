

print 'EDITVIEWS_FIELDS Orders';

set nocount on;
GO

-- 09/01/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EntryView';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EntryView'         , 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EntryView'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         ,  2, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryView'         ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EntryView'         ,  4, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EntryView'         ,  5, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Orders.EntryView'         ,  6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         ,  7, 'CreditCards.LBL_NAME'                   , 'CARD_NAME'                  , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EntryView'         ,  8, 'CreditCards.LBL_CARD_TYPE'              , 'CARD_TYPE'                  , 1, 1, 'credit_card_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         ,  9, 'CreditCards.LBL_CARD_NUMBER'            , 'CARD_NUMBER'                , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EntryView'         , 10, 'CreditCards.LBL_EXPIRATION_DATE'        , 'EXPIRATION_MONTH'           , 1, 1, 'dom_cal_month_long'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EntryView'         , 11, null                                     , 'EXPIRATION_YEAR'            , 1, 1, 'credit_card_year'    , -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 12, 'CreditCards.LBL_SECURITY_CODE'          , 'SECURITY_CODE'              , 0, 1, 10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryView'         , 13, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Orders.EntryView'         , 14;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 15, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Orders.EntryView'         , 15, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryView'         , 16, null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EntryView'         , 17, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'return BillingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EntryView'         , 18, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'return BillingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 19, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 20, 'Orders.LBL_BUSINESS_NAME'               , 'BUSINESS_NAME'              , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 21, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 22, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EntryView'         , 23, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryView'         , 24, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 25, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 26, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 27, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryView'         , 28, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
end else begin
	-- 09/01/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EntryView'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EntryView'         ,  4, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryCredit' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Orders.EntryView', 'Orders.EntryCredit', null, null;
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryAddress' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Orders.EntryView', 'Orders.EntryAddress', null, null;
	end -- if;
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryCredit';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryCredit' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EntryCredit';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EntryCredit'       , 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryCredit'       ,  0, 'CreditCards.LBL_NAME'                   , 'CARD_NAME'                  , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EntryCredit'       ,  1, 'CreditCards.LBL_CARD_TYPE'              , 'CARD_TYPE'                  , 1, 1, 'credit_card_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryCredit'       ,  2, 'CreditCards.LBL_CARD_NUMBER'            , 'CARD_NUMBER'                , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EntryCredit'       ,  3, 'CreditCards.LBL_EXPIRATION_DATE'        , 'EXPIRATION_MONTH'           , 1, 1, 'dom_cal_month_long'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EntryCredit'       ,  4, null                                     , 'EXPIRATION_YEAR'            , 1, 1, 'credit_card_year'    , -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryCredit'       ,  5, 'CreditCards.LBL_SECURITY_CODE'          , 'SECURITY_CODE'              , 0, 1, 10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryCredit'       ,  6, null;
end -- if;
*/
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryAddress';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryAddress' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EntryAddress';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EntryAddress'      , 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      ,  0, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Orders.EntryAddress'      ,  0, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryAddress'      ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EntryAddress'      ,  2, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'return BillingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EntryAddress'      ,  3, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'return BillingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      ,  4, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      ,  5, 'Orders.LBL_BUSINESS_NAME'               , 'BUSINESS_NAME'              , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      ,  6, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      ,  7, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EntryAddress'      ,  8, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EntryAddress'      ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      , 10, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      , 11, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      , 12, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EntryAddress'      , 13, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
end -- if;
*/
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EntryDescription' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EntryDescription';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EntryDescription'  , 'Orders', 'vwORDERS_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EntryDescription'  ,  0, 'Orders.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
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

call dbo.spEDITVIEWS_FIELDS_Orders()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Orders')
/

-- #endif IBM_DB2 */

