

set nocount on;
GO

/*
select distinct 
'if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = ''' + DETAILVIEWS_RELATIONSHIPS.TABLE_NAME + ''' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = ''' + isnull(vwSqlViews2.VIEW_NAME, '') + '''
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = ''' + DETAILVIEWS_RELATIONSHIPS.TABLE_NAME + '''
	   and DELETED           = 0;
end -- if;

'
  from            DETAILVIEWS_RELATIONSHIPS
  left outer join vwSqlViews
               on vwSqlViews.VIEW_NAME = DETAILVIEWS_RELATIONSHIPS.TABLE_NAME
  left outer join vwSqlViews  vwSqlViews2
               on replace(vwSqlViews2.VIEW_NAME, '_', '') = replace(DETAILVIEWS_RELATIONSHIPS.TABLE_NAME, '_', '')
 where DETAILVIEWS_RELATIONSHIPS.DELETED = 0
   and DETAILVIEWS_RELATIONSHIPS.SORT_FIELD is not null
   and vwSqlViews.VIEW_NAME is null
 order by 1;
*/


if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACCOUNTS_CREDITCARDS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwACCOUNTS_CREDIT_CARDS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACCOUNTS_CREDITCARDS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACCOUNTS_MEMBERORGANIZATIONS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwACCOUNTS_MEMBERS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACCOUNTS_MEMBERORGANIZATIONS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwACLROLES_USERS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwACL_ROLES_USERS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwACLROLES_USERS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCALLMARKETING_PROSPECTLISTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCALL_MARKETING_PROSPECT_LST'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCALLMARKETING_PROSPECTLISTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCAMPAIGNS_CALLMARKETING' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCAMPAIGNS_CALL_MARKETING'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCAMPAIGNS_CALLMARKETING'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCAMPAIGNS_CAMPAIGNTRACKERS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCAMPAIGNS_CAMPAIGN_TRKRS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCAMPAIGNS_CAMPAIGNTRACKERS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCAMPAIGNS_EMAILMARKETING' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCAMPAIGNS_EMAIL_MARKETING'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCAMPAIGNS_EMAILMARKETING'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCAMPAIGNS_PROSPECTLISTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCAMPAIGNS_PROSPECT_LISTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCAMPAIGNS_PROSPECTLISTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTACTS_DIRECTREPORTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCONTACTS_DIRECT_REPORTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTACTS_DIRECTREPORTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwCONTACTS_PROSPECTLISTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwCONTACTS_PROSPECT_LISTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwCONTACTS_PROSPECTLISTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwDOCUMENTS_REVISIONS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwDOCUMENT_REVISIONS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwDOCUMENTS_REVISIONS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwEMAILMARKETING_PROSPECTLISTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwEMAIL_MARKETING_PROSPECT_LST'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwEMAILMARKETING_PROSPECTLISTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwFLEXIBLEPAYMENTS.TOKENS_TOKENUSAGELIMIT' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwFLEXIBLEPAYMENTS.TOKENS_TOKENUSAGELIMIT'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwFLEXIBLEPAYMENTS_RELATEDTRANSACTIONS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwFLEXIBLEPAYMENTS_RELATEDTRANSACTIONS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwFLEXIBLEPAYMENTS_STATUSCHANGES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwFLEXIBLEPAYMENTS_STATUSCHANGES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwFLEXIBLEPAYMENTS_TRANSACTIONPARTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwFLEXIBLEPAYMENTS_TRANSACTIONPARTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwLEADS_PROSPECTLISTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwLEADS_PROSPECT_LISTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwLEADS_PROSPECTLISTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPAYMENTS_PAYMENTTRANSACTIONS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPAYMENTS_TRANSACTIONS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPAYMENTS_PAYMENTTRANSACTIONS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPAYPAL_LINEITEMS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPAYPAL_LINEITEMS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPRODUCTTEMPLATES_RELATEDPRODUCTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPRODUCTS_RELATED_PRODUCTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPRODUCTTEMPLATES_RELATEDPRODUCTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_ACCOUNTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_ACCOUNTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_ACCOUNTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_ACTIVITIES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_ACTIVITIES'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_ACTIVITIES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_ACTIVITIES_HISTORY' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_ACTIVITIES_HISTORY'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_ACTIVITIES_HISTORY'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_ACTIVITIES_OPEN' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_ACTIVITIES_OPEN'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_ACTIVITIES_OPEN'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_CONTACTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_CONTACTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_CONTACTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_OPPORTUNITIES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_OPPORTUNITIES'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_OPPORTUNITIES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_QUOTES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_QUOTES'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_QUOTES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECT_THREADS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECTS_THREADS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECT_THREADS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECTTASK_ACTIVITIES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECT_TASKS_ACTIVITIES'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECTTASK_ACTIVITIES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECTTASK_ACTIVITIES_HISTORY' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECT_TASKS_ACTIVITIES_HISTORY'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECTTASK_ACTIVITIES_HISTORY'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROJECTTASK_ACTIVITIES_OPEN' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROJECT_TASKS_ACTIVITIES_OPEN'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROJECTTASK_ACTIVITIES_OPEN'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTLISTS_CONTACTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROSPECT_LISTS_CONTACTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTLISTS_CONTACTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTLISTS_LEADS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROSPECT_LISTS_LEADS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTLISTS_LEADS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTLISTS_PROSPECTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROSPECT_LISTS_PROSPECTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTLISTS_PROSPECTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTLISTS_USERS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROSPECT_LISTS_USERS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTLISTS_USERS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwPROSPECTS_PROSPECTLISTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwPROSPECTS_PROSPECT_LISTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwPROSPECTS_PROSPECTLISTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_ACCOUNTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_ACCOUNTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_INVOICES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_INVOICES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_ORDERS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_ORDERS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_PRODUCTTEMPLATES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_PRODUCTTEMPLATES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_QUOTES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_QUOTES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_SHIPPERS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_SHIPPERS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwQUICKBOOKS_TAXRATES' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwQUICKBOOKS_TAXRATES'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwTEAMS_USERS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = 'vwTEAM_MEMBERSHIPS_List'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwTEAMS_USERS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwWORKFLOWS_ACTIONS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwWORKFLOWS_ACTIONS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwWORKFLOWS_ALERTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwWORKFLOWS_ALERTS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwWORKFLOWS_CONDITIONS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwWORKFLOWS_CONDITIONS'
	   and DELETED           = 0;
end -- if;

if exists(select * from DETAILVIEWS_RELATIONSHIPS where TABLE_NAME = 'vwWORKFLOWS_EVENTS' and DELETED = 0) begin -- then
	update DETAILVIEWS_RELATIONSHIPS
	   set TABLE_NAME        = null
	     , SORT_FIELD        = null
	     , SORT_DIRECTION    = null
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where TABLE_NAME        = 'vwWORKFLOWS_EVENTS'
	   and DELETED           = 0;
end -- if;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_TablesFix()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_TablesFix')
/

-- #endif IBM_DB2 */

