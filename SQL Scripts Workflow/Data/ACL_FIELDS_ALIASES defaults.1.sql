

print 'ACL_FIELDS_ALIASES defaults';
GO

set nocount on;
GO

exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CREATED_BY'           , null              , 'CREATED_BY_ID'      , null              ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'MODIFIED_BY'          , null              , 'MODIFIED_USER_ID'   , null              ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ASSIGNED_TO'          , null              , 'ASSIGNED_USER_ID'   , null              ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TEAM_NAME'            , null              , 'TEAM_ID'            , null              ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TEAM_SET_ID'          , null              , 'TEAM_ID'            , null              ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TEAM_SET_NAME'        , null              , 'TEAM_ID'            , null              ;

exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_NAME'          , 'Accounts'        , 'PARENT_ID'          , 'Accounts'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'FIXED_IN_RELEASE'     , 'Bugs'            , 'FIXED_IN_RELEASE_ID', 'Bugs'            ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'FOUND_IN_RELEASE'     , 'Bugs'            , 'FOUND_IN_RELEASE_ID', 'Bugs'            ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_NAME'          , 'Calls'           , 'PARENT_ID'          , 'Calls'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CAMPAIGN_NAME'        , 'CampaignTrackers', 'CAMPAIGN_ID'        , 'CampaignTrackers';
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CURRENCY_NAME'        , 'Campaigns'       , 'CURRENCY_ID'        , 'Campaigns'       ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Cases'           , 'ACCOUNT_ID'         , 'Cases'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Contacts'        , 'ACCOUNT_ID'         , 'Contacts'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'REPORTS_TO_NAME'      , 'Contacts'        , 'REPORTS_TO_ID'      , 'Contacts'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CAMPAIGN_NAME'        , 'EmailMarketing'  , 'CAMPAIGN_ID'        , 'EmailMarketing'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'TEMPLATE_NAME'        , 'EmailMarketing'  , 'TEMPLATE_ID'        , 'EmailMarketing'  ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_NAME'          , 'Emails'          , 'PARENT_ID'          , 'Emails'          ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Leads'           , 'ACCOUNT_ID'         , 'Leads'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CAMPAIGN_NAME'        , 'Leads'           , 'CAMPAIGN_ID'        , 'Leads'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'OPPORTUNITY_NAME'     , 'Leads'           , 'OPPORTUNITY_ID'     , 'Leads'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_NAME'          , 'Meetings'        , 'PARENT_ID'          , 'Meetings'        ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CONTACT_NAME'         , 'Notes'           , 'CONTACT_ID'         , 'Notes'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_NAME'          , 'Notes'           , 'PARENT_ID'          , 'Notes'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'ACCOUNT_NAME'         , 'Opportunities'   , 'ACCOUNT_ID'         , 'Opportunities'   ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CAMPAIGN_NAME'        , 'Opportunities'   , 'CAMPAIGN_ID'        , 'Opportunities'   ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'DEPENDS_ON_NAME'      , 'ProjectTask'     , 'DEPENDS_ON_ID'      , 'ProjectTask'     ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PROJECT_NAME'         , 'ProjectTask'     , 'PROJECT_ID'         , 'ProjectTask'     ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'CONTACT_NAME'         , 'Tasks'           , 'CONTACT_ID'         , 'Tasks'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'PARENT_NAME'          , 'Tasks'           , 'PARENT_ID'          , 'Tasks'           ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'REPORTS_TO_NAME'      , 'Employees'       , 'REPORTS_TO_ID'      , 'Employees'       ;
exec dbo.spACL_FIELDS_ALIASES_InsertOnly null, 'REPORTS_TO_NAME'      , 'Users'           , 'REPORTS_TO_ID'      , 'Users'           ;
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

call dbo.spACL_FIELDS_ALIASES_Defaults()
/

call dbo.spSqlDropProcedure('spACL_FIELDS_ALIASES_Defaults')
/

-- #endif IBM_DB2 */

