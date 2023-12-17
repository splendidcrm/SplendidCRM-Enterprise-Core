

print 'EDITVIEWS_FIELDS Search Professional Gmail';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.Search%.Gmail'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchBasic.Gmail'      , 'Quotes', 'vwQUOTES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Quotes.SearchBasic.Gmail'      ,  0, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchBasic.Gmail'      ,  1, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Quotes.SearchBasic.Gmail'      ,  2, 'Quotes.LBL_ACCOUNT_NAME'                , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Quotes.SearchBasic.Gmail'      ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchPopup.Gmail'      , 'Quotes', 'vwQUOTES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchPopup.Gmail'      ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes'  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchPopup.Gmail'      ,  1, 'Quotes.LBL_ACCOUNT_NAME'                , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchBasic.Gmail'      , 'Orders', 'vwORDERS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Orders.SearchBasic.Gmail'      ,  0, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchBasic.Gmail'      ,  1, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Orders.SearchBasic.Gmail'      ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchBasic.Gmail'      ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchPopup.Gmail'      , 'Orders', 'vwORDERS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchPopup.Gmail'      ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders'  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchPopup.Gmail'      ,  1, 'Orders.LBL_ACCOUNT_NAME'                , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchBasic.Gmail'    , 'Invoices', 'vwINVOICES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Invoices.SearchBasic.Gmail'    ,  0, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchBasic.Gmail'    ,  1, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Invoices.SearchBasic.Gmail'    ,  2, 'Invoices.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Invoices.SearchBasic.Gmail'    ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchPopup.Gmail'    , 'Invoices', 'vwINVOICES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchPopup.Gmail'    ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Invoices.SearchPopup.Gmail'    ,  1, 'Invoices.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchBasic.Gmail'   , 'Contracts', 'vwCONTRACTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contracts.SearchBasic.Gmail'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Contracts.SearchBasic.Gmail'   ,  1, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contracts.SearchBasic.Gmail'   ,  2, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox'    , 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Contracts.SearchBasic.Gmail'   ,  3, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 0, null, 'contract_status_dom', null, 6;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchPopup.Gmail'   , 'Contracts', 'vwCONTRACTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contracts.SearchPopup.Gmail'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, 'Contracts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contracts.SearchPopup.Gmail'   ,  1, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts' , null;
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

call dbo.spEDITVIEWS_FIELDS_SearchProfessionalGmail()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchProfessionalGmail')
/

-- #endif IBM_DB2 */

