

print 'EDITVIEWS_FIELDS Pardot';

set nocount on;
GO

-- 07/16/2017 Paul.  Add Pardot layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Prospects.EditView.Pardot';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Prospects.EditView.Pardot' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Prospects.EditView.Pardot';
	exec dbo.spEditViewS_InsertOnly           'Prospects.EditView.Pardot', 'Prospects', 'vwPROSPECTS_Pardot', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_EMAIL'                       , 'email'                       , 1, 1, 100,  60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_FIRST_NAME'                  , 'first_name'                  , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_LAST_NAME'                   , 'last_name'                   , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_PHONE'                       , 'phone'                       , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_FAX'                         , 'fax'                         , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_COMPANY'                     , 'company'                     , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_JOB_TITLE'                   , 'job_title'                   , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_DEPARTMENT'                  , 'department'                  , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_WEBSITE'                     , 'website'                     , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl    'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_IS_DO_NOT_EMAIL'             , 'is_do_not_email'             , 0, 1, 'CheckBox', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl    'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_IS_DO_NOT_CALL'              , 'is_do_not_call'              , 0, 1, 'CheckBox', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator  'Prospects.EditView.Pardot'    ,  -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_ADDRESS_ONE'                 , 'address_one'                 , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_ADDRESS_TWO'                 , 'address_two'                 , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_CITY'                        , 'city'                        , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_STATE'                       , 'state'                       , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_ZIP'                         , 'zip'                         , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_COUNTRY'                     , 'country'                     , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_NOTES'                       , 'notes'                       , 0, 5,   4, 120, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator  'Prospects.EditView.Pardot'    ,  -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_SOURCE'                      , 'source'                      , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_INDUSTRY'                    , 'industry'                    , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Prospects.EditView.Pardot'    ,  -1, 'Pardot.LBL_SCORE'                       , 'score'                       , 0, 1,  10,  10, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.Pardot';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.Pardot' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.EditView.Pardot';
	exec dbo.spEDITVIEWS_InsertOnly           'Accounts.EditView.Pardot', 'Accounts', 'vwACCOUNTS_Pardot', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_NAME'                        , 'name'                        , 1, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_NUMBER'                      , 'number'                      , 0, 1,  10,  10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_PHONE'                       , 'phone'                       , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_FAX'                         , 'fax'                         , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_RATING'                      , 'rating'                      , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SITE'                        , 'site'                        , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_TYPE'                        , 'type'                        , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_ANNUAL_REVENUE'              , 'annual_revenue'              , 0, 1,  10,  10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_INDUSTRY'                    , 'industry'                    , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SIC'                         , 'sic'                         , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_EMPLOYEES'                   , 'employees'                   , 0, 1,  10,  10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_OWNERSHIP'                   , 'ownership'                   , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_TICKER_SYMBOL'               , 'ticker_symbol'               , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank      'Accounts.EditView.Pardot'     ,  -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine  'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_DESCRIPTION'                 , 'description'                 , 0, 5,   4, 120, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator  'Accounts.EditView.Pardot'     ,  -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_ADDRESS_ONE'         , 'billing_address_one'         , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_ADDRESS_ONE'        , 'shipping_address_one'        , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_ADDRESS_TWO'         , 'billing_address_two'         , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_ADDRESS_TWO'        , 'shipping_address_two'        , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_CITY'                , 'billing_city'                , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_CITY'               , 'shipping_city'               , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_STATE'               , 'billing_state'               , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_STATE'              , 'shipping_state'              , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_ZIP'                 , 'billing_zip'                 , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_ZIP'                , 'shipping_zip'                , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_COUNTRY'             , 'billing_country'             , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Accounts.EditView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_COUNTRY'            , 'shipping_country'            , 0, 1, 100,  35, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Campaigns.EditView.Pardot';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Campaigns.EditView.Pardot' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Campaigns.EditView.Pardot';
	exec dbo.spEDITVIEWS_InsertOnly           'Campaigns.EditView.Pardot', 'Campaigns', 'vwCAMPAIGNS_Pardot', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Campaigns.EditView.Pardot'    ,  -1, 'Pardot.LBL_NAME'                        , 'name'                        , 1, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Campaigns.EditView.Pardot'    ,  -1, 'Pardot.LBL_COST'                        , 'cost'                        , 0, 1, 100,  35, null;
end -- if;
GO

-- http://help.pardot.com/customer/portal/articles/2125942-importing-opportunities
-- At the minimum, you must map the opportunity Name, Amount, Probability, Closed, Won, Email, and an External or Internal Identifier.
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView.Pardot';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView.Pardot' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.EditView.Pardot';
	exec dbo.spEDITVIEWS_InsertOnly           'Opportunities.EditView.Pardot', 'Opportunities', 'vwOPPORTUNITIES_Pardot', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_NAME'                        , 'name'                        , 1, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_VALUE'                       , 'value'                       , 1, 1,  10,  10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList  'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_CAMPAIGN_NAME'               , 'campaign_id'                 , 1, 1, 'pardot_campaign_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_PROBABILITY'                 , 'probability'                 , 1, 1,  10,  10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList  'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_TYPE'                        , 'type'                        , 0, 1, 'pardot_type_dom'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList  'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_STAGE'                       , 'stage'                       , 0, 1, 'pardot_stage_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList  'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_STATUS'                      , 'status'                      , 0, 1, 'pardot_status_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl    'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_CLOSED_AT'                   , 'closed_at'                   , 0, 1, 'DatePicker'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox   'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_IS_CLOSED'                   , 'is_closed'                   , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox   'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_IS_WON'                      , 'is_won'                      , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_EMAIL'                       , 'email'                       , 1, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Opportunities.EditView.Pardot',  -1, 'Pardot.LBL_EXTERNAL_ID'                 , 'crm_opportunity_fid'         , 0, 1, 100,  35, null;
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

call dbo.spEDITVIEWS_FIELDS_Pardot()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Pardot')
/

-- #endif IBM_DB2 */


