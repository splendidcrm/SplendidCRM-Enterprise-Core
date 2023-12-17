

print 'GRIDVIEWS_COLUMNS ListView Watson';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.Watson'
--GO

set nocount on;
GO

-- 04/08/2016 Paul.  Add Watson layout. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'EmailTemplates.ListView.Watson';
/*
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'EmailTemplates.ListView.Watson' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS EmailTemplates.ListView.iCloud';
	exec dbo.spGRIDVIEWS_InsertOnly           'EmailTemplates.ListView.Watson', 'EmailTemplates', 'vwEMAIL_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'EmailTemplates.ListView.Watson', 2, 'EmailTemplates.LBL_LIST_NAME'       , 'name'            , 'name'            , '50%', 'listViewTdLinkS1', 'id'   , 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'EmailTemplates.ListView.Watson', 3, 'Watson.LBL_LIST_TYPE'            , 'type'            , 'type'            , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'EmailTemplates.ListView.Watson', 4, 'Watson.LBL_LIST_CATEGORY'        , 'category'        , 'category'        , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'EmailTemplates.ListView.Watson', 5, '.LBL_LIST_DATE_ENTERED'             , 'date_created'    , 'date_created'    , '15%', 'DateTime';
end -- if;
*/
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.ListView.Watson';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.ListView.Watson' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProspectLists.ListView.Watson';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProspectLists.ListView.Watson', 'ProspectLists', 'vwPROSPECT_LISTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProspectLists.ListView.Watson' , 2, 'ProspectLists.LBL_LIST_NAME'        , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'   , 'view.aspx?HID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProspectLists.ListView.Watson' , 3, 'Watson.LBL_LIST_TYPE'               , 'TYPE'            , 'TYPE'            , '15%', 'watson_list_type';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProspectLists.ListView.Watson' , 4, 'Watson.LBL_LIST_VISIBILITY'         , 'VISIBILITY'      , 'VISIBILITY'      , '15%', 'watson_visibility';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProspectLists.ListView.Watson' , 5, '.LBL_LIST_DATE_MODIFIED'            , 'LAST_MODIFIED'   , 'LAST_MODIFIED'   , '15%', 'DateTime';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Watson.Databases.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Watson.Databases.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Watson.Databases.PopupView', 'Watson', 'vwDATABASES_Watson';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Watson.Databases.PopupView', 0, 'Watson.LBL_LIST_NAME', 'NAME', 'NAME', '95%', 'listViewTdLinkS1', 'ID NAME', 'SelectDatabase(''{0}'', ''{1}'');', null, null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Watson';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Watson' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.Watson';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.Watson', 'Contacts', 'vwCONTACTS_SYNC_Watson';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Watson'  ,  2, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '15%', 'listViewTdLinkS1', 'SYNC_REMOTE_KEY', 'view.aspx?HID={0}', null, 'Contacts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Watson'  ,  3, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '10';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Watson'  ,  4, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'          , 'EMAIL1'          , '15%', 'listViewTdLinkS1', 'SYNC_REMOTE_KEY', 'view.aspx?HID={0}', null, 'Contacts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Watson'  ,  5, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.Watson'  ,  6, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Watson'  ,  7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Watson'  ,  8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Watson'  ,  9, 'Watson.LBL_LIST_SYNC_REMOTE_KEY'          , 'SYNC_REMOTE_KEY' , 'SYNC_REMOTE_KEY' , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Watson'  , 10, '.LBL_LIST_ID'                             , 'ID'              , 'ID'              , '15%';
end else begin
	-- 02/12/2020 Paul.  Cleanup URL_ASSIGNED_FIELD, YNC_REMOTE_KEYASSIGNED_USER_ID is invalid. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Watson' and URL_ASSIGNED_FIELD = 'YNC_REMOTE_KEYASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Contacts.ListView.Watson: Cleanup URL_ASSIGNED_FIELD';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getdate()
		 where GRID_NAME          = 'Contacts.ListView.Watson'
		   and URL_ASSIGNED_FIELD = 'YNC_REMOTE_KEYASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.Watson';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.Watson' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.ListView.Watson';
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.ListView.Watson', 'Leads', 'vwLEADS_SYNC_Watson';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.Watson'     ,  2, 'Leads.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '15%', 'listViewTdLinkS1', 'SYNC_REMOTE_KEY', 'view.aspx?HID={0}', null, 'Leads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Watson'     ,  3, 'Leads.LBL_LIST_TITLE'                     , 'TITLE'           , 'TITLE'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.Watson'     ,  4, 'Leads.LBL_LIST_EMAIL_ADDRESS'             , 'EMAIL1'          , 'EMAIL1'          , '15%', 'listViewTdLinkS1', 'SYNC_REMOTE_KEY', 'view.aspx?HID={0}', null, 'Leads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Watson'     ,  5, 'Leads.LBL_LIST_PHONE'                     , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Leads.ListView.Watson'     ,  6, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Watson'     ,  7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Watson'     ,  8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Watson'     ,  9, 'Watson.LBL_LIST_SYNC_REMOTE_KEY'          , 'SYNC_REMOTE_KEY' , 'SYNC_REMOTE_KEY' , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Watson'     , 10, '.LBL_LIST_ID'                             , 'ID'              , 'ID'              , '15%';
end else begin
	-- 02/12/2020 Paul.  Cleanup URL_ASSIGNED_FIELD, YNC_REMOTE_KEYASSIGNED_USER_ID is invalid. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.Watson' and URL_ASSIGNED_FIELD = 'YNC_REMOTE_KEYASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Leads.ListView.Watson: Cleanup URL_ASSIGNED_FIELD';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getdate()
		 where GRID_NAME          = 'Leads.ListView.Watson'
		   and URL_ASSIGNED_FIELD = 'YNC_REMOTE_KEYASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospect.ListView.Watson';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospect.ListView.Watson' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospect.ListView.Watson';
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospect.ListView.Watson', 'Prospect', 'vwProspect_SYNC_Watson';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospect.ListView.Watson'  ,  2, 'Prospect.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '15%', 'listViewTdLinkS1', 'SYNC_REMOTE_KEY', 'view.aspx?HID={0}', null, 'Prospect', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospect.ListView.Watson'  ,  3, 'Prospect.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospect.ListView.Watson'  ,  4, 'Prospect.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'          , 'EMAIL1'          , '15%', 'listViewTdLinkS1', 'SYNC_REMOTE_KEY', 'view.aspx?HID={0}', null, 'Prospect', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospect.ListView.Watson'  ,  5, 'Prospect.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospect.ListView.Watson'  ,  6, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospect.ListView.Watson'  ,  7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospect.ListView.Watson'  ,  8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospect.ListView.Watson'  ,  9, 'Watson.LBL_LIST_SYNC_REMOTE_KEY'          , 'SYNC_REMOTE_KEY' , 'SYNC_REMOTE_KEY' , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospect.ListView.Watson'  , 10, '.LBL_LIST_ID'                             , 'ID'              , 'ID'              , '15%';
end else begin
	-- 02/12/2020 Paul.  Cleanup URL_ASSIGNED_FIELD, YNC_REMOTE_KEYASSIGNED_USER_ID is invalid. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospect.ListView.Watson' and URL_ASSIGNED_FIELD = 'YNC_REMOTE_KEYASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Prospect.ListView.Watson: Cleanup URL_ASSIGNED_FIELD';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getdate()
		 where GRID_NAME          = 'Prospect.ListView.Watson'
		   and URL_ASSIGNED_FIELD = 'YNC_REMOTE_KEYASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
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

call dbo.spGRIDVIEWS_COLUMNS_ListView_Watson()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListView_Watson')
/

-- #endif IBM_DB2 */

