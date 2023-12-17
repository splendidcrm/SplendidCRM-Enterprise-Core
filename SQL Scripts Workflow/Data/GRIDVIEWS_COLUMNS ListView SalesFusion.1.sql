

print 'GRIDVIEWS_COLUMNS ListView Cloud Services';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.SalesFusion'
--GO

set nocount on;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.SalesFusion';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.SalesFusion' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.ListView.SalesFusion';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.ListView.SalesFusion', 'Accounts', 'vwACCOUNTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.SalesFusion'     ,  2, 'SalesFusion.LBL_ACCOUNT_ID'               , 'account_id'               , 'account_id'               , '5%' , 'listViewTdLinkS1', 'account_id', 'view.aspx?account_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.SalesFusion'     ,  3, 'SalesFusion.LBL_ACCOUNT_NAME'             , 'account_name'             , 'account_name'             , '25%', 'listViewTdLinkS1', 'account_id', 'view.aspx?account_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.ListView.SalesFusion'     ,  4, '.LBL_LIST_DATE_ENTERED'                   , 'created_date'             , 'created_date'             , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.SalesFusion'     ,  5, 'SalesFusion.LBL_BILLING_CITY'             , 'billing_city'             , 'billing_city'             , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.SalesFusion'     ,  6, 'SalesFusion.LBL_PHONE'                    , 'phone'                    , 'phone'                    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.ListView.SalesFusion'     ,  7, 'SalesFusion.LBL_SALESFUSION_LAST_ACTIVITY', 'salesfusion_last_activity', 'salesfusion_last_activity', '15%', 'DateTime';
end -- if;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.SalesFusion';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.SalesFusion' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.SalesFusion';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.SalesFusion', 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.SalesFusion'     ,    2, 'SalesFusion.LBL_CONTACT_ID'             , 'contact_id'               , 'contact_id'               , '5%' , 'listViewTdLinkS1', 'contact_id'   , 'view.aspx?contact_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.SalesFusion'     ,    3, 'SalesFusion.LBL_FIRST_NAME'             , 'first_name'               , 'first_name'               , '10%', 'listViewTdLinkS1', 'contact_id'   , 'view.aspx?contact_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.SalesFusion'     ,    4, 'SalesFusion.LBL_LAST_NAME'              , 'last_name'                , 'last_name'                , '10%', 'listViewTdLinkS1', 'contact_id'   , 'view.aspx?contact_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.SalesFusion'     ,    5, 'SalesFusion.LBL_PHONE'                  , 'phone'                    , 'phone'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.SalesFusion'     ,    6, 'SalesFusion.LBL_EMAIL'                  , 'email'                    , 'email'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.SalesFusion'     ,    7, 'SalesFusion.LBL_ACCOUNT_NAME'           , 'account_name'             , 'account_name'             , '10%', 'listViewTdLinkS1', 'account_id'   , '../../Accounts/SalesFusion/view.aspx?account_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.SalesFusion'     ,    8, 'SalesFusion.LBL_OWNER_NAME'             , 'owner_name'               , 'owner_name'               , '10%', 'listViewTdLinkS1', 'owner_id'     , '../../Users/SalesFusion/view.aspx?owner_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.SalesFusion'     ,    9, '.LBL_LIST_DATE_ENTERED'                 , 'created_date'             , 'created_date'             , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.SalesFusion'     ,   10, 'SalesFusion.LBL_CUSTOM_SCORE_FIELD'     , 'custom_score_field'       , 'custom_score_field'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.SalesFusion'     ,   11, 'SalesFusion.LBL_LAST_ACTIVITY_DATE'     , 'last_activity_date'       , 'last_activity_date'       , '10%', 'DateTime';
end -- if;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.SalesFusion';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.SalesFusion' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.ListView.SalesFusion';
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.ListView.SalesFusion', 'Leads', 'vwLEADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.SalesFusion'        ,    2, 'SalesFusion.LBL_CONTACT_ID'             , 'contact_id'               , 'contact_id'               , '5%' , 'listViewTdLinkS1', 'contact_id'   , 'view.aspx?contact_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.SalesFusion'        ,    3, 'SalesFusion.LBL_FIRST_NAME'             , 'first_name'               , 'first_name'               , '10%', 'listViewTdLinkS1', 'contact_id'   , 'view.aspx?contact_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.SalesFusion'        ,    4, 'SalesFusion.LBL_LAST_NAME'              , 'last_name'                , 'last_name'                , '10%', 'listViewTdLinkS1', 'contact_id'   , 'view.aspx?contact_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.SalesFusion'        ,    5, 'SalesFusion.LBL_PHONE'                  , 'phone'                    , 'phone'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.SalesFusion'        ,    6, 'SalesFusion.LBL_EMAIL'                  , 'email'                    , 'email'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.SalesFusion'        ,    7, 'SalesFusion.LBL_ACCOUNT_NAME'           , 'account_name'             , 'account_name'             , '10%', 'listViewTdLinkS1', 'account_id'   , '../../Accounts/SalesFusion/view.aspx?account_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.SalesFusion'        ,    8, 'SalesFusion.LBL_OWNER_NAME'             , 'owner_name'               , 'owner_name'               , '10%', 'listViewTdLinkS1', 'owner_id'     , '../../Users/SalesFusion/view.aspx?owner_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Leads.ListView.SalesFusion'        ,    9, '.LBL_LIST_DATE_ENTERED'                 , 'created_date'             , 'created_date'             , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.SalesFusion'        ,   10, 'SalesFusion.LBL_CUSTOM_SCORE_FIELD'     , 'custom_score_field'       , 'custom_score_field'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Leads.ListView.SalesFusion'        ,   11, 'SalesFusion.LBL_LAST_ACTIVITY_DATE'     , 'last_activity_date'       , 'last_activity_date'       , '10%', 'DateTime';
end -- if;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView.SalesFusion';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView.SalesFusion' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.ListView.SalesFusion';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.ListView.SalesFusion', 'Opportunities', 'vwOPPORTUNITIES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.SalesFusion',  1, 'SalesFusion.LBL_OPPORTUNITY_ID'           , 'opportunity_id'           , 'opportunity_id'           , '4%' , 'listViewTdLinkS1', 'opportunity_id', 'view.aspx?opportunity_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.SalesFusion',  2, 'SalesFusion.LBL_NAME'                     , 'name'                     , 'name'                     , '10%', 'listViewTdLinkS1', 'opportunity_id', 'view.aspx?opportunity_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.SalesFusion',  3, 'SalesFusion.LBL_STAGE'                    , 'stage'                    , 'stage'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.SalesFusion',  4, 'SalesFusion.LBL_LEAD_SOURCE'              , 'lead_source'              , 'lead_source'              , '5%' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.SalesFusion',  5, 'SalesFusion.LBL_PRODUCT_NAME'             , 'product_name'             , 'product_name'             , '5%' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.SalesFusion',  6, 'SalesFusion.LBL_OWNER_NAME'               , 'owner_name'               , 'owner_name'               , '5%' , 'listViewTdLinkS1', 'owner_id'      , '../../Users/SalesFusion/view.aspx?owner_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.SalesFusion',  7, 'SalesFusion.LBL_AMOUNT'                   , 'amount'                   , 'amount'                   , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.SalesFusion',  8, 'SalesFusion.LBL_CLOSING_DATE'             , 'closing_date'             , 'closing_date'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.SalesFusion',  9, 'SalesFusion.LBL_PROBABILITY'              , 'probability'              , 'probability'              , '5%' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.SalesFusion', 10, '.LBL_LIST_DATE_MODIFIED'                  , 'updated_date'             , 'updated_date'             , '10%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.SalesFusion',  4, 'SalesFusion.LBL_ACCOUNT'                  , 'account'                  , 'account'                  , '10%', 'listViewTdLinkS1', 'account_id'   , '../../Accounts/SalesFusion/view.aspx?account_id={0}', null, null, null;
end -- if;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.ListView.SalesFusion';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProspectLists.ListView.SalesFusion' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProspectLists.ListView.SalesFusion';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProspectLists.ListView.SalesFusion', 'ProspectLists', 'vwPROSPECT_LISTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProspectLists.ListView.SalesFusion',  2, 'SalesFusion.LBL_LIST_ID'                  , 'list_id'                  , 'list_id'                  , '4%' , 'listViewTdLinkS1', 'list_id', 'view.aspx?list_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProspectLists.ListView.SalesFusion',  3, 'SalesFusion.LBL_LIST_NAME'                , 'list_name'                , 'list_name'                , '20%', 'listViewTdLinkS1', 'list_id', 'view.aspx?list_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.ListView.SalesFusion',  4, 'SalesFusion.LBL_DESCRIPTION'              , 'description'              , 'description'              , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProspectLists.ListView.SalesFusion',  5, 'SalesFusion.LBL_LIST_TYPE'                , 'list_type'                , 'list_type'                , '5%' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProspectLists.ListView.SalesFusion',  6, '.LBL_LIST_DATE_MODIFIED'                  , 'updated_date'             , 'updated_date'             , '10%', 'DateTime';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProspectLists.ListView.SalesFusion',  7, 'SalesFusion.LBL_UPDATED_BY'               , 'updated_by'               , 'updated_by'               , '5%' , 'listViewTdLinkS1', 'updated_by_id'      , '../../Users/SalesFusion/view.aspx?updated_by_id={0}', null, null, null;
end -- if;
GO


-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.ListView.SalesFusion';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.ListView.SalesFusion' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Users.ListView.SalesFusion';
	exec dbo.spGRIDVIEWS_InsertOnly           'Users.ListView.SalesFusion', 'Users', 'vwUSERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.ListView.SalesFusion'        ,  0, 'SalesFusion.LBL_USER_ID'                  , 'user_id'                  , 'user_id'                  , '4%' , 'listViewTdLinkS1', 'user_id', 'view.aspx?user_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.ListView.SalesFusion'        ,  1, 'SalesFusion.LBL_USER_NAME'                , 'user_name'                , 'user_name'                , '20%', 'listViewTdLinkS1', 'user_id', 'view.aspx?user_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.ListView.SalesFusion'        ,  2, 'SalesFusion.LBL_LAST_NAME'                , 'last_name'                , 'last_name'                , '20%', 'listViewTdLinkS1', 'user_id', 'view.aspx?user_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.ListView.SalesFusion'        ,  3, 'SalesFusion.LBL_FIRST_NAME'               , 'first_name'               , 'first_name'               , '20%', 'listViewTdLinkS1', 'user_id', 'view.aspx?user_id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Users.ListView.SalesFusion'        ,  4, 'SalesFusion.LBL_EMAIL'                    , 'email'                    , 'email'                    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Users.ListView.SalesFusion'        ,  5, 'SalesFusion.LBL_STATUS'                   , 'status'                   , 'status'                   , '15%';

--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',    7, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',    8, 'SalesFusion.LBL_ZIP'                          , 'zip'                          , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',    9, 'SalesFusion.LBL_STATE'                        , 'state'                        , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   10, 'SalesFusion.LBL_SALUTATION'                   , 'salutation'                   , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   11, 'SalesFusion.LBL_MOBILE'                       , 'mobile'                       , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   12, 'SalesFusion.LBL_COUNTRY'                      , 'country'                      , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   13, 'SalesFusion.LBL_FACE_BOOK'                    , 'face_book'                    , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   14, 'SalesFusion.LBL_PORTAL_PASSWORD'              , 'portal_password'              , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   15, 'SalesFusion.LBL_LINKED_IN'                    , 'linked_in'                    , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   16, 'SalesFusion.LBL_ADDRESS1'                     , 'address1'                     , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   17, 'SalesFusion.LBL_PHONE'                        , 'phone'                        , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   18, 'SalesFusion.LBL_ADDRESS2'                     , 'address2'                     , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   19, 'SalesFusion.LBL_CITY'                         , 'city'                         , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   20, 'SalesFusion.LBL_COMPANY_WEBSITE'              , 'company_website'              , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   21, 'SalesFusion.LBL_PROFILE_PICTURE'              , 'profile_picture'              , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   22, 'SalesFusion.LBL_TWITTER'                      , 'twitter'                      , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   23, 'SalesFusion.LBL_PHONE_EXTENSION'              , 'phone_extension'              , '{0}', null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound      'Users.DetailView.SalesFusion',   24, 'SalesFusion.LBL_JOB_TITLE'                    , 'job_title'                    , '{0}', null;
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

call dbo.spGRIDVIEWS_COLUMNS_ListView_SalesFusion()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListView_SalesFusion')
/

-- #endif IBM_DB2 */

