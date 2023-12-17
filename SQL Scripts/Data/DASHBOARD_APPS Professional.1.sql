

print 'DASHBOARD_APPS Professional';
--delete from DASHBOARD_APPS
--GO

set nocount on;
GO


if not exists(select * from DASHBOARD_APPS where CATEGORY = 'My Dashboard' and NAME = 'My Quotes' and DELETED = 0) begin -- then
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Quotes'                    , 'My Dashboard', 'Quotes'       , 'Quotes.LBL_LIST_MY_QUOTES'              , 'Quotes.SearchHome'                     , '~/html5/Dashlets/MyQuotes.js'                , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Orders'                    , 'My Dashboard', 'Orders'       , 'Orders.LBL_LIST_MY_ORDERS'              , 'Orders.SearchHome'                     , '~/html5/Dashlets/MyOrders.js'                , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Invoices'                  , 'My Dashboard', 'Invoices'     , 'Invoices.LBL_LIST_MY_INVOICES'          , 'Invoices.SearchHome'                   , '~/html5/Dashlets/MyInvoices.js'              , 0;
end -- if;
GO

-- 07/31/2017 Paul.  Add My Favorite dashlets. 
-- delete from DASHBOARD_APPS where CATEGORY = 'My Dashboard' and NAME like 'My Favorite %';
if not exists(select * from DASHBOARD_APPS where CATEGORY = 'My Dashboard' and NAME = 'My Favorite Quotes' and DELETED = 0) begin -- then
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Favorite Quotes'           , 'My Dashboard', 'Quotes'       , 'Quotes.LBL_LIST_MY_FAVORITE_QUOTES'     , 'Quotes.SearchHome'                     , '~/html5/Dashlets/MyFavoriteQuotes.js'        , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Favorite Orders'           , 'My Dashboard', 'Orders'       , 'Orders.LBL_LIST_MY_FAVORITE_ORDERS'     , 'Orders.SearchHome'                     , '~/html5/Dashlets/MyFavoriteOrders.js'        , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Favorite Invoices'         , 'My Dashboard', 'Invoices'     , 'Invoices.LBL_LIST_MY_FAVORITE_INVOICES' , 'Invoices.SearchHome'                   , '~/html5/Dashlets/MyFavoriteInvoices.js'      , 0;
end -- if;
GO

-- 07/31/2017 Paul.  Add My Team dashlets. 
-- delete from DASHBOARD_APPS where CATEGORY = 'My Dashboard' and NAME like 'My Team %';
if not exists(select * from DASHBOARD_APPS where CATEGORY = 'My Dashboard' and NAME = 'My Team Accounts' and DELETED = 0) begin -- then
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Accounts'               , 'My Dashboard', 'Accounts'     , 'Accounts.LBL_LIST_MY_TEAM_ACCOUNTS'          , 'Accounts.SearchHome'                 , '~/html5/Dashlets/MyTeamAccounts.js'              , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Activities'             , 'My Dashboard', 'Activities'   , 'Activities.LBL_MY_TEAM_ACTIVITIES'           , 'Activities.SearchHome'               , '~/html5/Dashlets/MyTeamActivities.js'            , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Bugs'                   , 'My Dashboard', 'Bugs'         , 'Bugs.LBL_LIST_MY_TEAM_BUGS'                  , 'Bugs.SearchHome'                     , '~/html5/Dashlets/MyTeamBugs.js'                  , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Calls'                  , 'My Dashboard', 'Calls'        , 'Calls.LBL_LIST_MY_TEAM_CALLS'                , 'Calls.SearchHome'                    , '~/html5/Dashlets/MyTeamCalls.js'                 , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Cases'                  , 'My Dashboard', 'Cases'        , 'Cases.LBL_LIST_MY_TEAM_CASES'                , 'Cases.SearchHome'                    , '~/html5/Dashlets/MyTeamCases.js'                 , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Contacts'               , 'My Dashboard', 'Contacts'     , 'Contacts.LBL_LIST_MY_TEAM_CONTACTS'          , 'Contacts.SearchHome'                 , '~/html5/Dashlets/MyTeamContacts.js'              , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Leads'                  , 'My Dashboard', 'Leads'        , 'Leads.LBL_LIST_MY_TEAM_LEADS'                , 'Leads.SearchHome'                    , '~/html5/Dashlets/MyTeamLeads.js'                 , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Meetings'               , 'My Dashboard', 'Meetings'     , 'Meetings.LBL_LIST_MY_TEAM_MEETINGS'          , 'Meetings.SearchHome'                 , '~/html5/Dashlets/MyTeamMeetings.js'              , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Opportunities'          , 'My Dashboard', 'Opportunities', 'Opportunities.LBL_MY_TEAM_TOP_OPPORTUNITIES' , 'Opportunities.SearchHome'            , '~/html5/Dashlets/MyTeamOpportunities.js'         , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Project'                , 'My Dashboard', 'Project'      , 'Project.LBL_LIST_MY_TEAM_PROJECTS'           , 'Project.SearchHome'                  , '~/html5/Dashlets/MyTeamProjects.js'              , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team ProjectTask'            , 'My Dashboard', 'ProjectTask'  , 'ProjectTask.LBL_LIST_MY_TEAM_PROJECT_TASKS'  , 'ProjectTask.SearchHome'              , '~/html5/Dashlets/MyTeamProjectTasks.js'          , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Prospects'              , 'My Dashboard', 'Prospects'    , 'Prospects.LBL_LIST_MY_TEAM_PROSPECTS'        , 'Prospects.SearchHome'                , '~/html5/Dashlets/MyTeamProspects.js'             , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Tasks'                  , 'My Dashboard', 'Tasks'        , 'Tasks.LBL_LIST_MY_TEAM_TASKS'                , 'Tasks.SearchHome'                    , '~/html5/Dashlets/MyTeamTasks.js'                 , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Pipeline By Sales Stage', 'My Dashboard', 'Opportunities', 'Home.LBL_MY_TEAM_PIPELINE'                   , 'Opportunities.MyPipelineBySalesStage', '~/html5/Dashlets/MyTeamPipelineBySalesStage.js'  , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Emails'                 , 'My Dashboard', 'Emails'       , 'Emails.LBL_LIST_MY_TEAM_EMAILS'              , 'Emails.SearchHome'                   , '~/html5/Dashlets/MyTeamEmails.js'                , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Quotes'                 , 'My Dashboard', 'Quotes'       , 'Quotes.LBL_LIST_MY_TEAM_QUOTES'              , 'Quotes.SearchHome'                   , '~/html5/Dashlets/MyTeamQuotes.js'                , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Orders'                 , 'My Dashboard', 'Orders'       , 'Orders.LBL_LIST_MY_TEAM_ORDERS'              , 'Orders.SearchHome'                   , '~/html5/Dashlets/MyTeamOrders.js'                , 0;
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Team Invoices'               , 'My Dashboard', 'Invoices'     , 'Invoices.LBL_LIST_MY_TEAM_INVOICES'          , 'Invoices.SearchHome'                 , '~/html5/Dashlets/MyTeamInvoices.js'              , 0;
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

call dbo.spDASHBOARD_APPS_Pro()
/

call dbo.spSqlDropProcedure('spDASHBOARD_APPS_Pro')
/

-- #endif IBM_DB2 */

