

print 'DYNAMIC_BUTTONS Popup Professional';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.PopupView'
--GO

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'GetResponse.PopupView', 'GetResponse';
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

call dbo.spDYNAMIC_BUTTONS_PopupCloud()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_PopupCloud')
/

-- #endif IBM_DB2 */

