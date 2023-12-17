

print 'DETAILVIEWS_RELATIONSHIPS Watson';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 04/11/2018 Paul.  Add Watson layout. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'ProspectLists.DetailView.Watson' and MODULE_NAME = 'Prospects' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'ProspectLists.DetailView.Watson', 'Prospects', 'Contacts',  0, 'Watson.LBL_CONTACTS', 'vwPROSPECT_LISTS_CONTACTS', 'EMAIL', 'EMAIL', 'asc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Watson()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Watson')
/

-- #endif IBM_DB2 */

