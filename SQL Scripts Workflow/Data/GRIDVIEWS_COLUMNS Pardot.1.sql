

print 'GRIDVIEWS_COLUMNS ListView Pardot';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.Pardot'
--GO

set nocount on;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.ListView.Pardot';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.ListView.Pardot' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.ListView.Pardot';
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospects.ListView.Pardot', 'Prospects', 'vwPROSPECTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.ListView.Pardot'         ,    2, 'Pardot.LBL_ID'                     , 'id'                       , 'id'                       , '10%', 'listViewTdLinkS1', 'id'   , 'view.aspx?prospect_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.ListView.Pardot'         ,    3, 'Pardot.LBL_EMAIL'                  , 'email'                    , 'email'                    , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.ListView.Pardot'         ,    4, 'Pardot.LBL_FIRST_NAME'             , 'first_name'               , 'first_name'               , '10%', 'listViewTdLinkS1', 'id'   , 'view.aspx?prospect_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.ListView.Pardot'         ,    5, 'Pardot.LBL_LAST_NAME'              , 'last_name'                , 'last_name'                , '10%', 'listViewTdLinkS1', 'id'   , 'view.aspx?prospect_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.ListView.Pardot'         ,    6, 'Pardot.LBL_COMPANY'                , 'company'                  , 'company'                  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.ListView.Pardot'         ,    7, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.ListView.Pardot'         ,    8, '.LBL_LIST_DATE_MODIFIED'           , 'updated_at'               , 'updated_at'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.ListView.Pardot'         ,    9, 'Pardot.LBL_LAST_ACTIVITY_AT'       , 'last_activity_at'         , 'last_activity_at'         , '10%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.Pardot.VisitorActivities';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.Pardot.VisitorActivities' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.Pardot.VisitorActivities';
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospects.Pardot.VisitorActivities', 'VisitorActivities', 'vwPROSPECTS_VISITOR_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.Pardot.VisitorActivities',    2, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '20%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.VisitorActivities',    3, 'Pardot.LBL_ACTIVITY_TYPE'          , 'type_name'                , 'type_name'                , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.VisitorActivities',    4, 'Pardot.LBL_ACTIVITY_DETAILS'       , 'details'                  , 'details'                  , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.VisitorActivities',    5, 'Pardot.LBL_CAMPAIGN_NAME'          , 'campaign_name'            , 'campaign_name'            , '20%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.Pardot';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.Pardot' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.ListView.Pardot';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.ListView.Pardot', 'Accounts', 'vwACCOUNTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.Pardot'          ,    2, 'Pardot.LBL_ID'                     , 'id'                       , 'id'                       , '10%', 'listViewTdLinkS1', 'id'   , 'view.aspx?account_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.Pardot'          ,    3, 'Pardot.LBL_NAME'                   , 'name'                     , 'name'                     , '60%', 'listViewTdLinkS1', 'id'   , 'view.aspx?account_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.ListView.Pardot'          ,    4, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.ListView.Pardot'          ,    5, '.LBL_LIST_DATE_MODIFIED'           , 'updated_at'               , 'updated_at'               , '10%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Campaigns.ListView.Pardot';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Campaigns.ListView.Pardot' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Campaigns.ListView.Pardot';
	exec dbo.spGRIDVIEWS_InsertOnly           'Campaigns.ListView.Pardot', 'Campaigns', 'vwCAMPAIGNS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Campaigns.ListView.Pardot'         ,    2, 'Pardot.LBL_ID'                     , 'id'                       , 'id'                       , '10%', 'listViewTdLinkS1', 'id'   , 'view.aspx?campaign_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Campaigns.ListView.Pardot'         ,    3, 'Pardot.LBL_NAME'                   , 'name'                     , 'name'                     , '50%', 'listViewTdLinkS1', 'id'   , 'view.aspx?campaign_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Campaigns.ListView.Pardot'         ,    4, 'Pardot.LBL_COST'                   , 'cost'                     , 'cost'                     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Campaigns.ListView.Pardot'         ,    5, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Campaigns.ListView.Pardot'         ,    6, '.LBL_LIST_DATE_MODIFIED'           , 'updated_at'               , 'updated_at'               , '10%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView.Pardot';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView.Pardot' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.ListView.Pardot';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.ListView.Pardot', 'Opportunities', 'vwOPPORTUNITIES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.Pardot'     ,    2, 'Pardot.LBL_ID'                     , 'id'                       , 'id'                       , '10%', 'listViewTdLinkS1', 'id'   , 'view.aspx?opportunity_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.Pardot'     ,    3, 'Pardot.LBL_NAME'                   , 'name'                     , 'name'                     , '15%', 'listViewTdLinkS1', 'id'   , 'view.aspx?opportunity_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.Pardot'     ,    4, 'Pardot.LBL_CAMPAIGN_NAME'          , 'campaign_name'            , 'campaign_name'            , '15%', 'listViewTdLinkS1', 'id'   , '~/Campaigns/Pardot/view.aspx?campaign_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Pardot'     ,    5, 'Pardot.LBL_VALUE'                  , 'value'                    , 'value'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Pardot'     ,    6, 'Pardot.LBL_PROBABILITY'            , 'probability'              , 'probability'              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Pardot'     ,    7, 'Pardot.LBL_STAGE'                  , 'stage'                    , 'stage'                    , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Pardot'     ,    8, 'Pardot.LBL_TYPE'                   , 'type'                     , 'type'                     , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Pardot'     ,    9, 'Pardot.LBL_STATUS'                 , 'status'                   , 'status'                   , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.Pardot'     ,   10, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.Pardot'     ,   11, '.LBL_LIST_DATE_MODIFIED'           , 'updated_at'               , 'updated_at'               , '10%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.Pardot.Visitors';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.Pardot.Visitors' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.Pardot.Visitors';
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospects.Pardot.Visitors', 'Visitors', 'vwPROSPECTS_VISITOR_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.Pardot.Visitors'         ,    2, 'Pardot.LBL_ID'                     , 'id'                       , 'id'                       , '10%', 'listViewTdLinkS1', 'id'         , 'view.aspx?visitor_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.Pardot.Visitors'         ,    3, 'Pardot.LBL_PROSPECT_NAME'          , 'prospect_name'            , 'prospect_name'            , '15%', 'listViewTdLinkS1', 'prospect_id', '~/Prospects/Pardot/view.aspx?prospect_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.Visitors'         ,    4, 'Pardot.LBL_PAGE_VIEW_COUNT'        , 'page_view_count'          , 'page_view_count'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.Visitors'         ,    5, 'Pardot.LBL_SOURCE_PARAMETER'       , 'source_parameter'         , 'source_parameter'         , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.Visitors'         ,    6, 'Pardot.LBL_HOSTNAME'               , 'hostname'                 , 'hostname'                 , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.Pardot.Visitors'         ,    7, 'Pardot.LBL_FIRST_PAGE_VIEW'        , 'created_at'               , 'created_at'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.Pardot.Visitors'         ,    8, 'Pardot.LBL_LAST_PAGE_VIEW'         , 'updated_at'               , 'updated_at'               , '10%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Pardot.VisitorActivities';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Pardot.VisitorActivities' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.Pardot.VisitorActivities';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.Pardot.VisitorActivities', 'VisitorActivities', 'vwOPPORTUNITIES_VISITOR_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Pardot.VisitorActivities',  2, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '20%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.Pardot.VisitorActivities',  3, 'Pardot.LBL_ACTIVITY_TYPE'          , 'type_name'                , 'type_name'                , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.Pardot.VisitorActivities',  4, 'Pardot.LBL_ACTIVITY_DETAILS'       , 'details'                  , 'details'                  , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.Pardot.VisitorActivities',  5, 'Pardot.LBL_CAMPAIGN_NAME'          , 'campaign_name'            , 'campaign_name'            , '20%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.Pardot.VisitorActivities';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.Pardot.VisitorActivities' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.Pardot.VisitorActivities';
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospects.Pardot.VisitorActivities', 'VisitorActivities', 'vwPROSPECTS_VISITOR_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.Pardot.VisitorActivities',  2, '.LBL_LIST_DATE_ENTERED'            , 'created_at'               , 'created_at'               , '20%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.VisitorActivities',  3, 'Pardot.LBL_ACTIVITY_TYPE'          , 'type_name'                , 'type_name'                , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.VisitorActivities',  4, 'Pardot.LBL_ACTIVITY_DETAILS'       , 'details'                  , 'details'                  , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.Pardot.VisitorActivities',  5, 'Pardot.LBL_CAMPAIGN_NAME'          , 'campaign_name'            , 'campaign_name'            , '20%';
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

call dbo.spGRIDVIEWS_COLUMNS_ListView_Pardot()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListView_Pardot')
/

-- #endif IBM_DB2 */

