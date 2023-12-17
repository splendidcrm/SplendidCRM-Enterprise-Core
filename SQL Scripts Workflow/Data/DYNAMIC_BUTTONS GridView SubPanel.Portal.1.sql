

print 'DYNAMIC_BUTTONS GridView SubPanel.Portal';
--GO

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.MyQuotes.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.MyQuotes.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes.MyQuotes.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.MyQuotes.Portal'          , 0, 'Quotes'          , 'edit'  , null, null, 'Create'              , null, 'Quotes.LBL_REQUEST_QUOTE', 'Quotes.LBL_REQUEST_QUOTE', null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_GridViewSubPanelPortal()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_GridViewSubPanelPortal')
/

-- #endif IBM_DB2 */

