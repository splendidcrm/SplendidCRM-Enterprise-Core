

print 'EDITVIEWS_FIELDS MassUpdate Professional';
--delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.MassUpdate'
--GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Contracts.MassUpdate'    , 'Contracts', 'vwContracts_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.MassUpdate'    ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.MassUpdate'    ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.MassUpdate'    ,  2, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.MassUpdate'    ,  3, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 0, null, 'contract_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.MassUpdate'    ,  4, 'Contracts.LBL_START_DATE'               , 'START_DATE'                 , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.MassUpdate'    ,  5, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                   , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.MassUpdate'    ,  6, 'Contracts.LBL_CUSTOMER_SIGNED_DATE'     , 'CUSTOMER_SIGNED_DATE'       , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.MassUpdate'    ,  7, 'Contracts.LBL_COMPANY_SIGNED_DATE'      , 'COMPANY_SIGNED_DATE'        , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Contracts.MassUpdate'    ,  8, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contracts.MassUpdate'    ,  9, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Products.MassUpdate'     , 'Products', 'vwPRODUCTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.MassUpdate'     ,  0, 'Products.LBL_DATE_PURCHASED'            , 'DATE_PURCHASED'             , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MassUpdate'     ,  1, 'Products.LBL_STATUS'                    , 'STATUS'                     , 0, null, 'product_status_dom' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.MassUpdate'     ,  2, 'Products.LBL_DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'       , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.MassUpdate'     ,  3, 'Products.LBL_DATE_SUPPORT_STARTS'       , 'DATE_SUPPORT_STARTS'        , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.MassUpdate'     ,  4, 'Products.LBL_BOOK_VALUE_DATE'           , 'BOOK_VALUE_DATE'            , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MassUpdate'     ,  5, null;
end -- if;
GO

	-- 02/21/2021 Paul.  Correct label for DATE_COST_PRICE. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductTemplates.MassUpdate', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.MassUpdate',  0, 'ProductTemplates.LBL_DATE_COST_PRICE'   , 'DATE_COST_PRICE'         , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.MassUpdate',  1, 'ProductTemplates.LBL_STATUS'            , 'STATUS'                  , 0, null, 'product_template_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.MassUpdate',  2, 'ProductTemplates.LBL_TAX_CLASS'         , 'TAX_CLASS'               , 0, null, 'tax_class_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.MassUpdate',  3, 'ProductTemplates.LBL_DATE_AVAILABLE'    , 'DATE_AVAILABLE'          , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.MassUpdate',  4, 'ProductTemplates.LBL_SUPPORT_TERM'      , 'SUPPORT_TERM'            , 0, null, 'support_term_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.MassUpdate',  5, 'ProductTemplates.LBL_TYPE'              , 'TYPE_ID'                 , 0, null, 'TYPE_NAME'          , 'ProductTypes', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.MassUpdate',  6, 'ProductTemplates.LBL_QUICKBOOKS_ACCOUNT', 'QUICKBOOKS_ACCOUNT'      , 0, null,  31, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.MassUpdate',  7, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                 , 0, null, 'TEAM_NAME'          , 'Teams', null;
end else begin
	-- 02/21/2021 Paul.  Correct label for DATE_COST_PRICE. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.MassUpdate' and DATA_LABEL = 'Products.LBL_DATE_COST_PRICE' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_LABEL          = 'ProductTemplates.LBL_DATE_COST_PRICE'
		     , DATE_MODIFIED       = getdate()
		     , DATE_MODIFIED_UTC   = getutcdate()
		     , MODIFIED_USER_ID    = null
		 where EDIT_NAME           = 'ProductTemplates.MassUpdate'
		   and DATA_LABEL          = 'Products.LBL_DATE_COST_PRICE'
		   and DELETED             = 0;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.MassUpdate'       , 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.MassUpdate'       ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.MassUpdate'       ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.MassUpdate'       ,  2, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.MassUpdate'       ,  3, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.MassUpdate'       ,  4, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, null, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.MassUpdate'       ,  5, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 0, null, 'quote_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.MassUpdate'       ,  6, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, null, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.MassUpdate'       ,  7, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, null, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.MassUpdate'       ,  8, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.MassUpdate'       ,  9, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, null, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Quotes.MassUpdate'       , 10, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.MassUpdate'       , 11, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.MassUpdate'       , 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.MassUpdate'       ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.MassUpdate'       ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.MassUpdate'       ,  2, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.MassUpdate'       ,  3, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.MassUpdate'       ,  4, 'Orders.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, null, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.MassUpdate'       ,  5, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 0, null, 'order_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Orders.MassUpdate'       ,  6, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.MassUpdate'       ,  7, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.MassUpdate'     , 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.MassUpdate'     ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.MassUpdate'     ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Invoices.MassUpdate'     ,  2, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.MassUpdate'     ,  3, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.MassUpdate'     ,  4, 'Invoices.LBL_PAYMENT_TERMS'             , 'PAYMENT_TERMS'              , 0, null, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.MassUpdate'     ,  5, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 0, null, 'invoice_stage_dom'  , null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Payments.MassUpdate'     , 'Payments', 'vwPAYMENTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.MassUpdate'     ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.MassUpdate'     ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Payments.MassUpdate'     ,  2, 'Payments.LBL_PAYMENT_DATE'              , 'PAYMENT_DATE'               , 0, null, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.MassUpdate'     ,  3, 'Payments.LBL_PAYMENT_TYPE'              , 'PAYMENT_TYPE'               , 0, null, 'payment_type_dom'   , null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'KBDocuments.MassUpdate'  , 'KBDocuments', 'vwKBDOCUMENTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'KBDocuments.MassUpdate'  ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'KBDocuments.MassUpdate'  ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'KBDocuments.MassUpdate'  ,  2, 'KBDocuments.LBL_EXP_DATE'               , 'EXP_DATE'                   , 0, null, 'DatePicker'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'KBDocuments.MassUpdate'  ,  3, 'KBDocuments.LBL_STATUS'                 , 'STATUS'                     , 0, null, 'kbdocument_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'KBDocuments.MassUpdate'  ,  4, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'KBDocuments.MassUpdate'  ,  5, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TwitterTracks.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'TwitterTracks.MassUpdate', 'TwitterTracks', 'vwTWITTER_TRACKS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TwitterTracks.MassUpdate',  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TwitterTracks.MassUpdate',  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'TwitterTracks.MassUpdate',  2, 'TwitterTracks.LBL_STATUS'               , 'STATUS'                     , 0, null, 'twitter_track_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'TwitterTracks.MassUpdate',  3, 'TwitterTracks.LBL_TYPE'                 , 'TYPE'                       , 0, null, 'twitter_track_type_dom'  , null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Surveys.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'Surveys.MassUpdate'      , 'Surveys', 'vwSUREVEYS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Surveys.MassUpdate'      ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Surveys.MassUpdate'      ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.MassUpdate'      ,  2, 'Surveys.LBL_STATUS'                     , 'STATUS'                     , 0, null, 'survey_status_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Surveys.MassUpdate'      ,  3, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyQuestions.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'SurveyQuestions.MassUpdate', 'SurveyQuestions', 'vwSURVEY_QUESTIONS', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'SurveyQuestions.MassUpdate',  0, '.LBL_ASSIGNED_TO'                     , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'SurveyQuestions.MassUpdate',  1, 'Teams.LBL_TEAM'                       , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
end -- if;
GO

-- 08/18/2019 Paul.  React Client needs separate panel. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportDesigner.MassUpdate';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportDesigner.MassUpdate' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.MassUpdate';
	exec dbo.spEDITVIEWS_InsertOnly            'ReportDesigner.MassUpdate' , 'ReportDesigner', 'vwREPORTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ReportDesigner.MassUpdate' ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ReportDesigner.MassUpdate' ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
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

call dbo.spEDITVIEWS_FIELDS_MassUpdatePro()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_MassUpdatePro')
/

-- #endif IBM_DB2 */


