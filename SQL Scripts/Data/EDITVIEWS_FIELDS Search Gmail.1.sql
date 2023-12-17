

print 'EDITVIEWS_FIELDS Search Gmail';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.Search%.Gmail'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Accounts.SearchBasic.Gmail'    , 'Accounts', 'vwACCOUNTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Accounts.SearchBasic.Gmail'    ,  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'NAME'                       , 0, null, 150, 25, 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Accounts.SearchBasic.Gmail'    ,  1, 'Accounts.LBL_BILLING_ADDRESS_CITY'      , 'BILLING_ADDRESS_CITY'       , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Accounts.SearchBasic.Gmail'    ,  2, 'Accounts.LBL_ANY_PHONE'                 , 'PHONE_OFFICE'               , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Accounts.SearchBasic.Gmail'    ,  3, 'Accounts.LBL_BILLING_ADDRESS_STREET'    , 'BILLING_ADDRESS_STREET'     , 0, null, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Accounts.SearchBasic.Gmail'    ,  4, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Accounts.SearchPopup.Gmail'    , 'Accounts', 'vwACCOUNTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Accounts.SearchPopup.Gmail'    ,  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'NAME'                       , 0, null, 150, 25, 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Accounts.SearchPopup.Gmail'    ,  1, 'Accounts.LBL_BILLING_ADDRESS_CITY'      , 'BILLING_ADDRESS_CITY'       , 0, null, 100, 25, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Bugs.SearchBasic.Gmail'        , 'Bugs', 'vwBUGS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Bugs.SearchBasic.Gmail'        ,  0, 'Bugs.LBL_BUG_NUMBER'                    , 'BUG_NUMBER'                 , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Bugs.SearchBasic.Gmail'        ,  1, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 0, null, 150, 25, 'Bugs', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Bugs.SearchBasic.Gmail'        ,  2, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Bugs.SearchPopup.Gmail'        , 'Bugs', 'vwBUGS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Bugs.SearchPopup.Gmail'        ,  0, 'Bugs.LBL_BUG_NUMBER'                    , 'BUG_NUMBER'                 , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Bugs.SearchPopup.Gmail'        ,  1, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 0, null, 150, 25, 'Bugs', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Cases.SearchBasic.Gmail'       , 'Cases', 'vwCASES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Cases.SearchBasic.Gmail'       ,  0, 'Cases.LBL_CASE_NUMBER'                  , 'CASE_NUMBER'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Cases.SearchBasic.Gmail'       ,  1, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 0, null,  50, 25, 'Cases', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Cases.SearchBasic.Gmail'       ,  2, 'Cases.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Cases.SearchBasic.Gmail'       ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Cases.SearchPopup.Gmail'       , 'Cases', 'vwCASES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Cases.SearchPopup.Gmail'       ,  0, 'Cases.LBL_CASE_NUMBER'                  , 'CASE_NUMBER'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Cases.SearchPopup.Gmail'       ,  1, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 0, null,  50, 25, 'Cases'   , null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Cases.SearchPopup.Gmail'       ,  2, 'Cases.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.SearchBasic.Gmail';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Contacts.SearchBasic.Gmail'    , 'Contacts', 'vwCONTACTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contacts.SearchBasic.Gmail'    ,  0, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contacts.SearchBasic.Gmail'    ,  1, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 0, null,  25, 25, 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Contacts.SearchBasic.Gmail'    ,  2, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contacts.SearchBasic.Gmail'    ,  3, 'Contacts.LBL_ANY_EMAIL'                 , 'EMAIL1 EMAIL2'              , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contacts.SearchBasic.Gmail'    ,  4, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Contacts.SearchPopup.Gmail'    , 'Contacts', 'vwCONTACTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contacts.SearchPopup.Gmail'    ,  0, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contacts.SearchPopup.Gmail'    ,  1, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contacts.SearchPopup.Gmail'    ,  2, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.SearchBasic.Gmail';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.SearchBasic.Gmail'   and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Leads.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Leads.SearchBasic.Gmail'       , 'Leads', 'vwLeads_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchBasic.Gmail'       ,  0, 'Leads.LBL_FIRST_NAME'                   , 'FIRST_NAME'                 , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchBasic.Gmail'       ,  1, 'Leads.LBL_LAST_NAME'                    , 'LAST_NAME'                  , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Leads.SearchBasic.Gmail'       ,  2, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchBasic.Gmail'       ,  3, 'Contacts.LBL_ANY_EMAIL'                 , 'EMAIL1 EMAIL2'              , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Leads.SearchBasic.Gmail'       ,  4, 'Leads.LBL_LEAD_SOURCE'                  , 'LEAD_SOURCE'                , 0, null, 'lead_source_dom', null, 6;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.SearchPopup.Gmail'   and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Leads.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Leads.SearchPopup.Gmail'       , 'Leads', 'vwLeads_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchPopup.Gmail'       ,  0, 'Leads.LBL_FIRST_NAME'                   , 'FIRST_NAME'                 , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchPopup.Gmail'       ,  1, 'Leads.LBL_LAST_NAME'                    , 'LAST_NAME'                  , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Leads.SearchPopup.Gmail'       ,  3, 'Leads.LBL_LEAD_SOURCE'                  , 'LEAD_SOURCE'                , 0, null, 'lead_source_dom', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Leads.SearchPopup.Gmail'       ,  4, 'Leads.LBL_STATUS'                       , 'STATUS'                     , 0, null, 'lead_status_dom', null, 6;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Opportunities.SearchBasic.Gmail', 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Opportunities.SearchBasic.Gmail',  0, 'Opportunities.LBL_OPPORTUNITY_NAME'    , 'NAME'                       , 0, null, 150, 25, 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Opportunities.SearchBasic.Gmail',  1, 'Opportunities.LBL_TYPE'                , 'OPPORTUNITY_TYPE'           , 0, null, 'opportunity_type_dom', null, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Opportunities.SearchBasic.Gmail',  2, '.LBL_CURRENT_USER_FILTER'              , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Opportunities.SearchPopup.Gmail', 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Opportunities.SearchPopup.Gmail',  0, 'Opportunities.LBL_OPPORTUNITY_NAME'    , 'NAME'                       , 0, null, 150, 25, 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Opportunities.SearchPopup.Gmail',  1, 'Opportunities.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts'     , null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Project.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Project.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Project.SearchBasic.Gmail'     , 'Project', 'vwPROJECTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Project.SearchBasic.Gmail'     ,  0, 'Project.LBL_NAME'                       , 'NAME'                       , 0, null, 100, 25, 'Project', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Project.SearchBasic.Gmail'     ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Project.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Project.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'Project.SearchPopup.Gmail'     , 'Project', 'vwPROJECTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Project.SearchPopup.Gmail'     ,  0, 'Project.LBL_NAME'                       , 'NAME'                       , 0, null, 100, 25, 'Project', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Project.SearchPopup.Gmail'     ,  1, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProjectTask.SearchBasic.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProjectTask.SearchBasic.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'ProjectTask.SearchBasic.Gmail' , 'ProjectTask', 'vwPROJECT_TASKS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProjectTask.SearchBasic.Gmail' ,  0, 'ProjectTask.LBL_NAME'                   , 'NAME'                       , 0, null, 100, 25, 'ProjectTask', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'ProjectTask.SearchBasic.Gmail' ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProjectTask.SearchPopup.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProjectTask.SearchPopup.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly             'ProjectTask.SearchPopup.Gmail' , 'ProjectTask', 'vwPROJECT_TASKS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProjectTask.SearchPopup.Gmail' ,  0, 'ProjectTask.LBL_NAME'                   , 'NAME'                       , 0, null, 100, 25, 'ProjectTask', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ProjectTask.SearchPopup.Gmail' ,  1, null;
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

call dbo.spEDITVIEWS_FIELDS_SearchGmail()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchGmail')
/

-- #endif IBM_DB2 */

