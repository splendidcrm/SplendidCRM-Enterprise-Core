

print 'EDITVIEWS_FIELDS Search Cloud Services';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.Search%.Gmail'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'GetResponse.Campaigns.PopupView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS GetResponse.Campaigns.PopupView';
	exec dbo.spEDITVIEWS_InsertOnly            'GetResponse.Campaigns.PopupView', 'GetResponse', 'vwCAMPAIGNS_GetResponse', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'GetResponse.Campaigns.PopupView',  0, 'GetResponse.LBL_NAME', 'NAME', 0, 1, 100, 35, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Google.Contacts.SearchSubpanel';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Google.Contacts.SearchSubpanel' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Google.Contacts.SearchSubpanel';
	exec dbo.spEDITVIEWS_InsertOnly             'Google.Contacts.SearchSubpanel', 'Contacts', 'vwCONTACTS_List', '15%', '35%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Google.Contacts.SearchSubpanel',  0, 'Contacts.LBL_FIRST_NAME', 'FIRST_NAME', 0, null,  35, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Google.Contacts.SearchSubpanel',  1, 'Contacts.LBL_LAST_NAME' , 'LAST_NAME' , 0, null,  35, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Google.Contacts.SearchSubpanel',  2, 'Contacts.LBL_EMAIL1'    , 'EMAIL1'    , 0, null, 100, 35, null;
end -- if;
GO

-- 02/25/2021 Paul.  Search panel for the React client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'AuthorizeNet.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'AuthorizeNet.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS AuthorizeNet.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'AuthorizeNet.SearchBasic', 'AuthorizeNet', 'vwAuthorizeNet_Transactions', '15%', '35%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'AuthorizeNet.SearchBasic'      ,  0, 'AuthorizeNet.LBL_START_DATE', 'START_DATE', 0, 1, 'DatePicker', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'AuthorizeNet.SearchBasic'      ,  1, 'AuthorizeNet.LBL_END_DATE'  , 'END_DATE'  , 0, 1, 'DatePicker', null, null, null;
end -- if;
GO

-- 02/28/2021 Paul.  Search panel for the React client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PayPal.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PayPal.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PayPal.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'PayPal.SearchBasic', 'PayPal', 'vwPayPal_Transactions', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'PayPal.SearchBasic'            ,  0, 'PayPal.LBL_START_DATE'        , 'START_DATE', 0, 1, 'DatePicker', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'PayPal.SearchBasic'            ,  1, 'PayPal.LBL_END_DATE'          , 'END_DATE'  , 0, 1, 'DatePicker', null, null, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBound        'PayPal.SearchBasic'            ,  2, 'PayPal.LBL_EMAIL'             , 'EMAIL'     , 0, null, 100, 35, null;
end -- if;
GO

-- 02/28/2021 Paul.  Search panel for the React client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PayTrace.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PayTrace.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PayTrace.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'PayTrace.SearchBasic', 'PayTrace', 'vwPayTrace_Transactions', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'PayTrace.SearchBasic'          ,  0, 'PayTrace.LBL_START_DATE'      , 'START_DATE'      , 0, 1, 'DatePicker', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'PayTrace.SearchBasic'          ,  1, 'PayTrace.LBL_END_DATE'        , 'END_DATE'        , 0, 1, 'DatePicker', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'PayTrace.SearchBasic'          ,  2, 'PayTrace.LBL_TRANSACTION_TYPE', 'TRANSACTION_TYPE', 0, null, 'paytrace_transaction_type', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'PayTrace.SearchBasic'          ,  3, 'PayTrace.LBL_SEARCH_TEXT'     , 'SEARCH_TEXT'     , 0, null, 100, 35, null;
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

call dbo.spEDITVIEWS_FIELDS_SearchCloudServices()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchCloudServices')
/

-- #endif IBM_DB2 */

