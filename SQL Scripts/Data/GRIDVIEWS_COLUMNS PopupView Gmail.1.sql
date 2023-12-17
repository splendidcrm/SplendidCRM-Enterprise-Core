

print 'GRIDVIEWS_COLUMNS PopupView Gmail';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.PopupView.Gmail'
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.PopupView.Gmail', 'Accounts', 'vwACCOUNTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.PopupView.Gmail'          , 1, 'Accounts.LBL_LIST_ACCOUNT_NAME'           , 'NAME'            , 'NAME'            , '45%', 'listViewTdLinkS1', 'ID NAME', 'SelectAccount(''{0}'', ''{1}'');', null, 'Accounts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.PopupView.Gmail'          , 2, 'Accounts.LBL_LIST_CITY'                   , 'CITY'            , 'CITY'            , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.PopupView.Gmail'          , 3, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.PopupView.Gmail'          , 4, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.PopupView.Gmail', 'Bugs', 'vwBUGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.PopupView.Gmail'              , 1, 'Bugs.LBL_LIST_NUMBER'                     , 'BUG_NUMBER'      , 'BUG_NUMBER'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.PopupView.Gmail'              , 2, 'Bugs.LBL_LIST_SUBJECT'                    , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID NAME', 'SelectBug(''{0}'', ''{1}'');', null, 'Bugs', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.PopupView.Gmail'              , 3, 'Bugs.LBL_LIST_STATUS'                     , 'STATUS'          , 'STATUS'          , '10%', 'bug_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.PopupView.Gmail'              , 4, 'Bugs.LBL_LIST_TYPE'                       , 'TYPE'            , 'TYPE'            , '10%', 'bug_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.PopupView.Gmail'              , 5, 'Bugs.LBL_LIST_PRIORITY'                   , 'PRIORITY'        , 'PRIORITY'        , '10%', 'bug_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.PopupView.Gmail'              , 6, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.PopupView.Gmail'              , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.PopupView.Gmail', 'Cases', 'vwCASES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.PopupView.Gmail'             , 1, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'     , 'CASE_NUMBER'     , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectCase(''{0}'', ''{1}'');'  , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.PopupView.Gmail'             , 2, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'            , 'NAME'            , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectCase(''{0}'', ''{1}'');'  , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.PopupView.Gmail'             , 3, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.PopupView.Gmail'             , 4, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'          , 'STATUS'          , '10%', 'case_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.PopupView.Gmail'             , 5, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.PopupView.Gmail'             , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.PopupView.Gmail', 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.PopupView.Gmail'          , 1, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectContact(''{0}'', ''{1}'');', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.PopupView.Gmail'          , 2, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.PopupView.Gmail'          , 3, 'Contacts.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.PopupView.Gmail'          , 4, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.PopupView.Gmail'          , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'EmailTemplates.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS EmailTemplates.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'EmailTemplates.PopupView.Gmail', 'EmailTemplates', 'vwEMAIL_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'EmailTemplates.PopupView.Gmail'    , 1, 'EmailTemplates.LBL_LIST_NAME'             , 'NAME'            , 'NAME'            , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectEmailTemplate(''{0}'', ''{1}'');', null, 'EmailTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'EmailTemplates.PopupView.Gmail'    , 2, 'EmailTemplates.LBL_LIST_DESCRIPTION'      , 'DESCRIPTION'     , 'DESCRIPTION'     , '55%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'EmailTemplates.PopupView.Gmail'    , 3, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.PopupView.Gmail', 'Leads', 'vwLEADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.PopupView.Gmail'             , 1, 'Leads.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectLead(''{0}'', ''{1}'');', null, 'Leads', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.PopupView.Gmail'             , 2, 'Leads.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '40%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.PopupView.Gmail'             , 3, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.PopupView.Gmail'             , 4, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.PopupView.Gmail', 'Opportunities', 'vwOPPORTUNITIES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.PopupView.Gmail'     , 1, 'Opportunities.LBL_LIST_OPPORTUNITY_NAME'  , 'NAME'            , 'NAME'            , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectOpportunity(''{0}'', ''{1}'');', null, 'Opportunities', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.PopupView.Gmail'     , 2, 'Opportunities.LBL_LIST_ACCOUNT_NAME'      , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '35%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.PopupView.Gmail'     , 3, 'Opportunities.LBL_LIST_DATE_CLOSED'       , 'DATE_CLOSED'     , 'DATE_CLOSED'     , '10%', 'Date'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.PopupView.Gmail'     , 4, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.PopupView.Gmail'     , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Project.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Project.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Project.PopupView.Gmail', 'Project', 'vwPROJECTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Project.PopupView.Gmail'           , 1, 'Project.LBL_LIST_NAME'                    , 'NAME'            , 'NAME'            , '60%', 'listViewTdLinkS1', 'ID NAME', 'SelectProject(''{0}'', ''{1}'');', null, 'Project', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Project.PopupView.Gmail'           , 2, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Project.PopupView.Gmail'           , 3, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '20%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProjectTask.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProjectTask.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProjectTask.PopupView.Gmail', 'ProjectTask', 'vwPROJECT_TASKS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProjectTask.PopupView.Gmail'       , 2, 'ProjectTask.LBL_LIST_NAME'                , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectProjectTask(''{0}'', ''{1}'');', null, 'ProjectTask', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProjectTask.PopupView.Gmail'       , 3, 'ProjectTask.LBL_LIST_PARENT_NAME'         , 'PROJECT_NAME'    , 'PROJECT_NAME'    , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProjectTask.PopupView.Gmail'       , 4, 'ProjectTask.LBL_LIST_DUE_DATE'            , 'DATE_DUE'        , 'DATE_DUE'        , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProjectTask.PopupView.Gmail'       , 5, 'ProjectTask.LBL_LIST_STATUS'              , 'STATUS'          , 'STATUS'          , '10%', 'project_task_status_options';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProjectTask.PopupView.Gmail'       , 6, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProjectTask.PopupView.Gmail'       , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Prospects.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospects.PopupView.Gmail', 'Prospects', 'vwPROSPECTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.PopupView.Gmail'         , 1, 'Prospects.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectProspect(''{0}'', ''{1}'');', null, 'Prospects', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.PopupView.Gmail'         , 2, 'Prospects.LBL_LIST_TITLE'                 , 'TITLE'           , 'TITLE'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.PopupView.Gmail'         , 3, 'Prospects.LBL_LIST_EMAIL_ADDRESS'         , 'EMAIL1'          , 'EMAIL1'          , '25%', 'listViewTdLinkS1', 'EMAIL1'     , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.PopupView.Gmail'         , 4, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.PopupView.Gmail'         , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Releases.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Releases.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Releases.PopupView.Gmail', 'Releases', 'vwRELEASES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Releases.PopupView.Gmail'         , 1, 'Releases.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '72%', 'listViewTdLinkS1', 'ID NAME', 'SelectRelease(''{0}'', ''{1}'');', null, 'Releases', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Releases.PopupView.Gmail'         , 2, 'Releases.LBL_LIST_STATUS'                 , 'STATUS'          , 'STATUS'          , '10%', 'release_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Releases.PopupView.Gmail'         , 3, 'Releases.LBL_LIST_LIST_ORDER'             , 'LIST_ORDER'      , 'LIST_ORDER'      , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Tasks.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Tasks.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Tasks.PopupView.Gmail', 'Tasks', 'vwTASKS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Tasks.PopupView.Gmail'             , 1, 'Tasks.LBL_LIST_SUBJECT'                   , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID NAME', 'SelectTask(''{0}'', ''{1}'');', null, 'Tasks', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Tasks.PopupView.Gmail'             , 2, 'Tasks.LBL_LIST_DUE_DATE'                  , 'DATE_DUE'        , 'DATE_DUE'        , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Tasks.PopupView.Gmail'             , 3, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Tasks.PopupView.Gmail'             , 4, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '15%';
end -- if;
GO

-- 12/02/2009 Paul.  Correct Users.PopupView URL_FIELD.
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.PopupView.Gmail';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Users.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Users.PopupView.Gmail', 'Users', 'vwUSERS_ASSIGNED_TO_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.PopupView.Gmail'             , 1, 'Users.LBL_LIST_NAME'                      , 'FULL_NAME'       , 'FULL_NAME'       , '40%', 'listViewTdLinkS1', 'ID USER_NAME', 'SelectUser(''{0}'', ''{1}'');', null, 'Users', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.PopupView.Gmail'             , 2, 'Users.LBL_LIST_USER_NAME'                 , 'USER_NAME'       , 'USER_NAME'       , '40%', 'listViewTdLinkS1', 'ID USER_NAME', 'SelectUser(''{0}'', ''{1}'');', null, 'Users', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Users.PopupView.Gmail'             , 3, 'Users.LBL_LIST_DEPARTMENT'                , 'DEPARTMENT'      , 'DEPARTMENT'      , '20%';
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

call dbo.spGRIDVIEWS_COLUMNS_PopupViewsGmail()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_PopupViewsGmail')
/

-- #endif IBM_DB2 */

