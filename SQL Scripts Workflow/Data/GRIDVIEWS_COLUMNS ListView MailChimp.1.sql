

print 'GRIDVIEWS_COLUMNS ListView MailChimp';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.MailChimp'
--GO

set nocount on;
GO

-- 04/08/2016 Paul.  Add MailChimp layout. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'EmailTemplates.ListView.MailChimp';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'EmailTemplates.ListView.MailChimp' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS EmailTemplates.ListView.iCloud';
	exec dbo.spGRIDVIEWS_InsertOnly           'EmailTemplates.ListView.MailChimp', 'EmailTemplates', 'vwEMAIL_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'EmailTemplates.ListView.MailChimp', 2, 'EmailTemplates.LBL_LIST_NAME'       , 'name'            , 'name'            , '50%', 'listViewTdLinkS1', 'id'   , 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'EmailTemplates.ListView.MailChimp', 3, 'MailChimp.LBL_LIST_TYPE'            , 'type'            , 'type'            , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'EmailTemplates.ListView.MailChimp', 4, 'MailChimp.LBL_LIST_CATEGORY'        , 'category'        , 'category'        , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'EmailTemplates.ListView.MailChimp', 5, '.LBL_LIST_DATE_ENTERED'             , 'date_created'    , 'date_created'    , '15%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.ListView.MailChimp';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.ListView.MailChimp' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProspectLists.ListView.iCloud';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProspectLists.ListView.MailChimp', 'ProspectLists', 'vwPROSPECT_LISTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProspectLists.ListView.MailChimp' , 2, 'ProspectLists.LBL_LIST_NAME'        , 'name'            , 'name'            , '50%', 'listViewTdLinkS1', 'id'   , 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.ListView.MailChimp' , 3, 'MailChimp.LBL_LIST_LIST_RATING'     , 'list_rating'     , 'list_rating'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.ListView.MailChimp' , 4, 'MailChimp.LBL_LIST_VISIBILITY'      , 'visibility'      , 'visibility'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProspectLists.ListView.MailChimp' , 5, '.LBL_LIST_DATE_ENTERED'             , 'date_created'    , 'date_created'    , '15%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.Members.MailChimp';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.Members.MailChimp' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProspectLists.Members.iCloud';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProspectLists.Members.MailChimp', 'Members', 'vwPROSPECT_LISTS_MEMBERS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProspectLists.Members.MailChimp'  , 0, 'MailChimp.LBL_LIST_EMAIL'           , 'email_address'   , 'email_address'   , '25%', 'listViewTdLinkS1', 'id'   , 'members/view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.Members.MailChimp'  , 1, 'MailChimp.LBL_LIST_UNIQUE_EMAIL_ID' , 'unique_email_id' , 'unique_email_id' , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.Members.MailChimp'  , 2, 'MailChimp.LBL_LIST_STATUS'          , 'status'          , 'status'          , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.Members.MailChimp'  , 3, 'MailChimp.LBL_LIST_AVG_OPEN_RATE'   , 'avg_open_rate'   , 'avg_open_rate'   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.Members.MailChimp'  , 4, 'MailChimp.LBL_LIST_AVG_CLICK_RATE'  , 'avg_click_rate'  , 'avg_click_rate'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProspectLists.Members.MailChimp'  , 5, 'MailChimp.LBL_LIST_LAST_CHANGED'    , 'last_changed'    , 'last_changed'    , '15%', 'DateTime';
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

call dbo.spGRIDVIEWS_COLUMNS_ListView_MailChimp()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListView_MailChimp')
/

-- #endif IBM_DB2 */

