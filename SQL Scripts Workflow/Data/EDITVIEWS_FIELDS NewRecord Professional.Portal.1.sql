

print 'EDITVIEWS_FIELDS NewRecord Professional.Portal';
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditCards.NewRecord' and DELETED = 0) begin -- then 
	print 'EDITVIEWS_FIELDS CreditCards.EditView'; 
	exec dbo.spEDITVIEWS_InsertOnly 'CreditCards.NewRecord', 'CreditCards', 'vwCREDIT_CARDS_Edit', '15%', '35%', null; 
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord',  0, 'CreditCards.LBL_NAME'              , 'NAME'              , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.NewRecord',  1, 'CreditCards.LBL_CARD_TYPE'         , 'CARD_TYPE'         , 1, 1, 'credit_card_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord',  2, 'CreditCards.LBL_CARD_NUMBER'       , 'CARD_NUMBER'       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.NewRecord',  3, 'CreditCards.LBL_EXPIRATION_DATE'   , 'EXPIRATION_MONTH'  , 1, 1, 'dom_cal_month_long'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.NewRecord',  4, null                                , 'EXPIRATION_YEAR'   , 1, 1, 'credit_card_year'    , -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord',  5, 'CreditCards.LBL_SECURITY_CODE'     , 'SECURITY_CODE'     , 0, 1, 10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'CreditCards.NewRecord',  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'CreditCards.NewRecord',  7, 'CreditCards.LBL_IS_PRIMARY'        , 'IS_PRIMARY'        , 0, 1, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord',  8, 'CreditCards.LBL_ADDRESS_STREET'    , 'ADDRESS_STREET'    , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord',  9, 'CreditCards.LBL_ADDRESS_CITY'      , 'ADDRESS_CITY'      , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord', 10, 'CreditCards.LBL_ADDRESS_STATE'     , 'ADDRESS_STATE'     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord', 11, 'CreditCards.LBL_ADDRESS_POSTALCODE', 'ADDRESS_POSTALCODE', 0, 1,  20, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.NewRecord', 12, 'CreditCards.LBL_ADDRESS_COUNTRY'   , 'ADDRESS_COUNTRY'   , 0, 1, 100, 35, null;
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

call dbo.spEDITVIEWS_FIELDS_NewRecordProPortal()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_NewRecordProPortal')
/

-- #endif IBM_DB2 */

