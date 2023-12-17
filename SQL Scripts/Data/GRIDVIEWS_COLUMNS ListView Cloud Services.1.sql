

print 'GRIDVIEWS_COLUMNS ListView Cloud Services';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.Cloud'
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.iCloud';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.iCloud' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.iCloud';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.iCloud'   , 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.iCloud'   , 2, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'UID'   , 'view.aspx?UID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.iCloud'   , 3, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.iCloud'   , 4, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'          , 'EMAIL1'          , '20%', 'listViewTdLinkS1', 'EMAIL1', 'mailto:{0}'       , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.iCloud'   , 5, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.iCloud'   , 6, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.iCloud'   , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '8%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.iCloud'   , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Contacts.ListView.iCloud'   , 8, null, null, '1%', 'Contacts.LBL_PRIMARY_ADDRESS PRIMARY_ADDRESS_STREET PRIMARY_ADDRESS_CITY PRIMARY_ADDRESS_STATE PRIMARY_ADDRESS_POSTALCODE PRIMARY_ADDRESS_COUNTRY Contacts.LBL_PHONE_MOBILE PHONE_MOBILE Contacts.LBL_PHONE_HOME PHONE_HOME', '<div class="ListViewInfoHover">
<b>{0}</b><br />
{1}<br />
{2}, {3} {4} {5}<br />
<b>{6}</b> {7}<br />
<b>{8}</b> {9}<br />
</div>', 'info_inline';
end -- if;
GO

-- 12/04/2020 Paul.  Include MODULE_TYPE. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Exchange';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Exchange' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.Exchange';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.Exchange' , 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Exchange' , 2, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID'    , 'view.aspx?id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Exchange' , 3, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Exchange' , 4, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'          , 'EMAIL1'          , '20%', 'listViewTdLinkS1', 'EMAIL1', 'mailto:{0}'      , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Exchange' , 5, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.Exchange' , 6, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Exchange' , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '8%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Exchange' , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Contacts.ListView.Exchange' , 8, null, null, '1%', 'Contacts.LBL_PRIMARY_ADDRESS PRIMARY_ADDRESS_STREET PRIMARY_ADDRESS_CITY PRIMARY_ADDRESS_STATE PRIMARY_ADDRESS_POSTALCODE PRIMARY_ADDRESS_COUNTRY Contacts.LBL_PHONE_MOBILE PHONE_MOBILE Contacts.LBL_PHONE_HOME PHONE_HOME', '<div class="ListViewInfoHover">
<b>{0}</b><br />
{1}<br />
{2}, {3} {4} {5}<br />
<b>{6}</b> {7}<br />
<b>{8}</b> {9}<br />
</div>', 'info_inline';

	update GRIDVIEWS_COLUMNS
	   set MODULE_TYPE       = 'Contacts'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where GRID_NAME         = 'Contacts.ListView.Exchange'
	   and DATA_FIELD        = 'NAME'
	   and MODULE_TYPE       is null
	   and DELETED           = 0;
end else begin
	-- 12/04/2020 Paul.  Include URL_MODULE. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Exchange' and DATA_FIELD = 'NAME' and MODULE_TYPE is null and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set MODULE_TYPE       = 'Contacts'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'Contacts.ListView.Exchange'
		   and DATA_FIELD        = 'NAME'
		   and MODULE_TYPE       is null
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.GoogleApps';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.GoogleApps' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.GoogleApps';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.GoogleApps', 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.GoogleApps', 2, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '15%', 'listViewTdLinkS1', 'ID'    , 'view.aspx?id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.GoogleApps', 3, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.GoogleApps', 4, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'          , 'EMAIL1'          , '15%', 'listViewTdLinkS1', 'EMAIL1', 'mailto:{0}'      , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.GoogleApps', 5, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.GoogleApps', 6, 'Google.LBL_LIST_GROUPS'                   , 'GROUPS'          , 'GROUPS'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.GoogleApps', 7, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '15%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.GoogleApps', 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '8%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.GoogleApps', 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Contacts.ListView.GoogleApps', 8, null, null, '1%', 'Contacts.LBL_PRIMARY_ADDRESS PRIMARY_ADDRESS_STREET PRIMARY_ADDRESS_CITY PRIMARY_ADDRESS_STATE PRIMARY_ADDRESS_POSTALCODE PRIMARY_ADDRESS_COUNTRY Contacts.LBL_PHONE_MOBILE PHONE_MOBILE Contacts.LBL_PHONE_HOME PHONE_HOME', '<div class="ListViewInfoHover">
<b>{0}</b><br />
{1}<br />
{2}, {3} {4} {5}<br />
<b>{6}</b> {7}<br />
<b>{8}</b> {9}<br />
</div>', 'info_inline';
end else begin
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.GoogleApps' and DATA_FIELD = 'GROUPS' and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Contacts.ListView.GoogleApps: Add Groups.';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'Contacts.ListView.GoogleApps'
		   and COLUMN_INDEX      >= 6
		   and DELETED           = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.GoogleApps', 6, 'Google.LBL_LIST_GROUPS'                   , 'GROUPS'          , 'GROUPS'          , '10%';
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Meetings.ListView.iCloud';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Meetings.ListView.iCloud' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Meetings.ListView.iCloud';
	exec dbo.spGRIDVIEWS_InsertOnly           'Meetings.ListView.iCloud'    , 'Meetings', 'vwMEETINGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Meetings.ListView.iCloud'    , 3, 'Meetings.LBL_LIST_SUBJECT'                , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'UID', 'view.aspx?UID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Meetings.ListView.iCloud'    , 4, 'Meetings.LBL_LIST_DATE'                   , 'DATE_TIME'       , 'DATE_TIME'       , '20%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.iCloud'    , 5, 'Meetings.LBL_LIST_DURATION_HOURS'         , 'DURATION_HOURS'  , 'DURATION_HOURS'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.iCloud'    , 6, 'Meetings.LBL_LIST_DURATION_MINUTES'       , 'DURATION_MINUTES', 'DURATION_MINUTES', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Meetings.ListView.iCloud'    , 7, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.iCloud'    , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '5%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.iCloud'    , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Meetings.ListView.Exchange';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Meetings.ListView.Exchange' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Meetings.ListView.Exchange';
	exec dbo.spGRIDVIEWS_InsertOnly           'Meetings.ListView.Exchange'  , 'Meetings', 'vwMEETINGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Meetings.ListView.Exchange'  , 2, 'Meetings.LBL_LIST_CLOSE'                  , 'STATUS'          , 'STATUS'          , '10%', 'meeting_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Meetings.ListView.Exchange'  , 3, 'Meetings.LBL_LIST_SUBJECT'                , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID', 'view.aspx?id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Meetings.ListView.Exchange'  , 4, 'Meetings.LBL_LIST_DATE'                   , 'DATE_TIME'       , 'DATE_TIME'       , '20%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.Exchange'  , 5, 'Meetings.LBL_LIST_DURATION_HOURS'         , 'DURATION_HOURS'  , 'DURATION_HOURS'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.Exchange'  , 6, 'Meetings.LBL_LIST_DURATION_MINUTES'       , 'DURATION_MINUTES', 'DURATION_MINUTES', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Meetings.ListView.Exchange'  , 7, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.Exchange'  , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.Exchange'  , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Meetings.ListView.GoogleApps';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Meetings.ListView.GoogleApps' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Meetings.ListView.GoogleApps';
	exec dbo.spGRIDVIEWS_InsertOnly           'Meetings.ListView.GoogleApps', 'Meetings', 'vwMEETINGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Meetings.ListView.GoogleApps', 2, 'Meetings.LBL_LIST_CLOSE'                  , 'STATUS'          , 'STATUS'          , '10%', 'meeting_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Meetings.ListView.GoogleApps', 3, 'Meetings.LBL_LIST_SUBJECT'                , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID', 'view.aspx?id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Meetings.ListView.GoogleApps', 4, 'Meetings.LBL_LIST_DATE'                   , 'DATE_TIME'       , 'DATE_TIME'       , '20%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.GoogleApps', 5, 'Meetings.LBL_LIST_DURATION_HOURS'         , 'DURATION_HOURS'  , 'DURATION_HOURS'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.GoogleApps', 6, 'Meetings.LBL_LIST_DURATION_MINUTES'       , 'DURATION_MINUTES', 'DURATION_MINUTES', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Meetings.ListView.GoogleApps', 7, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.GoogleApps', 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Meetings.ListView.GoogleApps', 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
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

call dbo.spGRIDVIEWS_COLUMNS_ListView_Cloud()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListView_Cloud')
/

-- #endif IBM_DB2 */

