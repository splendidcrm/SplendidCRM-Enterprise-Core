

print 'EDITVIEWS_FIELDS Search Professional.Portal';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.SearchBasic.Portal'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchBasic.Portal'   , 'Contracts', 'vwCONTRACTS_List', '15%', '15%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contracts.SearchBasic.Portal'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Contracts.SearchBasic.Portal'   ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 0, null, 'contract_status_dom', null, 6;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchBasic.Portal'    , 'Invoices', 'vwINVOICES_List', '15%', '15%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Invoices.SearchBasic.Portal'    ,  0, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchBasic.Portal'    ,  1, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchBasic.Portal'      , 'Orders', 'vwORDERS_List', '15%', '15%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Orders.SearchBasic.Portal'      ,  0, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchBasic.Portal'      ,  1, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchBasic.Portal'      , 'Quotes', 'vwQUOTES_List', '15%', '15%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Quotes.SearchBasic.Portal'      ,  0, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchBasic.Portal'      ,  1, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
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

call dbo.spEDITVIEWS_FIELDS_SearchProfessionalPortal()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchProfessionalPortal')
/

-- #endif IBM_DB2 */

