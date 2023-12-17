

print 'DETAILVIEWS_RELATIONSHIPS MicrosoftTeams';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 01/15/20123Paul.  Add MicrosoftTeams. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'MicrosoftTeams.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'MicrosoftTeams.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS MicrosoftTeams.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'MicrosoftTeams.DetailView' , 'MicrosoftTeams'    , 'Teams'   ,  0, 'MicrosoftTeams.LBL_TEAMS'   , 'vwMICROSOFT_TEAMS_TEAMS'   , null, 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'MicrosoftTeams.DetailView' , 'MicrosoftTeams'    , 'Channels',  1, 'MicrosoftTeams.LBL_CHANNELS', 'vwMICROSOFT_TEAMS_CHANNELS', null, 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'MicrosoftTeams.DetailView' , 'MicrosoftTeams'    , 'Chats'   ,  2, 'MicrosoftTeams.LBL_CHATS'   , 'vwMICROSOFT_TEAMS_CHATS'   , null, 'NAME', 'asc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_MicrosoftTeams()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_MicrosoftTeams')
/

-- #endif IBM_DB2 */

