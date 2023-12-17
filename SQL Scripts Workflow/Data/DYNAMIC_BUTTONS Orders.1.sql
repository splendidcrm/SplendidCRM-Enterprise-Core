

print 'DYNAMIC_BUTTONS Orders';
GO

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EntryView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.EntryView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders.EntryView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Orders.EntryView'    , 0, null              , null  , null              , null, 'Save'                    , null, '.LBL_SUBMIT_BUTTON_LABEL'                    , '.LBL_SAVE_BUTTON_TITLE'                      , '.LBL_SUBMIT_BUTTON_KEY'                    , null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Orders.EntryView'    , 1, null              , null  , null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , '.LBL_CANCEL_BUTTON_KEY'                    , null, null;
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

call dbo.spDYNAMIC_BUTTONS_Orders()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_Orders')
/

-- #endif IBM_DB2 */

