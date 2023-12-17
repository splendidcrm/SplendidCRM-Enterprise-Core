

print 'NUMBER_SEQUENCES DataPrivacy';
GO

set nocount on;
GO

exec dbo.spNUMBER_SEQUENCES_InsertOnly null, N'DATA_PRIVACY.DATA_PRIVACY_NUMBER'  , null, null, 1, 0, 0;
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

call dbo.spNUMBER_SEQUENCES_DataPrivacy()
/

call dbo.spSqlDropProcedure('spNUMBER_SEQUENCES_DataPrivacy')
/

-- #endif IBM_DB2 */

 