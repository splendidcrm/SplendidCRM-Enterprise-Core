

print 'GRIDVIEWS_COLUMNS PopupView Professional.Portal';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.PopupView.Portal'
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView.Portal' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductCatalog.PopupView.Portal', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCatalog.PopupView.Portal'  , 1, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductTemplate(''{0}'', ''{1}'');', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView.Portal'  , 2, 'ProductTemplates.LBL_LIST_TYPE'           , 'TYPE_NAME'           , 'TYPE_NAME'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView.Portal'  , 3, 'ProductTemplates.LBL_LIST_CATEGORY'       , 'CATEGORY_NAME'       , 'CATEGORY_NAME'       , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView.Portal'  , 4, 'ProductTemplates.LBL_LIST_MANUFACTURER'   , 'MANUFACTURER_NAME'   , 'MANUFACTURER_NAME'   , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductCatalog.PopupView.Portal'  , 5, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '15%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductCatalog.PopupView.Portal'  , 6, 'Quotes.LBL_LIST_ITEM_UNIT_PRICE'          , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '15%', 'Currency';
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

call dbo.spGRIDVIEWS_COLUMNS_PopupViewsProfessionalPortal()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_PopupViewsProfessionalPortal')
/

-- #endif IBM_DB2 */

