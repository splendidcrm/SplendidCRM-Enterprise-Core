

print 'GRIDVIEWS_COLUMNS BusinessProcesses';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcesses.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcesses.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS BusinessProcesses.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'BusinessProcesses.ListView'     , 'BusinessProcesses', 'vwBUSINESS_PROCESSES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'BusinessProcesses.ListView'     , 2, 'BusinessProcesses.LBL_LIST_NAME'                 , 'NAME'            , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'BusinessProcesses', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'BusinessProcesses.ListView'     , 3, 'BusinessProcesses.LBL_LIST_TYPE'                 , 'TYPE'            , 'TYPE'            , '15%', 'workflow_type_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'BusinessProcesses.ListView'     , 4, 'BusinessProcesses.LBL_LIST_BASE_MODULE'          , 'BASE_MODULE'     , 'BASE_MODULE'     , '15%', 'WorkflowModules';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'BusinessProcesses.ListView'     , 5, 'BusinessProcesses.LBL_LIST_STATUS'               , 'STATUS'          , 'STATUS'          , '15%', 'workflow_status_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where DATA_FIELD = 'PENDING_PROCESS_ID' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS BusinessProcesses PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.ListView'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Bugs.ListView'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Campaigns.ListView'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Cases.ListView'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.ListView'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contracts.ListView'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.ListView'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Invoices.ListView'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'KBDocuments.ListView'        , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Leads.ListView'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.ListView'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Orders.ListView'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'ProductTemplates.ListView'   , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Project.ListView'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'ProjectTask.ListView'        , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'ProspectLists.ListView'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Prospects.ListView'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.ListView'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Surveys.ListView'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Tasks.ListView'              , 'PENDING_PROCESS_ID';

	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Bugs'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Cases'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Contacts'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Contracts'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Documents'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Invoices'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Leads'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Opportunities'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Orders'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Project'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Accounts.Quotes'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Bugs.Accounts'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Bugs.Cases'                  , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Bugs.Contacts'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Bugs.Documents'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'CallMarketing.ProspectLists' , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Calls.Contacts'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Calls.Leads'                 , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Campaigns.Leads'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Campaigns.Opportunities'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Campaigns.ProspectLists'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Cases.Bugs'                  , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Cases.Contacts'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Cases.Documents'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Cases.KBDocuments'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Cases.Project'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Bugs'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Cases'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Contracts'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Documents'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Invoices'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Leads'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Opportunities'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Orders'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Project'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.ProspectLists'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contacts.Quotes'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contracts.Contacts'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contracts.Documents'         , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Contracts.Quotes'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Accounts'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Bugs'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Cases'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Contacts'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Contracts'         , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Leads'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Opportunities'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Documents.Quotes'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'EmailMarketing.ProspectLists', 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Accounts'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Bugs'                 , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Cases'                , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Contacts'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Leads'                , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Opportunities'        , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Project'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.ProjectTask'          , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Emails.Quotes'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Invoices.Cases'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'KBDocuments.Cases'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Leads.Contacts'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Leads.Documents'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Leads.ProspectLists'         , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Meetings.Contacts'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Meetings.Leads'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.Contacts'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.Contracts'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.Documents'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.Leads'         , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.Project'       , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Opportunities.Quotes'        , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Orders.Cases'                , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Orders.Invoices'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Payments.Invoices'           , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Project.Accounts'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Project.Contacts'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Project.Opportunities'       , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Project.ProjectTask'         , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Project.Quotes'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'ProspectLists.Contacts'      , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'ProspectLists.Leads'         , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'ProspectLists.Prospects'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Prospects.ProspectLists'     , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.Cases'                , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.Contracts'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.Documents'            , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.Invoices'             , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.Orders'               , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'Quotes.Project'              , 'PENDING_PROCESS_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHidden    'SurveyQuestions.Surveys'     , 'PENDING_PROCESS_ID';
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

call dbo.spGRIDVIEWS_COLUMNS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_BusinessProcesses')
/

-- #endif IBM_DB2 */

