

print 'DETAILVIEWS_FIELDS Preview Professional';
--delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.Preview'
--GO

set nocount on;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contracts.DetailView.Preview';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contracts.DetailView.Preview', 'Contracts', 'vwCONTRACTS_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  0, 'Contracts.LBL_NAME'                , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  1, 'Contracts.LBL_TYPE'                , 'TYPE'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  2, 'Contracts.LBL_START_DATE'          , 'START_DATE'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  3, 'Contracts.LBL_END_DATE'            , 'END_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView.Preview',  4, 'Contracts.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'          , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView.Preview',  5, 'Contracts.LBL_OPPORTUNITY_NAME'    , 'OPPORTUNITY_NAME'                 , '{0}'        , 'OPPORTUNITY_ID'      , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contracts.DetailView.Preview',  6, 'Contracts.LBL_STATUS'              , 'STATUS'                           , '{0}'        , 'contract_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  7, 'Contracts.LBL_CONTRACT_VALUE'      , 'TOTAL_CONTRACT_VALUE'             , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  8, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Preview',  9, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contracts.DetailView.Preview', 10, 'TextBox', 'Contracts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBDocuments.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS KBDocuments.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'KBDocuments.DetailView.Preview', 'KBDocuments', 'vwKBDOCUMENTS_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView.Preview',  0, 'KBDocuments.LBL_NAME'             , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'KBDocuments.DetailView.Preview',  1, 'KBDocuments.LBL_STATUS'           , 'STATUS'                           , '{0}'        , 'kbdocument_status_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView.Preview',  2, 'KBDocuments.LBL_ACTIVE_DATE'      , 'ACTIVE_DATE'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView.Preview',  3, 'KBDocuments.LBL_EXP_DATE'         , 'EXP_DATE'                         , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView.Preview',  4, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'KBDocuments.DetailView.Preview',  5, 'TextBox', 'KBDocuments.LBL_DESCRIPTION', 'DESCRIPTION', '10,90', null, null, null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.Preview';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.Preview', 'Quotes', 'vwQUOTES_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  0, 'Quotes.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  1, 'Quotes.LBL_QUOTE_NUM'             , 'QUOTE_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Preview'   ,  2, 'Quotes.LBL_QUOTE_STAGE'           , 'QUOTE_STAGE'                       , '{0}'        , 'quote_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  3, 'Quotes.LBL_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  4, 'Quotes.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Preview'   ,  5, 'Quotes.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Preview'   ,  6, 'Quotes.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  7, 'Quotes.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Preview'   ,  9, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Quotes.DetailView.Preview'   , 10, 'TextBox', 'Quotes.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView.Preview';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView.Preview', 'Orders', 'vwORDERS_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  0, 'Orders.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  1, 'Orders.LBL_ORDER_NUM'             , 'ORDER_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Preview'   ,  2, 'Orders.LBL_ORDER_STAGE'           , 'ORDER_STAGE'                       , '{0}'        , 'order_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  3, 'Orders.LBL_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'                    , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  4, 'Orders.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Preview'   ,  5, 'Orders.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Preview'   ,  6, 'Orders.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  7, 'Orders.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Preview'   ,  9, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Orders.DetailView.Preview'   , 10, 'TextBox', 'Orders.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.Preview';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.Preview', 'Invoices', 'vwINVOICES_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Preview' ,  0, 'Invoices.LBL_NAME'                 , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Preview' ,  1, 'Invoices.LBL_INVOICE_NUM'          , 'INVOICE_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Preview' ,  2, 'Invoices.LBL_INVOICE_STAGE'        , 'INVOICE_STAGE'                     , '{0}'        , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Preview' ,  3, 'Invoices.LBL_DUE_DATE'             , 'DUE_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Preview' ,  4, 'Invoices.LBL_OPPORTUNITY_NAME'     , 'OPPORTUNITY_NAME'                  , '{0}'        , 'OPPORTUNITY_ID' , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Preview' ,  5, 'Invoices.LBL_BILLING_CONTACT_NAME' , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Preview' ,  6, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Preview' ,  7, 'Invoices.LBL_BILLING_ADDRESS'      , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Preview' ,  8, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Preview' ,  9, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Invoices.DetailView.Preview' , 10, 'TextBox', 'Invoices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Surveys.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Surveys.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Surveys.DetailView.Preview', 'Surveys', 'vwSURVEYS_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView.Preview'  ,  0, 'Surveys.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView.Preview'  ,  1, 'Surveys.LBL_STATUS'                , 'STATUS'                            , '{0}'        , 'survey_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView.Preview'  ,  2, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView.Preview'  ,  3, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView.Preview'  ,  4, 'Surveys.LBL_DESCRIPTION'           , 'DESCRIPTION'                       , '{0}'        , null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TwitterTracks.DetailView.Preview' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TwitterTracks.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'TwitterTracks.DetailView.Preview', 'TwitterTracks', 'vwTWITTER_TRACKS_Edit', '35%', '65%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView.Preview',  0, 'TwitterTracks.LBL_NAME'        , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'TwitterTracks.DetailView.Preview',  1, 'TwitterTracks.LBL_TYPE'        , 'TYPE'                              , '{0}'        , 'twitter_track_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'TwitterTracks.DetailView.Preview',  2, 'TwitterTracks.LBL_STATUS'      , 'STATUS'                            , '{0}'        , 'twitter_track_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView.Preview',  3, 'Teams.LBL_TEAM'                , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView.Preview',  5, '.LBL_ASSIGNED_TO'              , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
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

call dbo.spDETAILVIEWS_FIELDS_PreviewPro()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_PreviewPro')
/

-- #endif IBM_DB2 */

