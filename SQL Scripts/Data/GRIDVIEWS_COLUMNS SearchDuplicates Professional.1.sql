

print 'GRIDVIEWS_COLUMNS Duplicate Search Professional';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.SearchDuplicates';
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.SearchDuplicates', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.SearchDuplicates'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.SearchDuplicates'         , 2, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '50%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Reports.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Reports.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Reports.SearchDuplicates', 'Reports', 'vwREPORTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Reports.SearchDuplicates'           , 1, 'Reports.LBL_LIST_NAME'                    , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Reports/view.aspx?id={0}', null, 'Reports', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Charts.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Charts.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Charts.SearchDuplicates', 'Charts', 'vwCHARTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Charts.SearchDuplicates'            , 1, 'Charts.LBL_LIST_NAME'                     , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Charts/view.aspx?id={0}', null, 'Charts', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.SearchDuplicates', 'KBDocuments', 'vwKBDOCUMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.SearchDuplicates'       , 1, 'KBDocuments.LBL_LIST_NAME'               , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/KBDocuments/view.aspx?id={0}', null, 'KBDocuments', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.SearchDuplicates', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.SearchDuplicates'          , 1, 'Invoices.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.SearchDuplicates', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.SearchDuplicates'            , 1, 'Orders.LBL_LIST_NAME'                    , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.SearchDuplicates', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.SearchDuplicates'            , 1, 'Quotes.LBL_LIST_NAME'                    , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Quotes/view.aspx?id={0}', null, 'Quotes', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductTemplates.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.SearchDuplicates', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.SearchDuplicates'  , 1, 'ProductTemplates.LBL_LIST_NAME'          , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Administration/ProductTemplates/view.aspx?id={0}', null, 'ProductTemplates', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Surveys.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'Surveys.SearchDuplicates', 'Surveys', 'vwSURVEYS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Surveys.SearchDuplicates'           , 1, 'Surveys.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Surveys/view.aspx?id={0}', null, 'Surveys', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyQuestions.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyQuestions.SearchDuplicates', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.SearchDuplicates'   , 1, 'SurveyQuestions.LBL_LIST_NAME'           , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/SurveyQuestions/view.aspx?id={0}', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TwitterTracks.SearchDuplicates' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TwitterTracks.SearchDuplicates';
	exec dbo.spGRIDVIEWS_InsertOnly           'TwitterTracks.SearchDuplicates', 'TwitterTracks', 'vwTWITTER_TRACKS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.SearchDuplicates'     , 1, 'TwitterTracks.LBL_LIST_NAME'             , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/TwitterTracks/view.aspx?id={0}', null, 'TwitterTracks', 'ASSIGNED_USER_ID';
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

call dbo.spGRIDVIEWS_COLUMNS_SearchDuplicatesPro()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_SearchDuplicatesPro')
/

-- #endif IBM_DB2 */

