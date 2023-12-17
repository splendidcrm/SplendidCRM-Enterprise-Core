

print 'DETAILVIEWS_RELATIONSHIPS MailChimp';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 04/11/2016 Paul.  Add MailChimp layout. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'ProspectLists.DetailView.MailChimp' and MODULE_NAME = 'Prospects' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'ProspectLists.DetailView.MailChimp', 'Prospects', 'Members',  0, 'MailChimp.LBL_MEMBERS', 'vwPROSPECT_LISTS_MEMBERS', 'email_address', 'email_address', 'asc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_MailChimp()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_MailChimp')
/

-- #endif IBM_DB2 */

