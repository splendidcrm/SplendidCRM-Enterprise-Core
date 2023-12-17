

print 'GRIDVIEWS_COLUMNS SubPanel default';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME not like '%.ListView'
--GO

set nocount on;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'MicrosoftTeams.Teams';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'MicrosoftTeams.Teams' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS MicrosoftTeams.Teams';
	exec dbo.spGRIDVIEWS_InsertOnly           'MicrosoftTeams.Teams', 'MicrosoftTeams', 'vwMICROSOFT_TEAMS_TEAMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Teams', 1, 'MicrosoftTeams.LBL_LIST_ID'                  , 'Id'                 , 'Id'                 , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Teams', 2, 'MicrosoftTeams.LBL_LIST_NAME'                , 'Name'               , 'Name'               , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Teams', 3, 'MicrosoftTeams.LBL_LIST_DESCRIPTION'         , 'Description'        , 'Description'        , '50%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'MicrosoftTeams.Channels';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'MicrosoftTeams.Channels' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS MicrosoftTeams.Channels';
	exec dbo.spGRIDVIEWS_InsertOnly           'MicrosoftTeams.Channels', 'MicrosoftTeams', 'vwMICROSOFT_TEAMS_CHANNELS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 1, 'MicrosoftTeams.LBL_LIST_TEAM_NAME'        , 'TeamName'           , 'TeamName'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 2, 'MicrosoftTeams.LBL_LIST_ID'               , 'Id'                 , 'Id'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 3, 'MicrosoftTeams.LBL_LIST_NAME'             , 'Name'               , 'Name'               , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 4, 'MicrosoftTeams.LBL_LIST_MEMBERSHIP_TYPE'  , 'MembershipType'     , 'MembershipType'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 5, 'MicrosoftTeams.LBL_LIST_CREATED_DATE'     , 'CreatedDateTime'    , 'CreatedDateTime'    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 6, 'MicrosoftTeams.LBL_LIST_DESCRIPTION'      , 'Description'        , 'Description'        , '30%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'MicrosoftTeams.Chats';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'MicrosoftTeams.Chats' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS MicrosoftTeams.Chats';
	exec dbo.spGRIDVIEWS_InsertOnly           'MicrosoftTeams.Chats'   , 'MicrosoftTeams', 'vwMICROSOFT_TEAMS_CHATS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Chats'   , 1, 'MicrosoftTeams.LBL_LIST_ID'               , 'Id'                 , 'Id'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Chats'   , 2, 'MicrosoftTeams.LBL_LIST_NAME'             , 'Name'               , 'Name'               , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Chats'   , 3, 'MicrosoftTeams.LBL_LIST_CHAT_TYPE'        , 'ChatType'           , 'ChatType'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Chats'   , 4, 'MicrosoftTeams.LBL_LIST_CREATED_DATE'     , 'CreatedDateTime'    , 'CreatedDateTime'    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Chats'   , 5, 'MicrosoftTeams.LBL_LIST_LAST_UPDATED_DATE', 'LastUpdatedDateTime', 'LastUpdatedDateTime', '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MicrosoftTeams.Channels', 6, 'MicrosoftTeams.LBL_LIST_DESCRIPTION'      , 'Description'        , 'Description'        , '30%';
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

call dbo.spGRIDVIEWS_COLUMNS_MicrosoftTeams()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_MicrosoftTeams')
/

-- #endif IBM_DB2 */

