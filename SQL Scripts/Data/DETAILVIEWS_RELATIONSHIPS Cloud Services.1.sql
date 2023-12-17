

print 'DETAILVIEWS_RELATIONSHIPS Cloud Services';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 04/29/2015 Paul.  Add HubSpot panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView' and MODULE_NAME = 'HubSpot' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView'      , 'HubSpot'          , 'HubSpot\DetailView' ,  0, '.moduleList.HubSpot'              , 'vwACCOUNTS_HubSpot'     , 'ID'        , 'ID', 'asc';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , RELATIONSHIP_ORDER   = null
	 where DETAIL_NAME          = 'Accounts.DetailView'
	   and MODULE_NAME          = 'HubSpot'
	   and DELETED              = 0;
end -- if;
GO

-- 04/29/2015 Paul.  Add HubSpot panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME = 'HubSpot' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'HubSpot'          , 'HubSpot\DetailView' ,  0, '.moduleList.HubSpot'              , 'vwCONTACTS_HubSpot'     , 'ID'        , 'ID', 'asc';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , RELATIONSHIP_ORDER   = null
	 where DETAIL_NAME          = 'Contacts.DetailView'
	   and MODULE_NAME          = 'HubSpot'
	   and DELETED              = 0;
end -- if;
GO

-- 04/29/2015 Paul.  Add HubSpot panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and MODULE_NAME = 'HubSpot' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView'         , 'HubSpot'          , 'HubSpot\DetailView' ,  0  , '.moduleList.HubSpot'            , 'vwLEADS_HubSpot'          , 'ID'        , 'ID', 'asc';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , RELATIONSHIP_ORDER   = null
	 where DETAIL_NAME          = 'Leads.DetailView'
	   and MODULE_NAME          = 'HubSpot'
	   and DELETED              = 0;
end -- if;
GO

-- 05/21/2015 Paul.  Add Marketo panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and MODULE_NAME = 'Marketo' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView'      , 'Marketo'          , 'Marketo\DetailView' ,  0, '.moduleList.Marketo'              , 'vwCONTACTS_Marketo'     , 'ID'        , 'ID', 'asc';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , RELATIONSHIP_ORDER   = null
	 where DETAIL_NAME          = 'Contacts.DetailView'
	   and MODULE_NAME          = 'Marketo'
	   and DELETED              = 0;
end -- if;
GO

-- 05/21/2015 Paul.  Add Marketo panel. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and MODULE_NAME = 'Marketo' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView'         , 'Marketo'          , 'Marketo\DetailView' ,  0  , '.moduleList.Marketo'            , 'vwLEADS_Marketo'          , 'ID'        , 'ID', 'asc';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ENABLED = 0
	     , RELATIONSHIP_ORDER   = null
	 where DETAIL_NAME          = 'Leads.DetailView'
	   and MODULE_NAME          = 'Marketo'
	   and DELETED              = 0;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_CloudServices()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_CloudServices')
/

-- #endif IBM_DB2 */

