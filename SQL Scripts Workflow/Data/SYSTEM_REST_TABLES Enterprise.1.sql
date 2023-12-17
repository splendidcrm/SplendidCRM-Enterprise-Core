

print 'SYSTEM_REST_TABLES Enterprise';
-- delete from SYSTEM_REST_TABLES
--GO

set nocount on;
GO

-- 06/15/2017 Paul.  HTML5 My Dashboard views. 
-- 03/21/2020 Paul.  This is wrong.  vwPROCESSES_MyList access must be filtered through WF4ApprovalActivity.Filter(), so use separate ~/Processes/Rest.svc call. 
-- exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROCESSES_MyList'              , 'vwPROCESSES_MyList'              , 'Processes'                , null                       , 0, null, 0, 0, null, 0;
if exists(select * from vwSYSTEM_REST_TABLES where TABLE_NAME = 'vwPROCESSES_MyList') begin -- then
	print 'SYSTEM_REST_TABLES: delete vwPROCESSES_MyList';
	update SYSTEM_REST_TABLES
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROCESSES_MyList'
	   and DELETED           = 0;
end -- if;
GO

-- 03/11/2021 Paul.  All system tables will require registration. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'DATA_PRIVACY'                      , 'vwDATA_PRIVACY'                  , 'DataPrivacy'              , null                       , 0, null, 1, 0, null, 0, null;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_CONTACTS'           , 'vwDATA_PRIVACY_CONTACTS'         , 'DataPrivacy'              , 'Contacts'                 , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_LEADS'              , 'vwDATA_PRIVACY_LEADS'            , 'DataPrivacy'              , 'Leads'                    , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_PROSPECTS'          , 'vwDATA_PRIVACY_PROSPECTS'        , 'DataPrivacy'              , 'Prospects'                , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_ACCOUNTS'           , 'vwDATA_PRIVACY_ACCOUNTS'         , 'DataPrivacy'              , 'Accounts'                 , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_CONTACTS_ARCHIVE'   , 'vwDATA_PRIVACY_CONTACTS_ARCHIVE' , 'DataPrivacy'              , 'Contacts'                 , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_LEADS_ARCHIVE'      , 'vwDATA_PRIVACY_LEADS_ARCHIVE'    , 'DataPrivacy'              , 'Leads'                    , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_PROSPECTS_ARCHIVE'  , 'vwDATA_PRIVACY_PROSPECTS_ARCHIVE', 'DataPrivacy'              , 'Prospects'                , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwDATA_PRIVACY_ACCOUNTS_ARCHIVE'   , 'vwDATA_PRIVACY_ACCOUNTS_ARCHIVE' , 'DataPrivacy'              , 'Accounts'                 , 0, null, 1, 0, null, 1, 'DATA_PRIVACY_ID';
-- 04/14/2021 Paul.  Missing tables required by React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwACCOUNTS_DATA_PRIVACY'           , 'vwACCOUNTS_DATA_PRIVACY'         , 'Accounts'                 , 'DataPrivacy'              , 0, null, 1, 0, null, 1, 'ACCOUNT_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwCONTACTS_DATA_PRIVACY'           , 'vwCONTACTS_DATA_PRIVACY'         , 'Contacts'                 , 'DataPrivacy'              , 0, null, 1, 0, null, 1, 'CONTACT_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwLEADS_DATA_PRIVACY'              , 'vwLEADS_DATA_PRIVACY'            , 'Leads'                    , 'DataPrivacy'              , 0, null, 1, 0, null, 1, 'LEAD_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROSPECTS_DATA_PRIVACY'          , 'vwPROSPECTS_DATA_PRIVACY'        , 'Prospects'                , 'DataPrivacy'              , 0, null, 1, 0, null, 1, 'PROSPECT_ID';
-- 06/01/2021 Paul.  We need a second query to get the dynamic list info. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROSPECT_LISTS_EditSQL'          , 'vwPROSPECT_LISTS_EditSQL'        , 'ProspectLists'            , null                       , 0, null, 0, 1, 'ASSIGNED_USER_ID', 0;
-- 06/02/2021 Paul.  Workflow procedures. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spWORKFLOWS_Enable'                , 'spWORKFLOWS_Enable'              , 'Workflows'                , null                       , 0, null, 1, 0, null, 0, 'ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spWORKFLOWS_Disable'               , 'spWORKFLOWS_Disable'             , 'Workflows'                , null                       , 0, null, 1, 0, null, 0, 'ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spWORKFLOWS_ORDER_MoveItem'        , 'spWORKFLOWS_ORDER_MoveItem'      , 'Workflows'                , null                       , 0, null, 1, 0, null, 0, 'BASE_MODULE';
-- 07/16/2023 Paul.  Also duplicte Field Level Security settings. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'spACL_FIELDS_Duplicate'            , 'spACL_FIELDS_Duplicate'          , 'ACLRoles'                 , null                       , 0, null, 1, 0, null, 0, 'ID DUPLICATE_ID';

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

call dbo.spSYSTEM_REST_TABLES_Enterprise()
/

call dbo.spSqlDropProcedure('spSYSTEM_REST_TABLES_Enterprise')
/

-- #endif IBM_DB2 */

