

print 'DETAILVIEWS_FIELDS OfficeAddin';
-- delete from DETAILVIEWS where NAME like '%.Home.OfficeAddin'
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.Home.OfficeAddin'
--GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Accounts.Home.OfficeAddin', 'Accounts', 'vwACCOUNTS_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.Home.OfficeAddin'     ,  0, null, 'PICTURE NAME EMAIL1 PHONE_OFFICE'  , '<img src="{0}" class="ModulePicture" /><div>{1}</div><div>{2}</div><div>{3}</div>', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Accounts.Home.OfficeAddin'     ,  0, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Accounts/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Accounts.Home.OfficeAddin'     ,  1, null, 'EMAIL1'                    , '{0}'        , 'EMAIL1'            , 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Accounts.Home.OfficeAddin'     ,  2, null, 'WEBSITE'                   , '{0}'        , 'WEBSITE'           , '{0}', '_blank', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.Home.OfficeAddin'     ,  3, null, 'PHONE_OFFICE'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Accounts.Home.OfficeAddin'     ,  4, null, null, 'ID PICTURE'          , 'OfficeAddinUI_Picture(''{0}'', ''{1}'');'        , null, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Cases.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Cases.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Cases.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Cases.Home.OfficeAddin', 'Cases', 'vwCASES_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Cases.Home.OfficeAddin'        ,  0, null, 'CASE_NUMBER NAME ACCOUNT_NAME', '<div>{0}</div><div>{1}</div><div>{2}</div>'          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Cases.Home.OfficeAddin'        ,  0, null, 'CASE_NUMBER'               , '{0}'        , 'ID'                , '~/Cases/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Cases.Home.OfficeAddin'        ,  1, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Cases/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Cases.Home.OfficeAddin'        ,  2, null, 'ACCOUNT_NAME'              , '{0}'        , 'ACCOUNT_ID'        , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Cases.Home.OfficeAddin'        ,  3, null, 'STATUS'                    , '{0}'        , 'case_status_dom'   , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Contacts.Home.OfficeAddin', 'Contacts', 'vwCONTACTS_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.Home.OfficeAddin'     ,  0, null, 'PICTURE NAME ACCOUNT_NAME EMAIL1 PHONE_OFFICE'  , '<img src="{0}" class="ModulePicture" /><div>{1}</div><div>{2}</div><div>{3}</div><div>{4}</div>', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Contacts.Home.OfficeAddin'     ,  0, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Contacts/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Contacts.Home.OfficeAddin'     ,  1, null, 'EMAIL1'                    , '{0}'        , 'EMAIL1'            , 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Contacts.Home.OfficeAddin'     ,  2, null, 'ACCOUNT_NAME'              , '{0}'        , 'ACCOUNT_ID'        , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.Home.OfficeAddin'     ,  3, null, 'PHONE_WORK'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Contacts.Home.OfficeAddin'     ,  4, null, null, 'ID PICTURE'          , 'OfficeAddinUI_Picture(''{0}'', ''{1}'');'        , null, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Leads.Home.OfficeAddin', 'Leads', 'vwLEADS_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.Home.OfficeAddin'        ,  0, null, 'PICTURE NAME ACCOUNT_NAME EMAIL1 PHONE_WORK', '<img src="{0}" class="ModulePicture" /><div>{1}</div><div>{2}</div><div>{3}</div><div>{4}</div>', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Leads.Home.OfficeAddin'        ,  0, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Leads/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Leads.Home.OfficeAddin'        ,  1, null, 'EMAIL1'                    , '{0}'        , 'EMAIL1'            , 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Leads.Home.OfficeAddin'        ,  2, null, 'ACCOUNT_NAME'              , '{0}'        , 'ACCOUNT_ID'        , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.Home.OfficeAddin'        ,  3, null, 'PHONE_WORK'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Leads.Home.OfficeAddin'        ,  4, null, null, 'ID PICTURE'          , 'OfficeAddinUI_Picture(''{0}'', ''{1}'');'        , null, null;
end -- if;
GO

-- delete from DETAILVIEWS where NAME = 'Opportunities.Home.OfficeAddin';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Opportunities.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Opportunities.Home.OfficeAddin', 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.Home.OfficeAddin',  0, null, 'NAME ACCOUNT_NAME'                      , '<div>{0}</div><div>{1}</div>'   , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.Home.OfficeAddin',  1, null, 'SALES_STAGE DATE_CLOSED AMOUNT_USDOLLAR', '<div>{0;sales_stage_dom}</div><div>{1:d}</div><div>{2:c}<div>', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Opportunities.Home.OfficeAddin',  0, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Opportunities/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.Home.OfficeAddin',  1, null, 'SALES_STAGE'               , '{0}'        , 'sales_stage_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.Home.OfficeAddin',  2, null, 'LEAD_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.Home.OfficeAddin',  3, null, 'DATE_CLOSED'               , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.Home.OfficeAddin',  4, null, 'ACCOUNT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.Home.OfficeAddin',  5, null, 'AMOUNT_USDOLLAR'           , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS where NAME = 'Quotes.Home.OfficeAddin';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Quotes.Home.OfficeAddin', 'Quotes', 'vwQUOTES_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Quotes.Home.OfficeAddin'       ,  0, null, 'NAME BILLING_CONTACT_NAME BILLING_ACCOUNT_NAME'       , '<div>{0}</div><div>{1}</div><div>{2}</div>'    , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Quotes.Home.OfficeAddin'       ,  1, null, 'QUOTE_STAGE DATE_QUOTE_EXPECTED_CLOSED TOTAL_USDOLLAR', '<div>{0;quote_stage_dom}</div><div>{1:d}</div><div>{2:c}</div>', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Quotes.Home.OfficeAddin'       ,  1, null, 'QUOTE_NUM'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Quotes.Home.OfficeAddin'       ,  0, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Quotes/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Quotes.Home.OfficeAddin'       ,  1, null, 'QUOTE_STAGE'               , '{0}'        , 'quote_stage_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Quotes.Home.OfficeAddin'       ,  2, null, 'BILLING_CONTACT_NAME'      , '{0}'        , 'BILLING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Quotes.Home.OfficeAddin'       ,  3, null, 'DATE_QUOTE_EXPECTED_CLOSED', '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Quotes.Home.OfficeAddin'       ,  4, null, 'BILLING_ACCOUNT_NAME'      , '{0}'        , 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Quotes.Home.OfficeAddin'       ,  5, null, 'TOTAL_USDOLLAR'            , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS where NAME = 'Orders.Home.OfficeAddin';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Orders.Home.OfficeAddin', 'Orders', 'vwORDERS_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Orders.Home.OfficeAddin'       ,  0, null, 'NAME BILLING_CONTACT_NAME BILLING_ACCOUNT_NAME', '<div>{0}</div><div>{1}</div><div>{2}</div>'    , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Orders.Home.OfficeAddin'       ,  1, null, 'ORDER_STAGE DATE_ORDER_DUE TOTAL_USDOLLAR'     , '<div>{0;order_stage_dom}</div><div>{1:d}</div><div>{2:c}</div>', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Orders.Home.OfficeAddin'       ,  1, null, 'ORDER_NUM'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Orders.Home.OfficeAddin'       ,  0, null, 'NAME'                      , '{0}'        , 'ID'                , '~/Orders/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Orders.Home.OfficeAddin'       ,  1, null, 'ORDER_STAGE'               , '{0}'        , 'order_stage_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Orders.Home.OfficeAddin'       ,  2, null, 'BILLING_CONTACT_NAME'      , '{0}'        , 'BILLING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Orders.Home.OfficeAddin'       ,  3, null, 'DATE_ORDER_DUE'            , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Orders.Home.OfficeAddin'       ,  4, null, 'BILLING_ACCOUNT_NAME'      , '{0}'        , 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Orders.Home.OfficeAddin'       ,  5, null, 'TOTAL_USDOLLAR'            , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS where NAME = 'Invoices.Home.OfficeAddin';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.Home.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.Home.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.Home.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly           'Invoices.Home.OfficeAddin', 'Invoices', 'vwINVOICES_Edit', '0%', '50%', 2;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Invoices.Home.OfficeAddin'     ,  0, null, 'NAME BILLING_CONTACT_NAME BILLING_ACCOUNT_NAME', '<div>{0}</div><div>{1}</div><div>{2}</div>', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Invoices.Home.OfficeAddin'     ,  1, null, 'INVOICE_STAGE DUE_DATE TOTAL_USDOLLAR'         , '<div>{0;invoice_stage_dom}</div><div>{1:d}</div><div>{2:c}</div>', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Invoices.Home.OfficeAddin'     ,  0, null, 'INVOICE_NUM'                 , '{0}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Invoices.Home.OfficeAddin'     ,  0, null, 'NAME'                        , '{0}'      , 'ID'                , '~/Invoices/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Invoices.Home.OfficeAddin'     ,  1, null, 'INVOICE_STAGE'               , '{0}'      , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Invoices.Home.OfficeAddin'     ,  2, null, 'BILLING_CONTACT_NAME'        , '{0}'      , 'BILLING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Invoices.Home.OfficeAddin'     ,  3, null, 'DUE_DATE'                    , '{0}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Invoices.Home.OfficeAddin'     ,  4, null, 'BILLING_ACCOUNT_NAME'        , '{0}'      , 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Invoices.Home.OfficeAddin'     ,  5, null, 'TOTAL_USDOLLAR'              , '{0:c}'    , null;
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

call dbo.spDETAILVIEWS_FIELDS_HomeOfficeAddin()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_HomeOfficeAddin')
/

-- #endif IBM_DB2 */

