

print 'EDITVIEWS_FIELDS Search MailChimp';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.Search%.MailChimp'
--GO

set nocount on;
GO

-- 04/08/2016 Paul.  Add MailChimp layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'EmailTemplates.MailChimp';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'EmailTemplates.MailChimp' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS EmailTemplates.MailChimp';
	exec dbo.spEDITVIEWS_InsertOnly             'EmailTemplates.MailChimp', 'EmailTemplates', 'vwEMAIL_TEMPLATES_List', '15%', '35%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'EmailTemplates.MailChimp',  0, 'MailChimp.LBL_TYPE'           , 'TYPE'    , 0, null,  35, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'EmailTemplates.MailChimp',  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'EmailTemplates.MailChimp',  2, null;
end -- if;
GO

-- 04/08/2016 Paul.  Add MailChimp layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProspectLists.MailChimp';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProspectLists.MailChimp' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProspectLists.MailChimp';
	exec dbo.spEDITVIEWS_InsertOnly             'ProspectLists.MailChimp', 'ProspectLists', 'vwPROSPECT_LISTS_List', '15%', '35%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProspectLists.MailChimp' ,  0, 'MailChimp.LBL_EMAIL'        , 'email'    , 0, null, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ProspectLists.MailChimp' ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ProspectLists.MailChimp' ,  2, null;
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

call dbo.spEDITVIEWS_FIELDS_SearchMailChimp()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchMailChimp')
/

-- #endif IBM_DB2 */

