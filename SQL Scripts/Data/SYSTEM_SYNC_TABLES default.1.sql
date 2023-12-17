

print 'SYSTEM_SYNC_TABLES Default';
-- delete from SYSTEM_SYNC_TABLES;
--GO

set nocount on;
GO

-- 01/12/2010 Paul.  Remove the ID first parameter. 
-- System Tables
-- 08/23/2014 Paul.  ACLRoles and FieldValidators module names should be blank in order to sync. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACL_ROLES'                     , 'ACL_ROLES'                     , null                       , null                       , 0, null, 1, 0, null, 0;
-- 11/21/2009 Paul.  We need to use a special view for the config table to prevent sensitive data from getting to the client. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONFIG'                        , 'vwCONFIG_Sync'                 , null                       , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CURRENCIES'                    , 'CURRENCIES'                    , 'Currencies'               , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'FIELD_VALIDATORS'              , 'FIELD_VALIDATORS'              , null                       , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'FIELDS_META_DATA'              , 'FIELDS_META_DATA'              , null                       , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'LANGUAGES'                     , 'LANGUAGES'                     , null                       , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'NUMBER_SEQUENCES'              , 'NUMBER_SEQUENCES'              , null                       , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'RELEASES'                      , 'RELEASES'                      , 'Releases'                 , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TIMEZONES'                     , 'TIMEZONES'                     , null                       , null                       , 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TAB_GROUPS'                    , 'TAB_GROUPS'                    , null                       , null                       , 0, null, 1, 0, null, 0;
-- 12/05/2010 Paul.  Add Rules. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'RULES'                         , 'RULES'                         , 'Rules'                    , null                       , 0, null, 1, 0, null, 0;
GO

-- System UI Tables
-- 08/23/2014 Paul.  ACLRoles and FieldValidators module names should be blank in order to sync. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACL_ACTIONS'                   , 'ACL_ACTIONS'                   , null                       , null                       , 1, 'CATEGORY'   , 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACL_ROLES_ACTIONS'             , 'vwACL_ROLES_ACTIONS_Sync'      , null                       , null                       , 1, 'CATEGORY'   , 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DASHLETS'                      , 'DASHLETS'                      , null                       , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
-- 08/23/2014 Paul.  Use special Sync views to filter out non-offline client views. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DETAILVIEWS'                   , 'vwDETAILVIEWS_Sync'            , null                       , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DETAILVIEWS_FIELDS'            , 'vwDETAILVIEWS_FIELDS_Sync'     , null                       , null                       , 2, 'DETAIL_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DETAILVIEWS_RELATIONSHIPS'     , 'vwDETAILVIEWS_RELATIONSHIPS_Sync', null                       , null                       , 2, 'DETAIL_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DYNAMIC_BUTTONS'               , 'vwDYNAMIC_BUTTONS_Sync'        , 'DynamicButtons'           , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EDITVIEWS'                     , 'vwEDITVIEWS_Sync'              , null                       , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EDITVIEWS_FIELDS'              , 'vwEDITVIEWS_FIELDS_Sync'       , null                       , null                       , 2, 'EDIT_NAME'  , 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'GRIDVIEWS'                     , 'vwGRIDVIEWS_Sync'              , null                       , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'GRIDVIEWS_COLUMNS'             , 'vwGRIDVIEWS_COLUMNS_Sync'      , null                       , null                       , 2, 'GRID_NAME'  , 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MODULES'                       , 'MODULES'                       , 'Modules'                  , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'SHORTCUTS'                     , 'vwSHORTCUTS_Sync'              , 'Shortcuts'                , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TERMINOLOGY_ALIASES'           , 'TERMINOLOGY_ALIASES'           , 'Terminology'              , null                       , 0, null         , 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TERMINOLOGY_HELP'              , 'TERMINOLOGY_HELP'              , 'Terminology'              , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TERMINOLOGY'                   , 'TERMINOLOGY'                   , 'Terminology'              , null                       , 3, 'MODULE_NAME', 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MODULES_GROUPS'                , 'MODULES_GROUPS'                , null                       , null                       , 1, 'MODULE_NAME', 1, 0, null, 0;

-- 08/23/2014 Paul.  Use special Sync views to filter out non-offline client views. 
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'ACL_ROLES_ACTIONS' and VIEW_NAME = 'vwACL_ROLES_ACTIONS_Category' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwACL_ROLES_ACTIONS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'ACL_ROLES_ACTIONS'
	   and VIEW_NAME         = 'vwACL_ROLES_ACTIONS_Category'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'DETAILVIEWS' and VIEW_NAME = 'DETAILVIEWS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwDETAILVIEWS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'DETAILVIEWS'
	   and VIEW_NAME         = 'DETAILVIEWS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'DETAILVIEWS_FIELDS' and VIEW_NAME = 'DETAILVIEWS_FIELDS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwDETAILVIEWS_FIELDS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'DETAILVIEWS_FIELDS'
	   and VIEW_NAME         = 'DETAILVIEWS_FIELDS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'DETAILVIEWS_RELATIONSHIPS' and VIEW_NAME = 'DETAILVIEWS_RELATIONSHIPS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwDETAILVIEWS_RELATIONSHIPS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'DETAILVIEWS_RELATIONSHIPS'
	   and VIEW_NAME         = 'DETAILVIEWS_RELATIONSHIPS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'DYNAMIC_BUTTONS' and VIEW_NAME = 'DYNAMIC_BUTTONS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwDYNAMIC_BUTTONS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'DYNAMIC_BUTTONS'
	   and VIEW_NAME         = 'DYNAMIC_BUTTONS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'EDITVIEWS' and VIEW_NAME = 'EDITVIEWS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwEDITVIEWS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'EDITVIEWS'
	   and VIEW_NAME         = 'EDITVIEWS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'EDITVIEWS_FIELDS' and VIEW_NAME = 'EDITVIEWS_FIELDS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwEDITVIEWS_FIELDS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'EDITVIEWS_FIELDS'
	   and VIEW_NAME         = 'EDITVIEWS_FIELDS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'GRIDVIEWS' and VIEW_NAME = 'GRIDVIEWS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwGRIDVIEWS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'GRIDVIEWS'
	   and VIEW_NAME         = 'GRIDVIEWS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'GRIDVIEWS_COLUMNS' and VIEW_NAME = 'GRIDVIEWS_COLUMNS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwGRIDVIEWS_COLUMNS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'GRIDVIEWS_COLUMNS'
	   and VIEW_NAME         = 'GRIDVIEWS_COLUMNS'
	   and DELETED           = 0;
end -- if;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'SHORTCUTS' and VIEW_NAME = 'SHORTCUTS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwSHORTCUTS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'SHORTCUTS'
	   and VIEW_NAME         = 'SHORTCUTS'
	   and DELETED           = 0;
end -- if;
GO

-- User Tables
-- 08/23/2014 Paul.  ACLRoles and FieldValidators module names should be blank in order to sync. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACL_ROLES_USERS'               , 'ACL_ROLES_USERS'               , null                       , 'Users'                    , 0, null, 1, 1, 'USER_ID'         , 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DASHLETS_USERS'                , 'DASHLETS_USERS'                , null                       , 'Users'                    , 0, null, 1, 1, 'ASSIGNED_USER_ID', 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TEAMS'                         , 'TEAMS'                         , 'Teams'                    , null                       , 0, null, 1, 0, null, 0;
-- 12/31/2017 Paul.  We should not sync the USERS table directly as it can contain encrypted passwords. 
-- Use vwUSERS_Sync instead as it filters these fields. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'USERS'                         , 'vwUSERS_Sync'                  , 'Users'                    , null                       , 0, null, 1, 0, null, 0;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'USERS' and VIEW_NAME = 'USERS' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwUSERS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'USERS'
	   and VIEW_NAME         = 'USERS'
	   and DELETED           = 0;
end -- if;

-- 12/05/2010 Paul.  Outbound email should not be necessary as the Offline client does not send emails. 
-- 07/21/2013 Paul.  OUTBOUND_EMAILS is now used when composing an email. 
-- 03/07/2014 Paul.  We need to use the raw table or have a view that includes DELETED, DATE_MODIFIED_UTC and CREATED_BY. 
-- 08/03/2014 Paul.  Use view so that SMTP values are not included. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'OUTBOUND_EMAILS'              , 'vwOUTBOUND_EMAILS_Sync'         , 'Users'                    , null                       , 0, null, 1, 1, 'USER_ID'         , 0;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'OUTBOUND_EMAILS' and VIEW_NAME in ('vwOUTBOUND_EMAILS', 'OUTBOUND_EMAILS') and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set VIEW_NAME         = 'vwOUTBOUND_EMAILS_Sync'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'OUTBOUND_EMAILS'
	   and VIEW_NAME         in ('vwOUTBOUND_EMAILS', 'OUTBOUND_EMAILS')
	   and DELETED           = 0;
end -- if;

-- 11/26/2009 Paul.  TEAM_SETS needs to be treated as a non-system table so that it will get updated with module updates. 
-- 08/27/2014 Paul.  Back to treating TEAM_SETS as a system table.  We update with regular modules by hard-coding into client side query. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TEAM_SETS'                     , 'TEAM_SETS'                     , 'Teams'                    , null                       , 0, null, 1, 0, null, 0;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'TEAM_SETS' and IS_SYSTEM = 0 and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set IS_SYSTEM         = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'TEAM_SETS'
	   and IS_SYSTEM         = 0
	   and DELETED           = 0;
end -- if;
GO

-- Module Tables
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS'                      , 'ACCOUNTS'                      , 'Accounts'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'BUGS'                          , 'BUGS'                          , 'Bugs'                     , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CALLS'                         , 'CALLS'                         , 'Calls'                    , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CAMPAIGNS'                     , 'CAMPAIGNS'                     , 'Campaigns'                , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CASES'                         , 'CASES'                         , 'Cases'                    , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTACTS'                      , 'CONTACTS'                      , 'Contacts'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS'                     , 'DOCUMENTS'                     , 'Documents'                , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAIL_TEMPLATES'               , 'EMAIL_TEMPLATES'               , 'EmailTemplates'           , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS'                        , 'EMAILS'                        , 'Emails'                   , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'FEEDS'                         , 'FEEDS'                         , 'Feeds'                    , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'IFRAMES'                       , 'IFRAMES'                       , 'iFrames'                  , null                       , 0, null, 0, 0, null, 0;
-- 02/14/2010 Paul.  We must also sync the IMAGES table in order to get Image custom field data. 
-- 02/14/2010 Paul.  We must specify a module for the Images table, otherwise the sync will throw an exception inside GetUserAccess().
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'IMAGES'                        , 'IMAGES'                        , 'Images'                   , null                       , 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'LEADS'                         , 'LEADS'                         , 'Leads'                    , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MEETINGS'                      , 'MEETINGS'                      , 'Meetings'                 , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'NOTES'                         , 'NOTES'                         , 'Notes'                    , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'OPPORTUNITIES'                 , 'OPPORTUNITIES'                 , 'Opportunities'            , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECT'                       , 'PROJECT'                       , 'Project'                  , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECT_TASK'                  , 'PROJECT_TASK'                  , 'ProjectTask'              , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROSPECT_LISTS'                , 'PROSPECT_LISTS'                , 'ProspectLists'            , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROSPECTS'                     , 'PROSPECTS'                     , 'Prospects'                , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'TASKS'                         , 'TASKS'                         , 'Tasks'                    , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
GO

-- Relationship Tables
-- 04/04/2010 Paul.  Add ACCOUNTS_USERS, BUGS_USERS, CASES_USERS, LEADS_USERS, OPPORTUNITIES_USERS and PROJECT_USERS. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS_BUGS'                 , 'ACCOUNTS_BUGS'                 , 'Accounts'                 , 'Bugs'                     , 0, null, 0, 0, null, 1;
-- 12/19/2017 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
--exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS_CASES'                , 'ACCOUNTS_CASES'                , 'Accounts'                 , 'Cases'                    , 0, null, 0, 0, null, 1;
-- 04/24/2018 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'ACCOUNTS_CASES' and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set DELETED           =  1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'ACCOUNTS_CASES'
	   and DELETED           = 0;
end -- if;
GO

exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS_CONTACTS'             , 'ACCOUNTS_CONTACTS'             , 'Accounts'                 , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS_OPPORTUNITIES'        , 'ACCOUNTS_OPPORTUNITIES'        , 'Accounts'                 , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACCOUNTS_USERS'                , 'ACCOUNTS_USERS'                , 'Accounts'                 , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'BUGS_USERS'                    , 'BUGS_USERS'                    , 'Bugs'                     , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CALLS_CONTACTS'                , 'CALLS_CONTACTS'                , 'Calls'                    , 'Contacts'                 , 0, null, 0, 0, null, 1;
-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CALLS_LEADS'                   , 'CALLS_LEADS'                   , 'Calls'                    , 'Leads'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CALLS_USERS'                   , 'CALLS_USERS'                   , 'Calls'                    , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CAMPAIGN_TRKRS'                , 'CAMPAIGN_TRKRS'                , 'CampaignTrackers'         , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CASES_BUGS'                    , 'CASES_BUGS'                    , 'Cases'                    , 'Bugs'                     , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CASES_USERS'                   , 'CASES_USERS'                   , 'Cases'                    , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTACTS_BUGS'                 , 'CONTACTS_BUGS'                 , 'Contacts'                 , 'Bugs'                     , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTACTS_CASES'                , 'CONTACTS_CASES'                , 'Contacts'                 , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CONTACTS_USERS'                , 'CONTACTS_USERS'                , 'Contacts'                 , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENT_REVISIONS'            , 'DOCUMENT_REVISIONS'            , 'Documents'                , null                       , 0, null, 0, 0, null, 1;
-- 09/15/2012 Paul.  New tables for Accounts, Bugs, Cases, Contacts, Contracts, Leads, Opportunities, Quotes. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_ACCOUNTS'            , 'DOCUMENTS_ACCOUNTS'            , 'Documents'                , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_BUGS'                , 'DOCUMENTS_BUGS'                , 'Documents'                , 'Bugs'                     , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_CASES'               , 'DOCUMENTS_CASES'               , 'Documents'                , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_CONTACTS'            , 'DOCUMENTS_CONTACTS'            , 'Documents'                , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_LEADS'               , 'DOCUMENTS_LEADS'               , 'Documents'                , 'Leads'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'DOCUMENTS_OPPORTUNITIES'       , 'DOCUMENTS_OPPORTUNITIES'       , 'Documents'                , 'Opportunities'            , 0, null, 0, 0, null, 1;

-- 03/22/2011 Paul.  Treat EMAILS_IMAGES as part of the Images module (which does not really exist), and remove the relationship flag. 
-- This is in part to allow the logo image to be downloaded even if the Emails module has been disabled. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAIL_IMAGES'                  , 'EMAIL_IMAGES'                  , 'Images'                   , null                       , 0, null, 0, 0, null, 0;
if exists(select * from SYSTEM_SYNC_TABLES where TABLE_NAME = 'EMAIL_IMAGES' and (MODULE_NAME = 'Emails' or IS_RELATIONSHIP = 1) and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set MODULE_NAME       = 'Images'
	     , IS_RELATIONSHIP   = 0
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'EMAIL_IMAGES'
	   and (MODULE_NAME = 'Emails' or IS_RELATIONSHIP = 1)
	   and DELETED           = 0;
end -- if;

exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAIL_MARKETING'               , 'EMAIL_MARKETING'               , 'EmailMarketing'           , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAIL_MARKETING_PROSPECT_LISTS', 'EMAIL_MARKETING_PROSPECT_LISTS', 'EmailMarketing'           , 'ProspectLists'            , 0, null, 0, 0, null, 1;
-- 08/28/2012 Paul.  Add Call Marketing. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CALL_MARKETING'                , 'CALL_MARKETING'                , 'CallMarketing'            , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'CALL_MARKETING_PROSPECT_LISTS' , 'CALL_MARKETING_PROSPECT_LISTS' , 'CallMarketing'            , 'ProspectLists'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_ACCOUNTS'               , 'EMAILS_ACCOUNTS'               , 'Emails'                   , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_BUGS'                   , 'EMAILS_BUGS'                   , 'Emails'                   , 'Bugs'                     , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_CASES'                  , 'EMAILS_CASES'                  , 'Emails'                   , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_CONTACTS'               , 'EMAILS_CONTACTS'               , 'Emails'                   , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_LEADS'                  , 'EMAILS_LEADS'                  , 'Emails'                   , 'Leads'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_OPPORTUNITIES'          , 'EMAILS_OPPORTUNITIES'          , 'Emails'                   , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_PROJECT_TASKS'          , 'EMAILS_PROJECT_TASKS'          , 'Emails'                   , 'Tasks'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_PROJECTS'               , 'EMAILS_PROJECTS'               , 'Emails'                   , 'Project'                  , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_PROSPECTS'              , 'EMAILS_PROSPECTS'              , 'Emails'                   , 'Prospects'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_TASKS'                  , 'EMAILS_TASKS'                  , 'Emails'                   , 'Tasks'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'EMAILS_USERS'                  , 'EMAILS_USERS'                  , 'Emails'                   , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'LEADS_USERS'                   , 'LEADS_USERS'                   , 'Leads'                    , 'Users'                    , 0, null, 0, 0, null, 1;
-- 08/07/2015 Paul.  Add Leads/Contacts relationship. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'LEADS_CONTACTS'                , 'LEADS_CONTACTS'                , 'Leads'                    , 'Contacts'                 , 0, null, 0, 0, null, 1;
-- 08/08/2015 Paul.  Separate relationship for Leads/Opportunities. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'LEADS_OPPORTUNITIES'           , 'LEADS_OPPORTUNITIES'           , 'Leads'                    , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MEETINGS_CONTACTS'             , 'MEETINGS_CONTACTS'             , 'Meetings'                 , 'Contacts'                 , 0, null, 0, 0, null, 1;
-- 04/01/2012 Paul.  Add Meetings/Leads relationship. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MEETINGS_LEADS'                , 'MEETINGS_LEADS'                , 'Meetings'                 , 'Leads'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'MEETINGS_USERS'                , 'MEETINGS_USERS'                , 'Meetings'                 , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'NOTE_ATTACHMENTS'              , 'NOTE_ATTACHMENTS'              , 'Notes'                    , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'OPPORTUNITIES_CONTACTS'        , 'OPPORTUNITIES_CONTACTS'        , 'Opportunities'            , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'OPPORTUNITIES_USERS'           , 'OPPORTUNITIES_USERS'           , 'Opportunities'            , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECT_RELATION'              , 'PROJECT_RELATION'              , 'Project'                  , null                       , 0, null, 0, 0, null, 1;
-- 09/15/2012 Paul.  New tables for Accounts, Bugs, Cases, Contacts, Opportunities, ProjectTask, Threads, Quotes. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_ACCOUNTS'             , 'PROJECTS_ACCOUNTS'             , 'Project'                  , 'Accounts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_BUGS'                 , 'PROJECTS_BUGS'                 , 'Project'                  , 'Bugs'                     , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_CASES'                , 'PROJECTS_CASES'                , 'Project'                  , 'Cases'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_CONTACTS'             , 'PROJECTS_CONTACTS'             , 'Project'                  , 'Contacts'                 , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_OPPORTUNITIES'        , 'PROJECTS_OPPORTUNITIES'        , 'Project'                  , 'Opportunities'            , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECTS_PROJECT_TASKS'        , 'PROJECTS_PROJECT_TASKS'        , 'Project'                  , 'ProjectTask'              , 0, null, 0, 0, null, 1;

exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROJECT_USERS'                 , 'PROJECT_USERS'                 , 'Project'                  , 'Users'                    , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROSPECT_LIST_CAMPAIGNS'       , 'PROSPECT_LIST_CAMPAIGNS'       , 'ProspectLists'            , 'Campaigns'                , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'PROSPECT_LISTS_PROSPECTS'      , 'PROSPECT_LISTS_PROSPECTS'      , 'ProspectLists'            , null                       , 0, null, 0, 0, null, 1;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'USERS_FEEDS'                   , 'USERS_FEEDS'                   , 'Users'                    , 'Feeds'                    , 0, null, 0, 1, 'USER_ID', 1;
-- 09/15/2012 Paul.  Add UserSignatures. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'USERS_SIGNATURES'              , 'USERS_SIGNATURES'              , 'Users'                    , 'UserSignatures'           , 0, null, 0, 0, 'USER_ID', 1;


-- 08/23/2014 Paul.  ACLRoles and FieldValidators module names should be blank in order to sync. 
if exists(select * from SYSTEM_SYNC_TABLES where MODULE_NAME in ('ACLRoles', 'FieldValidators') and DELETED = 0) begin -- then
	update SYSTEM_SYNC_TABLES
	   set MODULE_NAME       = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       in ('ACLRoles', 'FieldValidators')
	   and DELETED           = 0;
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

call dbo.spSYSTEM_SYNC_TABLES_Default()
/

call dbo.spSqlDropProcedure('spSYSTEM_SYNC_TABLES_Default')
/

-- #endif IBM_DB2 */

