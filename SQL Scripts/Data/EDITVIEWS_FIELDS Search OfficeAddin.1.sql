

print 'EDITVIEWS_FIELDS Search SubPanel defaults';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.SearchSubpanel.OfficeAddin'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.SearchSubpanel.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.SearchSubpanel.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly             'Accounts.SearchSubpanel.OfficeAddin'     , 'Accounts', 'vwACCOUNTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Accounts.SearchSubpanel.OfficeAddin'     ,  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'NAME'                       , 0, null, 150, 35, 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Accounts.SearchSubpanel.OfficeAddin'     ,  1, 'Accounts.LBL_EMAIL'                     , 'EMAIL1'                     , 0, null, 100, 35, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.SearchSubpanel.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.SearchSubpanel.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly             'Bugs.SearchSubpanel.OfficeAddin'         , 'Bugs', 'vwBUGS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Bugs.SearchSubpanel.OfficeAddin'         ,  0, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 0, null, 255, 35, 'Bugs', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Bugs.SearchSubpanel.OfficeAddin'         ,  1, 'Bugs.LBL_STATUS'                        , 'STATUS'                     , 0, null, 'bug_status_dom'      , null, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.SearchSubpanel.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.SearchSubpanel.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly             'Cases.SearchSubpanel.OfficeAddin'        , 'Cases', 'vwCASES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Cases.SearchSubpanel.OfficeAddin'        ,  0, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 0, null, 255, 35, 'Cases', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Cases.SearchSubpanel.OfficeAddin'        ,  1, 'Cases.LBL_STATUS'                       , 'STATUS'                     , 0, null, 'case_status_dom'  , null, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.SearchSubpanel.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.SearchSubpanel.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly             'Contacts.SearchSubpanel.OfficeAddin'     , 'Contacts', 'vwCONTACTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contacts.SearchSubpanel.OfficeAddin'     ,  0, 'Contacts.LBL_NAME'                      , 'NAME'                       , 0, null, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contacts.SearchSubpanel.OfficeAddin'     ,  1, 'Contacts.LBL_EMAIL1'                    , 'EMAIL1'                     , 0, null, 100, 35, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.SearchSubpanel.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Leads.SearchSubpanel.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly             'Leads.SearchSubpanel.OfficeAddin'        , 'Leads', 'vwLEADS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchSubpanel.OfficeAddin'        ,  0, 'Contacts.LBL_NAME'                      , 'NAME'                       , 0, null, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Leads.SearchSubpanel.OfficeAddin'        ,  1, 'Contacts.LBL_EMAIL1'                    , 'EMAIL1'                     , 0, null, 100, 35, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.SearchSubpanel.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.SearchSubpanel.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly             'Opportunities.SearchSubpanel.OfficeAddin', 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Opportunities.SearchSubpanel.OfficeAddin',  0, 'Opportunities.LBL_OPPORTUNITY_NAME'     , 'NAME'                       , 0, null, 150, 35, 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Opportunities.SearchSubpanel.OfficeAddin',  1, 'Opportunities.LBL_SALES_STAGE'          , 'SALES_STAGE'                , 0, null, 'sales_stage_dom'     , null, 3;
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

call dbo.spEDITVIEWS_FIELDS_SearchOfficeAddin()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchOfficeAddin')
/

-- #endif IBM_DB2 */

