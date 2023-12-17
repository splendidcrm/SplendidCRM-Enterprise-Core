

print 'DATA SimpleEmail';
GO

set nocount on;
GO

-- 09/12/2011 Paul.  REST_ENABLED provides a way to enable/disable a module in the REST API. 
exec dbo.spMODULES_InsertOnly null, 'SimpleEmail', '.moduleList.SimpleEmail', '~/Administration/SimpleEmail/', 1, 0,  0, 0, 0, 0, 0, 1, null, 0, 0, 0, 0, 0, 0;

exec dbo.spSHORTCUTS_InsertOnly null, 'SimpleEmail', 'SimpleEmail.LNK_VERIFIED_EMAIL_ADDRESSES', '~/Administration/SimpleEmail/default.aspx'   , 'SimpleEmail.gif', 1,  1, 'SimpleEmail', 'list';
exec dbo.spSHORTCUTS_InsertOnly null, 'SimpleEmail', 'SimpleEmail.LNK_SEND_STATISTICS'         , '~/Administration/SimpleEmail/statistics.aspx', 'SimpleEmail.gif', 1,  2, 'SimpleEmail', 'list';


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spDATA_SimpleEmail()
/

call dbo.spSqlDropProcedure('spDATA_SimpleEmail')
/
-- #endif IBM_DB2 */

