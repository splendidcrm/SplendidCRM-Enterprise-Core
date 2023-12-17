

print 'DETAILVIEWS_RELATIONSHIPS Pardot';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 07/18/2017 Paul.  Add Pardot layout. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Prospects.DetailView.Pardot' and MODULE_NAME = 'Prospects' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Prospects.DetailView.Pardot', 'Prospects', 'VisitorActivities',  0, 'Pardot.LBL_VISITOR_ACTIVITIES', 'vwPROSPECTS_VISITOR_ACTIVITIES', 'created_at', 'created_at', 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Prospects.Pardot.Visitors' and MODULE_NAME = 'Prospects' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Prospects.Pardot.Visitors', 'Prospects', 'VisitorActivities',  0, 'Pardot.LBL_VISITOR_ACTIVITIES', 'vwPROSPECTS_VISITOR_ACTIVITIES', 'created_at', 'created_at', 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Opportunities.DetailView.Pardot' and MODULE_NAME = 'Opportunities' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView.Pardot', 'Opportunities', 'VisitorActivities',  0, 'Pardot.LBL_VISITOR_ACTIVITIES', 'vwPROSPECTS_VISITOR_ACTIVITIES', 'created_at', 'created_at', 'asc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Pardot()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Pardot')
/

-- #endif IBM_DB2 */

