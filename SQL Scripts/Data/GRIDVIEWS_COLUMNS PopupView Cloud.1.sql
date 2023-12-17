

print 'GRIDVIEWS_COLUMNS PopupView Cloud';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.PopupView.Cloud'
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'GetResponse.Campaigns.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS GetResponse.Campaigns.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'GetResponse.Campaigns.PopupView', 'GetResponse', 'vwCAMPAIGNS_GetResponse';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'GetResponse.Campaigns.PopupView', 0, 'GetResponse.LBL_LIST_NAME', 'NAME', 'NAME', '95%', 'listViewTdLinkS1', 'ID NAME', 'SelectCampaign(''{0}'', ''{1}'');', null, null, null;
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

call dbo.spGRIDVIEWS_COLUMNS_PopupViewsCloud()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_PopupViewsCloud')
/

-- #endif IBM_DB2 */

