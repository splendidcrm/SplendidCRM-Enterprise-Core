

print 'EDITVIEWS_FIELDS EditView.EditExtension';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditExtension'
--GO

set nocount on;
GO

-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditExtension';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditExtension' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.EditExtension';
	exec dbo.spEDITVIEWS_InsertOnly            'Accounts.EditExtension'    , 'Accounts', 'vwACCOUNTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    ,  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'NAME'                       , 1, 1, 150, 35, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    ,  1, 'Accounts.LBL_WEBSITE'                   , 'WEBSITE'                    , 0, 1, 255, 28, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    ,  2, 'Accounts.LBL_EMAIL'                     , 'EMAIL1'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    ,  3, 'Accounts.LBL_PHONE'                     , 'PHONE_OFFICE'               , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    ,  4, 'Accounts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    ,  5, 'Accounts.LBL_FAX'                       , 'PHONE_FAX'                  , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Accounts.EditExtension'    ,  6, 'Accounts.LBL_INDUSTRY'                  , 'INDUSTRY'                   , 0, 1, 'industry_dom'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Accounts.EditExtension'    ,  7, 'Accounts.LBL_TYPE'                      , 'ACCOUNT_TYPE'               , 0, 1, 'account_type_dom'   , null, null;

	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditExtension'    ,  8, 'Accounts.LBL_BILLING_ADDRESS_STREET'    , 'BILLING_ADDRESS_STREET'     , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditExtension'    ,  9, 'Accounts.LBL_SHIPPING_ADDRESS_STREET'   , 'SHIPPING_ADDRESS_STREET'    , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    , 10, 'Accounts.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    , 11, 'Accounts.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    , 12, 'Accounts.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 1, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    , 13, 'Accounts.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 1, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Accounts.EditExtension'    , 14, 'Accounts.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 1,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Accounts.EditExtension'    , 15, 'Accounts.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 1,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    , 16, 'Accounts.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditExtension'    , 17, 'Accounts.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditExtension'    , 18, 'Accounts.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 1,   4, 60, 3;
end else begin
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Accounts.EditExtension', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Accounts.EditExtension', 'SHIPPING_ADDRESS_POSTALCODE';
end -- if;
GO

-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditExtension';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditExtension' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditExtension';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.EditExtension'      , 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  0, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  1, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  2, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, 1, 150, 35, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  3, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  4, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  5, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  6, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    ,  7, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contacts.EditExtension'    ,  8, 'Contacts.LBL_LEAD_SOURCE'               , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'    , null, null;

	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditExtension'    ,  9, 'Contacts.LBL_PRIMARY_ADDRESS'           , 'PRIMARY_ADDRESS_STREET'     , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditExtension'    , 10, 'Contacts.LBL_ALTERNATE_ADDRESS'         , 'ALT_ADDRESS_STREET'         , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    , 11, 'Contacts.LBL_CITY'                      , 'PRIMARY_ADDRESS_CITY'       , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    , 12, 'Contacts.LBL_CITY'                      , 'ALT_ADDRESS_CITY'           , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    , 13, 'Contacts.LBL_STATE'                     , 'PRIMARY_ADDRESS_STATE'      , 0, 1, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    , 14, 'Contacts.LBL_STATE'                     , 'ALT_ADDRESS_STATE'          , 0, 1, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Contacts.EditExtension'    , 15, 'Contacts.LBL_POSTAL_CODE'               , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 1,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Contacts.EditExtension'    , 16, 'Contacts.LBL_POSTAL_CODE'               , 'ALT_ADDRESS_POSTALCODE'     , 0, 1,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    , 17, 'Contacts.LBL_COUNTRY'                   , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditExtension'    , 18, 'Contacts.LBL_COUNTRY'                   , 'ALT_ADDRESS_COUNTRY'        , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditExtension'    , 19, 'Contacts.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 1,   4, 60, 3;
end else begin
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Contacts.EditExtension', 'PRIMARY_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Contacts.EditExtension', 'ALT_ADDRESS_POSTALCODE';
end -- if;
GO

-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.EditExtension';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.EditExtension' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Leads.EditExtension';
	exec dbo.spEDITVIEWS_InsertOnly            'Leads.EditExtension'       , 'Leads', 'vwLEADS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  0, 'Leads.LBL_FIRST_NAME'                   , 'FIRST_NAME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  1, 'Leads.LBL_LAST_NAME'                    , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  2, 'Leads.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_NAME'               , 0, 1, 150, 25, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  3, 'Leads.LBL_EMAIL_ADDRESS'                , 'EMAIL1'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  4, 'Leads.LBL_OFFICE_PHONE'                 , 'PHONE_WORK'                 , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  5, 'Leads.LBL_OTHER_EMAIL_ADDRESS'          , 'EMAIL2'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  6, 'Leads.LBL_MOBILE_PHONE'                 , 'PHONE_MOBILE'               , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       ,  7, 'Leads.LBL_TITLE'                        , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditExtension'       ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditExtension'       ,  9, 'Leads.LBL_LEAD_SOURCE'                  , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditExtension'       , 10, 'Leads.LBL_STATUS'                       , 'STATUS'                     , 0, 1, 'lead_status_dom', null, null;

	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditExtension'       , 11, 'Leads.LBL_PRIMARY_ADDRESS_STREET'       , 'PRIMARY_ADDRESS_STREET'     , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditExtension'       , 12, 'Leads.LBL_ALT_ADDRESS_STREET'           , 'ALT_ADDRESS_STREET'         , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       , 13, 'Leads.LBL_CITY'                         , 'PRIMARY_ADDRESS_CITY'       , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       , 14, 'Leads.LBL_CITY'                         , 'ALT_ADDRESS_CITY'           , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       , 15, 'Leads.LBL_STATE'                        , 'PRIMARY_ADDRESS_STATE'      , 0, 1, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       , 16, 'Leads.LBL_STATE'                        , 'ALT_ADDRESS_STATE'          , 0, 1, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Leads.EditExtension'       , 17, 'Leads.LBL_POSTAL_CODE'                  , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 1,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Leads.EditExtension'       , 18, 'Leads.LBL_POSTAL_CODE'                  , 'ALT_ADDRESS_POSTALCODE'     , 0, 1,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       , 19, 'Leads.LBL_COUNTRY'                      , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditExtension'       , 20, 'Leads.LBL_COUNTRY'                      , 'ALT_ADDRESS_COUNTRY'        , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditExtension'       , 21, 'Leads.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 1,   4, 60, 3;
end else begin
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Leads.EditExtension', 'PRIMARY_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Leads.EditExtension', 'ALT_ADDRESS_POSTALCODE';
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Emails.EditExtension';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Emails.EditExtension' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Emails.EditExtension';
	exec dbo.spEDITVIEWS_InsertOnly            'Emails.EditExtension'      , 'Emails', 'vwEMAILS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Emails.EditExtension'      ,  0, 'Emails.LBL_DATE_SENT'                   , 'DATE_TIME'                  , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Emails.EditExtension'      ,  1, 'Emails.LBL_TO'                          , 'TO_ADDRS'                   , 0, 1, 100, 100, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Emails.EditExtension'      ,  2, 'Emails.LBL_FROM'                        , 'FROM_ADDR'                  , 0, 1, 100, 100, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Emails.EditExtension'      ,  3, 'Emails.LBL_CC'                          , 'CC_ADDRS '                  , 0, 1,   2, 100, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Emails.EditExtension'      ,  4, 'Emails.LBL_SUBJECT'                     , 'NAME'                       , 1, 1, 255, 100, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Emails.EditExtension'      ,  5, 'Emails.LBL_HEADERS'                     , 'HEADERS'                    , 0, 1,   4,  60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Emails.EditExtension'      ,  6, 'Emails.LBL_BODY'                        , 'DESCRIPTION'                , 0, 1,   8,  60, 3;
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

call dbo.spEDITVIEWS_FIELDS_EditExtension()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_EditExtension')
/

-- #endif IBM_DB2 */


