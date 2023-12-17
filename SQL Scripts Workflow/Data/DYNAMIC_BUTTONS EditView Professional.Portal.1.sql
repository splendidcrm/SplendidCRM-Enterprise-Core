

print 'DYNAMIC_BUTTONS EditView Professional.Portal';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.EditView.Portal'
--GO

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Quotes.EditView.Portal', 'Quotes';
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Payments.EditView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Payments.EditView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Payments.EditView.Portal'        , 0, 'Payments', 'edit', null, null, 'Charge', null, 'Payments.LBL_CHARGE_BUTTON_LABEL', 'Payments.LBL_CHARGE_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Payments.EditView.Portal'        , 1, null      , null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL'        , '.LBL_CANCEL_BUTTON_TITLE'        , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_EditViewProfessionalPortal()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditViewProfessionalPortal')
/

-- #endif IBM_DB2 */

