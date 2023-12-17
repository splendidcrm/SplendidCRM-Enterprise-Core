

print 'DETAILVIEWS_RELATIONSHIPS Insights';

set nocount on;
GO

-- update DETAILVIEWS_RELATIONSHIPS set INSIGHT_VIEW = null, INSIGHT_OPERATOR = null, INSIGHT_LABEL = null where INSIGHT_LABEL is not null;
-- select distinct INSIGHT_VIEW from DETAILVIEWS_RELATIONSHIPS where INSIGHT_VIEW is not null;


-- 03/30/2022 Paul.  Add Insight fields. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Contacts'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Cases'               , '.LBL_INSIGHT_OPEN_CASES_TOTAL'    , null                                   , 'cast(sum(case when STATUS in (''New'', ''Assigned'', ''Pending Input'') then 1 else 0 end) as nvarchar(10)) + '' / '' + cast(count(*) as nvarchar(10))';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'ActivitiesHistory'   , '.LBL_INSIGHT_LAST_TOUCHPOINT'     , null                                   , 'max(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'ActivitiesOpen'      , '.LBL_INSIGHT_NEXT_ACTIVITY_DATE'  , 'vwACCOUNTS_ACTIVITIES_OPEN_Insight'   , 'min(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Opportunities'       , '.LBL_INSIGHT_TOTAL_VALUE'         , 'vwACCOUNTS_OPPORTUNITIES_Insight'     , 'sum(AMOUNT_USDOLLAR)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Leads'               , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'MemberOrganizations' , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Bugs'                , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Products'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Projects'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Quotes'              , '.LBL_INSIGHT_NEXT_EXPIRATION_DATE', 'vwACCOUNTS_QUOTES_Insight'            , 'min(DATE_QUOTE_EXPECTED_CLOSED)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Contracts'           , '.LBL_INSIGHT_RENEWAL_DATE'        , 'vwACCOUNTS_CONTRACTS_Insight'         , 'min(END_DATE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Documents'           , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Invoices'            , '.LBL_INSIGHT_TOTAL_OVERDUE_TOTAL' , null                                   , 'cast(sum(case when INVOICE_STAGE in (''Due'', ''Under Review'') and DUE_DATE < getdate() then 1 else 0 end) as nvarchar(10)) + '' / '' + cast(count(*) as nvarchar(10))';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'ProspectLists'       , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Payments'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Threads'             , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Orders'              , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'CreditCards'         , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Accounts.DetailView'     , 'Balance'             , '.LBL_INSIGHT_TOTAL_VALUE'         , null                                   , 'sum(AMOUNT_USDOLLAR)';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'ActivitiesOpen'      , '.LBL_INSIGHT_NEXT_ACTIVITY_DATE'  , 'vwCONTACTS_ACTIVITIES_OPEN_Insight'   , 'min(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'ActivitiesHistory'   , '.LBL_INSIGHT_LAST_TOUCHPOINT'     , null                                   , 'max(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Leads'               , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Opportunities'       , '.LBL_INSIGHT_TOTAL_VALUE'         , 'vwCONTACTS_OPPORTUNITIES_Insight'     , 'sum(AMOUNT_USDOLLAR)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Cases'               , '.LBL_INSIGHT_OPEN_CASES_TOTAL'    , null                                   , 'cast(sum(case when STATUS in (''New'', ''Assigned'', ''Pending Input'') then 1 else 0 end) as nvarchar(10)) + '' / '' + cast(count(*) as nvarchar(10))';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Bugs'                , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Products'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'DirectReports'       , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Projects'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Quotes'              , '.LBL_INSIGHT_NEXT_EXPIRATION_DATE', 'vwCONTACTS_QUOTES_Insight'            , 'min(DATE_QUOTE_EXPECTED_CLOSED)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Invoices'            , '.LBL_INSIGHT_TOTAL_OVERDUE_TOTAL' , null                                   , 'cast(sum(case when INVOICE_STAGE in (''Due'', ''Under Review'') and DUE_DATE < getdate() then 1 else 0 end) as nvarchar(10)) + '' / '' + cast(count(*) as nvarchar(10))';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'ProspectLists'       , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Orders'              , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'Documents'           , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Contacts.DetailView'     , 'SurveyResults'       , '.LBL_INSIGHT_TOTAL'               , null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Leads.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'ActivitiesOpen'      , '.LBL_INSIGHT_NEXT_ACTIVITY_DATE'  , 'vwLEADS_ACTIVITIES_OPEN_Insight'      , 'min(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'ActivitiesHistory'   , '.LBL_INSIGHT_LAST_TOUCHPOINT'     , null                                   , 'max(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'Threads'             , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'ProspectLists'       , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'Documents'           , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'Contacts'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'Opportunities'       , '.LBL_INSIGHT_TOTAL_VALUE'         , 'vwLEADS_OPPORTUNITIES_Insight'       , 'sum(AMOUNT_USDOLLAR)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Leads.DetailView'        , 'SurveyResults'       , '.LBL_INSIGHT_TOTAL'               , null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Prospects.DetailView'    , 'ProspectLists'       , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Prospects.DetailView'    , 'DataPrivacy'         , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Prospects.DetailView'    , 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Prospects.DetailView'    , 'Activities'          , '.LBL_INSIGHT_NEXT_ACTIVITY_DATE'  , 'vwPROSPECTS_ACTIVITIES_Insight'      , 'min(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Prospects.DetailView'    , 'SurveyResults'       , '.LBL_INSIGHT_TOTAL'               , null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'ProspectLists.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS ProspectLists.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'ProspectLists.DetailView', 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'ProspectLists.DetailView', 'Prospects'           , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'ProspectLists.DetailView', 'Contacts'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'ProspectLists.DetailView', 'Leads'               , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'ProspectLists.DetailView', 'Users'               , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'ProspectLists.DetailView', 'Accounts'            , '.LBL_INSIGHT_TOTAL'               , null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Cases.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Cases.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'ActivitiesOpen'      , '.LBL_INSIGHT_NEXT_ACTIVITY_DATE'  , 'vwCASES_ACTIVITIES_OPEN_Insight'      , 'min(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'ActivitiesHistory'   , '.LBL_INSIGHT_LAST_TOUCHPOINT'     , null                                   , 'max(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'Contacts'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'Bugs'                , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'Threads'             , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'KBDocuments'         , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'Documents'           , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Cases.DetailView'        , 'Projects'            , '.LBL_INSIGHT_TOTAL'               , null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Opportunities.DetailView' and INSIGHT_LABEL is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Opportunities.DetailView Insights';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'ActivityStream'      , '.LBL_INSIGHT_LAST_ACTIVITY_DATE'  , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Activities'          , '.LBL_INSIGHT_NEXT_ACTIVITY_DATE'  , 'vwOPPORTUNITIES_ACTIVITIES_Insight', 'min(DATE_DUE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Contacts'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Quotes'              , '.LBL_INSIGHT_NEXT_EXPIRATION_DATE', 'vwOPPORTUNITIES_QUOTES_Insight'    , 'min(DATE_QUOTE_EXPECTED_CLOSED)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Projects'            , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Contracts'           , '.LBL_INSIGHT_RENEWAL_DATE'        , 'vwOPPORTUNITIES_CONTRACTS_Insight' , 'min(END_DATE)';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Threads'             , '.LBL_INSIGHT_TOTAL'               , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_UpdateInsight null, 'Opportunities.DetailView', 'Documents'           , '.LBL_INSIGHT_TOTAL'               , null, null;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Insights()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Insights')
/

-- #endif IBM_DB2 */

