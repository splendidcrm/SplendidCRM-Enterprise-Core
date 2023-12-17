

print 'EDITVIEWS_FIELDS NewRecord Professional';
-- delete from EDITVIEWS where NAME like '%.NewRecord'
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.NewRecord'
--GO

set nocount on;
GO

-- 10/06/2010 Paul.  Size of NAME field was increased to 150. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.NewRecord'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.NewRecord' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.NewRecord';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.NewRecord'         , 'Quotes', 'vwQUOTES_Edit', '100%', '0%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.NewRecord'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.NewRecord'         ,  1, 'Quotes.LBL_ACCOUNT_NAME'                , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.NewRecord'         ,  2, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 1, 1, 'quote_stage_dom'   , null, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.NewRecord'         ,  3, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME', 'Users'   , null;
--	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.NewRecord'         ,  4, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'       , 'Teams'   , null;
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

call dbo.spEDITVIEWS_FIELDS_NewRecordPro()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_NewRecordPro')
/

-- #endif IBM_DB2 */

