

print 'DASHLETS Professional';
--delete from DASHLETS
--GO

set nocount on;
GO

-- 09/20/2009 Paul.  Move Team Notices to the Professional file. 
if not exists(select * from DASHLETS where CATEGORY = 'My Dashlets' and CONTROL_NAME = '~/Administration/TeamNotices/MyTeamNotices' and DELETED = 0) begin -- then
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Home'             , '~/Administration/TeamNotices/MyTeamNotices', 'Home.LBL_TEAM_NOTICES_TITLE', 0;
end -- if;
GO

-- 11/09/2011 Paul.  Report Dashlets can no longer select the report.  The edit view is now for report parameters. 
if exists(select * from DASHLETS where CATEGORY = 'My Dashlets' and CONTROL_NAME = '~/Reports/DashletReport' and DELETED = 0) begin -- then
	update DASHLETS
	   set DELETED        = 1
	     , DATE_MODIFIED  = getdate()
	 where CATEGORY       = 'My Dashlets'
	   and CONTROL_NAME   = '~/Reports/DashletReport'
	   and DELETED        = 0;
end -- if;
GO

-- 11/04/2010 Paul.  Add dashlets for Quotes, Orders and Invoices. 
if not exists(select * from DASHLETS where CATEGORY = 'My Dashlets' and CONTROL_NAME = '~/Quotes/MyQuotes' and DELETED = 0) begin -- then
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Quotes'             , '~/Quotes/MyQuotes'    , 'Quotes.LBL_LIST_MY_QUOTES'    , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Orders'             , '~/Orders/MyOrders'    , 'Orders.LBL_LIST_MY_ORDERS'    , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Invoices'           , '~/Invoices/MyInvoices', 'Invoices.LBL_LIST_MY_INVOICES', 0;
end -- if;
GO

-- 10/26/2013 Paul.  Add dashlets for TwitterTracks. 
if not exists(select * from DASHLETS where CATEGORY = 'My Dashlets' and CONTROL_NAME = '~/TwitterTracks/MyTwitterTracks' and DELETED = 0) begin -- then
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'TwitterTracks'      , '~/TwitterTracks/MyTwitterTracks', 'TwitterTracks.LBL_LIST_MY_TWITTER_TRACKS', 0;
end -- if;
GO

-- 04/10/2018 Paul.  Add Team dashlets. 
if not exists(select * from DASHLETS where CATEGORY = 'My Dashlets' and CONTROL_NAME = '~/Accounts/MyTeamAccounts' and DELETED = 0) begin -- then
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Accounts'           , '~/Accounts/MyTeamAccounts'            , 'Accounts.LBL_LIST_MY_TEAM_ACCOUNTS'           , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Activities'         , '~/Activities/MyTeamActivities'        , 'Activities.LBL_MY_TEAM_ACTIVITIES'            , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Bugs'               , '~/Bugs/MyTeamBugs'                    , 'Bugs.LBL_LIST_MY_TEAM_BUGS'                   , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Calls'              , '~/Calls/MyTeamCalls'                  , 'Calls.LBL_LIST_MY_TEAM_CALLS'                 , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Cases'              , '~/Cases/MyTeamCases'                  , 'Cases.LBL_LIST_MY_TEAM_CASES'                 , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Contacts'           , '~/Contacts/MyTeamContacts'            , 'Contacts.LBL_LIST_MY_TEAM_CONTACTS'           , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Leads'              , '~/Leads/MyTeamLeads'                  , 'Leads.LBL_LIST_MY_TEAM_LEADS'                 , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Meetings'           , '~/Meetings/MyTeamMeetings'            , 'Meetings.LBL_LIST_MY_TEAM_MEETINGS'           , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Opportunities'      , '~/Opportunities/MyTeamOpportunities'  , 'Opportunities.LBL_MY_TEAM_TOP_OPPORTUNITIES'  , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Project'            , '~/Projects/MyTeamProjects'            , 'Project.LBL_LIST_MY_TEAM_PROJECTS'            , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'ProjectTask'        , '~/ProjectTasks/MyTeamProjectTasks'    , 'ProjectTask.LBL_LIST_MY_TEAM_PROJECT_TASKS'   , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Prospects'          , '~/Prospects/MyTeamProspects'          , 'Prospects.LBL_LIST_MY_TEAM_PROSPECTS'         , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Tasks'              , '~/Tasks/MyTeamTasks'                  , 'Tasks.LBL_LIST_MY_TEAM_TASKS'                 , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Opportunities'      , '~/Opportunities/MyTeamPipeline'       , 'Home.LBL_MY_TEAM_PIPELINE'                    , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Emails'             , '~/Emails/MyTeamEmails'                , 'Emails.LBL_LIST_MY_TEAM_EMAILS'               , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Quotes'             , '~/Quotes/MyTeamQuotes'                , 'Quotes.LBL_LIST_MY_TEAM_QUOTES'               , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Orders'             , '~/Orders/MyTeamOrders'                , 'Orders.LBL_LIST_MY_TEAM_ORDERS'               , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Invoices'           , '~/Invoices/MyTeamInvoices'            , 'Invoices.LBL_LIST_MY_TEAM_INVOICES'           , 0;
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'TwitterTracks'      , '~/TwitterTracks/MyTeamTwitterTracks'  , 'TwitterTracks.LBL_LIST_MY_TEAM_TWITTER_TRACKS', 0;
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

call dbo.spDASHLETS_Professional()
/

call dbo.spSqlDropProcedure('spDASHLETS_Professional')
/

-- #endif IBM_DB2 */

