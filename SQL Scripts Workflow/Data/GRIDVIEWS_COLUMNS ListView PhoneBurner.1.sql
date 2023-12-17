

print 'GRIDVIEWS_COLUMNS ListView PhoneBurner';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.PhoneBurner'
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.PhoneBurner';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.PhoneBurner' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.PhoneBurner';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.PhoneBurner', 'Contacts', 'vwCONTACTS_SYNC_PhoneBurner';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.PhoneBurner'  ,  2, '.LBL_LIST_ID'                             , 'id'              , 'id'              , '5%' , 'listViewTdLinkS1', 'id', 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.PhoneBurner'  ,  3, 'Contacts.LBL_LIST_NAME'                   , 'name'            , 'name'            , '15%', 'listViewTdLinkS1', 'id', 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.PhoneBurner'  ,  4, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'email'           , 'email'           , '15%', 'listViewTdLinkS1', 'id', 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.PhoneBurner'  ,  5, 'Contacts.LBL_LIST_PHONE'                  , 'phone'           , 'phone'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.PhoneBurner'  ,  6, 'Contacts.LBL_LIST_PRIMARY_ADDRESS_STREET' , 'address1'        , 'address1'        , '10';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.PhoneBurner'  ,  7, 'Contacts.LBL_LIST_PRIMARY_ADDRESS_CITY'   , 'city'            , 'city'            , '10';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.PhoneBurner'  ,  8, 'Contacts.LBL_LIST_PRIMARY_ADDRESS_STATE'  , 'state'           , 'state'           , '10';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.PhoneBurner'  ,  9, '.LBL_LIST_DATE_ENTERED'                   , 'date_added'      , 'date_added'      , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.PhoneBurner'  , 10, '.LBL_LIST_DATE_MODIFIED'                  , 'date_modified'   , 'date_modified'   , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Contacts.ListView.PhoneBurner',  3, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Contacts.ListView.PhoneBurner',  4, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Contacts.ListView.PhoneBurner',  5, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Contacts.ListView.PhoneBurner',  9, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Contacts.ListView.PhoneBurner', 10, null, null, null, null, 0;
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

call dbo.spGRIDVIEWS_COLUMNS_ListView_PhoneBurner()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListView_PhoneBurner')
/

-- #endif IBM_DB2 */

