

print 'GRIDVIEWS_COLUMNS DataPrivacy';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%DataPrivacy%';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'DataPrivacy.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.ListView'     , 'DataPrivacy', 'vwDATA_PRIVACY_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.ListView'     ,  2, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'DataPrivacy', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.ListView'     ,  3, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'DataPrivacy', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'DataPrivacy.ListView'     ,  4, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '12%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'DataPrivacy.ListView'     ,  5, 'DataPrivacy.LBL_LIST_PRIORITY'             , 'PRIORITY'              , 'PRIORITY'             , '8%', 'dataprivacy_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'DataPrivacy.ListView'     ,  6, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '8%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'DataPrivacy.ListView'     ,  7, 'DataPrivacy.LBL_LIST_DATE_OPENED'          , 'DATE_OPENED'           , 'DATE_OPENED'          , '8%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'DataPrivacy.ListView'     ,  8, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '8%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'DataPrivacy.ListView'     ,  9, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '8%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.ListView'     , 10, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.ListView'     , 11, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '6%';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.ListView', 4, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.ListView', 5, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.ListView', 6, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.DataPrivacy';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.DataPrivacy' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.DataPrivacy';
	exec dbo.spGRIDVIEWS_InsertOnly             'Accounts.DataPrivacy'     , 'DataPrivacy', 'vwACCOUNTS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Accounts.DataPrivacy'     ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Accounts.DataPrivacy'     ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Accounts.DataPrivacy'     ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Accounts.DataPrivacy'     ,  3, 'DataPrivacy.LBL_LIST_PRIORITY'             , 'PRIORITY'              , 'PRIORITY'             , '10%', 'dataprivacy_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Accounts.DataPrivacy'     ,  4, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Accounts.DataPrivacy'     ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Accounts.DataPrivacy'     ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Accounts.DataPrivacy'     ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Accounts.DataPrivacy'     ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.DataPrivacy', 2, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.DataPrivacy', 3, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.DataPrivacy', 4, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.DataPrivacy';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.DataPrivacy' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.DataPrivacy';
	exec dbo.spGRIDVIEWS_InsertOnly             'Contacts.DataPrivacy'     , 'DataPrivacy', 'vwCONTACTS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Contacts.DataPrivacy'     ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Contacts.DataPrivacy'     ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Contacts.DataPrivacy'     ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Contacts.DataPrivacy'     ,  3, 'DataPrivacy.LBL_LIST_PRIORITY'             , 'PRIORITY'              , 'PRIORITY'             , '10%', 'dataprivacy_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Contacts.DataPrivacy'     ,  4, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Contacts.DataPrivacy'     ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Contacts.DataPrivacy'     ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Contacts.DataPrivacy'     ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Contacts.DataPrivacy'     ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contacts.DataPrivacy', 2, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contacts.DataPrivacy', 3, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contacts.DataPrivacy', 4, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.DataPrivacy';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.DataPrivacy' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.DataPrivacy';
	exec dbo.spGRIDVIEWS_InsertOnly             'Leads.DataPrivacy'        , 'DataPrivacy', 'vwLEADS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Leads.DataPrivacy'        ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Leads.DataPrivacy'        ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Leads.DataPrivacy'        ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Leads.DataPrivacy'        ,  3, 'DataPrivacy.LBL_LIST_PRIORITY'             , 'PRIORITY'              , 'PRIORITY'             , '10%', 'dataprivacy_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Leads.DataPrivacy'        ,  4, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Leads.DataPrivacy'        ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Leads.DataPrivacy'        ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Leads.DataPrivacy'        ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Leads.DataPrivacy'        ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Leads.DataPrivacy', 2, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Leads.DataPrivacy', 3, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Leads.DataPrivacy', 4, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.DataPrivacy';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.DataPrivacy' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.DataPrivacy';
	exec dbo.spGRIDVIEWS_InsertOnly             'Prospects.DataPrivacy'    , 'DataPrivacy', 'vwCONTACTS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Prospects.DataPrivacy'    ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Prospects.DataPrivacy'    ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Prospects.DataPrivacy'    ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Prospects.DataPrivacy'    ,  3, 'DataPrivacy.LBL_LIST_PRIORITY'             , 'PRIORITY'              , 'PRIORITY'             , '10%', 'dataprivacy_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Prospects.DataPrivacy'    ,  4, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Prospects.DataPrivacy'    ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Prospects.DataPrivacy'    ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Prospects.DataPrivacy'    ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Prospects.DataPrivacy'    ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Prospects.DataPrivacy', 2, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Prospects.DataPrivacy', 3, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Prospects.DataPrivacy', 4, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.DataPrivacy.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.DataPrivacy.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'Accounts.DataPrivacy.ArchiveView'     , 'DataPrivacy', 'vwACCOUNTS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Accounts.DataPrivacy.ArchiveView'     ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Accounts.DataPrivacy.ArchiveView'     ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Accounts.DataPrivacy.ArchiveView'     ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Accounts.DataPrivacy.ArchiveView'     ,  3, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Accounts.DataPrivacy.ArchiveView'     ,  4, 'DataPrivacy.LBL_LIST_DATE_OPENED'          , 'DATE_OPENED'           , 'DATE_OPENED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Accounts.DataPrivacy.ArchiveView'     ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Accounts.DataPrivacy.ArchiveView'     ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Accounts.DataPrivacy.ArchiveView'     ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Accounts.DataPrivacy.ArchiveView'     ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.DataPrivacy.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.DataPrivacy.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'Contacts.DataPrivacy.ArchiveView'     , 'DataPrivacy', 'vwCONTACTS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Contacts.DataPrivacy.ArchiveView'     ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Contacts.DataPrivacy.ArchiveView'     ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Contacts.DataPrivacy.ArchiveView'     ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Contacts.DataPrivacy.ArchiveView'     ,  3, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Contacts.DataPrivacy.ArchiveView'     ,  4, 'DataPrivacy.LBL_LIST_DATE_OPENED'          , 'DATE_OPENED'           , 'DATE_OPENED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Contacts.DataPrivacy.ArchiveView'     ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Contacts.DataPrivacy.ArchiveView'     ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Contacts.DataPrivacy.ArchiveView'     ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Contacts.DataPrivacy.ArchiveView'     ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.DataPrivacy.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.DataPrivacy.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'Leads.DataPrivacy.ArchiveView'        , 'DataPrivacy', 'vwLEADS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Leads.DataPrivacy.ArchiveView'        ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Leads.DataPrivacy.ArchiveView'        ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Leads.DataPrivacy.ArchiveView'        ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Leads.DataPrivacy.ArchiveView'        ,  3, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Leads.DataPrivacy.ArchiveView'        ,  4, 'DataPrivacy.LBL_LIST_DATE_OPENED'          , 'DATE_OPENED'           , 'DATE_OPENED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Leads.DataPrivacy.ArchiveView'        ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Leads.DataPrivacy.ArchiveView'        ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Leads.DataPrivacy.ArchiveView'        ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Leads.DataPrivacy.ArchiveView'        ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.DataPrivacy.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.DataPrivacy.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'Prospects.DataPrivacy.ArchiveView'    , 'DataPrivacy', 'vwCONTACTS_DATA_PRIVACY';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Prospects.DataPrivacy.ArchiveView'    ,  0, 'DataPrivacy.LBL_LIST_DATA_PRIVACY_NUMBER'  , 'DATA_PRIVACY_NUMBER'   , 'DATA_PRIVACY_NUMBER'  , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Prospects.DataPrivacy.ArchiveView'    ,  1, 'DataPrivacy.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/DataPrivacy/view.aspx?ID={0}', null, 'DataPrivacy', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Prospects.DataPrivacy.ArchiveView'    ,  2, 'DataPrivacy.LBL_LIST_TYPE'                 , 'TYPE'                  , 'TYPE'                 , '10%', 'dataprivacy_type_dom'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Prospects.DataPrivacy.ArchiveView'    ,  3, 'DataPrivacy.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'dataprivacy_status_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Prospects.DataPrivacy.ArchiveView'    ,  4, 'DataPrivacy.LBL_LIST_DATE_OPENED'          , 'DATE_OPENED'           , 'DATE_OPENED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Prospects.DataPrivacy.ArchiveView'    ,  5, 'DataPrivacy.LBL_LIST_DATE_DUE'             , 'DATE_DUE'              , 'DATE_DUE'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Prospects.DataPrivacy.ArchiveView'    ,  6, 'DataPrivacy.LBL_LIST_DATE_CLOSED'          , 'DATE_CLOSED'           , 'DATE_CLOSED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Prospects.DataPrivacy.ArchiveView'    ,  7, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'      , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Prospects.DataPrivacy.ArchiveView'    ,  8, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'             , 'TEAM_NAME'            , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Accounts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Accounts';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Accounts'     , 'DataPrivacy', 'vwDATA_PRIVACY_ACCOUNTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Accounts'     ,  0, 'Accounts.LBL_LIST_NAME'                     , 'NAME'                 , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts'     ,  1, 'Accounts.LBL_LIST_BILLING_ADDRESS_CITY'     , 'BILLING_ADDRESS_CITY' , 'BILLING_ADDRESS_CITY' , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts'     ,  2, 'Accounts.LBL_LIST_BILLING_ADDRESS_STATE'    , 'BILLING_ADDRESS_STATE', 'BILLING_ADDRESS_STATE', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Accounts'     ,  3, 'Accounts.LBL_LIST_EMAIL1'                   , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts'     ,  4, '.LBL_LIST_PHONE'                            , 'PHONE_OFFICE'         , 'PHONE_OFFICE'         , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts'     ,  5, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts'     ,  6, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Accounts'     ,  7, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Contacts' ,  4, null, null, null, null, 0;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Contacts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Contacts';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Contacts'     , 'DataPrivacy', 'vwDATA_PRIVACY_CONTACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Contacts'     ,  0, 'Contacts.LBL_LIST_CONTACT_NAME'             , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts'     ,  1, 'Contacts.LBL_LIST_TITLE'                    , 'TITLE'                , 'TITLE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Contacts'     ,  2, 'Contacts.LBL_LIST_EMAIL1'                   , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts'     ,  3, '.LBL_LIST_PHONE'                            , 'PHONE_WORK'           , 'PHONE_WORK'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts'     ,  4, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts'     ,  5, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Contacts'     ,  6, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Contacts' ,  3, null, null, null, null, 0;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Leads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Leads';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Leads'        , 'DataPrivacy', 'vwDATA_PRIVACY_LEADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Leads'        ,  0, 'Leads.LBL_LIST_NAME'                        , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Leads/view.aspx?id={0}', null, 'Leads', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads'        ,  1, 'Leads.LBL_LIST_TITLE'                       , 'TITLE'                , 'TITLE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Leads'        ,  2, 'Leads.LBL_LIST_EMAIL1'                      , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads'        ,  3, '.LBL_LIST_PHONE'                            , 'PHONE_WORK'           , 'PHONE_WORK'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads'        ,  4, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads'        ,  5, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Leads'        ,  6, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Leads'    ,  3, null, null, null, null, 0;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Prospects' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Prospects';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Prospects'    , 'DataPrivacy', 'vwDATA_PRIVACY_PROSPECTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Prospects'    ,  0, 'Prospects.LBL_LIST_PROSPECT_NAME'           , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Prospects/view.aspx?id={0}', null, 'Prospects', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects'    ,  1, 'Prospects.LBL_LIST_TITLE'                   , 'TITLE'                , 'TITLE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Prospects'    ,  2, 'Prospects.LBL_LIST_EMAIL1'                  , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects'    ,  3, '.LBL_LIST_PHONE'                            , 'PHONE_WORK'           , 'PHONE_WORK'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects'    ,  4, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects'    ,  5, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Prospects'    ,  6, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Prospects',  3, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Accounts.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Accounts.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Accounts.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Accounts.ArchiveView'     , 'DataPrivacy', 'vwDATA_PRIVACY_ACCOUNTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Accounts.ArchiveView'     ,  0, 'Accounts.LBL_LIST_NAME'                     , 'NAME'                 , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', '~/Accounts/view.aspx?id={0}&ArchiveView=1', null, 'Accounts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts.ArchiveView'     ,  1, 'Accounts.LBL_LIST_BILLING_ADDRESS_CITY'     , 'BILLING_ADDRESS_CITY' , 'BILLING_ADDRESS_CITY' , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts.ArchiveView'     ,  2, 'Accounts.LBL_LIST_BILLING_ADDRESS_STATE'    , 'BILLING_ADDRESS_STATE', 'BILLING_ADDRESS_STATE', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Accounts.ArchiveView'     ,  3, 'Accounts.LBL_LIST_EMAIL1'                   , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts.ArchiveView'     ,  4, '.LBL_LIST_PHONE'                            , 'PHONE_OFFICE'         , 'PHONE_OFFICE'         , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts.ArchiveView'     ,  5, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Accounts.ArchiveView'     ,  6, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Accounts.ArchiveView'     ,  7, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Contacts.ArchiveView' ,  4, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Contacts.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Contacts.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Contacts.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Contacts.ArchiveView'     , 'DataPrivacy', 'vwDATA_PRIVACY_CONTACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Contacts.ArchiveView'     ,  0, 'Contacts.LBL_LIST_CONTACT_NAME'             , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Contacts/view.aspx?id={0}&ArchiveView=1', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts.ArchiveView'     ,  1, 'Contacts.LBL_LIST_TITLE'                    , 'TITLE'                , 'TITLE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Contacts.ArchiveView'     ,  2, 'Contacts.LBL_LIST_EMAIL1'                   , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts.ArchiveView'     ,  3, '.LBL_LIST_PHONE'                            , 'PHONE_WORK'           , 'PHONE_WORK'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts.ArchiveView'     ,  4, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Contacts.ArchiveView'     ,  5, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Contacts.ArchiveView'     ,  6, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Contacts.ArchiveView' ,  3, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Leads.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Leads.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Leads.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Leads.ArchiveView'        , 'DataPrivacy', 'vwDATA_PRIVACY_LEADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Leads.ArchiveView'        ,  0, 'Leads.LBL_LIST_NAME'                        , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Leads/view.aspx?id={0}&ArchiveView=1', null, 'Leads', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads.ArchiveView'        ,  1, 'Leads.LBL_LIST_TITLE'                       , 'TITLE'                , 'TITLE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Leads.ArchiveView'        ,  2, 'Leads.LBL_LIST_EMAIL1'                      , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads.ArchiveView'        ,  3, '.LBL_LIST_PHONE'                            , 'PHONE_WORK'           , 'PHONE_WORK'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads.ArchiveView'        ,  4, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Leads.ArchiveView'        ,  5, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Leads.ArchiveView'        ,  6, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Leads.ArchiveView'    ,  3, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Prospects.ArchiveView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.Prospects.ArchiveView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.Prospects.ArchiveView';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.Prospects.ArchiveView'    , 'DataPrivacy', 'vwDATA_PRIVACY_PROSPECTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Prospects.ArchiveView'    ,  0, 'Prospects.LBL_LIST_PROSPECT_NAME'           , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Prospects/view.aspx?id={0}&ArchiveView=1', null, 'Prospects', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects.ArchiveView'    ,  1, 'Prospects.LBL_LIST_TITLE'                   , 'TITLE'                , 'TITLE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'DataPrivacy.Prospects.ArchiveView'    ,  2, 'Prospects.LBL_LIST_EMAIL1'                  , 'EMAIL1'               , 'EMAIL1'               , '20%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects.ArchiveView'    ,  3, '.LBL_LIST_PHONE'                            , 'PHONE_WORK'           , 'PHONE_WORK'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects.ArchiveView'    ,  4, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.Prospects.ArchiveView'    ,  5, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'DataPrivacy.Prospects.ArchiveView'    ,  6, null, '1%', 'ID', 'Preview', 'preview_inline';

	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'DataPrivacy.Prospects.ArchiveView',  3, null, null, null, null, 0;
end -- if;
GO

-- 04/04/2021 Paul.  Add support for React client. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.PopupMarkFields';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'DataPrivacy.PopupMarkFields' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS DataPrivacy.PopupMarkFields';
	exec dbo.spGRIDVIEWS_InsertOnly             'DataPrivacy.PopupMarkFields'          , 'DataPrivacy', 'vwDATA_PRIVACY_FIELDS';
	exec spGRIDVIEWS_COLUMNS_InsBound           'DataPrivacy.PopupMarkFields'          ,  0, 'Audit.LBL_LIST_FIELD'                       , 'FIELD_LABEL'          , null                   , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.PopupMarkFields'          ,  1, 'Audit.LBL_LIST_VALUE'                       , 'VALUE'                , null                   , '44%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.PopupMarkFields'          ,  2, 'Audit.LBL_LIST_LEAD_SOURCE'                 , 'LEAD_SOURCE'          , null                   , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'DataPrivacy.PopupMarkFields'          ,  3, 'Audit.LBL_LIST_LAST_UPDATED'                , 'LAST_UPDATED'         , null                   , '15%';
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

call dbo.spGRIDVIEWS_COLUMNS_DataPrivacy()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_DataPrivacy')
/

-- #endif IBM_DB2 */

