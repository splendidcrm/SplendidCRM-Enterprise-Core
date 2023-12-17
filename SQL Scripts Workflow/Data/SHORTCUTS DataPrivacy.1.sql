

print 'SHORTCUTS DataPrivacy';
-- delete SHORTCUTS
GO

set nocount on;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'DataPrivacy';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'DataPrivacy', 'DataPrivacy.LNK_NEW_DATA_PRIVACY'   , '~/Administration/DataPrivacy/edit.aspx'        , 'DataPrivacy.gif'        , 1,  1, 'DataPrivacy'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'DataPrivacy', 'DataPrivacy.LNK_DATA_PRIVACY_LIST'  , '~/Administration/DataPrivacy/default.aspx'     , 'DataPrivacy.gif'        , 1,  2, 'DataPrivacy'     , 'list';
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

call dbo.spSHORTCUTS_DataPrivacy()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_DataPrivacy')
/

-- #endif IBM_DB2 */

